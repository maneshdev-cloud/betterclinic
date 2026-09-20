import { cn } from "@/lib/utils";

export interface StackedBarPoint {
  label: string;
  /** Segments bottom-to-top, each with a value and tailwind background class. */
  segments: { value: number; className: string }[];
  title: string;
}

/**
 * Dependency-free stacked bar chart (pure CSS) for the analytics page.
 * Bars are proportional to the largest day; each bar carries a native
 * title tooltip with the exact numbers — no invented smoothing.
 */
export function StackedBarChart({
  points,
  emptyLabel = "No data in this period",
  className,
}: {
  points: StackedBarPoint[];
  emptyLabel?: string;
  className?: string;
}) {
  const totals = points.map((point) => point.segments.reduce((sum, s) => sum + s.value, 0));
  const max = Math.max(0, ...totals);
  const allZero = totals.every((total) => total === 0);

  if (allZero) {
    return (
      <div className={cn("rounded-lg border border-dashed bg-muted/30 px-6 py-10 text-center", className)}>
        <p className="text-sm text-muted-foreground">{emptyLabel}</p>
      </div>
    );
  }

  // Label roughly every ~6-10 bars depending on width.
  const labelEvery = points.length > 60 ? 15 : points.length > 20 ? 7 : points.length > 10 ? 3 : 1;

  return (
    <div className={cn("w-full", className)}>
      <div className="flex h-40 items-end gap-[2px]" role="img" aria-label="Daily appointment volume chart">
        {points.map((point, index) => {
          const total = point.segments.reduce((sum, s) => sum + s.value, 0);
          return (
            <div
              key={point.label}
              className="relative flex h-full flex-1 flex-col justify-end"
              title={point.title}
            >
              <div
                className="flex w-full flex-col justify-end overflow-hidden rounded-t-[3px]"
                style={{ height: `${max > 0 ? Math.max(total > 0 ? 4 : 0, (total / max) * 100) : 0}%` }}
              >
                {point.segments.map((segment, segIndex) =>
                  segment.value > 0 ? (
                    <div
                      key={segIndex}
                      className={cn("w-full", segment.className)}
                      style={{ height: `${(segment.value / Math.max(total, 1)) * 100}%` }}
                    />
                  ) : null
                )}
              </div>
              {index % labelEvery === 0 ? (
                <span className="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-muted-foreground">
                  {point.label}
                </span>
              ) : null}
            </div>
          );
        })}
      </div>
      <div className="mt-7 border-t pt-2" />
    </div>
  );
}
