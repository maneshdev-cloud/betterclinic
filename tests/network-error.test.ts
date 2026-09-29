import { describe, it, expect } from "vitest";
import { isNetworkError } from "@/lib/network/is-network-error";
import { AppError } from "@/lib/errors";

describe("Network Error Detection (isNetworkError)", () => {
  it("detects standard browser and Node fetch errors", () => {
    expect(isNetworkError(new TypeError("Failed to fetch"))).toBe(true);
    expect(isNetworkError(new TypeError("fetch failed"))).toBe(true);
    expect(isNetworkError(new Error("NetworkError when attempting to fetch resource."))).toBe(true);
    expect(isNetworkError(new Error("Network request failed"))).toBe(true);
  });

  it("detects socket and connection reset errors", () => {
    expect(isNetworkError(new Error("read ECONNRESET"))).toBe(true);
    expect(isNetworkError(new Error("connect ECONNREFUSED 127.0.0.1:5432"))).toBe(true);
    expect(isNetworkError(new Error("ETIMEDOUT"))).toBe(true);
    expect(isNetworkError(new Error("socket hang up"))).toBe(true);
    expect(isNetworkError(new Error("connection reset by peer"))).toBe(true);
    expect(isNetworkError(new Error("server unreachable"))).toBe(true);
  });

  it("detects timeout and abort errors", () => {
    const abortErr = new Error("The user aborted a request.");
    abortErr.name = "AbortError";
    expect(isNetworkError(abortErr)).toBe(true);

    const timeoutErr = new Error("Request timed out");
    timeoutErr.name = "TimeoutError";
    expect(isNetworkError(timeoutErr)).toBe(true);
  });

  it("detects gateway status codes (502, 503, 504, 408)", () => {
    expect(isNetworkError({ status: 502, message: "Bad Gateway" })).toBe(true);
    expect(isNetworkError({ status: 503, message: "Service Unavailable" })).toBe(true);
    expect(isNetworkError({ status: 504, message: "Gateway Timeout" })).toBe(true);
    expect(isNetworkError({ statusCode: 408, message: "Request Timeout" })).toBe(true);
  });

  it("detects AppError with NETWORK code", () => {
    const appErr = new AppError("NETWORK");
    expect(isNetworkError(appErr)).toBe(true);
  });

  it("does NOT classify application bugs or normal client errors as network errors", () => {
    expect(isNetworkError(new Error("Cannot read properties of undefined (reading 'name')"))).toBe(false);
    expect(isNetworkError(new Error("SyntaxError: Unexpected token"))).toBe(false);
    expect(isNetworkError(new AppError("NOT_FOUND"))).toBe(false);
    expect(isNetworkError(new AppError("VALIDATION"))).toBe(false);
    expect(isNetworkError(new AppError("FORBIDDEN"))).toBe(false);
    expect(isNetworkError(new AppError("INVALID_CREDENTIALS"))).toBe(false);
    expect(isNetworkError({ status: 400, message: "Bad Request" })).toBe(false);
    expect(isNetworkError({ status: 404, message: "Not Found" })).toBe(false);
    expect(isNetworkError(null)).toBe(false);
    expect(isNetworkError(undefined)).toBe(false);
  });
});
