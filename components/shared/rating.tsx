import { Star } from "lucide-react";
import { cn } from "@/lib/utils";

interface RatingProps {
  value: number;
  count?: number;
  size?: "sm" | "md";
  className?: string;
}

/** Star rating — always shows the numeric value as text (not colour-only). */
export function Rating({ value, count, size = "sm", className }: RatingProps) {
  const stars = Math.round(value);
  const starClass = size === "md" ? "h-4 w-4" : "h-3.5 w-3.5";

  return (
    <span className={cn("inline-flex items-center gap-1.5", className)}>
      <span className="inline-flex" role="img" aria-label={`Rated ${value.toFixed(1)} out of 5`}>
        {[1, 2, 3, 4, 5].map((i) => (
          <Star
            key={i}
            className={cn(starClass, i <= stars ? "fill-amber-400 text-amber-400" : "text-muted-foreground/40")}
            aria-hidden
          />
        ))}
      </span>
      <span className="text-sm font-medium">{value > 0 ? value.toFixed(1) : "New"}</span>
      {count !== undefined && count > 0 ? (
        <span className="text-xs text-muted-foreground">({count})</span>
      ) : null}
    </span>
  );
}
