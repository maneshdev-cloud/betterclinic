"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";

/**
 * Subscribes to Supabase Realtime postgres_changes for the given tables
 * and refreshes the server-rendered children whenever a row changes.
 * A visibility-aware poll acts as a fallback so the board stays honest
 * even if the realtime connection drops (RLS still scopes every row).
 *
 * `filters` format: "table[:column=eq.value]" entries joined by ";".
 */
export function LiveRefresh({
  channelKey,
  filters,
  pollMs = 45000,
  showIndicator = true,
  children,
}: {
  channelKey: string;
  filters: string;
  pollMs?: number;
  showIndicator?: boolean;
  children?: React.ReactNode;
}) {
  const router = useRouter();
  const [status, setStatus] = useState<"connecting" | "live" | "reconnecting" | "polling">("connecting");

  useEffect(() => {
    const specs = filters
      .split(";")
      .map((part) => part.trim())
      .filter(Boolean)
      .map((part) => {
        const [table, filter] = part.split(":");
        return { table: table!, filter };
      });

    let cleanupRealtime: (() => void) | null = null;
    let timer: ReturnType<typeof setInterval> | undefined;
    let refreshTimeout: ReturnType<typeof setTimeout> | null = null;
    let wasDisconnected = false;

    // Debounced refresh to coalesce rapid bursts of database changes into a single server refresh
    const debouncedRefresh = () => {
      if (refreshTimeout) clearTimeout(refreshTimeout);
      refreshTimeout = setTimeout(() => {
        router.refresh();
      }, 200);
    };

    const startPolling = () => {
      if (timer) return;
      timer = setInterval(() => {
        if (document.visibilityState === "visible") debouncedRefresh();
      }, pollMs);
    };

    // Background synchronization: reconcile when tab regains focus or comes back online
    const handleVisibilityChange = () => {
      if (document.visibilityState === "visible") {
        debouncedRefresh();
      }
    };
    const handleOnline = () => {
      debouncedRefresh();
    };
    const handleFocus = () => {
      debouncedRefresh();
    };

    document.addEventListener("visibilitychange", handleVisibilityChange);
    window.addEventListener("online", handleOnline);
    window.addEventListener("focus", handleFocus);

    try {
      const client = createClient();
      const channel = client.channel(channelKey, { config: { broadcast: { self: false } } });
      for (const spec of specs) {
        channel.on(
          "postgres_changes",
          {
            event: "*",
            schema: "public",
            table: spec.table,
            ...(spec.filter ? { filter: spec.filter } : {}),
          },
          () => debouncedRefresh()
        );
      }
      channel.subscribe((state) => {
        if (state === "SUBSCRIBED") {
          setStatus("live");
          // Reconnection catch-up: if we recovered from a disconnect, refresh state immediately
          if (wasDisconnected) {
            debouncedRefresh();
            wasDisconnected = false;
          }
        } else if (state === "TIMED_OUT" || state === "CLOSED") {
          setStatus("reconnecting");
          wasDisconnected = true;
          startPolling();
        } else if (state === "CHANNEL_ERROR") {
          setStatus("polling");
          wasDisconnected = true;
          startPolling();
        }
      });
      cleanupRealtime = () => {
        void client.removeChannel(channel);
      };
    } catch {
      // Supabase not configured / realtime unavailable — poll instead.
      setStatus("polling");
    }
    startPolling();

    return () => {
      cleanupRealtime?.();
      if (timer) clearInterval(timer);
      if (refreshTimeout) clearTimeout(refreshTimeout);
      document.removeEventListener("visibilitychange", handleVisibilityChange);
      window.removeEventListener("online", handleOnline);
      window.removeEventListener("focus", handleFocus);
    };
  }, [channelKey, filters, pollMs, router]);

  if (!showIndicator) {
    return <>{children}</>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-end gap-2" aria-live="polite">
        <span
          className={cn(
            "inline-flex items-center gap-1.5 rounded-full border px-2.5 py-0.5 text-xs font-medium",
            status === "live" && "border-emerald-300 bg-emerald-50 text-emerald-700 dark:border-emerald-800 dark:bg-emerald-950/40 dark:text-emerald-300",
            (status === "connecting" || status === "reconnecting") && "border-amber-300 bg-amber-50 text-amber-700 dark:border-amber-800 dark:bg-amber-950/40 dark:text-amber-300",
            status === "polling" && "border-slate-300 bg-slate-50 text-slate-600 dark:border-slate-700 dark:bg-slate-900/40 dark:text-slate-400"
          )}
        >
          <span
            className={cn(
              "h-1.5 w-1.5 rounded-full",
              status === "live" && "animate-pulse bg-emerald-500",
              (status === "connecting" || status === "reconnecting") && "animate-pulse bg-amber-500",
              status === "polling" && "bg-slate-400"
            )}
            aria-hidden
          />
          {status === "live"
            ? "Live (Realtime connected)"
            : status === "reconnecting"
            ? "Reconnecting…"
            : status === "connecting"
            ? "Connecting…"
            : `Polling fallback active (every ${Math.round(pollMs / 1000)}s)`}
        </span>
      </div>
      {children}
    </div>
  );
}
