"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole, getSessionUser } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import {
  getSlotsForDate,
  saveAvailability,
  type SlotSummary,
} from "@/services/availability/service";
import { availabilityPayloadSchema } from "@/lib/validation/appointments";

export interface ActionResult<T = undefined> {
  ok: boolean;
  error?: string;
  data?: T;
}

/**
 * Fetch bookable slots for a doctor/clinic/date. Runs on the server so the
 * slot generation RPC is called with an authenticated client. Called by
 * patient booking components.
 */
export async function getSlotsAction(input: {
  doctorId: string;
  clinicId: string;
  date: string;
}): Promise<ActionResult<SlotSummary[]>> {
  try {
    // Called programmatically (not via <form>), so return an error instead
    // of redirecting when the session has expired.
    const user = await getSessionUser();
    if (!user) {
      return { ok: false, error: "Please sign in again to see available times." };
    }
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(input.date)) {
      return { ok: false, error: "Please choose a valid date." };
    }
    const supabase = await createClient();
    const slots = await getSlotsForDate(supabase, input.doctorId, input.clinicId, input.date);
    return { ok: true, data: slots };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Save the doctor's weekly availability for one clinic. */
export async function saveAvailabilityAction(payload: unknown): Promise<ActionResult<{ savedDays: number }>> {
  try {
    const user = await requireRole(["DOCTOR"], "/doctor");
    const parsed = availabilityPayloadSchema.safeParse(payload);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the schedule details." };
    }
    const supabase = await createClient();
    const result = await saveAvailability(supabase, user.id, parsed.data);
    revalidatePath("/doctor/availability");
    revalidatePath("/doctor");
    return { ok: true, data: result };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
