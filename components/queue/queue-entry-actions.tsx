"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { BellRing, RotateCcw, SkipForward, Stethoscope, Undo2, UserRoundCheck } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  callNextAction,
  callSpecificAction,
  recallAction,
  returnToWaitingAction,
  skipAction,
  resumeAction,
  setPriorityAction,
  startConsultationAction,
} from "@/services/queue/actions";
import type { QueueEntryView } from "@/services/queue/service";
import type { Priority } from "@/lib/constants";

/** Call the next waiting token for a doctor's queue. */
export function CallNextButton({
  clinicId,
  doctorId,
  disabled,
}: {
  clinicId: string;
  doctorId: string;
  disabled?: boolean;
}) {
  const router = useRouter();
  const [pending, startTransition] = useTransition();

  return (
    <Button
      disabled={disabled || pending}
      onClick={() =>
        startTransition(async () => {
          const result = await callNextAction(clinicId, doctorId);
          if (result.ok && result.data) {
            toast.success(`Now calling token ${result.data.tokenCode}`);
            router.refresh();
          } else {
            toast.error(result.error ?? "Could not call the next patient.");
          }
        })
      }
    >
      <UserRoundCheck className="mr-1.5 h-4 w-4" aria-hidden />
      {pending ? "Calling…" : "Call next patient"}
    </Button>
  );
}

/**
 * Per-entry queue actions. Every button maps 1:1 to a SQL function that
 * validates permissions and the queue state machine server-side.
 */
export function QueueEntryActions({
  entry,
  showStart = true,
}: {
  entry: QueueEntryView;
  showStart?: boolean;
}) {
  const router = useRouter();
  const [pendingAction, setPendingAction] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const run = async (key: string, action: () => Promise<{ ok: boolean; error?: string }>, successMessage: string) => {
    setPendingAction(key);
    setError(null);
    const result = await action();
    if (result.ok) {
      toast.success(successMessage);
      router.refresh();
    } else {
      setError(result.error ?? "Action failed.");
      toast.error(result.error ?? "Action failed.");
    }
    setPendingAction(null);
  };

  const busy = pendingAction !== null;

  return (
    <div className="flex flex-wrap items-center gap-2">
      {entry.status === "WAITING" ? (
        <>
          <Button
            size="sm"
            variant="outline"
            disabled={busy}
            onClick={() =>
              run("call", () => callSpecificAction(entry.id), `Calling token ${entry.token_code}`)
            }
          >
            <BellRing className="mr-1.5 h-4 w-4" aria-hidden /> Call
          </Button>
          <Button
            size="sm"
            variant="outline"
            disabled={busy}
            onClick={() => run("skip", () => skipAction(entry.id), `Token ${entry.token_code} skipped`)}
          >
            <SkipForward className="mr-1.5 h-4 w-4" aria-hidden /> Skip
          </Button>
        </>
      ) : null}

      {entry.status === "CALLED" ? (
        <>
          <Button
            size="sm"
            variant="outline"
            disabled={busy}
            onClick={() =>
              run("recall", () => recallAction(entry.id), `Token ${entry.token_code} called again`)
            }
          >
            <BellRing className="mr-1.5 h-4 w-4" aria-hidden /> Call again
          </Button>
          <Button
            size="sm"
            variant="outline"
            disabled={busy}
            onClick={() =>
              run("return", () => returnToWaitingAction(entry.id), `Token ${entry.token_code} returned to the queue`)
            }
          >
            <Undo2 className="mr-1.5 h-4 w-4" aria-hidden /> Not present
          </Button>
          {showStart ? (
            <Button
              size="sm"
              disabled={busy}
              onClick={() =>
                run(
                  "start",
                  () => startConsultationAction(entry.appointment_id),
                  `Consultation started for ${entry.patient_name}`
                )
              }
            >
              <Stethoscope className="mr-1.5 h-4 w-4" aria-hidden />
              {pendingAction === "start" ? "Starting…" : "Start consultation"}
            </Button>
          ) : null}
        </>
      ) : null}

      {entry.status === "SKIPPED" ? (
        <Button
          size="sm"
          variant="outline"
          disabled={busy}
          onClick={() => run("resume", () => resumeAction(entry.id), `Token ${entry.token_code} resumed`)}
        >
          <RotateCcw className="mr-1.5 h-4 w-4" aria-hidden /> Resume
        </Button>
      ) : null}

      {(entry.status === "WAITING" || entry.status === "SKIPPED") && entry.priority !== "URGENT" ? (
        <Select
          value={entry.priority}
          onValueChange={(value) =>
            run(
              `priority-${value}`,
              () => setPriorityAction(entry.id, value as Priority),
              `${entry.patient_name}'s priority set to ${value}`
            )
          }
          disabled={busy}
        >
          <SelectTrigger className="h-8 w-32 text-xs" aria-label="Change priority">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="NORMAL">Normal priority</SelectItem>
            <SelectItem value="HIGH">High priority</SelectItem>
            <SelectItem value="URGENT">Urgent priority</SelectItem>
          </SelectContent>
        </Select>
      ) : null}

      {error ? (
        <span className="text-xs text-red-600" role="alert">
          {error}
        </span>
      ) : null}
    </div>
  );
}
