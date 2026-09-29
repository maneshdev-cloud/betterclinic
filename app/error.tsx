"use client";

import { AreaErrorCard } from "@/components/shared/area-error-card";

/**
 * Root error boundary. Server pages that fail mid-render (database
 * unreachable, unexpected shape, or network failure) land here instead of a raw crash —
 * with an honest, differentiated message and a retry.
 */
export default function RootError({
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
      dashboardHref="/"
      dashboardLabel="Back to the home page"
    />
  );
}
