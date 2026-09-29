"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { AlertTriangle, WifiOff, RotateCcw, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { isNetworkError } from "@/lib/network/is-network-error";

export interface AreaErrorCardProps {
  error: Error & { digest?: string };
  reset: () => void;
  dashboardHref?: string;
  dashboardLabel?: string;
}

export function AreaErrorCard({
  error,
  reset,
  dashboardHref = "/",
  dashboardLabel = "Back to the home page",
}: AreaErrorCardProps) {
  const [isResetting, setIsResetting] = useState(false);
  const isNetwork = isNetworkError(error);

  useEffect(() => {
    console.error("[AreaError]", error);
  }, [error]);

  // When connectivity is restored, automatically trigger reset without manual refresh
  useEffect(() => {
    if (typeof window === "undefined") return;

    const handleOnline = () => {
      console.log("[AreaErrorCard] Connectivity restored — auto-retrying...");
      setIsResetting(true);
      reset();
    };

    window.addEventListener("online", handleOnline);
    return () => {
      window.removeEventListener("online", handleOnline);
    };
  }, [reset]);

  const handleReset = () => {
    setIsResetting(true);
    reset();
  };

  return (
    <div className="page-container flex min-h-[60vh] items-center justify-center py-8">
      <Card className="max-w-md text-center" id="error-boundary-card">
        <CardHeader>
          <span
            className={`mx-auto mb-2 flex h-11 w-11 items-center justify-center rounded-full ${
              isNetwork
                ? "bg-amber-100 text-amber-700 dark:bg-amber-950/60 dark:text-amber-400"
                : "bg-amber-100 text-amber-700 dark:bg-amber-950/60 dark:text-amber-400"
            }`}
          >
            {isNetwork ? (
              <WifiOff className="h-5 w-5" aria-hidden />
            ) : (
              <AlertTriangle className="h-5 w-5" aria-hidden />
            )}
          </span>
          <CardTitle id="error-card-title">
            {isNetwork ? "We couldn't reach the server" : "This page could not load"}
          </CardTitle>
          <CardDescription id="error-card-description">
            {isNetwork
              ? "Check your connection and try again. If you're offline, we'll automatically reconnect once you're back."
              : "An unexpected error occurred while loading your data. The details are in the browser console — nothing was lost, and retrying is always safe."}
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-2">
          <Button onClick={handleReset} disabled={isResetting} id="error-retry-button">
            {isResetting ? (
              <Loader2 className="mr-1.5 h-4 w-4 animate-spin" aria-hidden />
            ) : (
              <RotateCcw className="mr-1.5 h-4 w-4" aria-hidden />
            )}
            {isResetting ? "Retrying..." : "Try again"}
          </Button>
          <Link
            href={dashboardHref}
            className="text-sm text-muted-foreground underline hover:text-foreground"
          >
            {dashboardLabel}
          </Link>
        </CardContent>
      </Card>
    </div>
  );
}
