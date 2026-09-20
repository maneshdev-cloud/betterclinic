import { describe, expect, it } from "vitest";
import {
  aggregateKpis,
  countNewPatients,
  dailySeries,
  median,
  parseAnalyticsRange,
  perDoctor,
  statusBreakdown,
  type AnalyticsRange,
  type AppointmentFact,
  type QueueFact,
} from "@/lib/analytics/aggregate";

function appt(overrides: Partial<AppointmentFact>): AppointmentFact {
  return {
    appointment_date: "2026-09-10",
    status: "COMPLETED",
    appointment_type: "SCHEDULED",
    doctor_id: "doc-1",
    patient_id: "pat-1",
    ...overrides,
  };
}

function queue(overrides: Partial<QueueFact>): QueueFact {
  return {
    doctor_id: "doc-1",
    created_at: "2026-09-10T04:00:00Z",
    called_at: "2026-09-10T04:20:00Z",
    started_at: "2026-09-10T04:21:00Z",
    completed_at: "2026-09-10T04:36:00Z",
    ...overrides,
  };
}

describe("parseAnalyticsRange", () => {
  it("defaults to the last 30 days", () => {
    const range = parseAnalyticsRange({});
    expect(range.preset).toBe("30");
    // from/to are dates, from ≤ to, span exactly 30 days
    expect(range.to >= range.from).toBe(true);
    expect((new Date(`${range.to}T12:00:00Z`).getTime() - new Date(`${range.from}T12:00:00Z`).getTime()) / 86400000).toBe(29);
  });

  it("supports the 7 and 90 day presets", () => {
    expect(parseAnalyticsRange({ range: "7" }).preset).toBe("7");
    expect(parseAnalyticsRange({ range: "90" }).preset).toBe("90");
    const week = parseAnalyticsRange({ range: "7" });
    expect((new Date(`${week.to}T12:00:00Z`).getTime() - new Date(`${week.from}T12:00:00Z`).getTime()) / 86400000).toBe(6);
  });

  it("accepts a valid custom range", () => {
    const range = parseAnalyticsRange({ from: "2026-09-01", to: "2026-09-15" });
    expect(range).toEqual<AnalyticsRange>({ preset: "custom", from: "2026-09-01", to: "2026-09-15" });
  });

  it("falls back to 30 days on invalid input instead of crashing", () => {
    for (const params of [
      { from: "2026-09-10", to: "2026-09-01" }, // to before from
      { from: "not-a-date", to: "2026-09-10" },
      { from: "2020-01-01", to: "2026-09-10" }, // span > 366 days
      { range: "bogus" },
    ]) {
      expect(parseAnalyticsRange(params).preset).toBe("30");
    }
  });
});

describe("aggregateKpis", () => {
  it("counts statuses, walk-ins and unique patients from real facts", () => {
    const facts: AppointmentFact[] = [
      appt({ status: "COMPLETED" }),
      appt({ status: "COMPLETED", patient_id: "pat-2" }),
      appt({ status: "CANCELLED", patient_id: "pat-2" }),
      appt({ status: "NO_SHOW", patient_id: "pat-3" }),
      appt({ status: "BOOKED", appointment_type: "WALK_IN", patient_id: "pat-3" }),
    ];
    const kpis = aggregateKpis(facts, []);
    expect(kpis.total).toBe(5);
    expect(kpis.completed).toBe(2);
    expect(kpis.cancelled).toBe(1);
    expect(kpis.noShow).toBe(1);
    expect(kpis.walkIns).toBe(1);
    expect(kpis.uniquePatients).toBe(3);
    expect(kpis.completionRate).toBe(50); // 2 of 4 finalized
    expect(kpis.noShowRate).toBe(25);
  });

  it("reports null rates when nothing is finalized (honest empty state)", () => {
    const kpis = aggregateKpis([appt({ status: "BOOKED" }), appt({ status: "CONFIRMED" })], []);
    expect(kpis.completionRate).toBeNull();
    expect(kpis.noShowRate).toBeNull();
    expect(kpis.medianWaitMinutes).toBeNull();
    expect(kpis.avgConsultMinutes).toBeNull();
  });

  it("computes median wait from queue timestamps", () => {
    const entries = [
      queue({ created_at: "2026-09-10T04:00:00Z", called_at: "2026-09-10T04:10:00Z" }), // 10 min
      queue({ created_at: "2026-09-10T05:00:00Z", called_at: "2026-09-10T05:31:00Z" }), // 31 min
      queue({ created_at: "2026-09-10T06:00:00Z", called_at: "2026-09-10T06:20:00Z" }), // 20 min
    ];
    const kpis = aggregateKpis([], entries);
    expect(kpis.medianWaitMinutes).toBe(20);
    expect(kpis.waitSamples).toBe(3);
  });

  it("ignores impossible negative waits and unstamped entries", () => {
    const entries = [
      queue({ created_at: "2026-09-10T04:20:00Z", called_at: "2026-09-10T04:00:00Z", started_at: null, completed_at: null }), // called before created
      queue({ called_at: null, started_at: null, completed_at: null }),
    ];
    const kpis = aggregateKpis([], entries);
    expect(kpis.waitSamples).toBe(0);
    expect(kpis.medianWaitMinutes).toBeNull();
    expect(kpis.consultSamples).toBe(0);
  });

  it("averages consultation length from start→complete timestamps", () => {
    const entries = [
      queue({ started_at: "2026-09-10T04:00:00Z", completed_at: "2026-09-10T04:15:00Z" }), // 15
      queue({ started_at: "2026-09-10T05:00:00Z", completed_at: "2026-09-10T05:26:00Z" }), // 26
    ];
    expect(aggregateKpis([], entries).avgConsultMinutes).toBe(21); // mean of 15 and 26 → 20.5 → 21
  });

  it("handles zero rows without inventing anything", () => {
    const kpis = aggregateKpis([], []);
    expect(kpis.total).toBe(0);
    expect(kpis.completionRate).toBeNull();
  });
});

