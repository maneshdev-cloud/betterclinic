import "server-only";
import { cookies } from "next/headers";
import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { env, isSupabaseConfigured } from "@/lib/env";
import { AppError } from "@/lib/errors";
import { HIDE_DEMO_COOKIE, TABLES_WITH_SYNTHETIC } from "@/lib/demo";

export interface CreateClientOptions {
  bypassHideDemo?: boolean;
  clientIp?: string;
}

/**
 * Server-side Supabase client bound to the request's cookies.
 * Use in Server Components, Server Actions and Route Handlers.
 * When "Hide demo data" mode is active, automatically excludes synthetic rows on SELECTs.
 */
export async function createClient(options: CreateClientOptions = {}) {
  if (!isSupabaseConfigured()) {
    throw new AppError("SUPABASE_NOT_CONFIGURED");
  }
  const cookieStore = cookies();
  const hideDemo = !options.bypassHideDemo && cookieStore.get(HIDE_DEMO_COOKIE)?.value === "true";

  const client = createServerClient(env.supabaseUrl, env.supabaseAnonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
          // Called from a Server Component — middleware refreshes the session.
        }
      },
    },
    global: {
      headers: options.clientIp ? { "x-client-ip": options.clientIp } : {},
    },
  });

  if (hideDemo) {
    const originalFrom = client.from.bind(client);
    client.from = (table: string) => {
      const qb = originalFrom(table);
      if (!TABLES_WITH_SYNTHETIC.has(table)) {
        return qb;
      }
      const originalSelect = qb.select.bind(qb);
      qb.select = (...args: any[]) => {
        const fb = (originalSelect as any)(...args);
        return fb.eq("is_synthetic", false);
      };
      return qb;
    };
  }

  return client;
}
