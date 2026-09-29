"use client";

import { AreaErrorCard } from "@/components/shared/area-error-card";

/** Error boundary for the Patient area — retry or return to the dashboard. */
export default function PatientAreaError({
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
      dashboardHref="/patient"
      dashboardLabel="Back to your dashboard"
    />
  );
}
