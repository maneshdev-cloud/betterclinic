import type { SupabaseClient } from "@supabase/supabase-js";
import type { Appointment, QueueEntry } from "@/lib/types/database";
import type { QueueStatus, Priority } from "@/lib/constants";
import { todayClinicDate } from "@/lib/utils";
import {
  sortByQueueOrder,
  bucketQueue,
  estimateWaitMinutes,
  averageMinutes,
  type QueueBuckets,
} from "@/lib/queue";

/* ── Views ─────────────────────────────────────────────────────── */

export interface QueueEntryView {
  id: string;
  token_code: string;
  token_number: number;
  priority: Priority;
  status: QueueStatus;
  clinic_id: string;
  doctor_id: string;
  doctor_name: string;
  patient_id: string;
  patient_name: string;
  appointment_id: string;
  appointment_type: "SCHEDULED" | "WALK_IN";
  visit_reason: string;
  appointment_time: string;
  created_at: string;
  called_at: string | null;
}

const QUEUE_SELECT = `
  id, token_code, token_number, priority, status, clinic_id, doctor_id,
  patient_id, appointment_id, created_at, called_at,
  patient:patients!queue_entries_patient_id_fkey(profile:profiles!patients_id_fkey(full_name)),
  doctor:doctors!queue_entries_doctor_id_fkey(profile:profiles!doctors_id_fkey(full_name)),
  appointment:appointments(visit_reason, start_time, appointment_type)
`;

interface RawQueueRow {
  id: string;
  token_code: string;
  token_number: number;
  priority: Priority;
  status: QueueStatus;
  clinic_id: string;
  doctor_id: string;
  patient_id: string;
  appointment_id: string;
  created_at: string;
  called_at: string | null;
  patient: { profile: { full_name: string } | null } | null;
  doctor: { profile: { full_name: string } | null } | null;
  appointment: { visit_reason: string; start_time: string; appointment_type: "SCHEDULED" | "WALK_IN" } | null;
}

function mapRow(row: RawQueueRow): QueueEntryView {
  return {
    id: row.id,
    token_code: row.token_code,
    token_number: row.token_number,
    priority: row.priority,
    status: row.status,
    clinic_id: row.clinic_id,
    doctor_id: row.doctor_id,
    doctor_name: row.doctor?.profile?.full_name ?? "Doctor",
    patient_id: row.patient_id,
    patient_name: row.patient?.profile?.full_name ?? "Patient",
    appointment_id: row.appointment_id,
    appointment_type: row.appointment?.appointment_type ?? "SCHEDULED",
    visit_reason: row.appointment?.visit_reason ?? "",
    appointment_time: row.appointment?.start_time ?? "",
    created_at: row.created_at,
    called_at: row.called_at,
  };
}

/* ── Board queries (RLS scopes rows per role) ──────────────────── */

/** Every queue entry for a clinic today (staff board). */
export async function listClinicQueueToday(
  client: SupabaseClient,
  clinicId: string
): Promise<QueueEntryView[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("queue_entries")
    .select(QUEUE_SELECT)
    .eq("clinic_id", clinicId)
    .eq("queue_date", today)
    .order("token_number")
    .limit(200);
  if (error) throw error;
  return ((data ?? []) as unknown as RawQueueRow[]).map(mapRow);
}

/** Queue entries for one doctor+clinic today (doctor board). */
export async function listDoctorQueueToday(
  client: SupabaseClient,
  clinicId: string,
  doctorId: string
): Promise<QueueEntryView[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("queue_entries")
    .select(QUEUE_SELECT)
    .eq("clinic_id", clinicId)
    .eq("doctor_id", doctorId)
    .eq("queue_date", today)
    .order("token_number")
    .limit(200);
  if (error) throw error;
  return ((data ?? []) as unknown as RawQueueRow[]).map(mapRow);
}

export interface PatientQueueStatus {
  entry: QueueEntryView;
  peopleAhead: number;
  position: number;
  nowServing: QueueEntryView | null;
  estimatedWaitMinutes: number | null;
  estimateBasis: "consultations" | "slot-length" | "none";
  waitingCount: number;
  queueEvents: { id: string; event_type: string; to_status: QueueStatus | null; note: string | null; created_at: string }[];
}

/**
 * The signed-in patient's live queue position for today: token, people
 * ahead (priority-ordered), who is being served right now, and a wait
 * estimate derived from that doctor's real consultation history.
 */
