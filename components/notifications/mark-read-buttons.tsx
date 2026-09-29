"use client";

import { useState, useTransition, useRef } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { CheckCheck } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  markAllNotificationsReadAction,
  markNotificationReadAction,
} from "@/services/notifications/actions";

/** Mark-all button for the notifications page. */
export function MarkAllReadButton({ disabled }: { disabled?: boolean }) {
  const router = useRouter();
  const [pending, startTransition] = useTransition();
  const [optimisticDone, setOptimisticDone] = useState(false);
  const isLockedRef = useRef(false);

  if (optimisticDone) {
    return (
      <Button variant="outline" size="sm" disabled>
        <CheckCheck className="mr-1.5 h-4 w-4 text-emerald-600" aria-hidden /> All caught up
      </Button>
    );
  }

  const handleMarkAll = () => {
    if (disabled || pending || isLockedRef.current) return;
    isLockedRef.current = true;
    setOptimisticDone(true);

    startTransition(async () => {
      try {
        const result = await markAllNotificationsReadAction();
        if (result.ok) {
          toast.success(`Marked ${result.data?.updated ?? 0} notification(s) as read`);
          router.refresh();
        } else {
          setOptimisticDone(false);
          isLockedRef.current = false;
          toast.error(result.error ?? "Could not update notifications.");
        }
      } catch {
        setOptimisticDone(false);
        isLockedRef.current = false;
        toast.error("Network or server failure updating notifications.");
      }
    });
  };

  return (
    <Button
      variant="outline"
      size="sm"
      disabled={disabled || pending}
      onClick={handleMarkAll}
    >
      <CheckCheck className="mr-1.5 h-4 w-4" aria-hidden />
      {pending ? "Marking…" : "Mark all as read"}
    </Button>
  );
}

/** Per-row "mark read" control. */
export function MarkReadButton({ notificationId }: { notificationId: string }) {
  const router = useRouter();
  const [pending, setPending] = useState(false);
  const [isReadOptimistic, setIsReadOptimistic] = useState(false);
  const isLockedRef = useRef(false);

  if (isReadOptimistic) {
    return <span className="text-xs text-muted-foreground italic">Read</span>;
  }

  return (
    <button
      type="button"
      disabled={pending}
      onClick={async () => {
        if (pending || isLockedRef.current) return;
        isLockedRef.current = true;
        setPending(true);
        setIsReadOptimistic(true);
        try {
          const res = await markNotificationReadAction(notificationId);
          if (!res.ok) {
            setIsReadOptimistic(false);
            isLockedRef.current = false;
            toast.error(res.error ?? "Failed to mark read");
          } else {
            router.refresh();
          }
        } catch {
          setIsReadOptimistic(false);
          isLockedRef.current = false;
          toast.error("Network error");
        } finally {
          setPending(false);
        }
      }}
      className="text-xs text-muted-foreground underline-offset-2 hover:underline disabled:opacity-50"
    >
      {pending ? "…" : "Mark read"}
    </button>
  );
}
