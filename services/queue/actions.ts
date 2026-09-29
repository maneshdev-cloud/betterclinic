"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import { visitReasonSchema } from "@/lib/validation/appointments";
import { uuidSchema } from "@/lib/validation/auth";
import { getStaffClinicContext } from "@/services/clinics/service";

function revalidateQueueViews() {
  revalidatePath("/patient");
  revalidatePath("/patient/queue");
  revalidatePath("/patient/appointments");
  revalidatePath("/doctor");
  revalidatePath("/doctor/queue");
  revalidatePath("/doctor/appointments");
  revalidatePath("/staff");
  revalidatePath("/staff/queue");
  revalidatePath("/staff/appointments");
}

/**
 * Patient checks in from the app: creates the check-in row, moves the
 * appointment to WAITING and assigns a token — all atomically in SQL.
 * Returns the token code for immediate display.
 */
export async function checkInAction(appointmentId: string): Promise<ActionResult<{ tokenCode: string }>> {
  try {
    await requireRole(["PATIENT"], "/patient/queue");
    if (!uuidSchema.safeParse(appointmentId).success) {
      return { ok: false, error: "Invalid appointment." };
    }
    const supabase = await createClient();
    const { data, error } = await supabase.rpc("check_in_appointment", {
      p_appointment_id: appointmentId,
      p_method: "APP",
    });
    if (error) throw error;
    const entry = (data ?? null) as { token_code: string } | null;
    if (!entry) return { ok: false, error: "Check-in failed." };
    revalidateQueueViews();
    return { ok: true, data: { tokenCode: entry.token_code } };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Receptionist checks a patient in at the desk. */
export async function staffCheckInAction(appointmentId: string): Promise<ActionResult<{ tokenCode: string }>> {
  try {
    await requireRole(["RECEPTIONIST", "CLINIC_ADMIN"], "/staff/queue");
    if (!uuidSchema.safeParse(appointmentId).success) {
      return { ok: false, error: "Invalid appointment." };
    }
    const supabase = await createClient();
    const { data, error } = await supabase.rpc("check_in_appointment", {
      p_appointment_id: appointmentId,
      p_method: "RECEPTIONIST",
    });
    if (error) throw error;
    const entry = (data ?? null) as { token_code: string } | null;
    if (!entry) return { ok: false, error: "Check-in failed." };
    revalidateQueueViews();
    return { ok: true, data: { tokenCode: entry.token_code } };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Register a walk-in patient at the desk (staff only). */
export async function createWalkInAction(input: {
  patientId: string;
  doctorId: string;
  visitReason: string;
  priority?: "NORMAL" | "HIGH" | "URGENT";
}): Promise<ActionResult<{ tokenCode: string }>> {
  try {
    const user = await requireRole(["RECEPTIONIST", "CLINIC_ADMIN"], "/staff/queue");
    if (!uuidSchema.safeParse(input.patientId).success || !uuidSchema.safeParse(input.doctorId).success) {
      return { ok: false, error: "Please pick a patient and a doctor." };
    }
    const reason = visitReasonSchema.safeParse(input.visitReason ?? "");
    if (!reason.success) {
      return { ok: false, error: reason.error.issues[0]?.message ?? "Describe the reason for the visit." };
    }
    const priority = input.priority ?? "NORMAL";

    const clinic = await getStaffClinicContext(user.id);
    if (!clinic) return { ok: false, error: "Your account is not linked to a clinic." };

    const supabase = await createClient();
    const { data, error } = await supabase.rpc("create_walk_in", {
      p_clinic_id: clinic.id,
      p_doctor_id: input.doctorId,
      p_patient_id: input.patientId,
      p_visit_reason: reason.data,
      p_priority: priority,
    });
    if (error) throw error;
    const entry = (data ?? null) as { token_code: string } | null;
    if (!entry) return { ok: false, error: "Walk-in registration failed." };
    revalidateQueueViews();
    return { ok: true, data: { tokenCode: entry.token_code } };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/* ── Queue management (doctor + staff) ──────────────────────────── */

export async function callNextAction(clinicId: string, doctorId: string): Promise<ActionResult<{ tokenCode: string }>> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { data, error } = await supabase.rpc("queue_call_next", {
      p_clinic_id: clinicId,
      p_doctor_id: doctorId,
    });
    if (error) throw error;
    const entry = (data ?? null) as { token_code: string } | null;
    revalidateQueueViews();
    return entry
      ? { ok: true, data: { tokenCode: entry.token_code } }
      : { ok: false, error: "No patients are waiting." };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

export async function callSpecificAction(queueEntryId: string): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { error } = await supabase.rpc("queue_call_specific", { p_queue_entry_id: queueEntryId });
    if (error) throw error;
    revalidateQueueViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

export async function recallAction(queueEntryId: string): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { error } = await supabase.rpc("queue_recall", { p_queue_entry_id: queueEntryId });
    if (error) throw error;
    revalidateQueueViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

export async function returnToWaitingAction(queueEntryId: string): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { error } = await supabase.rpc("queue_return_to_waiting", { p_queue_entry_id: queueEntryId });
    if (error) throw error;
    revalidateQueueViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

export async function skipAction(queueEntryId: string): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { error } = await supabase.rpc("queue_skip", { p_queue_entry_id: queueEntryId });
    if (error) throw error;
    revalidateQueueViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

export async function resumeAction(queueEntryId: string): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { error } = await supabase.rpc("queue_resume", { p_queue_entry_id: queueEntryId });
    if (error) throw error;
    revalidateQueueViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

export async function setPriorityAction(
  queueEntryId: string,
  priority: "NORMAL" | "HIGH" | "URGENT"
): Promise<ActionResult> {
  try {
    await requireRole(["DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"], "/doctor/queue");
    const supabase = await createClient();
    const { error } = await supabase.rpc("queue_set_priority", {
      p_queue_entry_id: queueEntryId,
      p_priority: priority,
    });
    if (error) throw error;
    revalidateQueueViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Doctor starts the consultation for a CALLED token (Phase 4 adds the workspace UI). */
export async function startConsultationAction(appointmentId: string): Promise<ActionResult<{ consultationId: string }>> {
  try {
    const user = await requireRole(["DOCTOR"], "/doctor/queue");
    if (!uuidSchema.safeParse(appointmentId).success) {
      return { ok: false, error: "Invalid appointment." };
    }
    const supabase = await createClient();
    const { data, error } = await supabase.rpc("start_consultation", {
      p_appointment_id: appointmentId,
    });
    if (error) throw error;
    const consultation = (data ?? null) as { id: string } | null;
    revalidateQueueViews();
    revalidatePath("/doctor/consultations");
    return consultation
      ? { ok: true, data: { consultationId: consultation.id } }
      : { ok: false, error: "Could not start the consultation." };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Server-side patient lookup for the walk-in dialog (staff only). */
export async function searchPatientsAction(query: string): Promise<
  ActionResult<{ id: string; full_name: string; email: string; phone: string | null }[]>
> {
  try {
    await requireRole(["RECEPTIONIST", "CLINIC_ADMIN"], "/staff/queue");
    const trimmed = query.trim();
    if (trimmed.length < 2) return { ok: true, data: [] };
    const supabase = await createClient();
    const { searchPatients } = await import("@/services/queue/service");
    return { ok: true, data: await searchPatients(supabase, trimmed) };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
