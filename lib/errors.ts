/**
 * Application error handling. Raw database / network errors are never
 * shown to end users — they are mapped to readable messages here.
 *
 * SQL RPCs raise errors whose message starts with a machine-readable
 * token in square brackets, e.g. `[SLOT_TAKEN] This slot was just booked.`
 * That token drives the mapping below.
 */

import { isNetworkError } from "@/lib/network/is-network-error";

export { isNetworkError };

export type AppErrorCode =
  | "SUPABASE_NOT_CONFIGURED"
  | "UNAUTHENTICATED"
  | "FORBIDDEN"
  | "NOT_FOUND"
  | "VALIDATION"
  | "SLOT_TAKEN"
  | "DOUBLE_BOOKING"
  | "INVALID_TRANSITION"
  | "DUPLICATE_CHECK_IN"
  | "PAST_DATE"
  | "NOT_CLINIC_HOURS"
  | "NO_AVAILABILITY"
  | "INVITE_CODE_INVALID"
  | "DOCTOR_INVITE_CODE_INVALID"
  | "DOCTOR_CODE_NOT_CONFIGURED"
  | "ADMIN_CLAIM_CODE_INVALID"
  | "ADMIN_CODE_NOT_CONFIGURED"
  | "CLINIC_NOT_FOUND"
  | "DUPLICATE_CLINIC"
  | "CLINIC_HAS_ADMIN"
  | "EMAIL_NOT_CONFIRMED"
  | "INVALID_CREDENTIALS"
  | "USER_ALREADY_EXISTS"
  | "RATE_LIMITED"
  | "AI_UNAVAILABLE"
  | "STORAGE_ERROR"
  | "NETWORK"
  | "UNKNOWN";

const DEFAULT_MESSAGES: Record<AppErrorCode, string> = {
  SUPABASE_NOT_CONFIGURED:
    "Supabase is not connected yet. Add your project URL and keys to .env.local, then restart the app.",
  UNAUTHENTICATED: "Please sign in to continue.",
  FORBIDDEN: "You do not have permission to perform this action.",
  NOT_FOUND: "The record you are looking for does not exist.",
  CLINIC_NOT_FOUND: "The selected clinic could not be found.",
  VALIDATION: "Please check the highlighted fields and try again.",
  SLOT_TAKEN: "That time slot was just booked by someone else. Please pick another slot.",
  DOUBLE_BOOKING: "This slot is already booked. Please choose a different time.",
  INVALID_TRANSITION: "This action is not allowed for the current state of this record.",
  DUPLICATE_CHECK_IN: "This appointment has already been checked in.",
  PAST_DATE: "You cannot book or check in for a date/time in the past.",
  NOT_CLINIC_HOURS: "This time is outside the clinic's working hours.",
  NO_AVAILABILITY: "No available slots were found for the selected day.",
  INVITE_CODE_INVALID: "The clinic invite code is not valid. Please check with the clinic.",
  DOCTOR_INVITE_CODE_INVALID: "The clinic doctor invite code is not valid. Please check with the clinic administrator.",
  DOCTOR_CODE_NOT_CONFIGURED: "No doctor invite code has been configured for this clinic yet. Please contact the clinic administrator.",
  ADMIN_CLAIM_CODE_INVALID: "The clinic admin verification code is not valid.",
  ADMIN_CODE_NOT_CONFIGURED: "No admin verification code is configured for this clinic yet.",
  DUPLICATE_CLINIC: "A clinic with this name and city already exists. Please select it from the list.",
  CLINIC_HAS_ADMIN: "This clinic already has an active administrator account.",
  EMAIL_NOT_CONFIRMED: "Please confirm your email address first — check your inbox.",
  INVALID_CREDENTIALS: "Incorrect email or password.",
  USER_ALREADY_EXISTS: "An account with this email already exists. Each person uses one account across Better Clinic. Please sign in instead.",
  RATE_LIMITED: "Too many attempts. Please wait a moment and try again.",
  AI_UNAVAILABLE: "The assistant is unavailable right now. Please try again shortly.",
  STORAGE_ERROR: "The file could not be uploaded. Please try again.",
  NETWORK: "Network problem — please check your connection and try again.",
  UNKNOWN: "Something went wrong. Please try again.",
};

