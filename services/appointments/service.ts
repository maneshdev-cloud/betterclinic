import type { SupabaseClient } from "@supabase/supabase-js";
import type { Appointment } from "@/lib/types/database";
import { pageRange, totalPages, todayClinicDate } from "@/lib/utils";
import type { SearchResult } from "@/services/doctors/service";

/** Statuses where an appointment is still "live". */
export const ACTIVE_STATUSES = [
  "BOOKED",
  "CONFIRMED",
  "CHECKED_IN",
  "WAITING",
  "CALLED",
  "IN_CONSULTATION",
] as const;

/** Statuses an appointment can never leave. */
export const TERMINAL_STATUSES = ["COMPLETED", "CANCELLED", "NO_SHOW"] as const;

export type AppointmentTab = "upcoming" | "past";

const PATIENT_PAGE_SIZE = 10;
const STAFF_PAGE_SIZE = 15;
/** Past-tab safety cap for the merge queries (prototype scale). */
const MERGE_FETCH_CAP = 500;

export interface PatientAppointmentItem {
  id: string;
  doctor_id: string;
  clinic_id: string;
  status: Appointment["status"];
  appointment_type: Appointment["appointment_type"];
  appointment_date: string;
  start_time: string;
  end_time: string;
  visit_reason: string;
  notes: string | null;
  cancellation_reason: string | null;
  doctor_name: string;
  doctor_qualification: string;
  clinic_name: string;
  clinic_city: string;
  clinic_area: string;
}

const PATIENT_APPT_SELECT = `
  id, doctor_id, clinic_id, status, appointment_type, appointment_date,
  start_time, end_time, visit_reason, notes, cancellation_reason,
  doctor:doctors!appointments_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name)),
  clinic:clinics(name, city, area)
`;

interface RawPatientRow {
  id: string;
  doctor_id: string;
  clinic_id: string;
  status: Appointment["status"];
  appointment_type: Appointment["appointment_type"];
  appointment_date: string;
  start_time: string;
  end_time: string;
  visit_reason: string;
  notes: string | null;
  cancellation_reason: string | null;
  doctor: { qualification: string; profile: { full_name: string } | null } | null;
  clinic: { name: string; city: string; area: string } | null;
}

function mapPatientRow(row: RawPatientRow): PatientAppointmentItem {
  return {
    id: row.id,
    doctor_id: row.doctor_id,
    clinic_id: row.clinic_id,
    status: row.status,
    appointment_type: row.appointment_type,
    appointment_date: row.appointment_date,
    start_time: row.start_time,
    end_time: row.end_time,
    visit_reason: row.visit_reason,
    notes: row.notes,
    cancellation_reason: row.cancellation_reason,
    doctor_name: row.doctor?.profile?.full_name ?? "Doctor",
    doctor_qualification: row.doctor?.qualification ?? "",
    clinic_name: row.clinic?.name ?? "Clinic",
    clinic_city: row.clinic?.city ?? "",
    clinic_area: row.clinic?.area ?? "",
  };
}

/**
 * A patient's appointments split into upcoming (active, today or later)
 * and past (finished, or before today). Both tabs are real queries with
 * real pagination.
 */
