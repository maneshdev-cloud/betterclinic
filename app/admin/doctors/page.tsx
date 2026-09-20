import type { Metadata } from "next";
import { Stethoscope } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { UserAvatar } from "@/components/shared/user-avatar";
import { Card, CardContent } from "@/components/ui/card";
import { CopyButton } from "@/components/shared/copy-button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getClinicDoctorInviteCode, getStaffClinicContext } from "@/services/clinics/service";
import { listClinicDoctorsWithStats } from "@/services/admin/service";
import { formatINR, formatDate } from "@/lib/utils";

export const metadata: Metadata = { title: "Doctors" };

/**
 * Read-only directory of the doctors practising at this clinic, with
 * real 30-day activity. Doctors join via signup and link themselves to
 * a clinic — admins don't create or edit doctor accounts here.
 */
export default async function AdminDoctorsPage() {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin/doctors");
  const clinic = await getStaffClinicContext(user.id);

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <PageHeader title="Doctors" description="No clinic is linked to this admin account." />
      </div>
    );
  }

  const supabase = await createClient();
  const [doctors, doctorInviteCode] = await Promise.all([
    listClinicDoctorsWithStats(supabase, clinic.id),
    getClinicDoctorInviteCode(clinic.id),
  ]);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Doctors at this clinic"
        description={`Directory and real 30-day activity for doctors practising at ${clinic.name}.`}
      />

      <div className="flex flex-wrap items-center justify-between gap-3 rounded-lg border bg-card p-4">
        <div>
          <p className="text-sm font-medium">Doctor invite code</p>
          <p className="text-xs text-muted-foreground">
            Share this code with doctors so they can select {clinic.name} during signup.
          </p>
        </div>
        {doctorInviteCode ? (
          <div className="flex items-center gap-2">
            <code className="rounded-md border bg-muted/50 px-3 py-1.5 text-sm font-semibold tracking-wide">
              {doctorInviteCode}
            </code>
            <CopyButton value={doctorInviteCode} />
          </div>
        ) : null}
      </div>

      {doctors.length === 0 ? (
        <EmptyState
          icon={Stethoscope}
          title="No doctors linked yet"
          description="Doctors create their own accounts at signup and link to your clinic — they appear here as soon as they do."
        />
      ) : (
        <div className="space-y-3">
          {doctors.map((doctor) => (
            <Card key={doctor.doctorId}>
              <CardContent className="flex flex-wrap items-center justify-between gap-4 py-4">
                <div className="flex min-w-0 items-center gap-3">
                  <UserAvatar name={doctor.name} size="lg" />
                  <div className="min-w-0">
                    <p className="font-medium">{doctor.name}</p>
                    <p className="truncate text-xs text-muted-foreground">
                      {doctor.qualification} · {doctor.specializations.join(", ") || "General practice"} ·{" "}
                      {doctor.experienceYears} yrs · {formatINR(doctor.fee)}
                      {doctor.avgRating > 0 ? ` · ★ ${doctor.avgRating.toFixed(1)}` : ""}
                    </p>
                    <p className="text-xs text-muted-foreground">Reg. no. {doctor.registrationNumber}</p>
                  </div>
                </div>
                <div className="grid grid-cols-3 gap-x-6 gap-y-1 text-center text-sm sm:grid-cols-5">
                  <div>
                    <p className="text-lg font-semibold tabular-nums">{doctor.appointments30d}</p>
                    <p className="text-[11px] text-muted-foreground">appts (30d)</p>
                  </div>
                  <div>
                    <p className="text-lg font-semibold tabular-nums">{doctor.completed30d}</p>
                    <p className="text-[11px] text-muted-foreground">completed</p>
                  </div>
                  <div>
                    <p className="text-lg font-semibold tabular-nums">{doctor.noShow30d}</p>
                    <p className="text-[11px] text-muted-foreground">no-shows</p>
                  </div>
                  <div>
                    <p className="text-lg font-semibold tabular-nums">{doctor.uniquePatients30d}</p>
                    <p className="text-[11px] text-muted-foreground">patients</p>
                  </div>
                  <div>
                    <p className="text-lg font-semibold tabular-nums">
                      {doctor.medianWaitMinutes !== null ? `${doctor.medianWaitMinutes}m` : "—"}
                    </p>
                    <p className="text-[11px] text-muted-foreground">median wait</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <p className="text-xs text-muted-foreground">
        Activity counts come from real appointments and queue entries in the last 30 days (since{" "}
        {formatDate(new Date(Date.now() - 29 * 86400000).toISOString().slice(0, 10))}).
      </p>
    </div>
  );
}
