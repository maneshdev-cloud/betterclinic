import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";
import { format, formatDistanceToNowStrict, parseISO, addDays } from "date-fns";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/* ── Dates & times ───────────────────────────────────────────────
   All stored timestamps are UTC; appointment dates/times are stored
   as plain `date` / `time` values interpreted in clinic local time
   (IST for this prototype). */

/**
 * "Today" in the clinic timezone (IST) as YYYY-MM-DD. All date
 * comparisons in the app use this so app-side dates line up with the
 * SQL functions, which evaluate the current IST time explicitly.
 */
export function todayClinicDate(): string {
  return new Date().toLocaleDateString("en-CA", { timeZone: "Asia/Kolkata" });
}

export function clinicDatePlusDays(days: number): string {
  const base = new Date(`${todayClinicDate()}T12:00:00Z`);
  return addDays(base, days).toISOString().slice(0, 10);
}

/** Day-of-week (0=Sunday … 6=Saturday) for a YYYY-MM-DD string, matching the DB convention. */
export function dayOfWeek(dateStr: string): number {
  return new Date(`${dateStr}T12:00:00Z`).getUTCDay();
}

/** Current time-of-day in IST as HH:MM. */
export function nowClinicTime(): string {
  return new Date().toLocaleTimeString("en-GB", {
    timeZone: "Asia/Kolkata",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  });
}

export function toDate(value: string | Date): Date {
  return typeof value === "string" ? parseISO(value) : value;
}

/** 16 Sep 2026 */
export function formatDate(value: string | Date | null | undefined): string {
  if (!value) return "—";
  return format(toDate(value), "d MMM yyyy");
}

/** Wed, 16 Sep 2026 */
export function formatDateWithDay(value: string | Date | null | undefined): string {
  if (!value) return "—";
  return format(toDate(value), "EEE, d MMM yyyy");
}

/** 4:30 PM */
export function formatTime(value: string | Date | null | undefined): string {
  if (!value) return "—";
  return format(toDate(value), "h:mm a");
}

/** 09:00 → 9:00 AM (for plain `time` strings) */
export function formatTimeString(value: string | null | undefined): string {
  if (!value) return "—";
  const [h, m] = value.split(":").map(Number);
  const suffix = h >= 12 ? "PM" : "AM";
  const hour = h % 12 === 0 ? 12 : h % 12;
  return `${hour}:${String(m ?? 0).padStart(2, "0")} ${suffix}`;
}

/** 16 Sep 2026, 4:30 PM */
export function formatDateTime(value: string | Date | null | undefined): string {
  if (!value) return "—";
  return format(toDate(value), "d MMM yyyy, h:mm a");
}

/** "2 days ago" / "in 3 days" */
export function formatRelative(value: string | Date): string {
  return formatDistanceToNowStrict(toDate(value), { addSuffix: true });
}

/* ── Numbers & currency ────────────────────────────────────────── */

/** ₹350 (Indian Rupee formatting used across the product) */
export function formatINR(amount: number | null | undefined): string {
  if (amount === null || amount === undefined) return "—";
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(amount);
}

/** 1 hr 20 min — honest, rounded wait estimates */
export function formatDuration(minutes: number | null | undefined): string {
  if (minutes === null || minutes === undefined || Number.isNaN(minutes)) return "—";
  if (minutes < 1) return "less than a minute";
  if (minutes < 60) return `${Math.round(minutes)} min`;
  const hours = Math.floor(minutes / 60);
  const mins = Math.round(minutes % 60);
  return mins === 0 ? `${hours} hr` : `${hours} hr ${mins} min`;
}

/** Age in whole years from a YYYY-MM-DD date of birth (defensive: null for bad ranges). */
export function ageFrom(dob: string | null): string | null {
  if (!dob) return null;
  const birth = new Date(`${dob}T12:00:00Z`);
  const now = new Date();
  let age = now.getUTCFullYear() - birth.getUTCFullYear();
  const monthDiff = now.getUTCMonth() - birth.getUTCMonth();
  if (monthDiff < 0 || (monthDiff === 0 && now.getUTCDate() < birth.getUTCDate())) age--;
  return age >= 0 && age < 130 ? `${age}` : null;
}

export function initials(name: string | null | undefined): string {
  if (!name) return "?";
  return name
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]!.toUpperCase())
    .join("");
}

export function pluralize(count: number, singular: string, plural?: string): string {
  return `${count} ${count === 1 ? singular : (plural ?? `${singular}s`)}`;
}

/** Deterministic accent colour for avatar chips, derived from a string. */
export function avatarTone(seed: string): "teal" | "blue" | "amber" | "rose" | "slate" | "indigo" {
  const tones = ["teal", "blue", "amber", "rose", "slate", "indigo"] as const;
  let hash = 0;
  for (let i = 0; i < seed.length; i++) hash = (hash * 31 + seed.charCodeAt(i)) >>> 0;
  return tones[hash % tones.length];
}

/* ── Pagination ────────────────────────────────────────────────── */

/** Page numbers are 1-based; computes the from/to range for Supabase range queries. */
export function pageRange(page: number, pageSize: number): { from: number; to: number } {
  const safePage = Math.max(1, Math.floor(page || 1));
  const from = (safePage - 1) * pageSize;
  return { from, to: from + pageSize - 1 };
}

export function totalPages(totalCount: number, pageSize: number): number {
  return Math.max(1, Math.ceil(totalCount / pageSize));
}

/** Debounce helper for search inputs. */
export function debounce<T extends (...args: never[]) => void>(fn: T, ms = 300) {
  let timer: ReturnType<typeof setTimeout> | undefined;
  return (...args: Parameters<T>) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), ms);
  };
}