export async function listPatientAppointments(
  client: SupabaseClient,
  patientId: string,
  tab: AppointmentTab,
  page = 1
): Promise<SearchResult<PatientAppointmentItem>> {
  const today = todayClinicDate();
  const { from, to } = pageRange(page, PATIENT_PAGE_SIZE);

  if (tab === "upcoming") {
    const { data, error, count } = await client
      .from("appointments")
      .select(PATIENT_APPT_SELECT, { count: "exact" })
      .eq("patient_id", patientId)
      .in("status", [...ACTIVE_STATUSES])
      .gte("appointment_date", today)
      .order("appointment_date", { ascending: true })
      .order("start_time", { ascending: true })
      .range(from, to);
    if (error) throw error;
    const items = ((data ?? []) as unknown as RawPatientRow[]).map(mapPatientRow);
    const total = count ?? items.length;
    return {
      items,
      total,
      page,
      pageSize: PATIENT_PAGE_SIZE,
      totalPages: totalPages(total, PATIENT_PAGE_SIZE),
    };
  }

  // Past tab: two simple queries (PostgREST cannot express the OR across
  // date and status cleanly), merged and paginated in memory.
  const [older, terminalFuture] = await Promise.all([
    client
      .from("appointments")
      .select(PATIENT_APPT_SELECT)
      .eq("patient_id", patientId)
      .lt("appointment_date", today)
      .order("appointment_date", { ascending: false })
      .order("start_time", { ascending: false })
      .limit(MERGE_FETCH_CAP),
    client
      .from("appointments")
      .select(PATIENT_APPT_SELECT)
      .eq("patient_id", patientId)
      .gte("appointment_date", today)
      .in("status", [...TERMINAL_STATUSES])
      .order("appointment_date", { ascending: false })
      .order("start_time", { ascending: false })
      .limit(MERGE_FETCH_CAP),
  ]);
  if (older.error) throw older.error;
  if (terminalFuture.error) throw terminalFuture.error;

  const seen = new Set<string>();
  const merged = [
    ...((older.data ?? []) as unknown as RawPatientRow[]),
    ...((terminalFuture.data ?? []) as unknown as RawPatientRow[]),
  ]
    .filter((row) => (seen.has(row.id) ? false : (seen.add(row.id), true)))
    .sort((a, b) =>
      a.appointment_date === b.appointment_date
        ? b.start_time.localeCompare(a.start_time)
        : b.appointment_date.localeCompare(a.appointment_date)
    )
    .map(mapPatientRow);

  return {
    items: merged.slice(from, to + 1),
    total: merged.length,
    page,
    pageSize: PATIENT_PAGE_SIZE,
    totalPages: totalPages(merged.length, PATIENT_PAGE_SIZE),
  };
}

export interface StatusHistoryEntry {
  id: string;
  from_status: Appointment["status"] | null;
  to_status: Appointment["status"];
  reason: string | null;
  created_at: string;
  changed_by_name: string | null;
}

export interface AppointmentDetail {
  appointment: PatientAppointmentItem;
  fee: number | null;
  history: StatusHistoryEntry[];
}

/** Full appointment detail + status timeline. RLS decides who may see it. */
export async function getAppointmentDetail(
  client: SupabaseClient,
  appointmentId: string
): Promise<AppointmentDetail | null> {
  const { data, error } = await client
    .from("appointments")
    .select(`
      id, doctor_id, clinic_id, status, appointment_type, appointment_date,
      start_time, end_time, visit_reason, notes, cancellation_reason,
      doctor:doctors!appointments_doctor_id_fkey(qualification, consultation_fee, profile:profiles!doctors_id_fkey(full_name)),
      clinic:clinics(name, city, area)
    `)
    .eq("id", appointmentId)
    .maybeSingle();
  if (error) throw error;
  if (!data) return null;

  const row = data as unknown as RawPatientRow & {
    doctor: { consultation_fee: number; qualification: string; profile: { full_name: string } | null } | null;
  };

  const { data: history, error: historyError } = await client
    .from("appointment_status_history")
    .select("id, from_status, to_status, reason, created_at, changed_by:profiles!appointment_status_history_changed_by_fkey(full_name)")
    .eq("appointment_id", appointmentId)
    .order("created_at", { ascending: true })
    .limit(50);
  if (historyError) throw historyError;

  const historyRows = (history ?? []) as unknown as {
    id: string;
    from_status: Appointment["status"] | null;
    to_status: Appointment["status"];
    reason: string | null;
    created_at: string;
    changed_by: { full_name: string } | null;
  }[];

  return {
    appointment: mapPatientRow(row),
    fee: row.doctor?.consultation_fee ?? null,
    history: historyRows.map((entry) => ({
      id: entry.id,
      from_status: entry.from_status,
      to_status: entry.to_status,
      reason: entry.reason,
      created_at: entry.created_at,
      changed_by_name: entry.changed_by?.full_name ?? null,
    })),
  };
}

