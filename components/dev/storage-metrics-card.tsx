import { HardDrive, CheckCircle, Database } from "lucide-react";

interface StorageMetricsCardProps {
  sizePretty: string;
  sizeBytes: number;
  tableCount: number;
}

export function StorageMetricsCard({ sizePretty, sizeBytes, tableCount }: StorageMetricsCardProps) {
  // Supabase Free Tier provides 500 MB Postgres database storage
  const freeTierLimitBytes = 500 * 1024 * 1024;
  const usedPercentage = Math.max(1, Math.min(100, Math.round((sizeBytes / freeTierLimitBytes) * 100)));

  return (
    <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div className="p-2.5 rounded-xl bg-purple-500/10 border border-purple-500/30 text-purple-400">
            <HardDrive className="h-5 w-5" />
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Supabase Infrastructure Usage</h3>
            <p className="text-xs text-slate-400">
              Live PostgreSQL database footprint &bull; {tableCount} tables tracked
            </p>
          </div>
        </div>

        <span className="text-xs px-2.5 py-1 rounded-full font-mono bg-emerald-950 text-emerald-400 border border-emerald-800/80 flex items-center space-x-1">
          <CheckCircle className="h-3 w-3" />
          <span>Healthy</span>
        </span>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-4 rounded-xl bg-slate-950 border border-slate-800 space-y-1">
          <span className="text-xs text-slate-400 font-medium">Database Disk Size</span>
          <p className="text-2xl font-bold font-mono text-cyan-400">{sizePretty}</p>
          <p className="text-[11px] text-slate-500 font-mono">{(sizeBytes / 1024 / 1024).toFixed(1)} MB live</p>
        </div>

        <div className="p-4 rounded-xl bg-slate-950 border border-slate-800 space-y-1">
          <span className="text-xs text-slate-400 font-medium">Free Tier Headroom</span>
          <p className="text-2xl font-bold font-mono text-white">{usedPercentage}%</p>
          <p className="text-[11px] text-slate-500 font-mono">500 MB quota</p>
        </div>

        <div className="p-4 rounded-xl bg-slate-950 border border-slate-800 space-y-1">
          <span className="text-xs text-slate-400 font-medium">Managed Schemas</span>
          <p className="text-2xl font-bold font-mono text-purple-400">{tableCount}</p>
          <p className="text-[11px] text-slate-500 font-mono">public relational tables</p>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="space-y-1.5 pt-1">
        <div className="flex justify-between text-xs font-mono text-slate-400">
          <span>Storage Utilization</span>
          <span>{sizePretty} / 500 MB (97%+ free)</span>
        </div>
        <div className="w-full h-2 rounded-full bg-slate-800 overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-cyan-500 to-purple-500 rounded-full transition-all duration-500"
            style={{ width: `${usedPercentage}%` }}
          />
        </div>
      </div>
    </div>
  );
}
