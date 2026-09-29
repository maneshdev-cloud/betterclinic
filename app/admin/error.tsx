"use client";

import { AreaErrorCard } from "@/components/shared/area-error-card";

/** Error boundary for the Admin area — retry or return to the dashboard. */
export default function AdminAreaError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <AreaErrorCard
      error={error}
      reset={reset}
      dashboardHref="/admin"
      dashboardLabel="Back to your dashboard"
    />
  );
}
