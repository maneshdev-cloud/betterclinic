import type { Metadata } from "next";

export const metadata: Metadata = { title: "Clinic admin dashboard" };

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { CopyButton } from "@/components/shared/copy-button";
import { requireRole } from "@/services/auth/service";
import { getClinicInviteCodes, getStaffClinicContext } from "@/services/clinics/service";
import { createClient } from "@/lib/supabase/server";
import type { ClinicHours } from "@/lib/types/database";
import { getClinicAnalytics } from "@/services/analytics/service";
import { DAYS_OF_WEEK } from "@/lib/constants";
import { formatTimeString } from "@/lib/utils";

export default async function AdminDashboard() {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin");
  const clinic = await getStaffClinicContext(user.id);

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <Card>
          <CardHeader>
            <CardTitle>No clinic linked</CardTitle>
            <CardDescription>
              This admin account is not linked to a clinic. Ask the project owner to re-run the seed
              or link your account from the database.
            </CardDescription>
          </CardHeader>
        </Card>
      </div>
    );
  }

  const supabase = await createClient();
  const [{ data: clinicRow }, { data: hours }, inviteCodes, quickStats] = await Promise.all([
    supabase.from("clinics").select("*").eq("id", clinic.id).single(),
    supabase.from("clinic_hours").select("*").eq("clinic_id", clinic.id).order("day_of_week"),
    getClinicInviteCodes(clinic.id),
    getClinicAnalytics(supabase, clinic.id, {}),
  ]);
  const hoursRows = (hours ?? []) as ClinicHours[];

  return (
    <div className="page-container space-y-6 py-8">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">{clinicRow?.name ?? clinic.name}</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {clinicRow ? `${clinicRow.area}, ${clinicRow.city}` : clinic.city} · Clinic administration
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader>
            <CardTitle>Staff invite code</CardTitle>
            <CardDescription>
              Share this code with receptionists so they can create staff accounts for this clinic
              at signup.
            </CardDescription>
          </CardHeader>
          <CardContent>
            {inviteCodes.staffCode ? (
              <div className="flex items-center gap-2">
                <code className="rounded-md border bg-muted/50 px-3 py-2 text-sm font-semibold tracking-wide">
                  {inviteCodes.staffCode}
                </code>
                <CopyButton value={inviteCodes.staffCode} />
              </div>
            ) : (
              <p className="text-sm text-muted-foreground">
                No staff invite code found.
              </p>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Doctor invite code</CardTitle>
            <CardDescription>
              Share this code with doctors so they can link their accounts to this clinic
              at signup.
            </CardDescription>
          </CardHeader>
          <CardContent>
            {inviteCodes.doctorCode ? (
              <div className="flex items-center gap-2">
                <code className="rounded-md border bg-muted/50 px-3 py-2 text-sm font-semibold tracking-wide">
                  {inviteCodes.doctorCode}
                </code>
                <CopyButton value={inviteCodes.doctorCode} />
              </div>
            ) : (
              <p className="text-sm text-muted-foreground">
                No doctor invite code found.
              </p>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Admin claim code</CardTitle>
            <CardDescription>
              Keep this safe. Used only when an authorized administrator claims or recovers an existing clinic record.
            </CardDescription>
          </CardHeader>
          <CardContent>
            {inviteCodes.adminClaimCode ? (
              <div className="flex items-center gap-2">
                <code className="rounded-md border bg-muted/50 px-3 py-2 text-sm font-semibold tracking-wide text-amber-700 dark:text-amber-300">
                  {inviteCodes.adminClaimCode}
                </code>
                <CopyButton value={inviteCodes.adminClaimCode} />
              </div>
            ) : (
              <p className="text-sm text-muted-foreground">
                No admin claim code found.
              </p>
            )}
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Clinic hours</CardTitle>
            <CardDescription>When the clinic is open.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-1.5">
            {hoursRows.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                Hours not configured yet — editable clinic settings arrive with the admin module.
              </p>
            ) : (
              hoursRows.map((h) => (
                <div key={h.id} className="flex items-center justify-between text-sm">
                  <span className="text-muted-foreground">
                    {DAYS_OF_WEEK.find((d) => d.value === h.day_of_week)?.label}
                  </span>
                  {h.is_closed ? (
                    <Badge variant="muted">Closed</Badge>
                  ) : (
                    <span className="font-medium">
                      {formatTimeString(h.opens_at)} – {formatTimeString(h.closes_at)}
                    </span>
                  )}
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Last 30 days</CardTitle>
          <CardDescription>
            Real operational numbers from appointments and queue records —{" "}
            <a href="/admin/analytics" className="font-medium underline">
              full analytics
            </a>
            .
          </CardDescription>
        </CardHeader>
        <CardContent>
          {quickStats ? (
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
              <div>
                <p className="text-2xl font-semibold tabular-nums">{quickStats.kpis.total}</p>
                <p className="text-xs text-muted-foreground">appointments</p>
              </div>
              <div>
                <p className="text-2xl font-semibold tabular-nums">{quickStats.kpis.completed}</p>
                <p className="text-xs text-muted-foreground">completed</p>
              </div>
              <div>
                <p className="text-2xl font-semibold tabular-nums">{quickStats.kpis.walkIns}</p>
                <p className="text-xs text-muted-foreground">walk-ins</p>
              </div>
              <div>
                <p className="text-2xl font-semibold tabular-nums">
                  {quickStats.kpis.medianWaitMinutes !== null ? `${quickStats.kpis.medianWaitMinutes}m` : "—"}
                </p>
                <p className="text-xs text-muted-foreground">median wait</p>
              </div>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">No appointment data yet.</p>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
