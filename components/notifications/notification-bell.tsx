"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { Bell, CheckCheck } from "lucide-react";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { createClient } from "@/lib/supabase/client";

interface NotificationRow {
  id: string;
  title: string;
  body: string;
  is_read: boolean;
  created_at: string;
}

/**
 * Header bell with live unread count (Supabase Realtime on the user's
 * notification rows — RLS scopes what the browser can see).
 */
export function NotificationBell({ userId, viewAllHref }: { userId: string; viewAllHref: string }) {
  const [unread, setUnread] = useState(0);
  const [recent, setRecent] = useState<NotificationRow[]>([]);
  const [open, setOpen] = useState(false);
  const [markingAll, setMarkingAll] = useState(false);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [soundEnabled, setSoundEnabled] = useState(false);

  const playNotificationChime = useCallback(() => {
    try {
      const AudioCtx = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
      if (!AudioCtx) return;
      const ctx = new AudioCtx();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = "sine";
      osc.frequency.setValueAtTime(587.33, ctx.currentTime); // D5
      osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.12); // A5
      gain.gain.setValueAtTime(0.12, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.35);
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(ctx.currentTime + 0.35);
    } catch {
      // AudioContext autoplay restrictions or unsupported
    }
  }, []);

  const load = useCallback(async () => {
    try {
      const supabase = createClient();
      const [unreadResult, recentResult] = await Promise.all([
        supabase
          .from("notifications")
          .select("id", { count: "exact", head: true })
          .eq("user_id", userId)
          .eq("is_read", false),
        supabase
          .from("notifications")
          .select("id, title, body, is_read, created_at")
          .eq("user_id", userId)
          .order("created_at", { ascending: false })
          .limit(8),
      ]);
      if (unreadResult.error || recentResult.error) {
        setStatus("error");
      } else {
        const rawRecent = (recentResult.data ?? []) as NotificationRow[];
        const uniqueRecent = Array.from(new Map(rawRecent.map((item) => [item.id, item])).values());
        setUnread(unreadResult.count ?? 0);
        setRecent(uniqueRecent);
        setStatus("ready");
      }
    } catch {
      setStatus("error");
    }
  }, [userId]);

  // Update browser tab title with unread badge so users never miss critical updates
  useEffect(() => {
    if (typeof document === "undefined") return;
    const baseTitle = document.title.replace(/^\(\d+\+?\)\s*/, "");
    if (unread > 0) {
      document.title = `(${unread > 9 ? "9+" : unread}) ${baseTitle}`;
    } else {
      document.title = baseTitle;
    }
    return () => {
      document.title = baseTitle;
    };
  }, [unread]);

  useEffect(() => {
    void load();

    let cleanup: (() => void) | null = null;
    try {
      const supabase = createClient();

      // Check if user has enabled sound in preferences
      supabase
        .from("user_preferences")
        .select("sound_enabled")
        .eq("user_id", userId)
        .maybeSingle()
        .then(
          (res: any) => {
            if (res?.data?.sound_enabled) setSoundEnabled(true);
          },
          () => {}
        );

      const channel = (supabase as any).channel(`notifications-${userId}`);
      channel.on(
        "postgres_changes",
        { event: "*", schema: "public", table: "notifications", filter: `user_id=eq.${userId}` },
        (payload: any) => {
          if (payload?.eventType === "INSERT" && soundEnabled) {
            playNotificationChime();
          }
          void load();
        }
      );
      channel.subscribe();
      cleanup = () => {
        void supabase.removeChannel(channel);
      };
    } catch {
      // Realtime unavailable — initial load still happened.
    }

    // Reconcile on tab visibility restore or online reconnect
    const handleReconcile = () => {
      if (document.visibilityState === "visible" || navigator.onLine) {
        void load();
      }
    };
    window.addEventListener("visibilitychange", handleReconcile);
    window.addEventListener("online", handleReconcile);
    window.addEventListener("focus", handleReconcile);

    return () => {
      cleanup?.();
      window.removeEventListener("visibilitychange", handleReconcile);
      window.removeEventListener("online", handleReconcile);
      window.removeEventListener("focus", handleReconcile);
    };
  }, [userId, load, soundEnabled, playNotificationChime]);

  const markSingleRead = async (id: string, isRead: boolean) => {
    if (isRead) return;
    setRecent((prev) => prev.map((n) => (n.id === id ? { ...n, is_read: true } : n)));
    setUnread((prev) => Math.max(0, prev - 1));
    try {
      const supabase = createClient();
      await supabase
        .from("notifications")
        .update({ is_read: true, read_at: new Date().toISOString() })
        .eq("id", id);
    } catch {
      // Non-critical background sync failure
    }
  };

  const markAllRead = async () => {
    if (markingAll) return;
    setMarkingAll(true);
    const prevUnread = unread;
    const prevRecent = [...recent];

    // Optimistic UI update
    setUnread(0);
    setRecent((prev) => prev.map((n) => ({ ...n, is_read: true })));

    try {
      const supabase = createClient();
      const { error } = await supabase
        .from("notifications")
        .update({ is_read: true, read_at: new Date().toISOString() })
        .eq("user_id", userId)
        .eq("is_read", false);

      if (error) {
        // Rollback on error
        setUnread(prevUnread);
        setRecent(prevRecent);
      } else {
        await load();
      }
    } catch {
      // Rollback on network failure
      setUnread(prevUnread);
      setRecent(prevRecent);
    } finally {
      setMarkingAll(false);
    }
  };

  const relative = (iso: string) => {
    const minutes = Math.round((Date.now() - new Date(iso).getTime()) / 60000);
    if (minutes < 1) return "just now";
    if (minutes < 60) return `${minutes}m ago`;
    const hours = Math.round(minutes / 60);
    if (hours < 24) return `${hours}h ago`;
    return `${Math.round(hours / 24)}d ago`;
  };

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <button
          className="relative rounded-md p-2 hover:bg-muted focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
          aria-label={unread > 0 ? `Notifications (${unread} unread)` : "Notifications"}
        >
          <Bell className="h-5 w-5" aria-hidden />
          {unread > 0 ? (
            <span
              className={cn(
                "absolute -right-0.5 -top-0.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-red-600 px-1 text-[10px] font-semibold text-white"
              )}
              aria-hidden
            >
              {unread > 9 ? "9+" : unread}
            </span>
          ) : null}
        </button>
      </PopoverTrigger>
      <PopoverContent align="end" className="w-80 p-0">
        <div className="flex items-center justify-between border-b px-3 py-2">
          <p className="text-sm font-semibold">Notifications</p>
          {unread > 0 ? (
            <Button variant="ghost" size="sm" onClick={markAllRead} disabled={markingAll}>
              <CheckCheck className="mr-1 h-3.5 w-3.5" aria-hidden />
              {markingAll ? "…" : "Mark all read"}
            </Button>
          ) : null}
        </div>
        <div className="max-h-80 overflow-y-auto">
          {status === "loading" ? (
            <p className="px-3 py-6 text-center text-sm text-muted-foreground">Loading…</p>
          ) : status === "error" ? (
            <div className="px-3 py-6 text-center">
              <p className="text-sm text-muted-foreground">Could not load notifications.</p>
              <Button variant="ghost" size="sm" onClick={load} className="mt-2 text-xs">
                Retry
              </Button>
            </div>
          ) : recent.length === 0 ? (
            <p className="px-3 py-6 text-center text-sm text-muted-foreground">
              No notifications yet — booking and queue updates land here.
            </p>
          ) : (
            recent.map((row) => (
              <div
                key={row.id}
                role="button"
                tabIndex={0}
                onClick={() => markSingleRead(row.id, row.is_read)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" || e.key === " ") {
                    e.preventDefault();
                    markSingleRead(row.id, row.is_read);
                  }
                }}
                className={cn(
                  "border-b px-3 py-2.5 last:border-b-0 cursor-pointer transition-colors hover:bg-muted/60 focus-visible:outline-none focus-visible:bg-muted/80",
                  !row.is_read && "bg-primary/5 font-medium"
                )}
                aria-label={`${row.title}. ${row.is_read ? "Read" : "Unread. Press to mark as read"}`}
              >
                <div className="flex items-start justify-between gap-2">
                  <p className={cn("text-sm", row.is_read ? "font-normal" : "font-semibold")}>{row.title}</p>
                  <span className="shrink-0 text-xs text-muted-foreground">{relative(row.created_at)}</span>
                </div>
                <p className="mt-0.5 line-clamp-2 text-xs text-muted-foreground">{row.body}</p>
              </div>
            ))
          )}
        </div>
        <div className="border-t p-2">
          <Button asChild variant="ghost" size="sm" className="w-full">
            <Link href={viewAllHref}>View all notifications</Link>
          </Button>
        </div>
      </PopoverContent>
    </Popover>
  );
}
