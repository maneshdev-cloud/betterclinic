/** Plain-text formatters shared by the assistant (no date-fns dependency in tests). */

export function formatDateString(date: string): string {
  // YYYY-MM-DD → "16 Sep 2026"
  const [y, m, d] = date.split("-").map(Number);
  if (!y || !m || !d) return date;
  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  return `${d} ${months[m - 1]} ${y}`;
}

export function formatTimeString(time: string): string {
  // HH:MM(:SS) → "9:00 AM"
  const [h, m] = time.split(":").map(Number);
  if (Number.isNaN(h)) return time;
  const suffix = h >= 12 ? "PM" : "AM";
  const hour = h % 12 === 0 ? 12 : h % 12;
  return `${hour}:${String(m ?? 0).padStart(2, "0")} ${suffix}`;
}
