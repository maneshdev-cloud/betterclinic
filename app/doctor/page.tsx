import type { Metadata } from "next";

export const metadata: Metadata = { title: "Doctor dashboard" };

import Link from "next/link";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { LiveRefresh } from "@/components/queue/live-refresh";
import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listDoctorToday } from "@/services/appointments/service";
import { formatINR, formatTimeString, todayClinicDate } from "@/lib/utils";
import type { Doctor, Specialization, Clinic } from "@/lib/types/database";
import { LinkClinicModal } from "@/components/doctor/link-clinic-modal";
import { Building2 } from "lucide-react";

export default async function DoctorDashboard() {
  const user = await requireRole(["DOCTOR"], "/doctor");
  const supabase = await createClient();
  const today = todayClinicDate();

  const [
    { data: doctor },
    { data: specializations },
    { data: clinics },
    todayAppointments,
    { count: activeQueueCount },
    { data: allClinicsData },
  ] = await Promise.all([
    supabase.from("doctors").select("*").eq("id", user.id).single(),
    supabase
      .from("doctor_specializations")
      .select("specialization:specializations!inner(id, name)")
      .eq("doctor_id", user.id),
    supabase
      .from("doctor_clinics")
      .select("clinic:clinics!inner(id, name, city, area)")
      .eq("doctor_id", user.id),
    listDoctorToday(supabase, user.id),
    supabase
      .from("queue_entries")
      .select("id", { count: "exact", head: true })
      .eq("doctor_id", user.id)
      .eq("entry_date", today)
      .in("status", ["WAITING", "CALLED", "IN_CONSULTATION"]),
    supabase
      .from("clinics")
      .select("id, name, city, area")
      .eq("is_active", true)
      .order("name"),
  ]);

  const d = doctor as Doctor | null;
  const specs = ((specializations ?? []) as unknown as { specialization: Specialization }[]).map(
    (row) => row.specialization.name
  );
  const clinicRows = ((clinics ?? []) as unknown as { clinic: Clinic }[]).map((row) => row.clinic);
  const allClinics = (allClinicsData as { id: string; name: string; city: string; area: string }[]) ?? [];

  return (
    <div className="page-container space-y-6 py-8">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">Welcome back, Dr. {user.fullName.split(" ").slice(-1)[0]}</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Live schedule and queue sync automatically across your active devices.
        </p>
      </div>

      {clinicRows.length === 0 ? (
        <Card className="border-primary/40 bg-gradient-to-r from-primary/5 via-background to-primary/10 shadow-sm">
          <CardContent className="p-5 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div className="flex items-start gap-3.5">
              <div className="rounded-xl bg-primary/15 p-2.5 text-primary shrink-0">
                <Building2 className="h-6 w-6" />
              </div>
              <div>
                <h2 className="text-base font-semibold text-foreground">
                  You are not linked to a clinic yet
                </h2>
                <p className="text-xs text-muted-foreground mt-1 max-w-xl">
                  To receive patient appointments, conduct consultations, and manage real-time queues, link your profile to an existing clinic with an invite code or register a new clinic for your practice.
                </p>
              </div>
            </div>
            <div className="flex flex-wrap items-center gap-2.5 shrink-0 w-full md:w-auto">
              <LinkClinicModal
                clinics={allClinics}
                triggerText="Link to an existing clinic"
                triggerVariant="default"
              />
              <LinkClinicModal
                clinics={allClinics}
                triggerText="Register a new clinic"
                triggerVariant="outline"
              />
            </div>
          </CardContent>
        </Card>
      ) : null}

      <LiveRefresh
        channelKey={`doctor-dashboard-${user.id}`}
        filters={`appointments:doctor_id=eq.${user.id};queue_entries:doctor_id=eq.${user.id}`}
      >
        <div className="grid gap-4 md:grid-cols-2">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base font-semibold">Today&apos;s Schedule</CardTitle>
              <CardDescription>
                {todayAppointments.length} appointment{todayAppointments.length === 1 ? "" : "s"} booked for today
              </CardDescription>
            </CardHeader>
            <CardContent>
              {todayAppointments.length === 0 ? (
                <p className="text-sm text-muted-foreground">No appointments scheduled for today.</p>
              ) : (
                <div className="space-y-2">
                  {todayAppointments.slice(0, 5).map((appt) => (
                    <div key={appt.id} className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 rounded border p-2.5 text-sm">
                      <div className="min-w-0 flex-1">
                        <p className="font-medium truncate">{appt.patient_name}</p>
                        <p className="text-xs text-muted-foreground truncate">
                          {formatTimeString(appt.start_time)} – {formatTimeString(appt.end_time)} · {appt.visit_reason}
                        </p>
                      </div>
                      <div className="shrink-0 self-start sm:self-auto">
                        <AppointmentStatusBadge status={appt.status} />
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base font-semibold">Live Patient Queue</CardTitle>
              <CardDescription>
                Realtime token calls and waiting patients
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-baseline gap-2">
                <span className="text-3xl font-bold tracking-tight">{activeQueueCount ?? 0}</span>
                <span className="text-sm text-muted-foreground">patients currently waiting or in consultation</span>
              </div>
              <Button asChild size="sm">
                <Link href="/doctor/queue">Manage Live Queue</Link>
              </Button>
            </CardContent>
          </Card>
        </div>
      </LiveRefresh>

      <div className="grid gap-4 md:grid-cols-3">
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>Professional profile</CardTitle>
            <CardDescription>
              This is the information patients see when they discover you.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex flex-wrap items-center gap-2">
              {specs.length > 0 ? (
                specs.map((s) => (
                  <Badge key={s} variant="secondary">
                    {s}
                  </Badge>
                ))
              ) : (
                <p className="text-sm text-muted-foreground">
                  No specialization linked yet — this is set during signup or by your clinic admin.
                </p>
              )}
            </div>
            <dl className="grid gap-x-6 gap-y-2 text-sm sm:grid-cols-2">
              <div className="flex justify-between gap-4 sm:block">
                <dt className="text-muted-foreground">Qualification</dt>
                <dd className="font-medium">{d?.qualification ?? "—"}</dd>
              </div>
              <div className="flex justify-between gap-4 sm:block">
                <dt className="text-muted-foreground">Experience</dt>
                <dd className="font-medium">{d ? `${d.experience_years} years` : "—"}</dd>
              </div>
              <div className="flex justify-between gap-4 sm:block">
                <dt className="text-muted-foreground">Consultation fee</dt>
                <dd className="font-medium">{d ? formatINR(d.consultation_fee) : "—"}</dd>
              </div>
              <div className="flex justify-between gap-4 sm:block">
                <dt className="text-muted-foreground">Registration no.</dt>
                <dd className="font-medium">{d?.registration_number ?? "—"}</dd>
              </div>
            </dl>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <div>
              <CardTitle>Practising at</CardTitle>
              <CardDescription>Clinics you are linked to.</CardDescription>
            </div>
            <LinkClinicModal
              clinics={allClinics}
              triggerText={clinicRows.length === 0 ? "Link Clinic" : "Add Clinic"}
              triggerVariant="outline"
            />
          </CardHeader>
          <CardContent className="space-y-3">
            {clinicRows.length === 0 ? (
              <div className="rounded-lg border border-dashed p-4 text-center space-y-2">
                <Building2 className="mx-auto h-7 w-7 text-muted-foreground/60" />
                <p className="text-xs text-muted-foreground">
                  Not linked to any clinic yet.
                </p>
                <div className="pt-1">
                  <LinkClinicModal
                    clinics={allClinics}
                    triggerText="Link or Register Clinic"
                    triggerVariant="default"
                  />
                </div>
              </div>
            ) : (
              clinicRows.map((c) => (
                <div key={c.id} className="rounded-md border p-3">
                  <p className="text-sm font-medium">{c.name}</p>
                  <p className="text-xs text-muted-foreground">
                    {c.area}, {c.city}
                  </p>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
