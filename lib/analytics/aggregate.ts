import { todayClinicDate } from "@/lib/utils";

/**
 * Pure analytics aggregations for the clinic-admin dashboard.
 *
 * Every number is computed from fetched database rows (appointments and
 * queue entries — the tables clinic admins can read under RLS). Nothing
 * is estimated or invented: when there are no samples, the value is
 * null and the UI shows "not enough data yet".
 *
 * These functions are pure so they are unit-testable without a database.
 */

export type AnalyticsPreset = "7" | "30" | "90" | "custom";

export interface AnalyticsRange {
  preset: AnalyticsPreset;
  from: string; // YYYY-MM-DD (clinic/IST dates)
  to: string; // YYYY-MM-DD inclusive
}

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;
const MAX_SPAN_DAYS = 366;

function addDaysIso(dateStr: string, days: number): string {
  const base = new Date(`${dateStr}T12:00:00Z`);
  base.setUTCDate(base.getUTCDate() + days);
  return base.toISOString().slice(0, 10);
}

function daysBetween(fromStr: string, toStr: string): number {
  const a = new Date(`${fromStr}T12:00:00Z`).getTime();
  const b = new Date(`${toStr}T12:00:00Z`).getTime();
  return Math.round((b - a) / 86400000);
}

/**
 * Parse range params from the URL. Presets ("7" | "30" | "90") anchor on
 * today (IST); `from`/`to` give a custom range (max 366 days, from ≤ to).
 * Invalid input falls back to the last 30 days — analytics must never
 * crash on a hand-edited URL.
 */
export function parseAnalyticsRange(
  params: Record<string, string | string[] | undefined>
): AnalyticsRange {
  const single = (key: string): string | undefined => {
    const raw = params[key];
    const value = Array.isArray(raw) ? raw[0] : raw;
    return value && value.length > 0 ? value : undefined;
  };

  const preset = single("range");
  const today = todayClinicDate();

  if (preset === "7" || preset === "30" || preset === "90") {
    return { preset, from: addDaysIso(today, -(Number(preset) - 1)), to: today };
  }

  const from = single("from");
  const to = single("to");
  if (from && to && ISO_DATE.test(from) && ISO_DATE.test(to) && from <= to && daysBetween(from, to) < MAX_SPAN_DAYS) {
    return { preset: "custom", from, to };
  }

  return { preset: "30", from: addDaysIso(today, -29), to: today };
}

export interface AppointmentFact {
  appointment_date: string;
  status: string;
  appointment_type: string;
  doctor_id: string;
  patient_id: string;
}

export interface QueueFact {
  doctor_id: string;
  created_at: string;
  called_at: string | null;
  started_at: string | null;
  completed_at: string | null;
}

export interface AnalyticsKpis {
  total: number;
  completed: number;
  cancelled: number;
  noShow: number;
  walkIns: number;
  uniquePatients: number;
  /** Completed ÷ finalized (completed+cancelled+no-show); null when nothing finalized yet. */
  completionRate: number | null;
  noShowRate: number | null;
  /** Median minutes from check-in to token called; null without samples. */
  medianWaitMinutes: number | null;
  waitSamples: number;
  /** Mean minutes from consultation start to completion (queue timestamps); null without samples. */
  avgConsultMinutes: number | null;
  consultSamples: number;
}

const RESOLVED_STATUSES = new Set(["COMPLETED", "CANCELLED", "NO_SHOW"]);

export function median(values: number[]): number | null {
  if (values.length === 0) return null;
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  return sorted.length % 2 === 1 ? sorted[mid] : Math.round((sorted[mid - 1] + sorted[mid]) / 2);
}

function minutesBetween(fromIso: string, toIso: string): number {
  return (new Date(toIso).getTime() - new Date(fromIso).getTime()) / 60000;
}

export function aggregateKpis(appts: AppointmentFact[], queue: QueueFact[]): AnalyticsKpis {
  let completed = 0;
  let cancelled = 0;
  let noShow = 0;
  let walkIns = 0;
  const patients = new Set<string>();

  for (const appt of appts) {
    if (appt.status === "COMPLETED") completed += 1;
    else if (appt.status === "CANCELLED") cancelled += 1;
    else if (appt.status === "NO_SHOW") noShow += 1;
    if (appt.appointment_type === "WALK_IN") walkIns += 1;
    patients.add(appt.patient_id);
  }

  const finalized = completed + cancelled + noShow;

  const waits: number[] = [];
  const consults: number[] = [];
  for (const entry of queue) {
    if (entry.called_at && new Date(entry.called_at) > new Date(entry.created_at)) {
      waits.push(minutesBetween(entry.created_at, entry.called_at));
    }
    if (entry.started_at && entry.completed_at && new Date(entry.completed_at) > new Date(entry.started_at)) {
      consults.push(minutesBetween(entry.started_at, entry.completed_at));
    }
  }

  return {
    total: appts.length,
    completed,
    cancelled,
    noShow,
    walkIns,
    uniquePatients: patients.size,
    completionRate: finalized > 0 ? Math.round((completed / finalized) * 100) : null,
    noShowRate: finalized > 0 ? Math.round((noShow / finalized) * 100) : null,
    medianWaitMinutes: waits.length > 0 ? Math.max(1, median(waits) ?? 0) : null,
    waitSamples: waits.length,
    avgConsultMinutes:
      consults.length > 0
        ? Math.max(1, Math.round(consults.reduce((sum, v) => sum + v, 0) / consults.length))
        : null,
    consultSamples: consults.length,
  };
}

