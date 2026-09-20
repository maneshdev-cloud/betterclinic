"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { CalendarClock } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { scheduleFollowUpAction } from "@/services/clinical/actions";
import { todayClinicDate, clinicDatePlusDays } from "@/lib/utils";

interface FollowUpDialogProps {
  consultationId: string;
  existingCount: number;
}

/** Doctor schedules a follow-up visit for the consultation's patient. */
export function FollowUpDialog({ consultationId, existingCount }: FollowUpDialogProps) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [date, setDate] = useState(clinicDatePlusDays(7));
  const [reason, setReason] = useState("");
  const [instructions, setInstructions] = useState("");
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async () => {
    setPending(true);
    setError(null);
    const result = await scheduleFollowUpAction({
      consultationId,
      scheduled_date: date,
      reason,
      instructions,
    });
    if (result.ok) {
      toast.success(`Follow-up scheduled for ${date}`);
      setOpen(false);
      setReason("");
      setInstructions("");
      router.refresh();
    } else {
      setError(result.error ?? "Could not schedule the follow-up.");
    }
    setPending(false);
  };

  return (
    <>
      <Button variant="outline" onClick={() => setOpen(true)}>
        <CalendarClock className="mr-1.5 h-4 w-4" aria-hidden />
        Schedule follow-up{existingCount > 0 ? ` (${existingCount})` : ""}
      </Button>

      <Dialog open={open} onOpenChange={(next) => !pending && setOpen(next)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Schedule a follow-up</DialogTitle>
            <DialogDescription>
              The patient is notified and it appears on their follow-ups page.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="follow-up-date">Date</Label>
              <Input
                id="follow-up-date"
                type="date"
                value={date}
                min={todayClinicDate()}
                onChange={(event) => setDate(event.target.value)}
                disabled={pending}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="follow-up-reason">Reason</Label>
              <Input
                id="follow-up-reason"
                value={reason}
                onChange={(event) => setReason(event.target.value)}
                placeholder="e.g. Review fever after 5 days of medication"
                maxLength={200}
                disabled={pending}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="follow-up-instructions">Instructions (optional)</Label>
              <Textarea
                id="follow-up-instructions"
                value={instructions}
                onChange={(event) => setInstructions(event.target.value)}
                placeholder="e.g. Bring the temperature log; come fasting"
                rows={2}
                maxLength={500}
                disabled={pending}
              />
            </div>
            {error ? (
              <p className="text-sm text-red-600" role="alert">
                {error}
              </p>
            ) : null}
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)} disabled={pending}>
              Cancel
            </Button>
            <Button onClick={handleSubmit} disabled={pending || !date || reason.trim().length < 3}>
              {pending ? "Scheduling…" : "Schedule follow-up"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
