"use client";

import { useState } from "react";
import { CalendarClock, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { CancelDialog } from "@/components/appointments/cancel-dialog";
import { CheckInButton } from "@/components/queue/check-in-button";
import { todayClinicDate } from "@/lib/utils";
import type { PatientAppointmentItem } from "@/services/appointments/service";

/** Client actions for a patient appointment card (driven by the real state machine). */
export function AppointmentCardActions({ appointment }: { appointment: PatientAppointmentItem }) {
  const [cancelOpen, setCancelOpen] = useState(false);

  const cancellable = ["BOOKED", "CONFIRMED", "CHECKED_IN", "WAITING"].includes(appointment.status);
  const reschedulable = ["BOOKED", "CONFIRMED"].includes(appointment.status);
  const checkinable =
    appointment.appointment_date === todayClinicDate() &&
    ["BOOKED", "CONFIRMED"].includes(appointment.status);

  return (
    <>
      <div className="flex flex-wrap gap-2 sm:justify-end">
        {checkinable ? <CheckInButton appointmentId={appointment.id} mode="patient" /> : null}
        {reschedulable ? (
          <Button asChild size="sm" variant="outline">
            <a href={`/patient/appointments/${appointment.id}/reschedule`}>
              <CalendarClock className="mr-1.5 h-4 w-4" aria-hidden /> Reschedule
            </a>
          </Button>
        ) : null}
        {cancellable ? (
          <Button size="sm" variant="ghost" className="text-red-600 hover:text-red-700" onClick={() => setCancelOpen(true)}>
            <XCircle className="mr-1.5 h-4 w-4" aria-hidden /> Cancel
          </Button>
        ) : null}
      </div>
      {cancellable ? (
        <CancelDialog
          open={cancelOpen}
          onOpenChange={setCancelOpen}
          appointmentId={appointment.id}
        />
      ) : null}
    </>
  );
}
