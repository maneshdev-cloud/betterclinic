import type { Metadata } from "next";
import Link from "next/link";
import { CalendarDays, Clock, MapPin, Stethoscope, User, SearchX } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listDoctorToday } from "@/services/appointments/service";
import { formatDateWithDay, formatTimeString, todayClinicDate } from "@/lib/utils";
import { LiveRefresh } from "@/components/queue/live-refresh";

export const metadata: Metadata = { title: "Doctor Appointments" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

export default async function DoctorAppointmentsPage({ searchParams }: PageProps) {
  const user = await requireRole(["DOCTOR"], "/doctor/appointments");
  const supabase = await createClient();
  const today = todayClinicDate();

  const tab = typeof searchParams.tab === "string" ? searchParams.tab : "today";

  // Fetch all doctor's appointments
  const { data: allAppointments } = await supabase
    .from("appointments")
    .select(`
      id, status, appointment_type, appointment_date, start_time, end_time,
      visit_reason, notes, cancellation_reason,
      patient:patients!appointments_patient_id_fkey(profile:profiles!patients_id_fkey(full_name)),
      clinic:clinics(name, city, area)
    `)
    .eq("doctor_id", user.id)
    .order("appointment_date", { ascending: tab === "past" ? false : true })
    .order("start_time", { ascending: tab === "past" ? false : true })
    .limit(100);

  const appointments = (allAppointments ?? []).map((row: any) => ({
    id: row.id,
    status: row.status,
    appointment_type: row.appointment_type,
    appointment_date: row.appointment_date,
    start_time: row.start_time,
    end_time: row.end_time,
    visit_reason: row.visit_reason,
    patient_name: row.patient?.profile?.full_name ?? "Patient",
    clinic_name: row.clinic?.name ?? "Clinic",
    clinic_city: row.clinic?.city ?? "",
    clinic_area: row.clinic?.area ?? "",
  }));

  const filtered = appointments.filter((appt) => {
    if (tab === "today") return appt.appointment_date === today;
    if (tab === "upcoming") return appt.appointment_date > today;
    if (tab === "past") return appt.appointment_date < today || ["COMPLETED", "CANCELLED", "NO_SHOW"].includes(appt.status);
    return true;
  });

  const counts = {
    today: appointments.filter((a) => a.appointment_date === today).length,
    upcoming: appointments.filter((a) => a.appointment_date > today && !["CANCELLED", "COMPLETED"].includes(a.status)).length,
    past: appointments.filter((a) => a.appointment_date < today || ["COMPLETED", "CANCELLED"].includes(a.status)).length,
  };

  return (
    <div className="page-container space-y-6 py-8">
      <LiveRefresh
        channelKey={`doctor-appointments-${user.id}`}
        filters={`appointments:doctor_id=eq.${user.id}`}
        showIndicator
      />

      <PageHeader
        title="Patient Appointments"
        description="Review scheduled consultations, patient symptoms, and practice schedule across all affiliated clinics."
      />

      {/* Tabs */}
      <div className="flex border-b border-border/80 gap-2">
        <Link
          href="/doctor/appointments?tab=today"
          className={`pb-3 px-3 text-sm font-medium border-b-2 transition-colors flex items-center gap-1.5 ${
            tab === "today"
              ? "border-primary text-primary font-semibold"
              : "border-transparent text-muted-foreground hover:text-foreground"
          }`}
        >
          <span>Today</span>
          <span className="rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground font-semibold">
            {counts.today}
          </span>
        </Link>
        <Link
          href="/doctor/appointments?tab=upcoming"
          className={`pb-3 px-3 text-sm font-medium border-b-2 transition-colors flex items-center gap-1.5 ${
            tab === "upcoming"
              ? "border-primary text-primary font-semibold"
              : "border-transparent text-muted-foreground hover:text-foreground"
          }`}
        >
          <span>Upcoming</span>
          <span className="rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground font-semibold">
            {counts.upcoming}
          </span>
        </Link>
        <Link
          href="/doctor/appointments?tab=past"
          className={`pb-3 px-3 text-sm font-medium border-b-2 transition-colors flex items-center gap-1.5 ${
            tab === "past"
              ? "border-primary text-primary font-semibold"
              : "border-transparent text-muted-foreground hover:text-foreground"
          }`}
        >
          <span>Past / History</span>
          <span className="rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground font-semibold">
            {counts.past}
          </span>
        </Link>
      </div>

      {filtered.length === 0 ? (
        <EmptyState
          icon={SearchX}
          title={
            tab === "today"
              ? "No appointments scheduled for today"
              : tab === "upcoming"
                ? "No upcoming appointments"
                : "No past appointments found"
          }
          description="New bookings will appear here automatically when patients confirm slots."
        />
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {filtered.map((appt) => (
            <Card key={appt.id} className="flex flex-col justify-between hover:shadow-md transition-shadow">
              <CardContent className="p-5 space-y-3">
                <div className="flex items-start justify-between gap-2">
                  <div className="flex items-center gap-2">
                    <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary/10 text-primary shrink-0">
                      <User className="h-4 w-4" />
                    </div>
                    <div>
                      <p className="font-semibold text-sm leading-tight">{appt.patient_name}</p>
                      <span className="text-xs text-muted-foreground">
                        {appt.appointment_type === "WALK_IN" ? "Walk-in" : "Scheduled Slot"}
                      </span>
                    </div>
                  </div>
                  <AppointmentStatusBadge status={appt.status} />
                </div>

                <div className="space-y-1.5 text-xs text-muted-foreground pt-1">
                  <p className="flex items-center gap-2 text-foreground font-medium">
                    <Clock className="h-3.5 w-3.5 text-primary shrink-0" />
                    <span>
                      {formatTimeString(appt.start_time)} – {formatTimeString(appt.end_time)}
                    </span>
                    <span className="text-muted-foreground font-normal">
                      · {formatDateWithDay(appt.appointment_date)}
                    </span>
                  </p>
                  <p className="flex items-center gap-2">
                    <MapPin className="h-3.5 w-3.5 shrink-0" />
                    <span className="truncate">
                      {appt.clinic_name} ({appt.clinic_area}, {appt.clinic_city})
                    </span>
                  </p>
                </div>

                <div className="rounded-md bg-muted/60 p-2.5 text-xs border border-border/50">
                  <span className="font-medium text-foreground">Reason: </span>
                  <span className="text-muted-foreground">{appt.visit_reason || "General Consultation"}</span>
                </div>

                <div className="pt-2 flex items-center justify-end gap-2">
                  {["CONFIRMED", "CHECKED_IN", "CALLED"].includes(appt.status) && (
                    <Button asChild size="sm" className="w-full">
                      <Link href="/doctor/queue">
                        <Stethoscope className="mr-1.5 h-3.5 w-3.5" /> Call to Consult
                      </Link>
                    </Button>
                  )}
                  {appt.status === "COMPLETED" && (
                    <Button asChild variant="outline" size="sm" className="w-full">
                      <Link href={`/doctor/consultations`}>View Record</Link>
                    </Button>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
