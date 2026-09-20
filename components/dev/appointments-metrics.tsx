import { CalendarCheck, CheckCircle, Clock, XCircle, AlertOctagon } from "lucide-react";

interface AppointmentsSummary {
  total: number;
  completed: number;
  cancelled: number;
  no_show: number;
  active: number;
}

interface AppointmentsMetricsProps {
  summary: AppointmentsSummary;
}

export function AppointmentsMetrics({ summary }: AppointmentsMetricsProps) {
  const total = summary.total || 0;
  const completed = summary.completed || 0;
  const cancelled = summary.cancelled || 0;
  const noShow = summary.no_show || 0;
  const active = summary.active || 0;

  const hasData = total > 0;

  const completionRate = hasData ? Math.round((completed / total) * 100) : null;
  const cancellationRate = hasData ? Math.round((cancelled / total) * 100) : null;
  const noShowRate = hasData ? Math.round((noShow / total) * 100) : null;

  return (
    <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-5">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div className="p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
            <CalendarCheck className="h-5 w-5" />
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Platform-wide Appointment Lifecycle</h3>
            <p className="text-xs text-slate-400">
              Aggregated across all registered clinics &bull;{" "}
              <span className="text-white font-semibold font-mono">{total}</span> total appointments
            </p>
          </div>
        </div>
      </div>

      {hasData ? (
        <div className="space-y-4">
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            {/* Completed */}
            <div className="p-3.5 rounded-xl bg-slate-950 border border-slate-800 space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="p-1 rounded-md bg-emerald-500/10 text-emerald-400">
                  <CheckCircle className="h-4 w-4" />
                </div>
                <span className="text-xs font-mono text-emerald-400 font-bold">{completionRate}%</span>
              </div>
              <div>
                <p className="text-xl font-bold font-mono text-white">{completed}</p>
                <p className="text-xs text-slate-400 font-medium">Completed</p>
              </div>
            </div>

            {/* Active / In-progress */}
            <div className="p-3.5 rounded-xl bg-slate-950 border border-slate-800 space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="p-1 rounded-md bg-cyan-500/10 text-cyan-400">
                  <Clock className="h-4 w-4" />
                </div>
                <span className="text-xs font-mono text-cyan-400 font-bold">
                  {Math.round((active / total) * 100)}%
                </span>
              </div>
              <div>
                <p className="text-xl font-bold font-mono text-white">{active}</p>
                <p className="text-xs text-slate-400 font-medium">Active / In-Queue</p>
              </div>
            </div>

            {/* Cancelled */}
            <div className="p-3.5 rounded-xl bg-slate-950 border border-slate-800 space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="p-1 rounded-md bg-rose-500/10 text-rose-400">
                  <XCircle className="h-4 w-4" />
                </div>
                <span className="text-xs font-mono text-rose-400 font-bold">{cancellationRate}%</span>
              </div>
              <div>
                <p className="text-xl font-bold font-mono text-white">{cancelled}</p>
                <p className="text-xs text-slate-400 font-medium">Cancelled</p>
              </div>
            </div>

            {/* No-Show */}
            <div className="p-3.5 rounded-xl bg-slate-950 border border-slate-800 space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="p-1 rounded-md bg-amber-500/10 text-amber-400">
                  <AlertOctagon className="h-4 w-4" />
                </div>
                <span className="text-xs font-mono text-amber-400 font-bold">{noShowRate}%</span>
              </div>
              <div>
                <p className="text-xl font-bold font-mono text-white">{noShow}</p>
                <p className="text-xs text-slate-400 font-medium">No-Show</p>
              </div>
            </div>
          </div>

          {/* Ratio bar */}
          <div className="p-3 bg-slate-950 rounded-xl border border-slate-800 space-y-2">
            <div className="flex justify-between text-[11px] font-mono text-slate-400">
              <span>Fulfillment Distribution</span>
              <span>{completed} of {total} satisfied</span>
            </div>
            <div className="w-full h-2.5 rounded-full bg-slate-800 overflow-hidden flex">
              <div className="bg-emerald-500 h-full" style={{ width: `${(completed / total) * 100}%` }} title="Completed" />
              <div className="bg-cyan-500 h-full" style={{ width: `${(active / total) * 100}%` }} title="Active" />
              <div className="bg-rose-500 h-full" style={{ width: `${(cancelled / total) * 100}%` }} title="Cancelled" />
              <div className="bg-amber-500 h-full" style={{ width: `${(noShow / total) * 100}%` }} title="No-Show" />
            </div>
          </div>
        </div>
      ) : (
        <div className="p-6 rounded-xl bg-slate-950 border border-slate-800 text-center space-y-1.5">
          <CalendarCheck className="h-6 w-6 text-slate-600 mx-auto" />
          <p className="text-xs font-semibold text-slate-300">Not enough data</p>
          <p className="text-xs text-slate-500 max-w-sm mx-auto">
            Zero appointments exist in the current scope. Metrics are withheld until real or demo appointments are recorded.
          </p>
        </div>
      )}
    </div>
  );
}
