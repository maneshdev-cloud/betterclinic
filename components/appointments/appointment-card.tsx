import Link from "next/link";
import { CalendarDays, Clock, MapPin, User } from "lucide-react";
import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { formatDateWithDay, formatTimeString } from "@/lib/utils";
import type { PatientAppointmentItem } from "@/services/appointments/service";

interface AppointmentCardProps {
  appointment: PatientAppointmentItem;
  /** Rendered after the status changes (cancel/reschedule buttons). */
  actions?: React.ReactNode;
}

/** Patient-facing appointment summary card. */
export function AppointmentCard({ appointment, actions }: AppointmentCardProps) {
  return (
    <Card>
      <CardContent className="flex flex-col gap-3 p-4 sm:flex-row sm:items-center sm:justify-between">
        <div className="min-w-0 space-y-1.5">
          <div className="flex flex-wrap items-center gap-2">
            <AppointmentStatusBadge status={appointment.status} />
            {appointment.appointment_type === "WALK_IN" ? <Badge variant="outline">Walk-in</Badge> : null}
          </div>

          <p className="inline-flex items-center gap-2 font-medium text-foreground">
            <User className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
            {appointment.doctor_name}
            {appointment.doctor_qualification ? (
              <span className="text-sm font-normal text-muted-foreground">
                · {appointment.doctor_qualification}
              </span>
            ) : null}
          </p>

          <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-sm text-muted-foreground">
            <span className="inline-flex items-center gap-1.5">
              <CalendarDays className="h-4 w-4 shrink-0" aria-hidden />
              {formatDateWithDay(appointment.appointment_date)}
            </span>
            <span className="inline-flex items-center gap-1.5">
              <Clock className="h-4 w-4 shrink-0" aria-hidden />
              {formatTimeString(appointment.start_time)} – {formatTimeString(appointment.end_time)}
            </span>
          </div>

          <p className="inline-flex items-center gap-2 text-sm text-muted-foreground">
            <MapPin className="h-4 w-4 shrink-0" aria-hidden />
            {appointment.clinic_name}
            {appointment.clinic_area ? `, ${appointment.clinic_area}` : ""}
          </p>
        </div>

        <div className="flex shrink-0 flex-col gap-2 sm:items-end w-full sm:w-auto">
          {actions}
          <Button asChild variant="outline" size="sm" className="w-full sm:w-auto">
            <Link href={`/patient/appointments/${appointment.id}`}>View details</Link>
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
