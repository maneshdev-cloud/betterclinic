"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { CalendarCheck } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { bookAppointmentAction } from "@/services/appointments/actions";
import { formatDateWithDay, formatTimeString } from "@/lib/utils";
import type { SlotSelection } from "@/components/appointments/slot-picker";

interface BookingDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  selection: SlotSelection | null;
  doctorName: string;
  clinicName: string;
  fee: number | null;
}

/** Confirm a chosen slot with a visit reason, then book for real. */
export function BookingDialog({
  open,
  onOpenChange,
  selection,
  doctorName,
  clinicName,
  fee,
}: BookingDialogProps) {
  const router = useRouter();
  const [visitReason, setVisitReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  const reset = () => {
    setVisitReason("");
    setError(null);
    setPending(false);
  };

  const handleBook = async () => {
    if (!selection) return;
    setPending(true);
    setError(null);
    const result = await bookAppointmentAction({
      slotId: selection.slotId,
      visitReason,
    });
    if (result.ok && result.data) {
      toast.success("Appointment booked", {
        description: `${doctorName} · ${formatDateWithDay(selection.date)}, ${formatTimeString(selection.startTime)}`,
      });
      onOpenChange(false);
      reset();
      router.push(`/patient/appointments/${result.data.appointmentId}`);
    } else {
      setError(result.error ?? "The appointment could not be booked.");
      setPending(false);
    }
  };

  return (
    <Dialog
      open={open}
      onOpenChange={(next) => {
        if (!pending) {
          onOpenChange(next);
          if (!next) reset();
        }
      }}
    >
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Confirm your appointment</DialogTitle>
          <DialogDescription asChild>
            <div className="space-y-1.5">
              <p className="font-medium text-foreground">{doctorName}</p>
              <p>{clinicName}</p>
              {selection ? (
                <p>
                  {formatDateWithDay(selection.date)} · {formatTimeString(selection.startTime)} –{" "}
                  {formatTimeString(selection.endTime)}
                  {fee !== null ? ` · ₹${fee}` : ""}
                </p>
              ) : null}
            </div>
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-1.5">
          <Label htmlFor="visit-reason">Reason for visit</Label>
          <Textarea
            id="visit-reason"
            value={visitReason}
            onChange={(event) => setVisitReason(event.target.value)}
            placeholder="e.g. Persistent headache for the last three days"
            rows={3}
            maxLength={500}
            disabled={pending}
            aria-describedby={error ? "visit-reason-error" : undefined}
          />
          <p className="text-xs text-muted-foreground">
            Briefly describe your symptoms (3–500 characters). This helps the doctor prepare.
          </p>
          {error ? (
            <p id="visit-reason-error" className="text-sm text-red-600" role="alert">
              {error}
            </p>
          ) : null}
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={pending}>
            Cancel
          </Button>
          <Button onClick={handleBook} disabled={pending || visitReason.trim().length < 3}>
            {pending ? "Booking…" : (
              <>
                <CalendarCheck className="mr-1.5 h-4 w-4" aria-hidden /> Confirm booking
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
