import { describe, expect, it } from "vitest";
import {
  APPOINTMENT_TRANSITIONS,
  canTransition,
  roleHomePath,
  QUEUE_TRANSITIONS,
  EMERGENCY_TRANSITIONS,
  PRIORITY_ORDER,
} from "@/lib/constants";

describe("appointment state machine", () => {
  it("allows the full happy path", () => {
    expect(canTransition("BOOKED", "CONFIRMED")).toBe(true);
    expect(canTransition("CONFIRMED", "CHECKED_IN")).toBe(true);
    expect(canTransition("CHECKED_IN", "WAITING")).toBe(true);
    expect(canTransition("WAITING", "CALLED")).toBe(true);
    expect(canTransition("CALLED", "IN_CONSULTATION")).toBe(true);
    expect(canTransition("IN_CONSULTATION", "COMPLETED")).toBe(true);
  });

  it("allows booking straight to check-in (auto-confirm)", () => {
    expect(canTransition("BOOKED", "CHECKED_IN")).toBe(true);
  });

  it("blocks invalid transitions", () => {
    expect(canTransition("BOOKED", "IN_CONSULTATION")).toBe(false);
    expect(canTransition("COMPLETED", "BOOKED")).toBe(false);
    expect(canTransition("CANCELLED", "WAITING")).toBe(false);
    expect(canTransition("NO_SHOW", "CALLED")).toBe(false);
    expect(canTransition("WAITING", "CHECKED_IN")).toBe(false);
  });

  it("treats COMPLETED, CANCELLED and NO_SHOW as terminal", () => {
    for (const terminal of ["COMPLETED", "CANCELLED", "NO_SHOW"] as const) {
      expect(APPOINTMENT_TRANSITIONS[terminal]).toEqual([]);
    }
  });

  it("has no empty transition lists for non-terminal states", () => {
    for (const [from, targets] of Object.entries(APPOINTMENT_TRANSITIONS)) {
      if (["COMPLETED", "CANCELLED", "NO_SHOW"].includes(from)) continue;
      expect(targets.length, `${from} should have at least one exit`).toBeGreaterThan(0);
    }
  });
});

describe("queue state machine", () => {
  it("supports the operational flow", () => {
    expect(canTransition("WAITING", "CALLED")).toBe(true);
    expect(QUEUE_TRANSITIONS.CALLED).toContain("IN_CONSULTATION");
    expect(QUEUE_TRANSITIONS.CALLED).toContain("WAITING"); // returned when patient not present
    expect(QUEUE_TRANSITIONS.WAITING).toContain("SKIPPED");
    expect(QUEUE_TRANSITIONS.SKIPPED).toContain("WAITING"); // resumed
    expect(QUEUE_TRANSITIONS.IN_CONSULTATION).toContain("COMPLETED");
  });

  it("is terminal at COMPLETED and CANCELLED", () => {
    expect(QUEUE_TRANSITIONS.COMPLETED).toEqual([]);
    expect(QUEUE_TRANSITIONS.CANCELLED).toEqual([]);
  });
});

describe("emergency state machine", () => {
  it("progresses only in order", () => {
    expect(EMERGENCY_TRANSITIONS.CREATED).toEqual(["RECEIVED"]);
    expect(EMERGENCY_TRANSITIONS.RECEIVED).toEqual(["ACKNOWLEDGED"]);
    expect(EMERGENCY_TRANSITIONS.ACKNOWLEDGED).toEqual(["CLOSED"]);
    expect(EMERGENCY_TRANSITIONS.CLOSED).toEqual([]);
  });
});

describe("priority ordering", () => {
  it("orders urgent before high before normal", () => {
    expect(PRIORITY_ORDER.URGENT).toBeLessThan(PRIORITY_ORDER.HIGH);
    expect(PRIORITY_ORDER.HIGH).toBeLessThan(PRIORITY_ORDER.NORMAL);
  });
});

describe("role home paths", () => {
  it("maps every role to its area", () => {
    expect(roleHomePath("PATIENT")).toBe("/patient");
    expect(roleHomePath("DOCTOR")).toBe("/doctor");
    expect(roleHomePath("RECEPTIONIST")).toBe("/staff");
    expect(roleHomePath("CLINIC_ADMIN")).toBe("/admin");
  });
});
