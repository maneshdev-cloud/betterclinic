import { describe, expect, it, afterEach, vi } from "vitest";

function setEnv(values: Record<string, string | undefined>) {
  for (const [key, value] of Object.entries(values)) {
    if (value === undefined) delete process.env[key];
    else process.env[key] = value;
  }
}

// NOTE: lib/env.ts evaluates the environment at import time, so these
// tests re-import the module with vitest's dynamic import + cache reset.

describe("env configuration", () => {
  afterEach(() => {
    vi.resetModules();
  });

  it("reports unconfigured when URL/key are empty (fresh clone state)", async () => {
    vi.resetModules();
    setEnv({ NEXT_PUBLIC_SUPABASE_URL: "", NEXT_PUBLIC_SUPABASE_ANON_KEY: "" });
    const mod = await import("@/lib/env");
    expect(mod.isSupabaseConfigured()).toBe(false);
  });

  it("rejects malformed URLs", async () => {
    vi.resetModules();
    setEnv({
      NEXT_PUBLIC_SUPABASE_URL: "not-a-url",
      NEXT_PUBLIC_SUPABASE_ANON_KEY: "a".repeat(40),
    });
    const mod = await import("@/lib/env");
    expect(mod.isSupabaseConfigured()).toBe(false);
  });

  it("accepts a valid https Supabase project", async () => {
    vi.resetModules();
    setEnv({
      NEXT_PUBLIC_SUPABASE_URL: "https://abcdefgh.supabase.co",
      NEXT_PUBLIC_SUPABASE_ANON_KEY: "a".repeat(40),
    });
    const mod = await import("@/lib/env");
    expect(mod.isSupabaseConfigured()).toBe(true);
  });

  it("defaults to demo mode and only production counts as production", async () => {
    vi.resetModules();
    setEnv({ NEXT_PUBLIC_APP_ENV: undefined });
    const mod1 = await import("@/lib/env");
    expect(mod1.isDemoMode()).toBe(true);

    vi.resetModules();
    setEnv({ NEXT_PUBLIC_APP_ENV: "demo" });
    const mod2 = await import("@/lib/env");
    expect(mod2.isDemoMode()).toBe(true);
    expect(mod2.env.appEnv).toBe("demo");

    vi.resetModules();
    setEnv({ NEXT_PUBLIC_APP_ENV: "production" });
    const mod3 = await import("@/lib/env");
    expect(mod3.isDemoMode()).toBe(false);
    expect(mod3.env.appEnv).toBe("production");
  });
});
