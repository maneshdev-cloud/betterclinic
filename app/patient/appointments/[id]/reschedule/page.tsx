import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRightLeft } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { RescheduleClient } from "@/components/appointments/reschedule-client";
import { createClient } from "@/lib/supabase/server";
import { getAppointmentDetail } from "@/services/appointments/service";
import { getDoctorAvailability } from "@/services/doctors/service";
import { formatDateWithDay, formatTimeString } from "@/lib/utils";

export const metadata: Metadata = { title: "Reschedule appointment" };

interface PageProps {
  params: { id: string };
}

export default async function ReschedulePage({ params }: PageProps) {
  const supabase = await createClient();
  const detail = await getAppointmentDetail(supabase, params.id);
  if (!detail) notFound();

  const { appointment } = detail;
  if (!["BOOKED", "CONFIRMED"].includes(appointment.status)) {
    return (
      <div className="page-container space-y-6 py-8">
        <PageHeader title="Reschedule appointment" />
        <Card>
          <CardContent className="space-y-3 p-6 text-sm text-muted-foreground">
            <p>
              This appointment is <AppointmentStatusBadge status={appointment.status} /> and can no
              longer be rescheduled.
            </p>
            <Link
              href={`/patient/appointments/${appointment.id}`}
              className="inline-block text-foreground underline-offset-2 hover:underline"
            >
              ← Back to appointment details
            </Link>
          </CardContent>
        </Card>
      </div>
    );
  }

  const availability = await getDoctorAvailability(supabase, appointment.doctor_id);
  const dows = Array.from(
    new Set(
      availability
        .filter((window) => window.clinic_id === appointment.clinic_id)
        .map((window) => window.day_of_week)
    )
  );

  return (
    <div className="page-container space-y-6 py-8">
      <nav aria-label="Breadcrumb" className="text-sm text-muted-foreground">
        <Link href={`/patient/appointments/${appointment.id}`} className="hover:underline">
          ← Back to appointment details
        </Link>
      </nav>

      <PageHeader
        title="Reschedule appointment"
        description={`${appointment.doctor_name} · ${appointment.clinic_name}`}
        actions={
          <span className="inline-flex items-center gap-2 text-sm text-muted-foreground">
            <ArrowRightLeft className="h-4 w-4" aria-hidden />
            {formatDateWithDay(appointment.appointment_date)}, {formatTimeString(appointment.start_time)}
          </span>
        }
      />

      <Card>
        <CardHeader>
          <CardTitle>Pick a new time</CardTitle>
        </CardHeader>
        <CardContent>
          <RescheduleClient
            appointmentId={appointment.id}
            doctorId={appointment.doctor_id}
            doctorName={appointment.doctor_name}
            clinicId={appointment.clinic_id}
            clinicName={appointment.clinic_name}
            availableDows={dows}
            currentDate={appointment.appointment_date}
            currentTime={appointment.start_time}
          />
        </CardContent>
      </Card>
    </div>
  );
}
