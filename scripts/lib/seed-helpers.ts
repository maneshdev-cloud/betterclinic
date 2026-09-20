/**
 * Deterministic helper utilities for realistic synthetic data generation.
 * Uses a reproducible PRNG so the exact same dataset is generated on every run.
 */

// ── Mulberry32 PRNG ────────────────────────────────────────────────

export class SeedRandom {
  private s: number;

  constructor(seed = 42) {
    this.s = seed | 0;
  }

  /** Returns float in [0, 1) */
  next(): number {
    let t = (this.s += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  }

  /** Random integer in [min, max] inclusive */
  int(min: number, max: number): number {
    return Math.floor(this.next() * (max - min + 1)) + min;
  }

  /** Pick one element from an array */
  pick<T>(arr: readonly T[]): T {
    return arr[Math.floor(this.next() * arr.length)];
  }

  /** Pick n distinct elements from an array */
  sample<T>(arr: readonly T[], n: number): T[] {
    const copy = [...arr];
    const result: T[] = [];
    const count = Math.min(n, copy.length);
    for (let i = 0; i < count; i++) {
      const idx = Math.floor(this.next() * copy.length);
      result.push(copy.splice(idx, 1)[0]);
    }
    return result;
  }

  /** Shuffle an array deterministically */
  shuffle<T>(arr: readonly T[]): T[] {
    const copy = [...arr];
    for (let i = copy.length - 1; i > 0; i--) {
      const j = Math.floor(this.next() * (i + 1));
      [copy[i], copy[j]] = [copy[j], copy[i]];
    }
    return copy;
  }

  /** Weighted pick: items and their relative weights */
  weightedPick<T>(items: readonly T[], weights: readonly number[]): T {
    const total = weights.reduce((sum, w) => sum + w, 0);
    let r = this.next() * total;
    for (let i = 0; i < items.length; i++) {
      r -= weights[i];
      if (r <= 0) return items[i];
    }
    return items[items.length - 1];
  }

  /** Boolean with given probability of true */
  chance(probability: number): boolean {
    return this.next() < probability;
  }

  /** Deterministic UUID v4 */
  uuid(): string {
    const hex = "0123456789abcdef";
    let out = "";
    for (let i = 0; i < 36; i++) {
      if (i === 8 || i === 13 || i === 18 || i === 23) {
        out += "-";
      } else if (i === 14) {
        out += "4"; // UUID v4
      } else if (i === 19) {
        out += hex[(Math.floor(this.next() * 4) + 8)]; // 8, 9, a, or b
      } else {
        out += hex[Math.floor(this.next() * 16)];
      }
    }
    return out;
  }

  /** Indian mobile phone: +91 9xxxxxxxx or +91 8xxxxxxxx or +91 7xxxxxxxx */
  phone(): string {
    const prefixes = ["98", "99", "97", "96", "95", "94", "93", "91", "88", "87", "86", "84", "81", "77", "75"];
    const prefix = this.pick(prefixes);
    const rest = String(this.int(10000000, 99999999));
    return `+91${prefix}${rest.slice(0, 8)}`;
  }

  /** Date between two dates */
  dateBetween(start: Date, end: Date): Date {
    const startTime = start.getTime();
    const endTime = end.getTime();
    const time = startTime + this.next() * (endTime - startTime);
    return new Date(time);
  }

  /** Date formatted as YYYY-MM-DD */
  dateString(date: Date): string {
    return date.toISOString().slice(0, 10);
  }

  /** Time formatted as HH:MM:00 */
  timeString(hour: number, minute: number): string {
    const h = String(hour).padStart(2, "0");
    const m = String(minute).padStart(2, "0");
    return `${h}:${m}:00`;
  }
}

/** Bcrypt hash for password: 'password123' (cost 10) */
export const DEMO_PASSWORD_HASH = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";

/** Slugs for URLs */
export function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/[\s_-]+/g, "-")
    .replace(/^-+|-+$/g, "");
}
