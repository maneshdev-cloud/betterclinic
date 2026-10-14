import type { SupabaseClient } from "@supabase/supabase-js";
import {
  addDaysIso,
  aggregateKpis,
  countNewPatients,
  dailySeries,
  daysBetween,
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
import { isHideDemoEnabled } from "@/lib/demo";

/**
 * Clinic analytics — aggregated either via PostgreSQL RPC (00032_clinic_analytics_summary)
 * or fallback aggregate queries, strictly scoped to the authorized clinic (RLS-scoped).
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

export async function getClinicAnalytics(
  client: SupabaseClient,
  clinicId: string,
  params: Record<string, string | string[] | undefined>,
  doctorId?: string
): Promise<ClinicAnalytics> {
  const range = parseAnalyticsRange(params);
  const hideDemo = isHideDemoEnabled();

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

  // 1. Try PostgreSQL RPC for database-side aggregation (fast, scalable, no raw row capping)
  const rpcPromise = client.rpc("get_clinic_analytics_summary", {
    p_clinic_id: clinicId,
    p_from: range.from,
    p_to: range.to,
    p_doctor_id: doctorId ?? null,
    p_hide_demo: hideDemo,
  });

  const [rpcRes, doctorsRes] = await Promise.all([rpcPromise, doctorsQuery]);
  if (doctorsRes.error) throw doctorsRes.error;

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

  // If the database RPC is available, return the server-computed aggregation
  if (!rpcRes.error && rpcRes.data) {
    const summary = rpcRes.data as {
      kpis: AnalyticsKpis;
      newPatients: number;
      dailySeries: DailyPoint[];
      statuses: StatusCount[];
      doctorRollups: DoctorRollup[];
    };

    const rollupsMap = new Map<string, DoctorRollup>();
    for (const r of summary.doctorRollups ?? []) {
      rollupsMap.set(r.doctorId, r);
    }

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
          rollupsMap.get(doctor.id) ??
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

    // Ensure all days in the range exist with explicit zeros
    const seriesMap = new Map<string, DailyPoint>();
    const span = daysBetween(range.from, range.to);
    for (let i = 0; i <= span; i += 1) {
      const date = addDaysIso(range.from, i);
      seriesMap.set(date, { date, total: 0, completed: 0, cancelled: 0 });
    }
    for (const point of summary.dailySeries ?? []) {
      if (seriesMap.has(point.date)) {
        seriesMap.set(point.date, point);
      }
    }
    const series = Array.from(seriesMap.values()).sort((a, b) => a.date.localeCompare(b.date));

    return {
      range,
      kpis: summary.kpis,
      newPatients: summary.newPatients,
      series,
      statuses: summary.statuses ?? [],
      doctors,
    };
  }

  // Fallback: in environments where the RPC migration has not been applied yet
  let factsQuery = client
    .from("appointments")
    .select("appointment_date, status, appointment_type, doctor_id, patient_id")
    .eq("clinic_id", clinicId)
    .gte("appointment_date", range.from)
    .lte("appointment_date", range.to);
  if (doctorId) factsQuery = factsQuery.eq("doctor_id", doctorId);

  let historyQuery = client
    .from("appointments")
    .select("appointment_date, patient_id")
    .eq("clinic_id", clinicId)
    .lt("appointment_date", range.from);
  if (doctorId) historyQuery = historyQuery.eq("doctor_id", doctorId);

  let queueQuery = client
    .from("queue_entries")
    .select("doctor_id, created_at, called_at, started_at, completed_at")
    .eq("clinic_id", clinicId)
    .gte("created_at", `${range.from}T00:00:00+05:30`)
    .lt("created_at", `${addDaysIso(range.to, 1)}T00:00:00+05:30`);
  if (doctorId) queueQuery = queueQuery.eq("doctor_id", doctorId);

  const [factsRes, historyRes, queueRes] = await Promise.all([
    factsQuery,
    historyQuery,
    queueQuery,
  ]);
  if (factsRes.error) throw factsRes.error;
  if (historyRes.error) throw historyRes.error;
  if (queueRes.error) throw queueRes.error;

  const facts = (factsRes.data ?? []) as unknown as AppointmentFactRow[];
  const history = (historyRes.data ?? []) as unknown as { appointment_date: string; patient_id: string }[];
  const queueFacts = (queueRes.data ?? []) as unknown as QueueFactRow[];

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