export async function getPatientQueueStatus(
  client: SupabaseClient,
  patientId: string
): Promise<PatientQueueStatus | null> {
  const today = todayClinicDate();

  const { data: myRows, error: myError } = await client
    .from("queue_entries")
    .select(QUEUE_SELECT)
    .eq("patient_id", patientId)
    .eq("queue_date", today)
    .in("status", ["WAITING", "CALLED", "IN_CONSULTATION"])
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (myError) throw myError;
  if (!myRows) return null;

  const entry = mapRow(myRows as unknown as RawQueueRow);

  // Everyone in this doctor's queue today (same clinic+doctor), to
  // compute the priority-ordered position and "now serving".
  const { data: allRows, error: allError } = await client
    .from("queue_entries")
    .select(QUEUE_SELECT)
    .eq("clinic_id", entry.clinic_id)
    .eq("doctor_id", entry.doctor_id)
    .eq("queue_date", today)
    .in("status", ["WAITING", "CALLED", "IN_CONSULTATION"])
    .limit(200);
  if (allError) throw allError;
  const active = ((allRows ?? []) as unknown as RawQueueRow[]).map(mapRow);

  const waiting = sortByQueueOrder(active.filter((e) => e.status === "WAITING"));
  const serving =
    active.find((e) => e.status === "IN_CONSULTATION") ??
    [...active.filter((e) => e.status === "CALLED")].sort(
      (a, b) => new Date(b.called_at ?? 0).getTime() - new Date(a.called_at ?? 0).getTime()
    )[0] ??
    null;

  let peopleAhead = 0;
  let position = 0;
  if (entry.status === "WAITING") {
    const index = waiting.findIndex((e) => e.id === entry.id);
    peopleAhead = index >= 0 ? index : waiting.length;
    position = peopleAhead + 1;
  }

  const [avgConsult, fallbackSlot] = await Promise.all([
    averageConsultationMinutes(client, entry.doctor_id),
    doctorSlotMinutes(client, entry.doctor_id),
  ]);
  const estimatedWaitMinutes = estimateWaitMinutes(peopleAhead, avgConsult, fallbackSlot);
  const estimateBasis: PatientQueueStatus["estimateBasis"] =
    avgConsult !== null ? "consultations" : fallbackSlot !== null ? "slot-length" : "none";

  const { data: events } = await client
    .from("queue_events")
    .select("id, event_type, to_status, note, created_at")
    .eq("queue_entry_id", entry.id)
    .order("created_at", { ascending: true })
    .limit(30);

  return {
    entry,
    peopleAhead,
    position,
    nowServing: serving,
    estimatedWaitMinutes,
    estimateBasis,
    waitingCount: waiting.length,
    queueEvents: ((events ?? []) as unknown as { id: string; event_type: string; to_status: QueueStatus | null; note: string | null; created_at: string }[]),
  };
}

/** Actual average consultation length (minutes) from completed consultations. */
export async function averageConsultationMinutes(
  client: SupabaseClient,
  doctorId: string
): Promise<number | null> {
  const { data, error } = await client
    .from("consultations")
    .select("started_at, completed_at")
    .eq("doctor_id", doctorId)
    .not("completed_at", "is", null)
    .order("completed_at", { ascending: false })
    .limit(50);
  if (error) throw error;
  const rows = (data ?? []) as unknown as { started_at: string; completed_at: string }[];
  const durations = rows.map((row) =>
    (new Date(row.completed_at).getTime() - new Date(row.started_at).getTime()) / 60000
  );
  return averageMinutes(durations);
}

/** The doctor's configured slot length (fallback wait basis). */
export async function doctorSlotMinutes(
  client: SupabaseClient,
  doctorId: string
): Promise<number | null> {
  const { data, error } = await client
    .from("doctor_availability")
    .select("slot_duration_minutes")
    .eq("doctor_id", doctorId)
    .limit(50);
  if (error) throw error;
  const rows = (data ?? []) as unknown as { slot_duration_minutes: number }[];
  if (rows.length === 0) return null;
  return Math.max(...rows.map((row) => row.slot_duration_minutes));
}

/* ── Check-in desk ─────────────────────────────────────────────── */

export interface CheckinableAppointment {
  id: string;
  status: Appointment["status"];
  start_time: string;
  end_time: string;
  doctor_name: string;
  clinic_name: string;
  visit_reason: string;
}

/**
 * Today's appointments a patient can still check in for (BOOKED or
 * CONFIRMED). Past-window ones are still returned (flagged via
 * end_time) so the UI can explain why the button is disabled.
 */
