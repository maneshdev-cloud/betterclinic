/**
 * Network error classification helper.
 * Distinguishes transient network errors, timeouts, connection dropouts,
 * and offline status from real application bugs.
 */

const NETWORK_ERROR_PATTERNS = [
  /failed to fetch/i,
  /fetch failed/i,
  /network\s?error/i,
  /network request failed/i,
  /econnreset/i,
  /econnrefused/i,
  /etimedout/i,
  /ehostunreach/i,
  /enotfound/i,
  /socket hang up/i,
  /connection reset/i,
  /connection refused/i,
  /server unreachable/i,
  /timed? out/i,
  /timeout/i,
  /the user aborted a request/i,
  /bad gateway/i,
  /gateway timeout/i,
];

export function isNetworkError(error: unknown): boolean {
  if (!error) return false;

  // 1. Browser reports offline
  if (typeof window !== "undefined" && typeof navigator !== "undefined" && !navigator.onLine) {
    return true;
  }

  // 2. AppError or error with NETWORK code
  if ((error as { code?: string })?.code === "NETWORK") {
    return true;
  }

  // 3. Known error names
  if (error instanceof Error) {
    if (error.name === "NetworkError" || error.name === "AbortError" || error.name === "TimeoutError") {
      return true;
    }
  }

  // 4. Supabase / Fetch status code checks (502, 503, 504, 408)
  const status = (error as { status?: number; statusCode?: number })?.status ??
    (error as { status?: number; statusCode?: number })?.statusCode;
  if (status === 408 || status === 502 || status === 503 || status === 504) {
    return true;
  }

  // 5. Message string analysis
  const message =
    error instanceof Error
      ? error.message
      : typeof (error as { message?: unknown })?.message === "string"
      ? (error as { message: string }).message
      : String(error);

  return NETWORK_ERROR_PATTERNS.some((pattern) => pattern.test(message));
}
