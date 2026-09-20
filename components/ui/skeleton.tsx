import { cn } from "@/lib/utils";

function Skeleton({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "animate-pulse rounded-md bg-slate-200/90 dark:bg-slate-700/80 border border-slate-300/40 dark:border-slate-600/30",
        className
      )}
      {...props}
    />
  );
}

export { Skeleton };
