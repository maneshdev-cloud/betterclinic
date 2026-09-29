import { describe, expect, it } from "vitest";
import {
  formatINR,
  formatTimeString,
  formatDuration,
  initials,
  avatarTone,
  ageFrom,
  pageRange,
  totalPages,
  formatDate,
  formatDateWithDay,
  todayClinicDate,
  toDate,
} from "@/lib/utils";

describe("formatINR", () => {
  it("formats rupees without decimals", () => {
    expect(formatINR(500)).toContain("500");
  });
  it("uses Indian digit grouping", () => {
    expect(formatINR(125000)).toContain("1,25,000");
  });
  it("handles null", () => {
    expect(formatINR(null)).toBe("—");
  });
});

describe("formatTimeString", () => {
  it("formats 24h time as 12h with AM/PM", () => {
    expect(formatTimeString("09:00")).toBe("9:00 AM");
    expect(formatTimeString("14:30")).toBe("2:30 PM");
    expect(formatTimeString("00:15")).toBe("12:15 AM");
    expect(formatTimeString("02:00")).toBe("2:00 AM");
  });
  it("handles empty values", () => {
    expect(formatTimeString(null)).toBe("—");
  });
});

describe("formatDuration", () => {
  it("formats minutes under an hour", () => {
    expect(formatDuration(25)).toBe("25 min");
  });
  it("formats hours and minutes", () => {
    expect(formatDuration(80)).toBe("1 hr 20 min");
  });
  it("formats exact hours", () => {
    expect(formatDuration(120)).toBe("2 hr");
  });
});

describe("initials", () => {
  it("takes the first two name parts", () => {
    expect(initials("Aarav Deshmukh")).toBe("AD");
    expect(initials("Priya Sharad Kulkarni")).toBe("PS");
  });
  it("handles null", () => {
    expect(initials(null)).toBe("?");
  });
});

describe("avatarTone", () => {
  it("is deterministic for the same seed", () => {
    expect(avatarTone("Aarav")).toBe(avatarTone("Aarav"));
  });
});

describe("pagination helpers", () => {
  it("computes range for page 1", () => {
    expect(pageRange(1, 20)).toEqual({ from: 0, to: 19 });
  });
  it("computes range for later pages", () => {
    expect(pageRange(3, 20)).toEqual({ from: 40, to: 59 });
  });
  it("clamps invalid pages to 1", () => {
    expect(pageRange(0, 20)).toEqual({ from: 0, to: 19 });
    expect(pageRange(-5, 20)).toEqual({ from: 0, to: 19 });
  });
  it("computes total pages with rounding up", () => {
    expect(totalPages(0, 20)).toBe(1);
    expect(totalPages(21, 20)).toBe(2);
    expect(totalPages(40, 20)).toBe(2);
  });
});

describe("ageFrom", () => {
  it("returns null without a date of birth", () => {
    expect(ageFrom(null)).toBeNull();
  });

  it("computes whole years correctly around birthday boundaries", () => {
    const thisYear = new Date().getUTCFullYear();
    // A birthday far in the past this year → already had it
    const january = ageFrom(`${thisYear - 30}-01-01`);
    // A birthday still in the future this year (Dec 31 always qualifies)
    const december = ageFrom(`${thisYear - 30}-12-31`);
    expect(Number(january)).toBe(30);
    expect(Number(december)).toBe(29);
  });

  it("rejects impossible ages defensively", () => {
    expect(ageFrom(`${new Date().getUTCFullYear() + 5}-01-01`)).toBeNull(); // future birth
  });
});

describe("date and timezone stability", () => {
  it("formats date strings without timezone day-shift", () => {
    expect(formatDate("2026-09-28")).toBe("28 Sep 2026");
    expect(formatDate("2026-01-01")).toBe("1 Jan 2026");
    expect(formatDate(null)).toBe("—");
  });

  it("formats dates with day of week without shifting", () => {
    // 2026-09-28 is a Monday
    expect(formatDateWithDay("2026-09-28")).toBe("Mon, 28 Sep 2026");
  });

  it("produces valid YYYY-MM-DD for todayClinicDate", () => {
    const today = todayClinicDate();
    expect(today).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  it("anchors plain date toDate at noon UTC", () => {
    const parsed = toDate("2026-09-28");
    expect(parsed.toISOString()).toContain("2026-09-28T12:00:00");
  });
});

