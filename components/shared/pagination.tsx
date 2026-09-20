import { ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface PaginationProps {
  page: number;
  totalPages: number;
  /** Base path; page is appended as ?page=N preserving nothing else (filters live in the URL already). */
  buildHref: (page: number) => string;
  className?: string;
}

/** Accessible pagination used by every paginated list. */
export function Pagination({ page, totalPages, buildHref, className }: PaginationProps) {
  if (totalPages <= 1) return null;

  const pages: (number | "…")[] = [];
  const push = (p: number | "…") => pages.push(p);
  if (totalPages <= 7) {
    for (let i = 1; i <= totalPages; i++) push(i);
  } else {
    push(1);
    if (page > 3) push("…");
    for (let i = Math.max(2, page - 1); i <= Math.min(totalPages - 1, page + 1); i++) push(i);
    if (page < totalPages - 2) push("…");
    push(totalPages);
  }

  return (
    <nav aria-label="Pagination" className={cn("flex items-center justify-center gap-1", className)}>
      {page > 1 ? (
        <Button asChild variant="outline" size="sm">
          <a href={buildHref(page - 1)} rel="prev" aria-label="Previous page">
            <ChevronLeft className="h-4 w-4" aria-hidden /> Previous
          </a>
        </Button>
      ) : (
        <Button variant="outline" size="sm" disabled aria-label="Previous page (disabled)">
          <ChevronLeft className="h-4 w-4" aria-hidden /> Previous
        </Button>
      )}
      {pages.map((p, index) =>
        p === "…" ? (
          <span key={`ellipsis-${index}`} className="px-2 text-sm text-muted-foreground" aria-hidden>
            …
          </span>
        ) : (
          <Button asChild key={p} variant={p === page ? "default" : "outline"} size="sm" aria-current={p === page ? "page" : undefined}>
            <a href={buildHref(p)}>{p}</a>
          </Button>
        )
      )}
      {page < totalPages ? (
        <Button asChild variant="outline" size="sm">
          <a href={buildHref(page + 1)} rel="next" aria-label="Next page">
            Next <ChevronRight className="h-4 w-4" aria-hidden />
          </a>
        </Button>
      ) : (
        <Button variant="outline" size="sm" disabled aria-label="Next page (disabled)">
          Next <ChevronRight className="h-4 w-4" aria-hidden />
        </Button>
      )}
    </nav>
  );
}
