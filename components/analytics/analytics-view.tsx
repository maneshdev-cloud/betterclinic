import Link from "next/link";
import {
  CalendarCheck,
  CalendarX,
  ClipboardCheck,
  Clock,
  Footprints,
  Stethoscope,
  UserPlus,
  Users,
  UserX,
} from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { EmptyState } from "@/components/shared/empty-state";
import { StackedBarChart } from "@/components/analytics/bar-chart";
import { buildQueryString } from "@/lib/search-params";
import { formatINR } from "@/lib/utils";
import type { ClinicAnalytics } from "@/services/analytics/service";

/**
 * Clinic analytics view — every figure comes from ClinicAnalytics, which
 * is aggregated from real appointment + queue rows only. When a metric
 * has no samples it says "not enough data yet" instead of showing 0%-ish
 * inventions.
 */

const STATUS_LABELS: Record<string, string> = {
  BOOKED: "Booked",
  CONFIRMED: "Confirmed",
  CHECKED_IN: "Checked in",
  WAITING: "Waiting",
  CALLED: "Called",
  IN_CONSULTATION: "In consultation",
  COMPLETED: "Completed",
  CANCELLED: "Cancelled",
  NO_SHOW: "No-show",
};

const PRESETS: { key: "7" | "30" | "90"; label: string }[] = [
  { key: "7", label: "7 days" },
  { key: "30", label: "30 days" },
  { key: "90", label: "90 days" },
];

function KpiCard({
  icon: Icon,
  label,
  value,
  hint,
}: {
  icon: typeof Clock;
  label: string;
  value: string;
  hint?: string;
}) {
  return (
    <Card>
      <CardContent className="flex items-start gap-3">
        <span className="mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-muted">
          <Icon className="h-4 w-4 text-muted-foreground" aria-hidden />
        </span>
        <div>
          <p className="text-xs font-medium text-muted-foreground">{label}</p>
          <p className="text-xl font-semibold tabular-nums">{value}</p>
          {hint ? <p className="mt-0.5 text-xs text-muted-foreground">{hint}</p> : null}
        </div>
      </CardContent>
    </Card>
  );
}

