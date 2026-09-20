"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
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
import { cancelAppointmentAction } from "@/services/appointments/actions";

interface CancelDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  appointmentId: string;
}

/** Cancel an appointment with an optional reason. */
export function CancelDialog({ open, onOpenChange, appointmentId }: CancelDialogProps) {
  const router = useRouter();
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  const handleCancel = async () => {
    setPending(true);
    setError(null);
    const result = await cancelAppointmentAction({ appointmentId, reason });
    if (result.ok) {
      toast.success("Appointment cancelled");
      onOpenChange(false);
      setReason("");
      router.refresh();
    } else {
      setError(result.error ?? "The appointment could not be cancelled.");
    }
    setPending(false);
  };

  return (
    <Dialog open={open} onOpenChange={(next) => !pending && onOpenChange(next)}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Cancel this appointment?</DialogTitle>
          <DialogDescription>
            The slot is released for other patients right away. This cannot be undone — you can book
            a new time afterwards.
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-1.5">
          <Label htmlFor="cancel-reason">Reason (optional)</Label>
          <Textarea
            id="cancel-reason"
            value={reason}
            onChange={(event) => setReason(event.target.value)}
            placeholder="e.g. Feeling better / schedule conflict"
            rows={2}
            maxLength={200}
            disabled={pending}
          />
          {error ? (
            <p className="text-sm text-red-600" role="alert">
              {error}
            </p>
          ) : null}
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={pending}>
            Keep appointment
          </Button>
          <Button variant="destructive" onClick={handleCancel} disabled={pending}>
            {pending ? "Cancelling…" : "Cancel appointment"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
