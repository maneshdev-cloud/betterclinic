"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { CheckCircle2, UserX } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { confirmAppointmentAction, markNoShowAction } from "@/services/appointments/actions";
import type { StaffAppointmentItem } from "@/services/appointments/service";

/** Receptionist actions per appointment row — each hits a real SQL function. */
export function StaffAppointmentActions({ appointment }: { appointment: StaffAppointmentItem }) {
  const router = useRouter();
  const [noShowOpen, setNoShowOpen] = useState(false);
  const [pendingAction, setPendingAction] = useState<"confirm" | "noShow" | null>(null);
  const [error, setError] = useState<string | null>(null);

  const canConfirm = appointment.status === "BOOKED";
  const canNoShow = ["BOOKED", "CONFIRMED", "WAITING", "CALLED"].includes(appointment.status);

  const handleConfirm = async () => {
    setPendingAction("confirm");
    setError(null);
    const result = await confirmAppointmentAction(appointment.id);
    if (result.ok) {
      toast.success(`Confirmed appointment for ${appointment.patient_name}`);
      router.refresh();
    } else {
      setError(result.error ?? "Could not confirm.");
    }
    setPendingAction(null);
  };

  const handleNoShow = async () => {
    setPendingAction("noShow");
    setError(null);
    const result = await markNoShowAction(appointment.id);
    if (result.ok) {
      toast.success(`Marked ${appointment.patient_name} as no-show`);
      setNoShowOpen(false);
      router.refresh();
    } else {
      setError(result.error ?? "Could not mark no-show.");
    }
    setPendingAction(null);
  };

  if (!canConfirm && !canNoShow) return null;

  return (
    <>
      <div className="flex flex-wrap gap-2">
        {canConfirm ? (
          <Button size="sm" variant="outline" onClick={handleConfirm} disabled={pendingAction !== null}>
            <CheckCircle2 className="mr-1.5 h-4 w-4" aria-hidden />
            {pendingAction === "confirm" ? "Confirming…" : "Confirm"}
          </Button>
        ) : null}
        {canNoShow ? (
          <Button size="sm" variant="ghost" className="text-red-600 hover:text-red-700" onClick={() => setNoShowOpen(true)} disabled={pendingAction !== null}>
            <UserX className="mr-1.5 h-4 w-4" aria-hidden /> No-show
          </Button>
        ) : null}
      </div>

      <Dialog open={noShowOpen} onOpenChange={(next) => pendingAction === null && setNoShowOpen(next)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Mark {appointment.patient_name} as a no-show?</DialogTitle>
            <DialogDescription>
              The appointment ({appointment.appointment_date} at {appointment.start_time.slice(0, 5)}) will
              be closed as “No show”. This frees the doctor&apos;s time but cannot be undone.
            </DialogDescription>
          </DialogHeader>
          {error ? (
            <p className="text-sm text-red-600" role="alert">
              {error}
            </p>
          ) : null}
          <DialogFooter>
            <Button variant="outline" onClick={() => setNoShowOpen(false)} disabled={pendingAction !== null}>
              Back
            </Button>
            <Button variant="destructive" onClick={handleNoShow} disabled={pendingAction !== null}>
              {pendingAction === "noShow" ? "Saving…" : "Mark as no-show"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
