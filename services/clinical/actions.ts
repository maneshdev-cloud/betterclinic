"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import {
  consultationNotesSchema,
  prescriptionSchema,
  diagnosisSchema,
  medicalHistorySchema,
  followUpSchema,
} from "@/lib/validation/clinical";
import {
  updateConsultationNotes,
  savePrescription,
  addDiagnosis,
  addMedicalHistory,
  scheduleFollowUp,
} from "@/services/clinical/service";

function revalidateClinicalViews(consultationId?: string) {
  if (consultationId) {
    revalidatePath(`/doctor/consultations/${consultationId}`);
  }
  revalidatePath("/doctor");
  revalidatePath("/patient");
  revalidatePath("/doctor/consultations");
  revalidatePath("/doctor/patients");
  revalidatePath("/patient/prescriptions");
  revalidatePath("/patient/medications");
  revalidatePath("/patient/follow-ups");
  revalidatePath("/patient/records");
}

/** Doctor saves the consultation narrative fields. */
export async function saveConsultationNotesAction(input: {
  consultationId: string;
  chief_complaint?: string;
  symptoms?: string;
  clinical_notes?: string;
  assessment?: string;
}): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR"], "/doctor/consultations");
    const parsed = consultationNotesSchema.safeParse({
      chief_complaint: input.chief_complaint,
      symptoms: input.symptoms,
      clinical_notes: input.clinical_notes,
      assessment: input.assessment,
    });
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the notes." };
    }
    const supabase = await createClient();
    await updateConsultationNotes(supabase, input.consultationId, parsed.data);
    revalidateClinicalViews(input.consultationId);
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Doctor creates (or extends) the consultation's prescription. */
export async function savePrescriptionAction(payload: unknown): Promise<ActionResult<{ items: number }>> {
  try {
    const user = await requireRole(["DOCTOR"], "/doctor/consultations");
    const parsed = prescriptionSchema.safeParse(payload);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the prescription." };
    }
    const supabase = await createClient();
    const result = await savePrescription(supabase, user.id, parsed.data);
    revalidateClinicalViews(parsed.data.consultationId);
    return { ok: true, data: result };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Doctor records a diagnosis for the consultation. */
export async function addDiagnosisAction(payload: unknown): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR"], "/doctor/consultations");
    const parsed = diagnosisSchema.safeParse(payload);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the diagnosis." };
    }
    const supabase = await createClient();

    // Patient id comes from the consultation server-side (never trusted from the client).
    const { data: consultation } = await supabase
      .from("consultations")
      .select("patient_id")
      .eq("id", parsed.data.consultationId)
      .maybeSingle();
    if (!consultation) return { ok: false, error: "Consultation not found." };
    const patientId = (consultation as { patient_id: string }).patient_id;

    await addDiagnosis(supabase, parsed.data.consultationId, patientId, {
      name: parsed.data.name,
      description: parsed.data.description || undefined,
      code: parsed.data.code || undefined,
      is_primary: parsed.data.is_primary,
    });
    revalidateClinicalViews(parsed.data.consultationId);
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Doctor records an allergy / condition / history entry for a patient. */
export async function addMedicalHistoryAction(payload: unknown): Promise<ActionResult> {
  try {
    const user = await requireRole(["DOCTOR"], "/doctor/consultations");
    const parsed = medicalHistorySchema.safeParse(payload);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the entry." };
    }
    const supabase = await createClient();
    await addMedicalHistory(supabase, user.id, parsed.data.patientId, {
      record_type: parsed.data.record_type,
      title: parsed.data.title,
      description: parsed.data.description || undefined,
    });
    revalidateClinicalViews();
    revalidatePath(`/doctor/patients/${parsed.data.patientId}`);
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Doctor schedules a follow-up visit. */
export async function scheduleFollowUpAction(payload: unknown): Promise<ActionResult> {
  try {
    const user = await requireRole(["DOCTOR"], "/doctor/consultations");
    const parsed = followUpSchema.safeParse(payload);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the follow-up details." };
    }
    const supabase = await createClient();
    await scheduleFollowUp(supabase, user.id, parsed.data.consultationId, {
      scheduled_date: parsed.data.scheduled_date,
      reason: parsed.data.reason,
      instructions: parsed.data.instructions || undefined,
    });
    revalidateClinicalViews(parsed.data.consultationId);
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Doctor closes the consultation — completes the appointment + queue entry too. */
export async function completeConsultationAction(consultationId: string): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR"], "/doctor/consultations");
    const supabase = await createClient();
    const { error } = await supabase.rpc("complete_consultation", {
      p_consultation_id: consultationId,
    });
    if (error) throw error;
    revalidateClinicalViews(consultationId);
    revalidatePath("/doctor/queue");
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
