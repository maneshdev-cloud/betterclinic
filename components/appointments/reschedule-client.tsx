"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { ArrowRightLeft } from "lucide-react";
import { SlotPicker, type SlotSelection } from "@/components/appointments/slot-picker";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { rescheduleAppointmentAction } from "@/services/appointments/actions";
import { formatDateWithDay, formatTimeString } from "@/lib/utils";

interface RescheduleClientProps {
  appointmentId: string;
  doctorId: string;
  doctorName: string;
  clinicId: string;
  clinicName: string;
  availableDows: number[];
  currentDate: string;
  currentTime: string;
}

/** Slot picker + confirmation for moving an appointment to a new slot. */
export function RescheduleClient({
  appointmentId,
  doctorId,
  doctorName,
  clinicId,
  clinicName,
  availableDows,
  currentDate,
  currentTime,
}: RescheduleClientProps) {
  const router = useRouter();
  const [selection, setSelection] = useState<SlotSelection | null>(null);
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleConfirm = async () => {
    if (!selection) return;
    setPending(true);
    setError(null);
    const result = await rescheduleAppointmentAction({
      appointmentId,
      newSlotId: selection.slotId,
    });
    if (result.ok) {
      toast.success("Appointment rescheduled", {
        description: `${formatDateWithDay(selection.date)} at ${formatTimeString(selection.startTime)}`,
      });
      setOpen(false);
      router.push(`/patient/appointments/${appointmentId}`);
    } else {
      setError(result.error ?? "Could not reschedule.");
      setOpen(false);
      setPending(false);
    }
  };

  return (
    <>
      <SlotPicker
        doctorId={doctorId}
        clinicId={clinicId}
        availableDows={availableDows}
        onSelectSlot={(slot) => {
          setSelection(slot);
          setOpen(true);
        }}
        selectLabel="Move appointment here"
      />

      <Dialog open={open} onOpenChange={(next) => !pending && setOpen(next)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Move your appointment?</DialogTitle>
            <DialogDescription asChild>
              <div className="space-y-1">
                <p>
                  <span className="text-muted-foreground">Current:</span> {doctorName} ·{" "}
                  {formatDateWithDay(currentDate)}, {formatTimeString(currentTime)}
                </p>
                <p>
                  <span className="text-muted-foreground">New:</span> {doctorName} ·{" "}
                  {selection ? `${formatDateWithDay(selection.date)}, ${formatTimeString(selection.startTime)}` : ""}{" "}
                  at {clinicName}
                </p>
              </div>
            </DialogDescription>
          </DialogHeader>
          {error ? (
            <p className="text-sm text-red-600" role="alert">
              {error}
            </p>
          ) : null}
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)} disabled={pending}>
              Keep current time
            </Button>
            <Button onClick={handleConfirm} disabled={pending}>
              {pending ? "Moving…" : (
                <>
                  <ArrowRightLeft className="mr-1.5 h-4 w-4" aria-hidden /> Confirm new time
                </>
              )}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