/* ── Staff (receptionist / clinic admin) ────────────────────────── */

export interface StaffAppointmentItem extends PatientAppointmentItem {
  patient_name: string;
  doctor_name: string;
}

const STAFF_APPT_SELECT = `
  id, status, appointment_type, appointment_date, start_time, end_time,
  visit_reason, notes, cancellation_reason,
  patient:patients!appointments_patient_id_fkey(profile:profiles!patients_id_fkey(full_name)),
  doctor:doctors!appointments_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name)),
  clinic:clinics(name, city, area)
`;

interface RawStaffRow extends RawPatientRow {
  patient: { profile: { full_name: string } | null } | null;
}

function mapStaffRow(row: RawStaffRow): StaffAppointmentItem {
  return {
    ...mapPatientRow(row),
    patient_name: row.patient?.profile?.full_name ?? "Patient",
  };
}

export type StaffView = "today" | "upcoming" | "past" | "search";

/** Today's schedule for the staff dashboard (all live rows, small enough). */
export async function listStaffToday(
  client: SupabaseClient,
  clinicId: string
): Promise<StaffAppointmentItem[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("appointments")
    .select(STAFF_APPT_SELECT)
    .eq("clinic_id", clinicId)
    .eq("appointment_date", today)
    .order("start_time", { ascending: true })
    .limit(200);
  if (error) throw error;
  return ((data ?? []) as unknown as RawStaffRow[]).map(mapStaffRow);
}

/** Today's schedule for the doctor's dashboard. */
export async function listDoctorToday(
  client: SupabaseClient,
  doctorId: string
): Promise<StaffAppointmentItem[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("appointments")
    .select(STAFF_APPT_SELECT)
    .eq("doctor_id", doctorId)
    .eq("appointment_date", today)
    .order("start_time", { ascending: true })
    .limit(50);
  if (error) throw error;
  return ((data ?? []) as unknown as RawStaffRow[]).map(mapStaffRow);
}

/** Real-time-ish counts derived from today's rows (no faked numbers). */
export async function getStaffTodayCounts(
  client: SupabaseClient,
  clinicId: string
): Promise<{ total: number; booked: number; confirmed: number; checkedIn: number; inConsultation: number; completed: number; cancelled: number; noShow: number }> {
  const rows = await listStaffToday(client, clinicId);
  const count = (pred: (row: StaffAppointmentItem) => boolean) => rows.filter(pred).length;
  return {
    total: rows.length,
    booked: count((r) => r.status === "BOOKED"),
    confirmed: count((r) => r.status === "CONFIRMED"),
    checkedIn: count((r) => r.status === "CHECKED_IN" || r.status === "WAITING" || r.status === "CALLED"),
    inConsultation: count((r) => r.status === "IN_CONSULTATION"),
    completed: count((r) => r.status === "COMPLETED"),
    cancelled: count((r) => r.status === "CANCELLED"),
    noShow: count((r) => r.status === "NO_SHOW"),
  };
}

/** Future appointments (after today), paginated. */
export async function listStaffUpcoming(
  client: SupabaseClient,
  clinicId: string,
  page = 1
): Promise<SearchResult<StaffAppointmentItem>> {
  const today = todayClinicDate();
  const { from, to } = pageRange(page, STAFF_PAGE_SIZE);
  const { data, error, count } = await client
    .from("appointments")
    .select(STAFF_APPT_SELECT, { count: "exact" })
    .eq("clinic_id", clinicId)
    .gt("appointment_date", today)
    .in("status", [...ACTIVE_STATUSES])
    .order("appointment_date", { ascending: true })
    .order("start_time", { ascending: true })
    .range(from, to);
  if (error) throw error;
  const items = ((data ?? []) as unknown as RawStaffRow[]).map(mapStaffRow);
  const total = count ?? items.length;
  return {
    items,
    total,
    page,
    pageSize: STAFF_PAGE_SIZE,
    totalPages: totalPages(total, STAFF_PAGE_SIZE),
  };
}

