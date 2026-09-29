"use client";

import { AreaErrorCard } from "@/components/shared/area-error-card";

/** Error boundary for the Doctor area — retry or return to the dashboard. */
export default function DoctorAreaError({
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
      dashboardHref="/doctor"
      dashboardLabel="Back to your dashboard"
    />
  );
}
