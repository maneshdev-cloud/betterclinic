import type { SupabaseClient } from "@supabase/supabase-js";
import {
  aggregateKpis,
  countNewPatients,
  dailySeries,
  parseAnalyticsRange,
  perDoctor,
  statusBreakdown,
  type AnalyticsKpis,
  type AnalyticsRange,
  type AppointmentFact,
  type DailyPoint,
  type DoctorRollup,
  type QueueFact,
  type StatusCount,
} from "@/lib/analytics/aggregate";

/**
 * Clinic analytics — every figure is aggregated from real appointment
 * and queue rows the clinic admin is allowed to read (RLS-scoped).
 * Clinical tables (consultations, prescriptions, …) are deliberately
 * NOT used: admins cannot read them by design, so analytics is
 * operational (appointments + queue) only.
 */

export interface DoctorAnalyticsRow {
  doctorId: string;
  name: string;
  qualification: string;
  specializations: string[];
  fee: number;
  avgRating: number;
  rollup: DoctorRollup;
}

export interface ClinicAnalytics {
  range: AnalyticsRange;
  kpis: AnalyticsKpis;
  newPatients: number;
  series: DailyPoint[];
  statuses: StatusCount[];
  doctors: DoctorAnalyticsRow[];
}

interface AppointmentFactRow {
  appointment_date: string;
  status: string;
  appointment_type: string;
  doctor_id: string;
  patient_id: string;
}

interface QueueFactRow {
  doctor_id: string;
  created_at: string;
  called_at: string | null;
  started_at: string | null;
  completed_at: string | null;
}

function addDayIso(dateStr: string): string {
  const base = new Date(`${dateStr}T12:00:00Z`);
  base.setUTCDate(base.getUTCDate() + 1);
  return base.toISOString().slice(0, 10);
}

export async function getClinicAnalytics(
  client: SupabaseClient,
  clinicId: string,
  params: Record<string, string | string[] | undefined>,
  doctorId?: string
): Promise<ClinicAnalytics> {
  const range = parseAnalyticsRange(params);

  // Facts inside the range (optionally narrowed to one doctor).
  let factsQuery = client
    .from("appointments")
    .select("appointment_date, status, appointment_type, doctor_id, patient_id")
    .eq("clinic_id", clinicId)
    .gte("appointment_date", range.from)
    .lte("appointment_date", range.to);
  if (doctorId) factsQuery = factsQuery.eq("doctor_id", doctorId);

  // Earlier history at this clinic (for new-vs-returning patients).
  let historyQuery = client
    .from("appointments")
    .select("appointment_date, patient_id")
    .eq("clinic_id", clinicId)
    .lt("appointment_date", range.from);
  if (doctorId) historyQuery = historyQuery.eq("doctor_id", doctorId);

  // Queue entries created inside the range (IST day boundaries).
  let queueQuery = client
    .from("queue_entries")
    .select("doctor_id, created_at, called_at, started_at, completed_at")
    .eq("clinic_id", clinicId)
    .gte("created_at", `${range.from}T00:00:00+05:30`)
    .lt("created_at", `${addDayIso(range.to)}T00:00:00+05:30`);
  if (doctorId) queueQuery = queueQuery.eq("doctor_id", doctorId);

  // Doctor metadata for the clinic.
  const doctorsQuery = client
    .from("doctor_clinics")
    .select(
      `doctor:doctors!doctor_clinics_doctor_id_fkey(
        id, qualification, consultation_fee, avg_rating,
        profile:profiles!doctors_id_fkey(full_name),
        doctor_specializations(specialization:specializations(name))
      )`
    )
    .eq("clinic_id", clinicId);

  const [factsRes, historyRes, queueRes, doctorsRes] = await Promise.all([
    factsQuery,
    historyQuery,
    queueQuery,
    doctorsQuery,
  ]);
  if (factsRes.error) throw factsRes.error;
  if (historyRes.error) throw historyRes.error;
  if (queueRes.error) throw queueRes.error;
  if (doctorsRes.error) throw doctorsRes.error;

  const facts = (factsRes.data ?? []) as unknown as AppointmentFactRow[];
  const history = (historyRes.data ?? []) as unknown as { appointment_date: string; patient_id: string }[];
  const queueFacts = (queueRes.data ?? []) as unknown as QueueFactRow[];
  const doctorRows = (doctorsRes.data ?? []) as unknown as {
    doctor: {
      id: string;
      qualification: string;
      consultation_fee: number;
      avg_rating: string | number;
      profile: { full_name: string } | null;
      doctor_specializations: { specialization: { name: string } }[];
    };
  }[];

  const apptFacts: AppointmentFact[] = facts;
  const queue: QueueFact[] = queueFacts;
  const rollups = perDoctor(apptFacts, queue);

  const doctors: DoctorAnalyticsRow[] = doctorRows
    .map((row) => row.doctor)
    .filter((doctor): doctor is NonNullable<typeof doctor> => Boolean(doctor))
    .map((doctor) => ({
      doctorId: doctor.id,
      name: doctor.profile?.full_name ?? "Unknown doctor",
      qualification: doctor.qualification,
      specializations: doctor.doctor_specializations.map((ds) => ds.specialization.name),
      fee: doctor.consultation_fee,
      avgRating: Number(doctor.avg_rating) || 0,
      rollup:
        rollups.get(doctor.id) ??
        ({
          doctorId: doctor.id,
          total: 0,
          completed: 0,
          cancelled: 0,
          noShow: 0,
          walkIns: 0,
          uniquePatients: 0,
          medianWaitMinutes: null,
          avgConsultMinutes: null,
        } as DoctorRollup),
    }))
    .sort((a, b) => b.rollup.total - a.rollup.total || a.name.localeCompare(b.name));

  return {
    range,
    kpis: aggregateKpis(apptFacts, queue),
    newPatients: countNewPatients(
      apptFacts,
      history.map((h) => ({ ...h, status: "", appointment_type: "", doctor_id: "" }))
    ),
    series: dailySeries(apptFacts, range),
    statuses: statusBreakdown(apptFacts),
    doctors,
  };
}