describe("dailySeries", () => {
  it("fills every day in the range with explicit zeros", () => {
    const range: AnalyticsRange = { preset: "custom", from: "2026-09-01", to: "2026-09-05" };
    const series = dailySeries(
      [
        appt({ appointment_date: "2026-09-02", status: "COMPLETED" }),
        appt({ appointment_date: "2026-09-02", status: "CANCELLED" }),
        appt({ appointment_date: "2026-09-04", status: "BOOKED" }),
      ],
      range
    );
    expect(series.map((point) => point.date)).toEqual([
      "2026-09-01",
      "2026-09-02",
      "2026-09-03",
      "2026-09-04",
      "2026-09-05",
    ]);
    expect(series[1]).toEqual({ date: "2026-09-02", total: 2, completed: 1, cancelled: 1 });
    expect(series[0].total).toBe(0);
    expect(series[3]).toEqual({ date: "2026-09-04", total: 1, completed: 0, cancelled: 0 });
  });

  it("skips facts outside the range (defensive)", () => {
    const range: AnalyticsRange = { preset: "custom", from: "2026-09-01", to: "2026-09-01" };
    const series = dailySeries([appt({ appointment_date: "2026-09-02" })], range);
    expect(series[0].total).toBe(0);
  });
});

describe("perDoctor", () => {
  it("rolls up activity per doctor independently", () => {
    const facts: AppointmentFact[] = [
      appt({ doctor_id: "doc-1", patient_id: "p1" }),
      appt({ doctor_id: "doc-1", patient_id: "p2", status: "NO_SHOW" }),
      appt({ doctor_id: "doc-2", patient_id: "p1", status: "CANCELLED", appointment_type: "WALK_IN" }),
    ];
    const entries = [
      queue({ doctor_id: "doc-1", created_at: "2026-09-10T04:00:00Z", called_at: "2026-09-10T04:12:00Z" }),
      queue({ doctor_id: "doc-2", created_at: "2026-09-10T04:00:00Z", called_at: "2026-09-10T04:30:00Z" }),
    ];
    const rollups = perDoctor(facts, entries);
    expect(rollups.get("doc-1")?.total).toBe(2);
    expect(rollups.get("doc-1")?.uniquePatients).toBe(2);
    expect(rollups.get("doc-1")?.medianWaitMinutes).toBe(12);
    expect(rollups.get("doc-2")?.walkIns).toBe(1);
    expect(rollups.get("doc-2")?.medianWaitMinutes).toBe(30);
  });

  it("returns an empty map for no activity", () => {
    expect(perDoctor([], []).size).toBe(0);
  });
});

describe("statusBreakdown", () => {
  it("orders statuses by count, then alphabetically", () => {
    const breakdown = statusBreakdown([
      appt({ status: "BOOKED" }),
      appt({ status: "COMPLETED" }),
      appt({ status: "COMPLETED" }),
    ]);
    expect(breakdown).toEqual([
      { status: "COMPLETED", count: 2 },
      { status: "BOOKED", count: 1 },
    ]);
  });
});

describe("countNewPatients", () => {
  it("counts in-range patients with no earlier visit, once each", () => {
    const inRange = [
      appt({ patient_id: "new-1" }),
      appt({ patient_id: "new-1", appointment_date: "2026-09-11" }),
      appt({ patient_id: "returning" }),
    ];
    const preRange = [
      appt({ patient_id: "returning", appointment_date: "2026-08-01" }),
    ];
    expect(countNewPatients(inRange, preRange)).toBe(1);
  });

  it("treats everyone as new when there is no history", () => {
    const inRange = [appt({ patient_id: "a" }), appt({ patient_id: "b" })];
    expect(countNewPatients(inRange, [])).toBe(2);
  });
});

describe("median", () => {
  it("handles odd, even and empty inputs", () => {
    expect(median([])).toBeNull();
    expect(median([5])).toBe(5);
    expect(median([10, 2, 8])).toBe(8);
    expect(median([10, 2, 8, 4])).toBe(6); // (4+8)/2
  });
});
