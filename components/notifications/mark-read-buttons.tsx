"use client";

import { useState, useTransition } from "react";
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

  return (
    <Button
      variant="outline"
      size="sm"
      disabled={disabled || pending}
      onClick={() =>
        startTransition(async () => {
          const result = await markAllNotificationsReadAction();
          if (result.ok) {
            toast.success(`Marked ${result.data?.updated ?? 0} notification(s) as read`);
            router.refresh();
          } else {
            toast.error(result.error ?? "Could not update notifications.");
          }
        })
      }
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

  return (
    <button
      type="button"
      disabled={pending}
      onClick={async () => {
        setPending(true);
        await markNotificationReadAction(notificationId);
        router.refresh();
        setPending(false);
      }}
      className="text-xs text-muted-foreground underline-offset-2 hover:underline disabled:opacity-50"
    >
      {pending ? "…" : "Mark read"}
    </button>
  );
}
