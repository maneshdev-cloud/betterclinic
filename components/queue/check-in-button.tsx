"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { LogIn } from "lucide-react";
import { Button } from "@/components/ui/button";
import { checkInAction, staffCheckInAction } from "@/services/queue/actions";

/**
 * Check a patient in: the SQL function creates the check-in row, joins
 * the queue and assigns the token atomically.
 */
export function CheckInButton({
  appointmentId,
  mode = "patient",
  disabled,
  disabledReason,
}: {
  appointmentId: string;
  mode?: "patient" | "staff";
  disabled?: boolean;
  disabledReason?: string;
}) {
  const router = useRouter();
  const [pending, startTransition] = useTransition();

  return (
    <Button
      size="sm"
      variant={mode === "patient" ? "default" : "outline"}
      disabled={disabled || pending}
      title={disabled ? disabledReason : undefined}
      onClick={() =>
        startTransition(async () => {
          const result =
            mode === "patient"
              ? await checkInAction(appointmentId)
              : await staffCheckInAction(appointmentId);
          if (result.ok && result.data) {
            toast.success(`Checked in — your token is ${result.data.tokenCode}`);
            router.refresh();
          } else {
            toast.error(result.error ?? "Check-in failed.");
          }
        })
      }
    >
      <LogIn className="mr-1.5 h-4 w-4" aria-hidden />
      {pending ? "Checking in…" : mode === "patient" ? "Check in" : "Check in at desk"}
    </Button>
  );
}
