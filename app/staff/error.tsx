"use client";

import { useEffect } from "react";
import Link from "next/link";
import { AlertTriangle, RotateCcw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

/** Error boundary for the Staff area — retry or return to the dashboard. */
export default function StaffAreaError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Staff area error:", error);
  }, [error]);

  return (
    <div className="page-container flex min-h-[60vh] items-center justify-center py-8">
      <Card className="max-w-md text-center">
        <CardHeader>
          <span className="mx-auto mb-2 flex h-11 w-11 items-center justify-center rounded-full bg-amber-100">
            <AlertTriangle className="h-5 w-5 text-amber-700" aria-hidden />
          </span>
          <CardTitle>This page could not load</CardTitle>
          <CardDescription>
            An unexpected error occurred while loading your data. The details are in the browser
            console — nothing was lost, and retrying is always safe.
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-2">
          <Button onClick={reset}>
            <RotateCcw className="mr-1.5 h-4 w-4" aria-hidden />
            Try again
          </Button>
          <Link href="/staff" className="text-sm text-muted-foreground underline hover:text-foreground">
            Back to your dashboard
          </Link>
        </CardContent>
      </Card>
    </div>
  );
}
