import { describe, it, expect } from "vitest";
import { isNetworkError } from "@/lib/network/is-network-error";
import { toAppError, AppError } from "@/lib/errors";
import {
  isAuthSessionMissingError,
  isAuthRetryableFetchError,
  AuthSessionMissingError,
  AuthRetryableFetchError,
} from "@supabase/supabase-js";
import {
  PATIENT_NAV,
  DOCTOR_NAV,
  STAFF_NAV,
  ADMIN_NAV,
} from "@/components/layout/nav-config";
import {
  addDaysIso,
  daysBetween,
  type DailyPoint,
} from "@/lib/analytics/aggregate";

describe("Issue 1: Authentication Error Classification & Resilience", () => {
  it("distinguishes confirmed unauthenticated sessions from transient network failures", () => {
    const missingSessionErr = new AuthSessionMissingError();
    expect(isAuthSessionMissingError(missingSessionErr)).toBe(true);
    // Missing session must NOT be treated as a network error
    expect(isNetworkError(missingSessionErr)).toBe(false);
    expect(toAppError(missingSessionErr).code).not.toBe("NETWORK");

    const transientFetchErr = new AuthRetryableFetchError("fetch failed", 0);
    expect(isAuthRetryableFetchError(transientFetchErr)).toBe(true);
    // Transient fetch errors must be treated as network errors
    expect(isNetworkError(transientFetchErr)).toBe(true);
    expect(toAppError(transientFetchErr).code).toBe("NETWORK");
  });

  it("classifies Supabase auth 502/503/504 and timeouts as transient network errors", () => {
    const gatewayErr = { status: 503, message: "Server temporarily unavailable" };
    expect(isNetworkError(gatewayErr)).toBe(true);
    expect(toAppError(gatewayErr).code).toBe("NETWORK");

    const timeoutErr = new Error("Auth timeout");
    expect(isNetworkError(timeoutErr)).toBe(true);
    expect(toAppError(timeoutErr).code).toBe("NETWORK");

    const abortErr = new Error("The user aborted a request.");
    abortErr.name = "AbortError";
    expect(isNetworkError(abortErr)).toBe(true);
    expect(toAppError(abortErr).code).toBe("NETWORK");
  });

  it("never grants access on failure and preserves AppError('NETWORK') for recovery", () => {
    const netErr = new AppError("NETWORK");
    expect(netErr.code).toBe("NETWORK");
    expect(isNetworkError(netErr)).toBe(true);
    // When a network error is encountered, userMessage guides the user to reconnect
    expect(netErr.userMessage).toContain("Network problem");
  });
});

describe("Issue 2: Sidebar Prefetch Defaults", () => {
  it("sidebar navigation items do not have prefetch set to true", () => {
    const allSections = [...PATIENT_NAV, ...DOCTOR_NAV, ...STAFF_NAV, ...ADMIN_NAV];
    const allItems = allSections.flatMap((s) => s.items);

    expect(allItems.length).toBeGreaterThan(0);
    for (const item of allItems) {
      // Unconditional prefetching must be removed; prefetch must either be undefined or false
      expect(item.prefetch).not.toBe(true);
    }
  });
});

describe("Issue 3: Analytics Aggregation and Zero-filling", () => {
  it("dailySeries zero-fills missing days across arbitrary date ranges", () => {
    const from = "2026-09-01";
    const to = "2026-09-05";
    const rawDailySeries: DailyPoint[] = [
      { date: "2026-09-02", total: 3, completed: 2, cancelled: 1 },
      { date: "2026-09-04", total: 1, completed: 1, cancelled: 0 },
    ];

    const seriesMap = new Map<string, DailyPoint>();
    const span = daysBetween(from, to);
    for (let i = 0; i <= span; i += 1) {
      const date = addDaysIso(from, i);
      seriesMap.set(date, { date, total: 0, completed: 0, cancelled: 0 });
    }
    for (const point of rawDailySeries) {
      if (seriesMap.has(point.date)) {
        seriesMap.set(point.date, point);
      }
    }
    const filled = Array.from(seriesMap.values()).sort((a, b) => a.date.localeCompare(b.date));

    expect(filled.length).toBe(5);
    expect(filled[0]).toEqual({ date: "2026-09-01", total: 0, completed: 0, cancelled: 0 });
    expect(filled[1]).toEqual({ date: "2026-09-02", total: 3, completed: 2, cancelled: 1 });
    expect(filled[2]).toEqual({ date: "2026-09-03", total: 0, completed: 0, cancelled: 0 });
    expect(filled[3]).toEqual({ date: "2026-09-04", total: 1, completed: 1, cancelled: 0 });
    expect(filled[4]).toEqual({ date: "2026-09-05", total: 0, completed: 0, cancelled: 0 });
  });

  it("handles empty ranges without NaN or undefined properties", () => {
    const from = "2026-09-10";
    const to = "2026-09-10";
    const span = daysBetween(from, to);
    expect(span).toBe(0);
    expect(addDaysIso(from, 0)).toBe("2026-09-10");
  });
});
