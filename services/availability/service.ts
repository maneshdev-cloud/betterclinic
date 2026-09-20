import type { SupabaseClient } from "@supabase/supabase-js";
import { availabilityPayloadSchema, type AvailabilityPayloadInput } from "@/lib/validation/appointments";
import { todayClinicDate, nowClinicTime, clinicDatePlusDays } from "@/lib/utils";
import type { DoctorAvailability } from "@/lib/types/database";

/** Slots are generated on demand for a 60-day booking window. */
export const BOOKING_WINDOW_DAYS = 60;

export interface SlotSummary {
  id: string;
  start_time: string;
  end_time: string;
}

export interface DoctorClinicOption {
  clinic_id: string;
  clinic_name: string;
  city: string;
  area: string;
  is_primary: boolean;
}

/**
 * Ensure the slot rows for a doctor/clinic/date exist (generated from the
 * doctor's availability by the `ensure_slots` SQL function) and return the
 * bookable ones: FREE slots that have not already passed today.
 */
export async function getSlotsForDate(
  client: SupabaseClient,
  doctorId: string,
  clinicId: string,
  date: string
): Promise<SlotSummary[]> {
  const today = todayClinicDate();
  if (date < today || date > clinicDatePlusDays(BOOKING_WINDOW_DAYS)) {
    return [];
  }

  const { data, error } = await client.rpc("ensure_slots", {
    p_doctor: doctorId,
    p_clinic: clinicId,
    p_date: date,
  });
  if (error) throw error;

  const rows = (data ?? []) as { id: string; start_time: string; end_time: string; status: string }[];
  const nowTime = nowClinicTime();
  return rows
    .filter((row) => row.status === "FREE")
    .filter((row) => (date === today ? row.start_time > nowTime : true))
    .map((row) => ({ id: row.id, start_time: row.start_time, end_time: row.end_time }));
}

/** Clinics a doctor is linked to (for the availability editor dropdown). */
export async function getDoctorClinicOptions(
  client: SupabaseClient,
  doctorId: string
): Promise<DoctorClinicOption[]> {
  const { data, error } = await client
    .from("doctor_clinics")
    .select("is_primary, clinic:clinics(id, name, city, area)")
    .eq("doctor_id", doctorId)
    .order("is_primary", { ascending: false });
  if (error) throw error;
  const rows = (data ?? []) as unknown as {
    is_primary: boolean;
    clinic: { id: string; name: string; city: string; area: string } | null;
  }[];
  return rows
    .filter((row) => row.clinic)
    .map((row) => ({
      clinic_id: row.clinic!.id,
      clinic_name: row.clinic!.name,
      city: row.clinic!.city,
      area: row.clinic!.area,
      is_primary: row.is_primary,
    }));
}

/** Current availability rows for one doctor+clinic (all days, for the editor). */
export async function getAvailabilityForClinic(
  client: SupabaseClient,
  doctorId: string,
  clinicId: string
): Promise<DoctorAvailability[]> {
  const { data, error } = await client
    .from("doctor_availability")
    .select("*")
    .eq("doctor_id", doctorId)
    .eq("clinic_id", clinicId)
    .order("day_of_week")
    .order("start_time");
  if (error) throw error;
  return (data ?? []) as DoctorAvailability[];
}

export interface SaveAvailabilityResult {
  savedDays: number;
}

/**
 * Replace the doctor's weekly availability at one clinic:
 * validate with zod, verify the doctor practises at the clinic, delete the
 * existing rows, insert the enabled days, then drop FREE future slots so
 * they regenerate on demand (BOOKED slots always survive).
 */
export async function saveAvailability(
  client: SupabaseClient,
  doctorId: string,
  payload: AvailabilityPayloadInput
): Promise<SaveAvailabilityResult> {
  const parsed = availabilityPayloadSchema.parse(payload);

  const { data: link, error: linkError } = await client
    .from("doctor_clinics")
    .select("clinic_id")
    .eq("doctor_id", doctorId)
    .eq("clinic_id", parsed.clinicId)
    .maybeSingle();
  if (linkError) throw linkError;
  if (!link) {
    throw new Error("[FORBIDDEN] You are not linked to this clinic");
  }

  const enabledDays = parsed.days.filter((day) => day.enabled);

  // Delete-then-insert inside a transaction-ish sequence: RLS restricts
  // doctor_availability to the owning doctor, so this is safe.
  const { error: deleteError } = await client
    .from("doctor_availability")
    .delete()
    .eq("doctor_id", doctorId)
    .eq("clinic_id", parsed.clinicId);
  if (deleteError) throw deleteError;

  if (enabledDays.length > 0) {
    const rows = enabledDays.map((day) => ({
      doctor_id: doctorId,
      clinic_id: parsed.clinicId,
      day_of_week: day.dayOfWeek,
      start_time: day.startTime,
      end_time: day.endTime,
      break_start: day.breakEnabled ? day.breakStart : null,
      break_end: day.breakEnabled ? day.breakEnd : null,
      slot_duration_minutes: day.slotDurationMinutes,
      is_active: true,
    }));
    const { error: insertError } = await client.from("doctor_availability").insert(rows);
    if (insertError) throw insertError;
  }

  // FREE future slots for this doctor+clinic regenerate from the new
  // availability the next time a patient asks for them.
  const { error: refreshError } = await client.rpc("refresh_future_slots", {
    p_doctor: doctorId,
    p_clinic: parsed.clinicId,
  });
  if (refreshError) throw refreshError;

  return { savedDays: enabledDays.length };
}
