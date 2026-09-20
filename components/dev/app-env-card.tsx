import { ShieldAlert, CheckCircle2, Lock } from "lucide-react";

interface AppEnvCardProps {
  appEnv: string;
}

export function AppEnvCard({ appEnv }: AppEnvCardProps) {
  const isProduction = appEnv === "production";

  return (
    <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div
            className={`p-2.5 rounded-xl border ${
              isProduction
                ? "bg-emerald-500/10 border-emerald-500/30 text-emerald-400"
                : "bg-amber-500/10 border-amber-500/30 text-amber-400"
            }`}
          >
            {isProduction ? <CheckCircle2 className="h-5 w-5" /> : <ShieldAlert className="h-5 w-5" />}
          </div>
          <div>
            <div className="flex items-center space-x-2">
              <span className="font-bold text-sm text-white">Environment Configuration</span>
              <span
                className={`text-xs px-2 py-0.5 rounded-full font-mono font-bold ${
                  isProduction
                    ? "bg-emerald-950 text-emerald-400 border border-emerald-800"
                    : "bg-amber-950 text-amber-400 border border-amber-800"
                }`}
              >
                {appEnv.toUpperCase()}
              </span>
            </div>
            <p className="text-xs text-slate-400 mt-0.5">
              Read-only system state via <code className="text-cyan-400 font-mono text-[11px]">NEXT_PUBLIC_APP_ENV</code>
            </p>
          </div>
        </div>

        <div className="flex items-center space-x-1.5 text-xs text-slate-400 font-mono bg-slate-950 px-2.5 py-1 rounded-lg border border-slate-800">
          <Lock className="h-3 w-3 text-slate-500" />
          <span>Deploy-time immutable</span>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
        <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800/80 space-y-1">
          <span className="font-semibold text-slate-200">Current Behavior:</span>
          <p className="text-slate-400 leading-relaxed">
            {isProduction
              ? "Strict production mode active: Seeding scripts are disabled, fake synthetic fixtures are disallowed, and strict real-world constraints apply."
              : "Demo mode active: Synthetic seed fixtures allowed, demo badge indicators visible, test helper accounts enabled."}
          </p>
        </div>

        <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800/80 space-y-1">
          <span className="font-semibold text-slate-200">Deployment Policy:</span>
          <p className="text-slate-400 leading-relaxed">
            Switching environment mode is deliberately restricted to deploy-time configuration. No live runtime toggle exists to prevent catastrophic live-production data contamination from accidental clicks.
          </p>
        </div>
      </div>
    </div>
  );
}
