import type { QueueStatus, Priority } from "@/lib/constants";

/**
 * Pure queue math (unit-tested in tests/queue-estimator.test.ts).
 * All numbers shown to users derive from real rows — no hard-coded rates.
 */

/** URGENT jumps ahead of HIGH, which jumps ahead of NORMAL. */
export function priorityRank(priority: Priority): number {
  switch (priority) {
    case "URGENT":
      return 0;
    case "HIGH":
      return 1;
    default:
      return 2;
  }
}

export interface SortableQueueEntry {
  priority: Priority;
  token_number: number;
}

/** The exact order the queue_call_next SQL function uses. */
export function sortByQueueOrder<T extends SortableQueueEntry>(entries: T[]): T[] {
  return [...entries].sort(
    (a, b) =>
      priorityRank(a.priority) - priorityRank(b.priority) || a.token_number - b.token_number
  );
}

export function countAhead<T extends SortableQueueEntry>(queue: T[], entry: T): number {
  const index = sortByQueueOrder(queue).findIndex((e) => e === entry);
  return index >= 0 ? index : queue.length;
}

/**
 * Estimated wait for a patient, in minutes.
 *
 * peopleAhead × average actual consultation length for the doctor
 * (from completed consultations). If the doctor has no completed
 * consultations yet, fall back to their configured slot length. If
 * neither exists, return null — the UI shows "not enough data" instead
 * of inventing a number.
 */
export function estimateWaitMinutes(peopleAhead: number, avgConsultMinutes: number | null, fallbackSlotMinutes: number | null): number | null {
  if (peopleAhead < 0) return null;
  if (peopleAhead === 0) return 0;
  const perPatient = avgConsultMinutes ?? fallbackSlotMinutes;
  if (perPatient === null || perPatient <= 0) return null;
  return Math.round(peopleAhead * perPatient);
}

/**
 * Average duration in minutes from completed consultations.
 * Needs at least `minSamples` finished consultations to be considered
 * representative; otherwise returns null so the caller can fall back.
 */
export function averageMinutes(durationsMinutes: number[], minSamples = 3): number | null {
  const valid = durationsMinutes.filter((d) => Number.isFinite(d) && d > 0 && d < 24 * 60);
  if (valid.length < minSamples) return null;
  return valid.reduce((sum, d) => sum + d, 0) / valid.length;
}

export interface QueueBuckets<T extends { status: QueueStatus }> {
  waiting: T[];
  called: T[];
  inConsultation: T[];
  skipped: T[];
  finished: T[];
}

/** Bucket a day's queue entries into UI groups. */
export function bucketQueue<T extends { status: QueueStatus; priority: Priority; token_number: number }>(entries: T[]): QueueBuckets<T> {
  const buckets: QueueBuckets<T> = {
    waiting: [],
    called: [],
    inConsultation: [],
    skipped: [],
    finished: [],
  };
  for (const entry of entries) {
    switch (entry.status) {
      case "WAITING":
        buckets.waiting.push(entry);
        break;
      case "CALLED":
        buckets.called.push(entry);
        break;
      case "IN_CONSULTATION":
        buckets.inConsultation.push(entry);
        break;
      case "SKIPPED":
        buckets.skipped.push(entry);
        break;
      case "COMPLETED":
      case "CANCELLED":
        buckets.finished.push(entry);
        break;
    }
  }
  buckets.waiting = sortByQueueOrder(buckets.waiting);
  return buckets;
}

/** Human label for the estimated wait. */
export function waitLabel(estimatedMinutes: number | null): string {
  if (estimatedMinutes === null) return "Not enough data yet";
  if (estimatedMinutes === 0) return "Your turn";
  if (estimatedMinutes < 60) return `~${estimatedMinutes} min`;
  const hours = Math.floor(estimatedMinutes / 60);
  const minutes = estimatedMinutes % 60;
  return minutes === 0 ? `~${hours} hr` : `~${hours} hr ${minutes} min`;
}
