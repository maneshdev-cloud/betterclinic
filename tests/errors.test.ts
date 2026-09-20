import { describe, expect, it } from "vitest";
import { toAppError, AppError } from "@/lib/errors";

describe("toAppError", () => {
  it("passes AppError through unchanged", () => {
    const err = new AppError("SLOT_TAKEN");
    expect(toAppError(err)).toBe(err);
  });

  it("maps SQL machine tokens raised by RPCs", () => {
    const err = toAppError({ message: "[SLOT_TAKEN] That time was just booked by someone else" });
    expect(err.code).toBe("SLOT_TAKEN");
    expect(err.userMessage).toContain("just booked");
  });

  it("maps all tokens used by the SQL layer", () => {
    const tokens = [
      "SLOT_TAKEN",
      "DOUBLE_BOOKING",
      "INVALID_TRANSITION",
      "DUPLICATE_CHECK_IN",
      "PAST_DATE",
      "NOT_CLINIC_HOURS",
      "NO_AVAILABILITY",
      "INVITE_CODE_INVALID",
      "FORBIDDEN",
      "NOT_FOUND",
      "VALIDATION",
    ];
    for (const token of tokens) {
      expect(toAppError({ message: `[${token}] something` }).code).toBe(token);
    }
  });

  it("maps Supabase auth errors to safe messages", () => {
    expect(toAppError({ message: "Invalid login credentials" }).code).toBe("INVALID_CREDENTIALS");
    expect(toAppError({ message: "Email not confirmed" }).code).toBe("EMAIL_NOT_CONFIRMED");
    expect(toAppError({ message: "User already registered" }).code).toBe("USER_ALREADY_EXISTS");
  });

  it("maps network failures", () => {
    expect(toAppError({ message: "Failed to fetch" }).code).toBe("NETWORK");
    expect(toAppError({ message: "fetch failed" }).code).toBe("NETWORK");
  });

  it("never leaks raw unknown errors to users", () => {
    const err = toAppError(new Error("relation public.secret_table does not exist"));
    expect(err.userMessage).not.toContain("secret_table");
    expect(err.userMessage).toBe("Something went wrong. Please try again.");
  });

  it("maps row-level security violations to a permission message", () => {
    expect(toAppError({ message: "new row violates row-level security policy" }).code).toBe("FORBIDDEN");
  });
});
