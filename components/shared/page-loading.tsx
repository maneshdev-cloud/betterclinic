import { Loader2 } from "lucide-react";
import { EscalatingSkeletonNote } from "./escalating-skeleton-note";

/**
 * Loading skeleton shown while a role area's server pages fetch data.
 * Honest about what's happening (no fake content shimmer).
 * Escalates honestly after 3-4s or when network retries occur.
 */
export function PageLoading({ label = "Loading…" }: { label?: string }) {
  return (
    <div className="page-container flex min-h-[50vh] flex-col items-center justify-center gap-3 py-8">
      <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" aria-hidden />
      <p className="text-sm text-muted-foreground" aria-live="polite">
        {label}
      </p>
      <EscalatingSkeletonNote />
    </div>
  );
}
