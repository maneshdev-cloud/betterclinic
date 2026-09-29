import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { withRetry, retryFetch } from "@/lib/network/with-retry";
import {
  getConnectivitySnapshot,
  getIsOnlineSnapshot,
  getIsRetryingSnapshot,
  subscribeNetworkStatus,
} from "@/lib/network/status";

describe("Network Retry Utility (withRetry)", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("resolves immediately on first attempt without delay if call succeeds", async () => {
    const fn = vi.fn().mockResolvedValue("success");
    const resultPromise = withRetry(fn);

    await expect(resultPromise).resolves.toBe("success");
    expect(fn).toHaveBeenCalledTimes(1);
  });

  it("retries on network error with backoff (300ms, then 800ms) and resolves upon recovery", async () => {
    const fn = vi
      .fn()
      .mockRejectedValueOnce(new TypeError("Failed to fetch"))
      .mockRejectedValueOnce(new TypeError("Failed to fetch"))
      .mockResolvedValueOnce("recovered");

    const onRetry = vi.fn();
    const resultPromise = withRetry(fn, { onRetry });

    // Initial attempt failed, scheduled retry 1 (300ms)
    await vi.advanceTimersByTimeAsync(300);
    expect(fn).toHaveBeenCalledTimes(2);

    // Second attempt failed, scheduled retry 2 (800ms)
    await vi.advanceTimersByTimeAsync(800);
    expect(fn).toHaveBeenCalledTimes(3);

    const result = await resultPromise;
    expect(result).toBe("recovered");
    expect(onRetry).toHaveBeenCalledTimes(2);
    expect(onRetry).toHaveBeenNthCalledWith(1, 1, expect.any(TypeError), 300);
    expect(onRetry).toHaveBeenNthCalledWith(2, 2, expect.any(TypeError), 800);
  });

  it("fails immediately without retrying for non-network errors (e.g. validation/auth)", async () => {
    const fn = vi.fn().mockRejectedValue(new Error("Invalid credentials"));
    const onRetry = vi.fn();

    const resultPromise = withRetry(fn, { onRetry });

    await expect(resultPromise).rejects.toThrow("Invalid credentials");
    expect(fn).toHaveBeenCalledTimes(1);
    expect(onRetry).not.toHaveBeenCalled();
  });

  it("throws after exhausting max retries", async () => {
    const networkErr = new TypeError("Failed to fetch");
    const fn = vi.fn().mockRejectedValue(networkErr);
    const onRetry = vi.fn();

    const resultPromise = withRetry(fn, { retries: 2, backoffs: [100, 200], onRetry });

    // Attach rejection handler to prevent unhandled rejection during timer advance
    let caughtError: unknown;
    resultPromise.catch((err) => {
      caughtError = err;
    });

    await vi.advanceTimersByTimeAsync(100);
    await vi.advanceTimersByTimeAsync(200);

    await expect(resultPromise).rejects.toThrow("Failed to fetch");
    expect(fn).toHaveBeenCalledTimes(3); // 1 initial + 2 retries
    expect(onRetry).toHaveBeenCalledTimes(2);
    expect(caughtError).toBe(networkErr);
  });

  it("notifies status listeners and updates retrying snapshot during retry lifecycle", async () => {
    const fn = vi
      .fn()
      .mockRejectedValueOnce(new TypeError("Failed to fetch"))
      .mockResolvedValueOnce("done");

    const statusHistory: string[] = [];
    const unsubscribe = subscribeNetworkStatus(() => {
      statusHistory.push(getConnectivitySnapshot());
    });

    const resultPromise = withRetry(fn, { backoffs: [300] });

    // Advance to trigger retry
    await vi.advanceTimersByTimeAsync(300);
    await resultPromise;

    unsubscribe();

    expect(statusHistory).toContain("retrying");
    expect(getIsRetryingSnapshot()).toBe(false);
    expect(getConnectivitySnapshot()).toBe("idle");
  });
});

describe("retryFetch", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
    vi.restoreAllMocks();
  });

  it("retries when response returns 503 Service Unavailable", async () => {
    const originalFetch = global.fetch;
    const mockFetch = vi
      .fn()
      .mockResolvedValueOnce(new Response("Service Unavailable", { status: 503 }))
      .mockResolvedValueOnce(new Response(JSON.stringify({ ok: true }), { status: 200 }));

    global.fetch = mockFetch;

    try {
      const fetchPromise = retryFetch("https://api.betterclinic.test/health");
      await vi.advanceTimersByTimeAsync(300);

      const response = await fetchPromise;
      expect(response.status).toBe(200);
      expect(mockFetch).toHaveBeenCalledTimes(2);
    } finally {
      global.fetch = originalFetch;
    }
  });
});
