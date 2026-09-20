import { Skeleton } from "@/components/ui/skeleton";
import { Card, CardContent, CardHeader } from "@/components/ui/card";

export function StatCardSkeleton() {
  return (
    <Card className="p-5">
      <div className="flex items-center justify-between">
        <Skeleton className="h-4 w-24" />
        <Skeleton className="h-8 w-8 rounded-full" />
      </div>
      <Skeleton className="mt-3 h-7 w-16" />
      <Skeleton className="mt-2 h-3 w-32" />
    </Card>
  );
}

export function CardSkeleton({ lines = 3 }: { lines?: number }) {
  return (
    <Card>
      <CardHeader className="space-y-2">
        <Skeleton className="h-5 w-40" />
        <Skeleton className="h-3 w-64" />
      </CardHeader>
      <CardContent className="space-y-3">
        {Array.from({ length: lines }).map((_, i) => (
          <Skeleton key={i} className="h-4 w-full" />
        ))}
      </CardContent>
    </Card>
  );
}

export function ListItemSkeleton() {
  return (
    <div className="flex items-center justify-between p-4 border rounded-lg">
      <div className="flex items-center gap-3">
        <Skeleton className="h-10 w-10 rounded-full" />
        <div className="space-y-1.5">
          <Skeleton className="h-4 w-32" />
          <Skeleton className="h-3 w-48" />
        </div>
      </div>
      <Skeleton className="h-7 w-20 rounded-md" />
    </div>
  );
}

export function TableRowSkeleton({ cols = 5 }: { cols?: number }) {
  return (
    <tr className="border-b">
      {Array.from({ length: cols }).map((_, i) => (
        <td key={i} className="p-3">
          <Skeleton className={`h-4 ${i === 0 ? "w-28" : i === cols - 1 ? "w-16" : "w-24"}`} />
        </td>
      ))}
    </tr>
  );
}

