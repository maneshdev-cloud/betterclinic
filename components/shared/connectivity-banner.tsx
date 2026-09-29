"use client";

import { useSyncExternalStore } from "react";
import { WifiOff, Loader2 } from "lucide-react";
import {
  subscribeNetworkStatus,
  getConnectivitySnapshot,
  getServerConnectivitySnapshot,
  type ConnectivityState,
} from "@/lib/network/status";

export function ConnectivityBanner() {
  const state: ConnectivityState = useSyncExternalStore(
    subscribeNetworkStatus,
    getConnectivitySnapshot,
    getServerConnectivitySnapshot
  );

  if (state === "idle") {
    return null;
  }

  const isOffline = state === "offline";

  return (
    <aside
      className="fixed top-0 inset-x-0 z-[100] flex justify-center pointer-events-none px-4"
      role="status"
      aria-live="polite"
      id="connectivity-banner"
    >
      <div
        className={`pointer-events-auto flex items-center gap-2 rounded-b-md px-3.5 py-1.5 text-xs font-medium text-white shadow-md transition-all duration-200 animate-in slide-in-from-top-full ${
          isOffline
            ? "bg-rose-600 dark:bg-rose-700 border-b border-x border-rose-700"
            : "bg-amber-600 dark:bg-amber-700 border-b border-x border-amber-700"
        }`}
      >
        {isOffline ? (
          <>
            <WifiOff className="h-3.5 w-3.5 shrink-0 animate-pulse" aria-hidden />
            <span>You&apos;re offline — reconnecting...</span>
          </>
        ) : (
          <>
            <Loader2 className="h-3.5 w-3.5 shrink-0 animate-spin" aria-hidden />
            <span>Connection trouble — retrying...</span>
          </>
        )}
      </div>
    </aside>
  );
}
