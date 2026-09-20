import { describe, expect, it } from "vitest";
import {
  priorityRank,
  sortByQueueOrder,
  countAhead,
  estimateWaitMinutes,
  averageMinutes,
  bucketQueue,
  waitLabel,
} from "@/lib/queue";
import type { Priority } from "@/lib/constants";

describe("priorityRank", () => {
  it("orders URGENT before HIGH before NORMAL", () => {
    expect(priorityRank("URGENT")).toBeLessThan(priorityRank("HIGH"));
    expect(priorityRank("HIGH")).toBeLessThan(priorityRank("NORMAL"));
  });
});

describe("sortByQueueOrder", () => {
  it("sorts by priority first, then token number", () => {
    const entries = [
      { priority: "NORMAL" as Priority, token_number: 1 },
      { priority: "URGENT" as Priority, token_number: 5 },
      { priority: "NORMAL" as Priority, token_number: 2 },
      { priority: "HIGH" as Priority, token_number: 4 },
    ];
    expect(sortByQueueOrder(entries).map((e) => e.token_number)).toEqual([5, 4, 1, 2]);
  });

  it("does not mutate the input", () => {
    const entries = [
      { priority: "NORMAL" as Priority, token_number: 2 },
      { priority: "NORMAL" as Priority, token_number: 1 },
    ];
    sortByQueueOrder(entries);
    expect(entries[0]!.token_number).toBe(2);
  });
});

describe("countAhead", () => {
  it("counts how many jump ahead of the entry", () => {
    const queue = [
      { priority: "NORMAL" as Priority, token_number: 1 },
      { priority: "NORMAL" as Priority, token_number: 2 },
      { priority: "NORMAL" as Priority, token_number: 3 },
    ];
    expect(countAhead(queue, queue[1]!)).toBe(1);
    expect(countAhead(queue, queue[0]!)).toBe(0);
  });
});

describe("estimateWaitMinutes", () => {
  it("uses the doctor's average consultation length", () => {
    expect(estimateWaitMinutes(2, 12, null)).toBe(24);
  });

  it("falls back to the configured slot length when no history exists", () => {
    expect(estimateWaitMinutes(3, null, 15)).toBe(45);
  });

  it("returns null when no basis exists — never invents a number", () => {
    expect(estimateWaitMinutes(2, null, null)).toBeNull();
  });

  it("is zero when nobody is ahead", () => {
    expect(estimateWaitMinutes(0, null, null)).toBe(0);
  });

  it("rejects negative counts", () => {
    expect(estimateWaitMinutes(-1, 10, 10)).toBeNull();
  });
});

describe("averageMinutes", () => {
  it("needs at least 3 samples", () => {
    expect(averageMinutes([10, 20])).toBeNull();
    expect(averageMinutes([10, 20, 30])).toBeCloseTo(20);
  });

  it("ignores invalid durations", () => {
    expect(averageMinutes([10, -5, NaN, 20, 30, 999999])).toBeCloseTo(20);
  });
});

describe("bucketQueue", () => {
  it("groups entries by status and orders the waiting list", () => {
    const entries = [
      { status: "WAITING" as const, priority: "NORMAL" as Priority, token_number: 1 },
      { status: "WAITING" as const, priority: "URGENT" as Priority, token_number: 2 },
      { status: "CALLED" as const, priority: "NORMAL" as Priority, token_number: 3 },
      { status: "IN_CONSULTATION" as const, priority: "NORMAL" as Priority, token_number: 4 },
      { status: "SKIPPED" as const, priority: "NORMAL" as Priority, token_number: 5 },
      { status: "COMPLETED" as const, priority: "NORMAL" as Priority, token_number: 6 },
      { status: "CANCELLED" as const, priority: "NORMAL" as Priority, token_number: 7 },
    ];
    const buckets = bucketQueue(entries);
    expect(buckets.waiting.map((e) => e.token_number)).toEqual([2, 1]);
    expect(buckets.called).toHaveLength(1);
    expect(buckets.inConsultation).toHaveLength(1);
    expect(buckets.skipped).toHaveLength(1);
    expect(buckets.finished).toHaveLength(2);
  });
});

describe("waitLabel", () => {
  it("formats human labels", () => {
    expect(waitLabel(null)).toBe("Not enough data yet");
    expect(waitLabel(0)).toBe("Your turn");
    expect(waitLabel(25)).toBe("~25 min");
    expect(waitLabel(60)).toBe("~1 hr");
    expect(waitLabel(95)).toBe("~1 hr 35 min");
  });
});
