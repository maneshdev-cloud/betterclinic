import { Building2, Stethoscope, Award, MapPin } from "lucide-react";

interface TopClinic {
  id: string;
  name: string;
  city: string;
  appointment_count: number;
}

interface TopDoctor {
  id: string;
  name: string;
  qualification: string;
  appointment_count: number;
}

interface TopEntitiesCardProps {
  topClinics: TopClinic[];
  topDoctors: TopDoctor[];
}

export function TopEntitiesCard({ topClinics = [], topDoctors = [] }: TopEntitiesCardProps) {
  const hasClinicAppointments = topClinics.some((c) => Number(c.appointment_count) > 0);
  const hasDoctorAppointments = topDoctors.some((d) => Number(d.appointment_count) > 0);

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {/* Most Active Clinics */}
      <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-4">
        <div className="flex items-center space-x-3">
          <div className="p-2 rounded-xl bg-blue-500/10 border border-blue-500/30 text-blue-400">
            <Building2 className="h-5 w-5" />
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Most Active Clinics</h3>
            <p className="text-xs text-slate-400">Ranked by appointment volume platform-wide</p>
          </div>
        </div>

        {hasClinicAppointments ? (
          <div className="space-y-2">
            {topClinics.map((c, idx) => (
              <div
                key={c.id}
                className="flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800/80 hover:border-slate-700 transition"
              >
                <div className="flex items-center space-x-3 min-w-0">
                  <span className="flex items-center justify-center w-5 h-5 rounded-full bg-slate-800 text-[11px] font-mono text-slate-300 font-bold">
                    {idx + 1}
                  </span>
                  <div className="min-w-0">
                    <p className="text-xs font-semibold text-white truncate">{c.name}</p>
                    <p className="text-[11px] text-slate-400 flex items-center space-x-1">
                      <MapPin className="h-3 w-3 inline text-slate-500" />
                      <span>{c.city}</span>
                    </p>
                  </div>
                </div>
                <div className="text-right pl-3">
                  <span className="text-sm font-bold font-mono text-cyan-400">
                    {c.appointment_count}
                  </span>
                  <p className="text-[10px] text-slate-500 uppercase">appts</p>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="p-6 rounded-xl bg-slate-950 border border-slate-800 text-center space-y-1">
            <Building2 className="h-6 w-6 text-slate-600 mx-auto" />
            <p className="text-xs font-medium text-slate-400">Not enough data</p>
            <p className="text-[11px] text-slate-500">
              No appointments have been booked across clinics in this view.
            </p>
          </div>
        )}
      </div>

      {/* Most Active Doctors */}
      <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-4">
        <div className="flex items-center space-x-3">
          <div className="p-2 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
            <Stethoscope className="h-5 w-5" />
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Most Active Doctors</h3>
            <p className="text-xs text-slate-400">Ranked by patient consultations platform-wide</p>
          </div>
        </div>

        {hasDoctorAppointments ? (
          <div className="space-y-2">
            {topDoctors.map((d, idx) => (
              <div
                key={d.id}
                className="flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800/80 hover:border-slate-700 transition"
              >
                <div className="flex items-center space-x-3 min-w-0">
                  <span className="flex items-center justify-center w-5 h-5 rounded-full bg-slate-800 text-[11px] font-mono text-slate-300 font-bold">
                    {idx + 1}
                  </span>
                  <div className="min-w-0">
                    <p className="text-xs font-semibold text-white truncate">{d.name}</p>
                    <p className="text-[11px] text-slate-400 truncate">{d.qualification}</p>
                  </div>
                </div>
                <div className="text-right pl-3">
                  <span className="text-sm font-bold font-mono text-emerald-400">
                    {d.appointment_count}
                  </span>
                  <p className="text-[10px] text-slate-500 uppercase">appts</p>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="p-6 rounded-xl bg-slate-950 border border-slate-800 text-center space-y-1">
            <Stethoscope className="h-6 w-6 text-slate-600 mx-auto" />
            <p className="text-xs font-medium text-slate-400">Not enough data</p>
            <p className="text-[11px] text-slate-500">
              No appointments have been assigned to doctors in this view.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