export function TableSkeleton({ rows = 5, cols = 5 }: { rows?: number; cols?: number }) {
  return (
    <div className="rounded-lg border bg-card">
      <div className="p-4 border-b flex items-center justify-between">
        <Skeleton className="h-5 w-36" />
        <Skeleton className="h-8 w-48" />
      </div>
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="border-b bg-muted/40">
              {Array.from({ length: cols }).map((_, i) => (
                <th key={i} className="p-3 text-left">
                  <Skeleton className="h-3 w-16" />
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {Array.from({ length: rows }).map((_, i) => (
              <TableRowSkeleton key={i} cols={cols} />
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export function DoctorCardSkeleton() {
  return (
    <Card className="p-5 flex flex-col justify-between space-y-4">
      <div className="flex items-start gap-4">
        <Skeleton className="h-14 w-14 rounded-full shrink-0" />
        <div className="space-y-2 flex-1">
          <Skeleton className="h-5 w-36" />
          <Skeleton className="h-3 w-28" />
          <Skeleton className="h-3 w-44" />
        </div>
      </div>
      <div className="pt-2 border-t flex items-center justify-between">
        <Skeleton className="h-4 w-20" />
        <Skeleton className="h-8 w-24 rounded-md" />
      </div>
    </Card>
  );
}

export function QueueTicketSkeleton() {
  return (
    <Card className="p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div className="flex items-center gap-4">
        <Skeleton className="h-14 w-14 rounded-lg shrink-0" />
        <div className="space-y-2">
          <Skeleton className="h-5 w-40" />
          <Skeleton className="h-3 w-56" />
          <Skeleton className="h-3 w-32" />
        </div>
      </div>
      <div className="flex items-center gap-2">
        <Skeleton className="h-8 w-24 rounded-md" />
        <Skeleton className="h-8 w-24 rounded-md" />
      </div>
    </Card>
  );
}

export function DashboardSkeleton({ title = "Dashboard" }: { title?: string }) {
  return (
    <div className="page-container space-y-6 py-6">
      <div className="space-y-1">
        <Skeleton className="h-7 w-48" />
        <Skeleton className="h-4 w-72" />
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCardSkeleton />
        <StatCardSkeleton />
        <StatCardSkeleton />
        <StatCardSkeleton />
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader className="space-y-2">
              <Skeleton className="h-5 w-36" />
              <Skeleton className="h-3 w-56" />
            </CardHeader>
            <CardContent className="space-y-3">
              <ListItemSkeleton />
              <ListItemSkeleton />
              <ListItemSkeleton />
            </CardContent>
          </Card>
        </div>
        <div className="space-y-4">
          <Card>
            <CardHeader className="space-y-2">
              <Skeleton className="h-5 w-28" />
              <Skeleton className="h-3 w-40" />
            </CardHeader>
            <CardContent className="space-y-3">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}

export function TablePageSkeleton({ title = "Overview" }: { title?: string }) {
  return (
    <div className="page-container space-y-6 py-6">
      <div className="space-y-1">
        <Skeleton className="h-7 w-48" />
        <Skeleton className="h-4 w-72" />
      </div>
      <div className="flex flex-col sm:flex-row gap-3">
        <Skeleton className="h-9 flex-1" />
        <Skeleton className="h-9 w-32" />
        <Skeleton className="h-9 w-32" />
      </div>
      <TableSkeleton rows={6} cols={5} />
    </div>
  );
}

export function SettingsSkeleton() {
  return (
    <div className="page-container max-w-3xl space-y-6 py-8">
      <div className="space-y-1">
        <Skeleton className="h-7 w-32" />
        <Skeleton className="h-4 w-64" />
      </div>
      <div className="flex gap-2 border-b pb-2">
        <Skeleton className="h-8 w-24 rounded-md" />
        <Skeleton className="h-8 w-24 rounded-md" />
        <Skeleton className="h-8 w-28 rounded-md" />
      </div>
      <Card>
        <CardHeader className="space-y-2">
          <Skeleton className="h-5 w-28" />
          <Skeleton className="h-3 w-64" />
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Skeleton className="h-3 w-16" />
              <Skeleton className="h-9 w-full" />
            </div>
            <div className="space-y-1.5">
              <Skeleton className="h-3 w-24" />
              <Skeleton className="h-9 w-full" />
            </div>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Skeleton className="h-3 w-16" />
              <Skeleton className="h-9 w-full" />
            </div>
            <div className="space-y-1.5">
              <Skeleton className="h-3 w-20" />
              <Skeleton className="h-9 w-full" />
            </div>
          </div>
          <Skeleton className="h-9 w-28" />
        </CardContent>
      </Card>
    </div>
  );
}

export function ConsultationSkeleton() {
  return (
    <div className="page-container space-y-6 py-6">
      <div className="flex items-center justify-between">
        <div className="space-y-1">
          <Skeleton className="h-7 w-64" />
          <Skeleton className="h-4 w-40" />
        </div>
        <Skeleton className="h-9 w-32" />
      </div>
      <div className="grid gap-6 lg:grid-cols-3">
        <div className="space-y-4">
          <CardSkeleton lines={5} />
        </div>
        <div className="lg:col-span-2 space-y-4">
          <CardSkeleton lines={8} />
        </div>
      </div>
    </div>
  );
}

export function CardsGridSkeleton({ count = 6 }: { count?: number }) {
  return (
    <div className="page-container space-y-6 py-6">
      <div className="space-y-1">
        <Skeleton className="h-7 w-48" />
        <Skeleton className="h-4 w-72" />
      </div>
      <div className="flex flex-col sm:flex-row gap-3">
        <Skeleton className="h-9 flex-1" />
        <Skeleton className="h-9 w-32" />
      </div>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: count }).map((_, i) => (
          <DoctorCardSkeleton key={i} />
        ))}
      </div>
    </div>
  );
}
