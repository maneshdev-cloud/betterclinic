import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { CalendarDays, Clock, IndianRupee, MapPin, Stethoscope, UserRound } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { PrintButton } from "@/components/shared/print-button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { StatusHistory } from "@/components/appointments/status-history";
import { AppointmentCardActions } from "@/components/appointments/appointment-card-actions";
import { createClient } from "@/lib/supabase/server";
import { getAppointmentDetail } from "@/services/appointments/service";
import { formatDateWithDay, formatINR, formatTimeString } from "@/lib/utils";

interface PageProps {
  params: { id: string };
}

export const metadata: Metadata = { title: "Appointment details" };

export default async function AppointmentDetailPage({ params }: PageProps) {
  const supabase = await createClient();
  // RLS ensures only the patient, the doctor and the clinic's staff can
  // load this row.
  const detail = await getAppointmentDetail(supabase, params.id);
  if (!detail) notFound();

  const { appointment, fee, history } = detail;

  return (
    <div className="page-container space-y-6 py-8">
      <nav aria-label="Breadcrumb" className="text-sm text-muted-foreground">
        <Link href="/patient/appointments" className="hover:underline">
          ← Back to appointments
        </Link>
      </nav>

      <PageHeader
        title="Appointment details"
        description={`With ${appointment.doctor_name} · ${appointment.clinic_name}`}
        actions={
          <>
            <AppointmentStatusBadge status={appointment.status} />
            <PrintButton label="Print" />
          </>
        }
      />

      <div className="grid gap-6 lg:grid-cols-[1fr_360px]">
        <div className="space-y-6">
          <Card className="print:border-0 print:shadow-none">
            <CardHeader>
              <CardTitle>Visit summary</CardTitle>
            </CardHeader>
            <CardContent className="grid gap-3 text-sm sm:grid-cols-2">
              <p className="inline-flex items-center gap-2">
                <CalendarDays className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                {formatDateWithDay(appointment.appointment_date)}
              </p>
              <p className="inline-flex items-center gap-2">
                <Clock className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                {formatTimeString(appointment.start_time)} – {formatTimeString(appointment.end_time)}
              </p>
              <p className="inline-flex items-center gap-2">
                <UserRound className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                {appointment.doctor_name}
                {appointment.doctor_qualification ? ` · ${appointment.doctor_qualification}` : ""}
              </p>
              <p className="inline-flex items-center gap-2">
                <MapPin className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                {appointment.clinic_name}
                {appointment.clinic_area ? `, ${appointment.clinic_area}` : ""}
                {appointment.clinic_city ? `, ${appointment.clinic_city}` : ""}
              </p>
              <p className="inline-flex items-center gap-2">
                <Stethoscope className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                {appointment.appointment_type === "WALK_IN" ? "Walk-in" : "Scheduled"}
              </p>
              <p className="inline-flex items-center gap-2">
                <IndianRupee className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                {fee !== null ? `${formatINR(fee)} (consultation)` : "—"}
              </p>

              <div className="sm:col-span-2">
                <Separator className="my-1" />
                <p className="font-medium">Reason for visit</p>
                <p className="mt-1 text-muted-foreground">{appointment.visit_reason}</p>
              </div>

              {appointment.notes ? (
                <div className="sm:col-span-2">
                  <p className="font-medium">Clinic notes</p>
                  <p className="mt-1 text-muted-foreground">{appointment.notes}</p>
                </div>
              ) : null}

              {appointment.cancellation_reason ? (
                <div className="sm:col-span-2">
                  <p className="font-medium">Cancellation reason</p>
                  <p className="mt-1 text-muted-foreground">{appointment.cancellation_reason}</p>
                </div>
              ) : null}
            </CardContent>
          </Card>

          <Card className="print:hidden">
            <CardHeader>
              <CardTitle>Actions</CardTitle>
            </CardHeader>
            <CardContent>
              <AppointmentCardActions appointment={appointment} />
            </CardContent>
          </Card>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Status timeline</CardTitle>
          </CardHeader>
          <CardContent>
            <StatusHistory entries={history} />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
