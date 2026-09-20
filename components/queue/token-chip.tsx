import { cn } from "@/lib/utils";
import { QueueStatusBadge, PriorityBadge } from "@/components/shared/status-badge";
import type { QueueEntryView } from "@/services/queue/service";

/** Big token display used on every queue board. */
export function TokenChip({ entry, size = "md" }: { entry: QueueEntryView; size?: "md" | "lg" }) {
  return (
    <div className="flex items-center gap-3">
      <span
        className={cn(
          "inline-flex items-center justify-center rounded-lg border-2 border-primary/20 bg-primary/5 font-mono font-bold tracking-wide text-primary",
          size === "lg" ? "h-16 min-w-16 px-3 text-2xl" : "h-10 min-w-10 px-2 text-base"
        )}
        aria-label={`Token ${entry.token_code}`}
      >
        {entry.token_code}
      </span>
      <div className="flex flex-col items-start gap-1">
        <QueueStatusBadge status={entry.status} />
        <PriorityBadge priority={entry.priority} />
      </div>
    </div>
  );
}