/** Past appointments for the staff view (same two-query merge as patients). */
export async function listStaffPast(
  client: SupabaseClient,
  clinicId: string,
  page = 1
): Promise<SearchResult<StaffAppointmentItem>> {
  const today = todayClinicDate();
  const [older, terminalFuture] = await Promise.all([
    client
      .from("appointments")
      .select(STAFF_APPT_SELECT)
      .eq("clinic_id", clinicId)
      .lt("appointment_date", today)
      .order("appointment_date", { ascending: false })
      .order("start_time", { ascending: false })
      .limit(MERGE_FETCH_CAP),
    client
      .from("appointments")
      .select(STAFF_APPT_SELECT)
      .eq("clinic_id", clinicId)
      .gte("appointment_date", today)
      .in("status", [...TERMINAL_STATUSES])
      .order("appointment_date", { ascending: false })
      .order("start_time", { ascending: false })
      .limit(MERGE_FETCH_CAP),
  ]);
  if (older.error) throw older.error;
  if (terminalFuture.error) throw terminalFuture.error;

  const seen = new Set<string>();
  const merged = [
    ...((older.data ?? []) as unknown as RawStaffRow[]),
    ...((terminalFuture.data ?? []) as unknown as RawStaffRow[]),
  ]
    .filter((row) => (seen.has(row.id) ? false : (seen.add(row.id), true)))
    .sort((a, b) =>
      a.appointment_date === b.appointment_date
        ? b.start_time.localeCompare(a.start_time)
        : b.appointment_date.localeCompare(a.appointment_date)
    )
    .map(mapStaffRow);

  const { from, to } = pageRange(page, STAFF_PAGE_SIZE);
  return {
    items: merged.slice(from, to + 1),
    total: merged.length,
    page,
    pageSize: STAFF_PAGE_SIZE,
    totalPages: totalPages(merged.length, STAFF_PAGE_SIZE),
  };
}

/**
 * Search upcoming appointments by patient name: resolve matching patient
 * ids from profiles first (plain-column query), then filter appointments.
 */
export async function searchStaffAppointments(
  client: SupabaseClient,
  clinicId: string,
  query: string,
  page = 1
): Promise<SearchResult<StaffAppointmentItem>> {
  const today = todayClinicDate();
  const { data: profileRows, error: profileError } = await client
    .from("profiles")
    .select("id")
    .eq("role", "PATIENT")
    .ilike("full_name", `%${query}%`)
    .limit(100);
  if (profileError) throw profileError;

  const patientIds = ((profileRows ?? []) as { id: string }[]).map((row) => row.id);
  if (patientIds.length === 0) {
    return { items: [], total: 0, page, pageSize: STAFF_PAGE_SIZE, totalPages: 1 };
  }

  const { from, to } = pageRange(page, STAFF_PAGE_SIZE);
  const { data, error, count } = await client
    .from("appointments")
    .select(STAFF_APPT_SELECT, { count: "exact" })
    .eq("clinic_id", clinicId)
    .in("patient_id", patientIds)
    .gte("appointment_date", today)
    .in("status", [...ACTIVE_STATUSES])
    .order("appointment_date", { ascending: true })
    .order("start_time", { ascending: true })
    .range(from, to);
  if (error) throw error;

  const items = ((data ?? []) as unknown as RawStaffRow[]).map(mapStaffRow);
  const total = count ?? items.length;
  return {
    items,
    total,
    page,
    pageSize: STAFF_PAGE_SIZE,
    totalPages: totalPages(total, STAFF_PAGE_SIZE),
  };
}
