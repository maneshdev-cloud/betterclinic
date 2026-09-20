import { createBrowserClient } from "@supabase/ssr";
import { env, isSupabaseConfigured } from "@/lib/env";
import { AppError } from "@/lib/errors";

/**
 * Browser-side Supabase client (anon key only — never the service role key).
 * Uses the @supabase/ssr cookie-pkce flow so the session survives reloads
 * and stays in sync with the server.
 */
export function createClient() {
  if (!isSupabaseConfigured()) {
    throw new AppError("SUPABASE_NOT_CONFIGURED");
  }
  return createBrowserClient(env.supabaseUrl, env.supabaseAnonKey);
}