export async function listCheckinableAppointments(
  client: SupabaseClient,
  patientId: string
): Promise<CheckinableAppointment[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("appointments")
    .select(
      `id, status, start_time, end_time, visit_reason,
       doctor:doctors!appointments_doctor_id_fkey(profile:profiles!doctors_id_fkey(full_name)),
       clinic:clinics(name)`
    )
    .eq("patient_id", patientId)
    .eq("appointment_date", today)
    .in("status", ["BOOKED", "CONFIRMED"])
    .order("start_time")
    .limit(20);
  if (error) throw error;

  const rows = (data ?? []) as unknown as {
    id: string;
    status: Appointment["status"];
    start_time: string;
    end_time: string;
    visit_reason: string;
    doctor: { profile: { full_name: string } | null } | null;
    clinic: { name: string } | null;
  }[];
  return rows.map((row) => ({
    id: row.id,
    status: row.status,
    start_time: row.start_time,
    end_time: row.end_time,
    doctor_name: row.doctor?.profile?.full_name ?? "Doctor",
    clinic_name: row.clinic?.name ?? "Clinic",
    visit_reason: row.visit_reason,
  }));
}

/** Today's not-yet-checked-in appointments at a clinic (arrival desk). */
export interface ArrivalItem {
  id: string;
  status: Appointment["status"];
  start_time: string;
  end_time: string;
  patient_id: string;
  patient_name: string;
  doctor_name: string;
  visit_reason: string;
}

export async function listClinicArrivals(
  client: SupabaseClient,
  clinicId: string
): Promise<ArrivalItem[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("appointments")
    .select(
      `id, status, start_time, end_time, visit_reason, patient_id,
       patient:patients!appointments_patient_id_fkey(profile:profiles!patients_id_fkey(full_name)),
       doctor:doctors!appointments_doctor_id_fkey(profile:profiles!doctors_id_fkey(full_name))`
    )
    .eq("clinic_id", clinicId)
    .eq("appointment_date", today)
    .in("status", ["BOOKED", "CONFIRMED"])
    .order("start_time")
    .limit(50);
  if (error) throw error;
  const rows = (data ?? []) as unknown as {
    id: string;
    status: Appointment["status"];
    start_time: string;
    end_time: string;
    visit_reason: string;
    patient_id: string;
    patient: { profile: { full_name: string } | null } | null;
    doctor: { profile: { full_name: string } | null } | null;
  }[];
  return rows.map((row) => ({
    id: row.id,
    status: row.status,
    start_time: row.start_time,
    end_time: row.end_time,
    patient_id: row.patient_id,
    patient_name: row.patient?.profile?.full_name ?? "Patient",
    doctor_name: row.doctor?.profile?.full_name ?? "Doctor",
    visit_reason: row.visit_reason,
  }));
}

/** Doctors practising at a clinic (for the staff walk-in form). */
export async function listClinicDoctors(
  client: SupabaseClient,
  clinicId: string
): Promise<{ id: string; name: string; qualification: string }[]> {
  const { data: dcRows, error: dcError } = await client
    .from("doctor_clinics")
    .select("doctor_id")
    .eq("clinic_id", clinicId)
    .limit(100);
  if (dcError) throw dcError;
  const doctorIds = ((dcRows ?? []) as { doctor_id: string }[]).map((row) => row.doctor_id);
  if (doctorIds.length === 0) return [];

  const { data, error } = await client
    .from("doctors")
    .select("id, qualification, profile:profiles!doctors_id_fkey(full_name)")
    .in("id", doctorIds)
    .limit(100);
  if (error) throw error;
  const rows = (data ?? []) as unknown as {
    id: string;
    qualification: string;
    profile: { full_name: string } | null;
  }[];
  return rows
    .map((row) => ({
      id: row.id,
      name: row.profile?.full_name ?? "Doctor",
      qualification: row.qualification,
    }))
    .sort((a, b) => a.name.localeCompare(b.name));
}

/** Patient search for the walk-in desk (name or email, role PATIENT). */
export async function searchPatients(
  client: SupabaseClient,
  query: string
): Promise<{ id: string; full_name: string; email: string; phone: string | null }[]> {
  const { data, error } = await client
    .from("profiles")
    .select("id, full_name, email, phone")
    .eq("role", "PATIENT")
    .ilike("full_name", `%${query}%`)
    .limit(10);
  if (error) throw error;
  const byName = (data ?? []) as { id: string; full_name: string; email: string; phone: string | null }[];

  const { data: byEmailRows, error: emailError } = await client
    .from("profiles")
    .select("id, full_name, email, phone")
    .eq("role", "PATIENT")
    .ilike("email", `%${query}%`)
    .limit(10);
  if (emailError) throw emailError;
  const byEmail = (byEmailRows ?? []) as { id: string; full_name: string; email: string; phone: string | null }[];

  const merged = new Map<string, { id: string; full_name: string; email: string; phone: string | null }>();
  for (const row of [...byName, ...byEmail]) merged.set(row.id, row);
  return Array.from(merged.values()).slice(0, 10);
}

export type { QueueEntry, QueueBuckets };
export { bucketQueue };
