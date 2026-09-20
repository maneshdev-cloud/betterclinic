import Link from "next/link";
import { CalendarDays, Clock } from "lucide-react";
import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { formatDateWithDay, formatTimeString } from "@/lib/utils";
import type { StaffAppointmentItem } from "@/services/appointments/service";
import { StaffAppointmentActions } from "@/components/appointments/staff-appointment-actions";

/** One appointment row for the staff dashboard. */
export function StaffAppointmentRow({ appointment }: { appointment: StaffAppointmentItem }) {
  return (
    <Card>
      <CardContent className="flex flex-col gap-3 p-4 lg:flex-row lg:items-center lg:justify-between">
        <div className="min-w-0 space-y-1.5">
          <div className="flex flex-wrap items-center gap-2">
            <AppointmentStatusBadge status={appointment.status} />
            {appointment.appointment_type === "WALK_IN" ? <Badge variant="outline">Walk-in</Badge> : null}
          </div>
          <p className="font-medium text-foreground">{appointment.patient_name}</p>
          <p className="text-sm text-muted-foreground">
            {appointment.doctor_name}
            {appointment.doctor_qualification ? ` · ${appointment.doctor_qualification}` : ""}
          </p>
          <p className="inline-flex items-center gap-2 text-sm text-muted-foreground">
            <CalendarDays className="h-4 w-4 shrink-0" aria-hidden />
            {formatDateWithDay(appointment.appointment_date)}
          </p>
          <p className="inline-flex items-center gap-2 text-sm text-muted-foreground">
            <Clock className="h-4 w-4 shrink-0" aria-hidden />
            {formatTimeString(appointment.start_time)} – {formatTimeString(appointment.end_time)}
          </p>
          <p className="max-w-xl truncate text-sm text-muted-foreground">
            <span className="font-medium text-foreground/80">Reason:</span> {appointment.visit_reason}
          </p>
        </div>

        <div className="flex shrink-0 flex-col gap-2 lg:items-end">
          <StaffAppointmentActions appointment={appointment} />
          <Link
            href={`/staff/appointments?focus=${appointment.id}`}
            className="text-xs text-muted-foreground underline-offset-2 hover:underline"
          >
            ID {appointment.id.slice(0, 8)}…
          </Link>
        </div>
      </CardContent>
    </Card>
  );
}
