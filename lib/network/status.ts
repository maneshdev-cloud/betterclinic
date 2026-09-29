/**
 * Client-side network status store.
 * Tracks browser online/offline status and active in-flight network retries.
 * Safe for server-side execution and provides primitive, reference-stable snapshots
 * for React's useSyncExternalStore to prevent re-render loops.
 */

type Listener = () => void;

export type ConnectivityState = "idle" | "offline" | "retrying";

let activeRetries = 0;
const listeners = new Set<Listener>();

function notify() {
  listeners.forEach((listener) => {
    try {
      listener();
    } catch (err) {
      console.error("[NetworkStatus] Listener error:", err);
    }
  });
}

let isInitialized = false;

function initBrowserListeners() {
  if (isInitialized || typeof window === "undefined") return;
  isInitialized = true;

  window.addEventListener("online", () => {
    notify();
  });

  window.addEventListener("offline", () => {
    notify();
  });
}

/**
 * Primitive string snapshot for the global ConnectivityBanner:
 * returns "idle" | "offline" | "retrying".
 * Being a primitive string, Object.is comparison in useSyncExternalStore
 * is perfectly stable across renders and never creates object references.
 */
export function getConnectivitySnapshot(): ConnectivityState {
  initBrowserListeners();

  if (typeof window !== "undefined" && typeof navigator !== "undefined" && !navigator.onLine) {
    return "offline";
  }
  if (activeRetries > 0) {
    return "retrying";
  }
  return "idle";
}

/** Stable server default: always "idle" */
export function getServerConnectivitySnapshot(): ConnectivityState {
  return "idle";
}

/**
 * Primitive boolean snapshot for online status.
 */
export function getIsOnlineSnapshot(): boolean {
  initBrowserListeners();
  if (typeof window !== "undefined" && typeof navigator !== "undefined") {
    return navigator.onLine;
  }
  return true;
}

/** Stable server default: always true */
export function getServerIsOnlineSnapshot(): boolean {
  return true;
}

/**
 * Primitive boolean snapshot for active retry status.
 */
export function getIsRetryingSnapshot(): boolean {
  return activeRetries > 0;
}

/** Stable server default: always false */
export function getServerIsRetryingSnapshot(): boolean {
  return false;
}

export function subscribeNetworkStatus(listener: Listener): () => void {
  initBrowserListeners();
  listeners.add(listener);
  return () => {
    listeners.delete(listener);
  };
}

export function notifyRetryStart() {
  activeRetries++;
  notify();
  if (typeof window !== "undefined") {
    window.dispatchEvent(
      new CustomEvent("bc:network-retry", {
        detail: { active: true, count: activeRetries },
      })
    );
  }
}

export function notifyRetryEnd() {
  activeRetries = Math.max(0, activeRetries - 1);
  notify();
  if (typeof window !== "undefined") {
    window.dispatchEvent(
      new CustomEvent("bc:network-retry", {
        detail: { active: activeRetries > 0, count: activeRetries },
      })
    );
  }
}
