"use client";

import { useRef, useTransition, useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { LogIn, Loader2, CheckCircle2 } from "lucide-react";
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
  const [checkedInToken, setCheckedInToken] = useState<string | null>(null);
  const isLockedRef = useRef(false);

  if (checkedInToken) {
    return (
      <span className="inline-flex items-center gap-1.5 text-xs font-semibold text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-md border border-emerald-200">
        <CheckCircle2 className="h-3.5 w-3.5" aria-hidden /> Token {checkedInToken}
      </span>
    );
  }

  const handleCheckIn = () => {
    if (disabled || pending || isLockedRef.current) return;
    isLockedRef.current = true;

    startTransition(async () => {
      try {
        const result =
          mode === "patient"
            ? await checkInAction(appointmentId)
            : await staffCheckInAction(appointmentId);
        if (result.ok && result.data) {
          setCheckedInToken(result.data.tokenCode);
          toast.success(`Checked in — your token is ${result.data.tokenCode}`);
          router.refresh();
        } else {
          isLockedRef.current = false;
          toast.error(result.error ?? "Check-in failed.");
        }
      } catch {
        isLockedRef.current = false;
        toast.error("Network or server failure during check-in.");
      }
    });
  };

  return (
    <Button
      size="sm"
      variant={mode === "patient" ? "default" : "outline"}
      disabled={disabled || pending}
      title={disabled ? disabledReason : undefined}
      onClick={handleCheckIn}
    >
      {pending ? (
        <Loader2 className="mr-1.5 h-4 w-4 animate-spin" aria-hidden />
      ) : (
        <LogIn className="mr-1.5 h-4 w-4" aria-hidden />
      )}
      {pending ? "Checking in…" : mode === "patient" ? "Check in" : "Check in at desk"}
    </Button>
  );
}
