import { AppointmentStatusBadge } from "@/components/shared/status-badge";
import { formatDateTime } from "@/lib/utils";
import type { StatusHistoryEntry } from "@/services/appointments/service";

/** Vertical timeline of every status change recorded by the database triggers. */
export function StatusHistory({ entries }: { entries: StatusHistoryEntry[] }) {
  if (entries.length === 0) {
    return <p className="text-sm text-muted-foreground">No status changes recorded yet.</p>;
  }

  return (
    <ol className="space-y-0">
      {entries.map((entry, index) => (
        <li key={entry.id} className="relative flex gap-3 pb-5 last:pb-0">
          {index < entries.length - 1 ? (
            <span className="absolute left-[7px] top-4 h-full w-px bg-border" aria-hidden />
          ) : null}
          <span
            className="mt-1.5 h-[15px] w-[15px] shrink-0 rounded-full border-2 border-primary bg-background"
            aria-hidden
          />
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-2">
              {entry.from_status ? (
                <>
                  <AppointmentStatusBadge status={entry.from_status} />
                  <span className="text-xs text-muted-foreground">→</span>
                </>
              ) : null}
              <AppointmentStatusBadge status={entry.to_status} />
            </div>
            <p className="mt-1 text-xs text-muted-foreground">
              {formatDateTime(entry.created_at)}
              {entry.changed_by_name ? ` · by ${entry.changed_by_name}` : ""}
              {entry.reason ? ` · ${entry.reason}` : ""}
            </p>
          </div>
        </li>
      ))}
    </ol>
  );
}