export function AnalyticsView({
  analytics,
  basePath,
  selectedDoctorId,
  doctorOptions,
}: {
  analytics: ClinicAnalytics;
  basePath: string;
  selectedDoctorId?: string;
  doctorOptions: { id: string; name: string }[];
}) {
  const { range, kpis, series, statuses, doctors, newPatients } = analytics;
  const isCustom = range.preset === "custom";

  const rangeHref = (preset: "7" | "30" | "90") =>
    `${basePath}${buildQueryString({ range: preset === "30" ? undefined : preset, doctor: selectedDoctorId || undefined })}`;

  const chartPoints = series.map((point) => ({
    label: point.date.slice(5), // MM-DD
    title: `${point.date}: ${point.total} appointment${point.total === 1 ? "" : "s"} (${point.completed} completed, ${point.cancelled} cancelled)`,
    segments: [
      { value: point.completed, className: "bg-teal-500/80" },
      { value: point.cancelled, className: "bg-red-400/80" },
      {
        value: Math.max(0, point.total - point.completed - point.cancelled),
        className: "bg-slate-300",
      },
    ],
  }));

  return (
    <div className="space-y-6">
      {/* Range + doctor filters (URL state, no client JS needed) */}
      <div className="flex flex-wrap items-end justify-between gap-3">
        <div className="flex items-center gap-1 rounded-lg border bg-muted/40 p-1" role="tablist" aria-label="Date range">
          {PRESETS.map((preset) => (
            <Link
              key={preset.key}
              href={rangeHref(preset.key)}
              role="tab"
              aria-selected={!isCustom && range.preset === preset.key}
              className={
                !isCustom && range.preset === preset.key
                  ? "rounded-md bg-background px-3 py-1.5 text-sm font-medium shadow-sm"
                  : "rounded-md px-3 py-1.5 text-sm text-muted-foreground hover:text-foreground"
              }
            >
              {preset.label}
            </Link>
          ))}
          {isCustom ? (
            <span className="rounded-md bg-background px-3 py-1.5 text-sm font-medium shadow-sm">
              {range.from} → {range.to}
            </span>
          ) : null}
        </div>

        {doctorOptions.length > 1 ? (
          <form method="GET" action={basePath} className="flex items-end gap-2">
            {isCustom ? (
              <>
                <input type="hidden" name="from" value={range.from} />
                <input type="hidden" name="to" value={range.to} />
              </>
            ) : (
              <input type="hidden" name="range" value={range.preset} />
            )}
            <div>
              <label htmlFor="analytics-doctor" className="mb-1 block text-xs font-medium text-muted-foreground">
                Doctor
              </label>
              <select
                id="analytics-doctor"
                name="doctor"
                defaultValue={selectedDoctorId ?? ""}
                className="h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="">All doctors</option>
                {doctorOptions.map((doctor) => (
                  <option key={doctor.id} value={doctor.id}>
                    {doctor.name}
                  </option>
                ))}
              </select>
            </div>
            <button
              type="submit"
              className="h-9 rounded-md border bg-background px-3 text-sm font-medium hover:bg-muted/50"
            >
              Apply
            </button>
          </form>
        ) : null}
      </div>

      {kpis.total === 0 ? (
        <EmptyState
          icon={CalendarCheck}
          title="No appointments in this period"
          description="Analytics will appear as soon as real bookings, walk-ins or consultations exist for this clinic in the selected range."
        />
      ) : (
        <>
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <KpiCard icon={CalendarCheck} label="Appointments" value={String(kpis.total)} hint={`${newPatients} new patient${newPatients === 1 ? "" : "s"}`} />
            <KpiCard
              icon={ClipboardCheck}
              label="Completed"
              value={String(kpis.completed)}
              hint={kpis.completionRate !== null ? `${kpis.completionRate}% of finalized` : "rate: not enough data"}
            />
            <KpiCard
              icon={UserX}
              label="No-shows"
              value={String(kpis.noShow)}
              hint={kpis.noShowRate !== null ? `${kpis.noShowRate}% of finalized` : "rate: not enough data"}
            />
            <KpiCard icon={CalendarX} label="Cancelled" value={String(kpis.cancelled)} />
            <KpiCard icon={Footprints} label="Walk-ins" value={String(kpis.walkIns)} />
            <KpiCard icon={Users} label="Unique patients" value={String(kpis.uniquePatients)} />
            <KpiCard
              icon={Clock}
              label="Median wait"
              value={kpis.medianWaitMinutes !== null ? `${kpis.medianWaitMinutes} min` : "—"}
              hint={kpis.waitSamples > 0 ? `${kpis.waitSamples} token${kpis.waitSamples === 1 ? "" : "s"} sampled` : "not enough data"}
            />
            <KpiCard
              icon={Stethoscope}
              label="Avg consultation"
              value={kpis.avgConsultMinutes !== null ? `${kpis.avgConsultMinutes} min` : "—"}
              hint={kpis.consultSamples > 0 ? `${kpis.consultSamples} visit${kpis.consultSamples === 1 ? "" : "s"} sampled` : "not enough data"}
            />
          </div>

          <Card>
            <CardHeader>
              <CardTitle>Appointments per day</CardTitle>
              <CardDescription>
                Teal = completed · red = cancelled · grey = upcoming/in progress. Hover a bar for exact numbers.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <StackedBarChart points={chartPoints} emptyLabel="No appointments in this period" />
            </CardContent>
          </Card>

          <div className="grid gap-6 lg:grid-cols-3">
            <Card>
              <CardHeader>
                <CardTitle>Status breakdown</CardTitle>
                <CardDescription>All appointments in the period, by current status.</CardDescription>
              </CardHeader>
              <CardContent className="space-y-1.5">
                {statuses.map((status) => (
                  <div key={status.status} className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">{STATUS_LABELS[status.status] ?? status.status}</span>
                    <span className="font-medium tabular-nums">{status.count}</span>
                  </div>
                ))}
              </CardContent>
            </Card>

            <Card className="lg:col-span-2">
              <CardHeader>
                <CardTitle>Doctor activity</CardTitle>
                <CardDescription>Real appointment + queue activity per doctor in the period.</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="overflow-x-auto">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="border-b text-left text-xs text-muted-foreground">
                        <th className="pb-2 pr-3 font-medium">Doctor</th>
                        <th className="pb-2 pr-3 text-right font-medium">Appts</th>
                        <th className="pb-2 pr-3 text-right font-medium">Done</th>
                        <th className="pb-2 pr-3 text-right font-medium">No-show</th>
                        <th className="pb-2 pr-3 text-right font-medium">Walk-ins</th>
                        <th className="pb-2 pr-3 text-right font-medium">Patients</th>
                        <th className="pb-2 text-right font-medium">Median wait</th>
                      </tr>
                    </thead>
                    <tbody>
                      {doctors.map((doctor) => (
                        <tr key={doctor.doctorId} className="border-b last:border-0">
                          <td className="py-2.5 pr-3">
                            <p className="font-medium">{doctor.name}</p>
                            <p className="text-xs text-muted-foreground">
                              {doctor.specializations.join(", ") || doctor.qualification} · {formatINR(doctor.fee)}
                              {doctor.avgRating > 0 ? ` · ★ ${doctor.avgRating.toFixed(1)}` : ""}
                            </p>
                          </td>
                          <td className="py-2.5 pr-3 text-right tabular-nums">{doctor.rollup.total}</td>
                          <td className="py-2.5 pr-3 text-right tabular-nums">{doctor.rollup.completed}</td>
                          <td className="py-2.5 pr-3 text-right tabular-nums">{doctor.rollup.noShow}</td>
                          <td className="py-2.5 pr-3 text-right tabular-nums">{doctor.rollup.walkIns}</td>
                          <td className="py-2.5 pr-3 text-right tabular-nums">{doctor.rollup.uniquePatients}</td>
                          <td className="py-2.5 text-right tabular-nums">
                            {doctor.rollup.medianWaitMinutes !== null ? `${doctor.rollup.medianWaitMinutes} min` : "—"}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </CardContent>
            </Card>
          </div>
        </>
      )}

      <p className="text-xs text-muted-foreground">
        Computed from real appointment and queue records only. Clinical details (notes, prescriptions,
        diagnoses) are never included — admins cannot read them by design.
      </p>
    </div>
  );
}
