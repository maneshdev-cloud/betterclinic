import { Construction } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";

/**
 * Honest placeholder for modules that land in later build phases.
 * It renders a clearly-labelled state — never fake data, never fake
 * buttons — and disappears when the real module replaces the page.
 */
export function ModuleInProgress({
  title,
  phase,
  description,
}: {
  title: string;
  phase: number;
  description: string;
}) {
  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader title={title} />
      <div className="flex flex-col items-center justify-center rounded-lg border border-dashed bg-muted/30 px-6 py-16 text-center">
        <div className="mb-3 flex h-11 w-11 items-center justify-center rounded-full bg-muted">
          <Construction className="h-5 w-5 text-muted-foreground" aria-hidden />
        </div>
        <p className="text-sm font-medium">Built in Phase {phase} — not yet connected</p>
        <p className="mt-1 max-w-md text-sm text-muted-foreground">{description}</p>
        <p className="mt-3 text-xs text-muted-foreground">
          This placeholder is deliberately honest: no simulated data lives here.
        </p>
      </div>
    </div>
  );
}
