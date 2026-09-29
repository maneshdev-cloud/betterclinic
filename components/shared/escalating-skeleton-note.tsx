"use client";

import { useEffect, useState, useSyncExternalStore } from "react";
import { Loader2, WifiOff, RefreshCw } from "lucide-react";
import {
  subscribeNetworkStatus,
  getIsOnlineSnapshot,
  getServerIsOnlineSnapshot,
  getIsRetryingSnapshot,
  getServerIsRetryingSnapshot,
} from "@/lib/network/status";

export function useEscalatingLoadingState(thresholdMs = 3500) {
  const [thresholdReached, setThresholdReached] = useState(false);

  const isOnline = useSyncExternalStore(
    subscribeNetworkStatus,
    getIsOnlineSnapshot,
    getServerIsOnlineSnapshot
  );

  const isRetrying = useSyncExternalStore(
    subscribeNetworkStatus,
    getIsRetryingSnapshot,
    getServerIsRetryingSnapshot
  );

  useEffect(() => {
    const timer = setTimeout(() => {
      setThresholdReached(true);
    }, thresholdMs);
    return () => clearTimeout(timer);
  }, [thresholdMs]);

  const isOffline = !isOnline;
  const isDelayed = thresholdReached;

  const escalated = isOffline || isRetrying || isDelayed;

  let message = "";
  let iconType: "offline" | "retrying" | "delayed" = "delayed";

  if (isOffline) {
    message = "You appear to be offline — reconnecting...";
    iconType = "offline";
  } else if (isRetrying) {
    message = "Connection trouble — retrying request...";
    iconType = "retrying";
  } else if (isDelayed) {
    message = "Still loading — checking your connection...";
    iconType = "delayed";
  }

  return {
    escalated,
    message,
    iconType,
    isOffline,
    isRetrying,
    isDelayed,
  };
}

export function EscalatingSkeletonNote({ className = "" }: { className?: string }) {
  const { escalated, message, iconType } = useEscalatingLoadingState(3500);

  if (!escalated) return null;

  return (
    <div
      role="status"
      aria-live="polite"
      className={`flex items-center gap-2 rounded-md border border-amber-300/60 bg-amber-50/90 px-3 py-1.5 text-xs font-medium text-amber-800 shadow-xs dark:border-amber-700/50 dark:bg-amber-950/40 dark:text-amber-300 animate-in fade-in slide-in-from-top-1 duration-300 ${className}`}
    >
      {iconType === "offline" ? (
        <WifiOff className="h-3.5 w-3.5 shrink-0 animate-pulse text-amber-700 dark:text-amber-400" aria-hidden />
      ) : iconType === "retrying" ? (
        <RefreshCw className="h-3.5 w-3.5 shrink-0 animate-spin text-amber-700 dark:text-amber-400" aria-hidden />
      ) : (
        <Loader2 className="h-3.5 w-3.5 shrink-0 animate-spin text-amber-700 dark:text-amber-400" aria-hidden />
      )}
      <span>{message}</span>
    </div>
  );
}
