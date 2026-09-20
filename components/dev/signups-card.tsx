import { Users, UserCheck, Stethoscope, Building2, Calendar } from "lucide-react";

interface SignupsByRole {
  total: number;
  patient: number;
  doctor: number;
  receptionist: number;
  clinic_admin: number;
}

interface SignupPeriod {
  period: string;
  total_signups: number;
  patient_count: number;
  doctor_count: number;
  receptionist_count: number;
  admin_count: number;
}

interface SignupsCardProps {
  signupsByRole: SignupsByRole;
  signupsOverTime?: SignupPeriod[];
}

export function SignupsCard({ signupsByRole, signupsOverTime = [] }: SignupsCardProps) {
  const roles = [
    {
      label: "Patients",
      count: signupsByRole.patient || 0,
      icon: Users,
      color: "text-cyan-400",
      bg: "bg-cyan-500/10 border-cyan-500/30",
    },
    {
      label: "Doctors",
      count: signupsByRole.doctor || 0,
      icon: Stethoscope,
      color: "text-emerald-400",
      bg: "bg-emerald-500/10 border-emerald-500/30",
    },
    {
      label: "Clinic Admins",
      count: signupsByRole.clinic_admin || 0,
      icon: Building2,
      color: "text-indigo-400",
      bg: "bg-indigo-500/10 border-indigo-500/30",
    },
    {
      label: "Receptionists",
      count: signupsByRole.receptionist || 0,
      icon: UserCheck,
      color: "text-purple-400",
      bg: "bg-purple-500/10 border-purple-500/30",
    },
  ];

  return (
    <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-5">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div className="p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/30 text-indigo-400">
            <Users className="h-5 w-5" />
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Platform Signups by Role</h3>
            <p className="text-xs text-slate-400">
              Total registered accounts: <span className="text-white font-semibold font-mono">{signupsByRole.total}</span>
            </p>
          </div>
        </div>
      </div>

      {/* Role Stat Cards */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {roles.map((r) => {
          const Icon = r.icon;
          const pct = signupsByRole.total > 0 ? Math.round((r.count / signupsByRole.total) * 100) : 0;
          return (
            <div key={r.label} className="p-3.5 rounded-xl bg-slate-950 border border-slate-800 space-y-2">
              <div className="flex items-center justify-between">
                <div className={`p-1.5 rounded-lg border ${r.bg} ${r.color}`}>
                  <Icon className="h-4 w-4" />
                </div>
                <span className="text-[11px] font-mono text-slate-400">{pct}%</span>
              </div>
              <div>
                <p className="text-lg font-bold font-mono text-white">{r.count}</p>
                <p className="text-xs text-slate-400 font-medium">{r.label}</p>
              </div>
            </div>
          );
        })}
      </div>

      {/* Signups Over Time Table */}
      <div className="space-y-2 pt-2">
        <div className="flex items-center space-x-2 text-xs font-semibold text-slate-300">
          <Calendar className="h-3.5 w-3.5 text-cyan-400" />
          <span>Signups Timeline (from created_at timestamps)</span>
        </div>

        {signupsOverTime.length > 0 ? (
          <div className="border border-slate-800 rounded-xl overflow-hidden bg-slate-950">
            <table className="w-full text-left text-xs font-mono">
              <thead className="bg-slate-900/80 text-slate-400 text-[11px] uppercase border-b border-slate-800">
                <tr>
                  <th className="py-2 px-3">Period</th>
                  <th className="py-2 px-3 text-right">Patients</th>
                  <th className="py-2 px-3 text-right">Doctors</th>
                  <th className="py-2 px-3 text-right">Admins</th>
                  <th className="py-2 px-3 text-right">Staff</th>
                  <th className="py-2 px-3 text-right font-bold text-white">Total</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-900">
                {signupsOverTime.map((period) => (
                  <tr key={period.period} className="hover:bg-slate-900/30">
                    <td className="py-2 px-3 text-slate-200 font-semibold">{period.period}</td>
                    <td className="py-2 px-3 text-right text-cyan-400">{period.patient_count}</td>
                    <td className="py-2 px-3 text-right text-emerald-400">{period.doctor_count}</td>
                    <td className="py-2 px-3 text-right text-indigo-400">{period.admin_count}</td>
                    <td className="py-2 px-3 text-right text-purple-400">{period.receptionist_count}</td>
                    <td className="py-2 px-3 text-right font-bold text-white">{period.total_signups}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="p-4 rounded-xl bg-slate-950 border border-slate-800 text-center text-xs text-slate-500 font-mono">
            No signup activity recorded for the selected scope.
          </div>
        )}
      </div>
    </div>
  );
}
