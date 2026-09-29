/**
 * Shared retry wrapper for network operations.
 * Executes a network call with short retries and small backoff (300ms, then 800ms)
 * on transient network failures, and notifies the global connectivity tracker.
 */

import { isNetworkError } from "./is-network-error";
import { notifyRetryStart, notifyRetryEnd } from "./status";

export interface RetryOptions {
  /** Maximum number of retry attempts (default: 2) */
  retries?: number;
  /** Backoff intervals in milliseconds for each retry (default: [300, 800]) */
  backoffs?: number[];
  /** Custom check to determine if an error is transient and retryable */
  shouldRetry?: (error: unknown, attempt: number) => boolean;
  /** Optional callback fired right before a retry delay */
  onRetry?: (attempt: number, error: unknown, delayMs: number) => void;
}

const DEFAULT_RETRIES = 2;
const DEFAULT_BACKOFFS = [300, 800];

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export function defaultShouldRetry(error: unknown): boolean {
  return isNetworkError(error);
}

/**
 * Execute an async network operation with retries on transient errors.
 */
export async function withRetry<T>(
  fn: () => Promise<T>,
  options: RetryOptions = {}
): Promise<T> {
  const maxRetries = options.retries ?? DEFAULT_RETRIES;
  const backoffs = options.backoffs ?? DEFAULT_BACKOFFS;
  const shouldRetry = options.shouldRetry ?? defaultShouldRetry;

  let attempt = 0;
  let hasNotifiedRetry = false;

  try {
    while (true) {
      try {
        const result = await fn();
        return result;
      } catch (error) {
        if (attempt >= maxRetries || !shouldRetry(error, attempt)) {
          throw error;
        }

        const delayMs = backoffs[attempt] ?? backoffs[backoffs.length - 1] ?? 800;

        if (!hasNotifiedRetry) {
          notifyRetryStart();
          hasNotifiedRetry = true;
        }

        options.onRetry?.(attempt + 1, error, delayMs);

        await sleep(delayMs);
        attempt++;
      }
    }
  } finally {
    if (hasNotifiedRetry) {
      notifyRetryEnd();
    }
  }
}

/**
 * Custom fetch wrapper with automatic transient network retries.
 * Can be passed to Supabase clients via global.fetch or used directly.
 */
export async function retryFetch(
  input: RequestInfo | URL,
  init?: RequestInit
): Promise<Response> {
  return withRetry(
    async () => {
      const response = await fetch(input, init);
      // Transient gateway errors are treated as retryable
      if (response.status === 502 || response.status === 503 || response.status === 504) {
        const error = new Error(`Server temporarily unavailable (HTTP ${response.status})`);
        (error as { status?: number }).status = response.status;
        throw error;
      }
      return response;
    },
    {
      retries: 2,
      backoffs: [300, 800],
      shouldRetry: (err) => isNetworkError(err),
    }
  );
}
