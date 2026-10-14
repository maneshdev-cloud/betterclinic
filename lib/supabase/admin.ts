import "server-only";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { env, hasServiceRole, isSupabaseConfigured } from "@/lib/env";
import { AppError } from "@/lib/errors";

/**
 * Admin (service-role) client — SERVER ONLY.
 *
 * The service-role key bypasses Row Level Security. It is used exclusively
 * for trusted server-side operations (e.g. creating staff accounts from the
 * clinic-admin dashboard) and never ships to the browser: this module is
 * guarded by the `server-only` package and the key comes from a
 * non-NEXT_PUBLIC environment variable.
 */
import { createMockClient } from "./mock-client";

export function createAdminClient() {
  if (!isSupabaseConfigured() || !hasServiceRole()) {
    return createMockClient();
  }
  return createSupabaseClient(env.supabaseUrl, env.supabaseServiceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