/** Machine-readable token → user-facing code. Sync with SQL RAISE statements. */
const TOKEN_TO_CODE: Record<string, AppErrorCode> = {
  SLOT_TAKEN: "SLOT_TAKEN",
  DOUBLE_BOOKING: "DOUBLE_BOOKING",
  INVALID_TRANSITION: "INVALID_TRANSITION",
  DUPLICATE_CHECK_IN: "DUPLICATE_CHECK_IN",
  PAST_DATE: "PAST_DATE",
  NOT_CLINIC_HOURS: "NOT_CLINIC_HOURS",
  NO_AVAILABILITY: "NO_AVAILABILITY",
  INVITE_CODE_INVALID: "INVITE_CODE_INVALID",
  DOCTOR_INVITE_CODE_INVALID: "DOCTOR_INVITE_CODE_INVALID",
  DOCTOR_CODE_NOT_CONFIGURED: "DOCTOR_CODE_NOT_CONFIGURED",
  ADMIN_CLAIM_CODE_INVALID: "ADMIN_CLAIM_CODE_INVALID",
  ADMIN_CODE_NOT_CONFIGURED: "ADMIN_CODE_NOT_CONFIGURED",
  CLINIC_NOT_FOUND: "CLINIC_NOT_FOUND",
  DUPLICATE_CLINIC: "DUPLICATE_CLINIC",
  CLINIC_HAS_ADMIN: "CLINIC_HAS_ADMIN",
  FORBIDDEN: "FORBIDDEN",
  NOT_FOUND: "NOT_FOUND",
  VALIDATION: "VALIDATION",
};

export class AppError extends Error {
  readonly code: AppErrorCode;
  readonly userMessage: string;
  readonly details?: unknown;

  constructor(code: AppErrorCode, userMessage?: string, details?: unknown) {
    super(userMessage ?? DEFAULT_MESSAGES[code]);
    this.name = "AppError";
    this.code = code;
    this.userMessage = userMessage ?? DEFAULT_MESSAGES[code];
    this.details = details;
  }
}

type SupabaseLikeError = {
  message?: string;
  code?: string | number;
  details?: string;
  hint?: string;
  status?: number;
};

function extractToken(message: string): string | null {
  const match = message.match(/\[([A-Z_]+)\]/);
  return match ? match[1]! : null;
}

/** Convert any thrown value / Supabase error into an AppError with a safe message. */
export function toAppError(error: unknown): AppError {
  if (error instanceof AppError) return error;

  const err = error as SupabaseLikeError;
  const rawMessage = typeof err?.message === "string" ? err.message : String(error ?? "");

  // 1. Machine-readable tokens raised by our SQL functions
  const token = extractToken(rawMessage);
  if (token && TOKEN_TO_CODE[token]) {
    return new AppError(TOKEN_TO_CODE[token]!, DEFAULT_MESSAGES[TOKEN_TO_CODE[token]!]);
  }

  // 2. Auth errors (Supabase Auth messages are already user-safe)
  const lower = rawMessage.toLowerCase();
  if (lower.includes("invalid login credentials")) return new AppError("INVALID_CREDENTIALS");
  if (lower.includes("email not confirmed")) return new AppError("EMAIL_NOT_CONFIRMED");
  if (lower.includes("user already registered") || lower.includes("already been registered"))
    return new AppError("USER_ALREADY_EXISTS");
  if (
    err?.status === 429 ||
    (err as { code?: string })?.code === "over_email_send_rate_limit" ||
    lower.includes("rate limit") ||
    lower.includes("too many requests") ||
    lower.includes("over_email_send_rate_limit")
  ) {
    return new AppError(
      "RATE_LIMITED",
      "Email rate limit exceeded (free-tier allows 3 emails/hour). In Supabase Dashboard → Auth → Providers → Email, turn OFF 'Confirm email' for instant signups."
    );
  }
  if (isNetworkError(error) || lower.includes("failed to fetch") || lower.includes("networkerror") || lower.includes("fetch failed"))
    return new AppError("NETWORK");
  if (err?.status === 401) return new AppError("UNAUTHENTICATED");
  if (err?.status === 403) return new AppError("FORBIDDEN");
  if (err?.status === 404) return new AppError("NOT_FOUND");
  if (lower.includes("row-level security")) return new AppError("FORBIDDEN");
  if (lower.includes("duplicate key")) return new AppError("DOUBLE_BOOKING");

  // 3. Unknown — log server-side details, keep user message generic
  console.error("[AppError] Unmapped error:", error);
  return new AppError("UNKNOWN");
}

/** Safe message for rendering in UI, whatever the thrown value is. */
export function errorMessage(error: unknown): string {
  return toAppError(error).userMessage;
}
