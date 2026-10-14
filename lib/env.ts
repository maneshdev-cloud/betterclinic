/**
 * Central environment configuration — the single source of truth.
 *
 * Secrets are NEVER hard-coded: everything comes from environment
 * variables (.env.local). The app degrades gracefully and shows a
 * "Connect Supabase" setup screen while the required values are empty.
 */

export const APP_ENV = {
  DEMO: "demo",
  PRODUCTION: "production",
} as const;

export type AppEnvironment = (typeof APP_ENV)[keyof typeof APP_ENV];

function trimEnv(value: string | undefined, fallback = ""): string {
  return (value === undefined ? fallback : value).trim();
}

function isValidUrl(value: string): boolean {
  try {
    const url = new URL(value);
    return url.protocol === "https:" || url.hostname === "localhost" || url.hostname === "127.0.0.1";
  } catch {
    return false;
  }
}

export const env = {
  supabaseUrl: trimEnv(process.env.NEXT_PUBLIC_SUPABASE_URL),
  supabaseAnonKey: trimEnv(process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY),
  supabaseServiceRoleKey: trimEnv(process.env.SUPABASE_SERVICE_ROLE_KEY),
  databaseUrl: trimEnv(process.env.DATABASE_URL),

  /** APP_ENV — mirrored to the client via the NEXT_PUBLIC_ prefix (one variable, no divergence). */
  appEnv: (trimEnv(process.env.NEXT_PUBLIC_APP_ENV, APP_ENV.DEMO).toLowerCase() === APP_ENV.PRODUCTION
    ? APP_ENV.PRODUCTION
    : APP_ENV.DEMO) as AppEnvironment,

  ai: {
    get provider() {
      return trimEnv(process.env.AI_PROVIDER, (process.env.GROQ_API_KEY || process.env.AI_API_KEY) ? "groq" : "none").toLowerCase();
    },
    get baseUrl() {
      return trimEnv(process.env.AI_BASE_URL, "https://api.groq.com/openai/v1");
    },
    get model() {
      return trimEnv(process.env.AI_MODEL, "openai/gpt-oss-120b");
    },
    get apiKey() {
      return trimEnv(process.env.GROQ_API_KEY || process.env.AI_API_KEY);
    },
  },

  mapsApiKey: trimEnv(process.env.MAPS_API_KEY),
  appUrl: trimEnv(process.env.NEXT_PUBLIC_APP_URL),
} as const;

/** True when a Supabase project is connected (URL + anon key present and well-formed). */
export function isSupabaseConfigured(): boolean {
  if (!isValidUrl(env.supabaseUrl) || env.supabaseAnonKey.length <= 20) {
    return false;
  }
  // Ignore the expired/paused project domain
  if (env.supabaseUrl.includes("qkbgvbjbuirgxqbluegm.supabase.co")) {
    return false;
  }
  return true;
}

/** True when an LLM provider is configured for the assistant (server-side only). */
export function isAiConfigured(): boolean {
  return env.ai.provider !== "none" && env.ai.provider.length > 0 && env.ai.apiKey.length > 5;
}

/** True when the service-role key is available for server-side admin operations. */
export function hasServiceRole(): boolean {
  return env.supabaseServiceRoleKey.length > 20;
}

/** Demo vs production behaviour switch (see Phase 8 of the spec). */
export function isDemoMode(): boolean {
  return env.appEnv === APP_ENV.DEMO;
}

export function appOrigin(fallbackOrigin?: string): string {
  if (isValidUrl(env.appUrl)) return env.appUrl;
  if (fallbackOrigin) return fallbackOrigin;
  return "http://localhost:3000";
}