export interface DailyPoint {
  date: string;
  total: number;
  completed: number;
  cancelled: number;
}

/** One point per day in [from..to] — missing days are explicit zeros, not gaps. */
export function dailySeries(appts: AppointmentFact[], range: AnalyticsRange): DailyPoint[] {
  const byDate = new Map<string, DailyPoint>();
  const span = daysBetween(range.from, range.to);
  for (let i = 0; i <= span; i += 1) {
    const date = addDaysIso(range.from, i);
    byDate.set(date, { date, total: 0, completed: 0, cancelled: 0 });
  }
  for (const appt of appts) {
    const point = byDate.get(appt.appointment_date);
    if (!point) continue; // outside range (defensive)
    point.total += 1;
    if (appt.status === "COMPLETED") point.completed += 1;
    else if (appt.status === "CANCELLED") point.cancelled += 1;
  }
  return Array.from(byDate.values()).sort((a, b) => a.date.localeCompare(b.date));
}

export interface DoctorRollup {
  doctorId: string;
  total: number;
  completed: number;
  cancelled: number;
  noShow: number;
  walkIns: number;
  uniquePatients: number;
  medianWaitMinutes: number | null;
  avgConsultMinutes: number | null;
}

export function perDoctor(
  appts: AppointmentFact[],
  queue: QueueFact[]
): Map<string, DoctorRollup> {
  const rollups = new Map<string, DoctorRollup>();
  const patientsByDoctor = new Map<string, Set<string>>();
  const waitsByDoctor = new Map<string, number[]>();
  const consultsByDoctor = new Map<string, number[]>();

  const ensureRollup = (doctorId: string): DoctorRollup => {
    let entry = rollups.get(doctorId);
    if (!entry) {
      entry = {
        doctorId,
        total: 0,
        completed: 0,
        cancelled: 0,
        noShow: 0,
        walkIns: 0,
        uniquePatients: 0,
        medianWaitMinutes: null,
        avgConsultMinutes: null,
      };
      rollups.set(doctorId, entry);
      patientsByDoctor.set(doctorId, new Set());
      waitsByDoctor.set(doctorId, []);
      consultsByDoctor.set(doctorId, []);
    }
    return entry;
  };

  const ensureList = (map: Map<string, number[]>, doctorId: string): number[] => {
    ensureRollup(doctorId); // initializes every per-doctor list
    let list = map.get(doctorId);
    if (!list) {
      list = [];
      map.set(doctorId, list);
    }
    return list;
  };

  for (const appt of appts) {
    const entry = ensureRollup(appt.doctor_id);
    entry.total += 1;
    if (appt.status === "COMPLETED") entry.completed += 1;
    else if (appt.status === "CANCELLED") entry.cancelled += 1;
    else if (appt.status === "NO_SHOW") entry.noShow += 1;
    if (appt.appointment_type === "WALK_IN") entry.walkIns += 1;
    (patientsByDoctor.get(appt.doctor_id) as Set<string>).add(appt.patient_id);
  }

  for (const q of queue) {
    if (q.called_at && new Date(q.called_at) > new Date(q.created_at)) {
      ensureList(waitsByDoctor, q.doctor_id).push(minutesBetween(q.created_at, q.called_at));
    }
    if (q.started_at && q.completed_at && new Date(q.completed_at) > new Date(q.started_at)) {
      ensureList(consultsByDoctor, q.doctor_id).push(minutesBetween(q.started_at, q.completed_at));
    }
  }

  for (const [doctorId, entry] of Array.from(rollups.entries())) {
    entry.uniquePatients = (patientsByDoctor.get(doctorId) as Set<string>).size;
    const waits = waitsByDoctor.get(doctorId) ?? [];
    entry.medianWaitMinutes = waits.length > 0 ? Math.max(1, median(waits) ?? 0) : null;
    const consults = consultsByDoctor.get(doctorId) ?? [];
    entry.avgConsultMinutes =
      consults.length > 0
        ? Math.max(1, Math.round(consults.reduce((sum, v) => sum + v, 0) / consults.length))
        : null;
  }

  return rollups;
}

export interface StatusCount {
  status: string;
  count: number;
}

export function statusBreakdown(appts: AppointmentFact[]): StatusCount[] {
  const counts = new Map<string, number>();
  for (const appt of appts) {
    counts.set(appt.status, (counts.get(appt.status) ?? 0) + 1);
  }
  return Array.from(counts.entries())
    .map(([status, count]) => ({ status, count }))
    .sort((a, b) => b.count - a.count || a.status.localeCompare(b.status));
}

/**
 * Patients whose FIRST-EVER appointment at this clinic falls inside the
 * range — i.e. in-range patients with no earlier appointment here
 * (preRangeFacts = this clinic's appointments dated before the range).
 */
export function countNewPatients(
  inRange: AppointmentFact[],
  preRange: AppointmentFact[]
): number {
  const returning = new Set(preRange.map((a) => a.patient_id));
  const counted = new Set<string>();
  let newPatients = 0;
  for (const appt of inRange) {
    if (returning.has(appt.patient_id) || counted.has(appt.patient_id)) continue;
    counted.add(appt.patient_id);
    newPatients += 1;
  }
  return newPatients;
}

export { RESOLVED_STATUSES };
