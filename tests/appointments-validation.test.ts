import { describe, expect, it } from "vitest";
import {
  bookAppointmentSchema,
  cancelSchema,
  rescheduleSchema,
  doctorSearchSchema,
  clinicSearchSchema,
  availabilityPayloadSchema,
  visitReasonSchema,
} from "@/lib/validation/appointments";

const UUID = "11111111-1111-1111-1111-111111111111";

describe("visit reason", () => {
  it("accepts a normal reason", () => {
    expect(visitReasonSchema.parse("Headache for three days")).toBe("Headache for three days");
  });

  it("rejects too-short and too-long reasons", () => {
    expect(visitReasonSchema.safeParse("no").success).toBe(false);
    expect(visitReasonSchema.safeParse("x".repeat(501)).success).toBe(false);
  });

  it("trims whitespace before validating", () => {
    expect(visitReasonSchema.safeParse("   ").success).toBe(false);
  });
});

describe("bookAppointmentSchema", () => {
  it("requires a valid slot id and reason", () => {
    expect(
      bookAppointmentSchema.safeParse({ slotId: UUID, visitReason: "Fever since yesterday" }).success
    ).toBe(true);
  });

  it("rejects a malformed slot id", () => {
    expect(
      bookAppointmentSchema.safeParse({ slotId: "not-a-uuid", visitReason: "Fever" }).success
    ).toBe(false);
  });
});

describe("cancelSchema", () => {
  it("accepts with or without a reason", () => {
    expect(cancelSchema.safeParse({ appointmentId: UUID }).success).toBe(true);
    expect(cancelSchema.safeParse({ appointmentId: UUID, reason: "Feeling better" }).success).toBe(true);
    expect(cancelSchema.safeParse({ appointmentId: UUID, reason: "" }).success).toBe(true);
  });

  it("rejects a long reason", () => {
    expect(cancelSchema.safeParse({ appointmentId: UUID, reason: "x".repeat(201) }).success).toBe(false);
  });
});

describe("rescheduleSchema", () => {
  it("requires both appointment and new slot ids", () => {
    expect(rescheduleSchema.safeParse({ appointmentId: UUID, newSlotId: UUID }).success).toBe(true);
    expect(rescheduleSchema.safeParse({ appointmentId: UUID }).success).toBe(false);
  });
});

describe("doctorSearchSchema (URL params)", () => {
  it("coerces numeric params and applies defaults", () => {
    const parsed = doctorSearchSchema.parse({ q: "", maxFee: "500", minRating: "4", page: "2" });
    expect(parsed.maxFee).toBe(500);
    expect(parsed.minRating).toBe(4);
    expect(parsed.page).toBe(2);
    expect(parsed.sort).toBe("rating");
    expect(parsed.availableToday).toBe(false);
  });

  it("tolerates array-ish / unknown params via object input", () => {
    const parsed = doctorSearchSchema.parse({});
    expect(parsed.page).toBe(1);
    expect(parsed.q).toBe("");
    expect(parsed.city).toBe("");
  });

  it("rejects out-of-range values", () => {
    expect(doctorSearchSchema.safeParse({ maxFee: "-1" }).success).toBe(false);
    expect(doctorSearchSchema.safeParse({ minRating: "6" }).success).toBe(false);
    expect(doctorSearchSchema.safeParse({ page: "0" }).success).toBe(false);
    expect(doctorSearchSchema.safeParse({ sort: "bogus" }).success).toBe(false);
  });

  it("keeps an empty specialization as an empty string (falsy in services)", () => {
    const parsed = doctorSearchSchema.parse({ specialization: "" });
    expect(parsed.specialization ?? "").toBe("");
  });
});

describe("clinicSearchSchema (URL params)", () => {
  it("applies defaults and coerces page", () => {
    const parsed = clinicSearchSchema.parse({ page: "3" });
    expect(parsed.page).toBe(3);
    expect(parsed.sort).toBe("rating");
    expect(parsed.area).toBe("");
  });
});

describe("availabilityPayloadSchema", () => {
  const baseDay = (dayOfWeek: number, overrides: Record<string, unknown> = {}) => ({
    dayOfWeek,
    enabled: false,
    startTime: "09:00",
    endTime: "17:00",
    breakEnabled: false,
    breakStart: null,
    breakEnd: null,
    slotDurationMinutes: 15,
    ...overrides,
  });

  it("accepts a valid week with one enabled day and a break", () => {
    const payload = {
      clinicId: UUID,
      days: Array.from({ length: 7 }, (_, i) =>
        baseDay(i, i === 1 ? { enabled: true, breakEnabled: true, breakStart: "13:00", breakEnd: "14:00" } : {})
      ),
    };
    expect(availabilityPayloadSchema.safeParse(payload).success).toBe(true);
  });

  it("requires exactly 7 days", () => {
    const payload = { clinicId: UUID, days: [baseDay(0, { enabled: true })] };
    expect(availabilityPayloadSchema.safeParse(payload).success).toBe(false);
  });

  it("rejects end before start on an enabled day", () => {
    const days = Array.from({ length: 7 }, (_, i) => baseDay(i));
    days[2] = baseDay(2, { enabled: true, startTime: "18:00", endTime: "09:00" });
    expect(availabilityPayloadSchema.safeParse({ clinicId: UUID, days }).success).toBe(false);
  });

  it("ignores times on disabled days", () => {
    const days = Array.from({ length: 7 }, (_, i) =>
      baseDay(i, i === 3 ? { startTime: "20:00", endTime: "05:00" } : {})
    );
    expect(availabilityPayloadSchema.safeParse({ clinicId: UUID, days }).success).toBe(true);
  });

  it("rejects a break outside the working window", () => {
    const days = Array.from({ length: 7 }, (_, i) => baseDay(i));
    days[1] = baseDay(1, { enabled: true, breakEnabled: true, breakStart: "08:00", breakEnd: "09:30" });
    expect(availabilityPayloadSchema.safeParse({ clinicId: UUID, days }).success).toBe(false);
  });

  it("rejects an invalid slot duration", () => {
    const days = Array.from({ length: 7 }, (_, i) => baseDay(i));
    days[4] = baseDay(4, { enabled: true, slotDurationMinutes: 3 });
    expect(availabilityPayloadSchema.safeParse({ clinicId: UUID, days }).success).toBe(false);
  });
});
