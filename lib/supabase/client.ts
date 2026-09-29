import { createBrowserClient } from "@supabase/ssr";
import { env, isSupabaseConfigured } from "@/lib/env";
import { AppError } from "@/lib/errors";
import { retryFetch } from "@/lib/network/with-retry";

/**
 * Browser-side Supabase client (anon key only — never the service role key).
 * Uses the @supabase/ssr cookie-pkce flow so the session survives reloads
 * and stays in sync with the server.
 * Network calls are wrapped with retryFetch for transient network resilience.
 */
let browserClient: ReturnType<typeof createBrowserClient> | null = null;

export function createClient() {
  if (!isSupabaseConfigured()) {
    throw new AppError("SUPABASE_NOT_CONFIGURED");
  }
  if (!browserClient) {
    browserClient = createBrowserClient(env.supabaseUrl, env.supabaseAnonKey, {
      global: {
        fetch: retryFetch,
      },
    });
  }
  return browserClient;
}
