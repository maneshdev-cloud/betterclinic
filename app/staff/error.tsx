"use client";

import { AreaErrorCard } from "@/components/shared/area-error-card";

/** Error boundary for the Staff area — retry or return to the dashboard. */
export default function StaffAreaError({
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
      dashboardHref="/staff"
      dashboardLabel="Back to your dashboard"
    />
  );
}
