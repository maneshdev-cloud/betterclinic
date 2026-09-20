"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { CheckCircle2 } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { completeConsultationAction } from "@/services/clinical/actions";

/** Closes the consultation: appointment → COMPLETED, queue entry done, patient notified. */
export function CompleteConsultationButton({
  consultationId,
  patientName,
}: {
  consultationId: string;
  patientName: string;
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleComplete = async () => {
    setPending(true);
    setError(null);
    const result = await completeConsultationAction(consultationId);
    if (result.ok) {
      toast.success(`Consultation completed for ${patientName}`);
      setOpen(false);
      router.refresh();
    } else {
      setError(result.error ?? "Could not complete the consultation.");
    }
    setPending(false);
  };

  return (
    <>
      <Button onClick={() => setOpen(true)} variant="default">
        <CheckCircle2 className="mr-1.5 h-4 w-4" aria-hidden /> Complete consultation
      </Button>

      <Dialog open={open} onOpenChange={(next) => !pending && setOpen(next)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Complete this consultation?</DialogTitle>
            <DialogDescription>
              The appointment is marked COMPLETED, the queue entry is closed, and the patient is notified. Notes and
              prescriptions stay on record.
            </DialogDescription>
          </DialogHeader>
          {error ? (
            <p className="text-sm text-red-600" role="alert">
              {error}
            </p>
          ) : null}
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)} disabled={pending}>
              Keep open
            </Button>
            <Button onClick={handleComplete} disabled={pending}>
              {pending ? "Completing…" : "Complete"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
