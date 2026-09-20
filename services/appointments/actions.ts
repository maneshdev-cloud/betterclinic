"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import { bookAppointmentSchema, cancelSchema, rescheduleSchema } from "@/lib/validation/appointments";

function revalidateAppointmentViews() {
  revalidatePath("/patient/appointments");
  revalidatePath("/staff/appointments");
  revalidatePath("/patient/doctors");
}

/**
 * Book an appointment for the signed-in patient. The `book_appointment`
 * SQL function is the single source of truth: it locks the slot, validates
 * the state machine, creates the appointment + history + notification and
 * flips the slot to BOOKED — atomically.
 */
export async function bookAppointmentAction(input: {
  slotId: string;
  visitReason: string;
}): Promise<ActionResult<{ appointmentId: string }>> {
  try {
    const user = await requireRole(["PATIENT"], "/patient/doctors");
    const parsed = bookAppointmentSchema.safeParse(input);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the booking details." };
    }

    const supabase = await createClient();
    const { data, error } = await supabase.rpc("book_appointment", {
      p_slot_id: parsed.data.slotId,
      p_visit_reason: parsed.data.visitReason,
    });
    if (error) throw error;
    const appointment = (data ?? null) as { id: string } | null;
    if (!appointment) return { ok: false, error: "The appointment could not be created." };

    revalidateAppointmentViews();
    return { ok: true, data: { appointmentId: appointment.id } };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/**
 * Reschedule an appointment to a new slot. The SQL function verifies the
 * caller (patient owner or clinic staff) and enforces the state machine.
 */
export async function rescheduleAppointmentAction(input: {
  appointmentId: string;
  newSlotId: string;
}): Promise<ActionResult> {
  try {
    await requireRole(["PATIENT", "RECEPTIONIST", "CLINIC_ADMIN"], "/login");
    const parsed = rescheduleSchema.parse(input);

    const supabase = await createClient();
    const { error } = await supabase.rpc("reschedule_appointment", {
      p_appointment_id: parsed.appointmentId,
      p_new_slot_id: parsed.newSlotId,
    });
    if (error) throw error;

    revalidateAppointmentViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Cancel an appointment (patient owner or clinic staff). */
export async function cancelAppointmentAction(input: {
  appointmentId: string;
  reason?: string;
}): Promise<ActionResult> {
  try {
    await requireRole(["PATIENT", "RECEPTIONIST", "CLINIC_ADMIN"], "/login");
    const parsed = cancelSchema.parse(input);

    const supabase = await createClient();
    const { error } = await supabase.rpc("cancel_appointment", {
      p_appointment_id: parsed.appointmentId,
      p_reason: parsed.reason ?? null,
    });
    if (error) throw error;

    revalidateAppointmentViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Receptionist / clinic admin confirm a BOOKED appointment. */
export async function confirmAppointmentAction(appointmentId: string): Promise<ActionResult> {
  try {
    await requireRole(["RECEPTIONIST", "CLINIC_ADMIN"], "/staff");
    if (!/^[0-9a-f-]{36}$/i.test(appointmentId)) {
      return { ok: false, error: "Invalid appointment." };
    }
    const supabase = await createClient();
    const { error } = await supabase.rpc("confirm_appointment", {
      p_appointment_id: appointmentId,
    });
    if (error) throw error;

    revalidateAppointmentViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Receptionist / clinic admin mark a no-show. */
export async function markNoShowAction(appointmentId: string): Promise<ActionResult> {
  try {
    await requireRole(["RECEPTIONIST", "CLINIC_ADMIN"], "/staff");
    if (!/^[0-9a-f-]{36}$/i.test(appointmentId)) {
      return { ok: false, error: "Invalid appointment." };
    }
    const supabase = await createClient();
    const { error } = await supabase.rpc("mark_no_show", {
      p_appointment_id: appointmentId,
    });
    if (error) throw error;

    revalidateAppointmentViews();
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
