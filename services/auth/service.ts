import "server-only";
import { cache } from "react";
import { cookies } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { roleHomePath, type Role } from "@/lib/constants";
import type { Profile } from "@/lib/types/database";
import { withRetry } from "@/lib/network/with-retry";

export interface SessionUser {
  id: string;
  email: string;
  role: Role;
  roles: Role[];
  fullName: string;
  phone: string | null;
  avatarUrl: string | null;
  profile: Profile | null;
}

/**
 * Returns the signed-in user with their profile and all active roles.
 * Wrapped in React cache() so it executes at most once per server request,
 * eliminating redundant auth round-trips and profile queries.
 * Network queries are protected with withRetry against transient glitches.
 */
export const getSessionUser = cache(async (): Promise<SessionUser | null> => {
  const cookieStore = cookies();

  // 1. Check for Demo User Session Cookie
  const demoCookie = cookieStore.get("bc_demo_user");
  if (demoCookie?.value) {
    try {
      let rawVal = demoCookie.value;
      try {
        rawVal = decodeURIComponent(rawVal);
      } catch {}
      const demoUser = JSON.parse(rawVal);
      if (demoUser && demoUser.id && demoUser.role) {
        const activeCookieRole = cookieStore.get("bc_active_role")?.value as Role | undefined;
        const roles = Array.isArray(demoUser.roles) && demoUser.roles.length > 0
          ? (demoUser.roles as Role[])
          : [demoUser.role as Role];
        const activeRole =
          activeCookieRole && roles.includes(activeCookieRole)
            ? activeCookieRole
            : demoUser.role;

        return {
          id: demoUser.id,
          email: demoUser.email || "demo@betterclinic.app",
          role: activeRole,
          roles,
          fullName: demoUser.fullName || demoUser.full_name || "Demo User",
          phone: demoUser.phone || null,
          avatarUrl: demoUser.avatarUrl || demoUser.avatar_url || null,
          profile: demoUser.profile || {
            id: demoUser.id,
            role: activeRole,
            full_name: demoUser.fullName || demoUser.full_name || "Demo User",
            email: demoUser.email || "demo@betterclinic.app",
            phone: demoUser.phone || null,
            avatar_url: demoUser.avatarUrl || null,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          } as any,
        };
      }
    } catch {
      // invalid demo cookie, fall through
    }
  }

  // 2. If Supabase is not configured, no further session lookup
  const { isSupabaseConfigured } = await import("@/lib/env");
  if (!isSupabaseConfigured()) {
    return null;
  }

  try {
    const supabase = await createClient();
    const authRes = (await withRetry(() => supabase.auth.getUser(), { retries: 1, backoffs: [150] })) as any;
    const user = authRes?.data?.user;
    if (!user) return null;

    const [{ data: profile }, { data: rolesRows }] = (await withRetry(
      () =>
        Promise.all([
          supabase
            .from("profiles")
            .select("*")
            .eq("id", user.id)
            .single(),
          supabase.from("profile_roles").select("role").eq("profile_id", user.id),
        ]),
      { retries: 1, backoffs: [150] }
    )) as any;

    const roles: Role[] =
      rolesRows && rolesRows.length > 0
        ? ((rolesRows as { role: Role }[]).map((r) => r.role as Role).filter(Boolean))
        : [((profile?.role ?? user.app_metadata?.role ?? "PATIENT") as Role) ?? "PATIENT"];

    const activeCookieRole = cookieStore.get("bc_active_role")?.value as Role | undefined;
    const activeRole =
      activeCookieRole && roles.includes(activeCookieRole)
        ? activeCookieRole
        : roles[0] ?? "PATIENT";

    return {
      id: user.id,
      email: user.email ?? "",
      role: activeRole,
      roles,
      fullName: profile?.full_name ?? user.email?.split("@")[0] ?? "User",
      phone: profile?.phone ?? null,
      avatarUrl: profile?.avatar_url ?? null,
      profile: profile ?? null,
    };
  } catch {
    return null;
  }
});

/** Redirects to /login (with a return path) when not signed in. */
export async function requireUser(nextPath?: string): Promise<SessionUser> {
  const user = await getSessionUser();
  if (!user) {
    redirect(nextPath ? `/login?next=${encodeURIComponent(nextPath)}` : "/login");
  }
  return user;
}

/**
 * Guards a role area: unauthenticated → /login; wrong role → their own
 * home. The middleware does a fast JWT-claim pre-check; this is the
 * database-backed verification inside every role layout.
 *
 * If the user holds the required role in `user.roles`, allows access.
 */
export async function requireRole(roles: Role[], nextPath?: string): Promise<SessionUser> {
  const user = await requireUser(nextPath);

  // If current active role matches, proceed
  if (roles.includes(user.role)) {
    return user;
  }

  // If user possesses one of the allowed roles, auto-adapt active role for this request
  const matchingRole = user.roles.find((r) => roles.includes(r));
  if (matchingRole) {
    return { ...user, role: matchingRole };
  }

  // User does not have any of the required roles
  redirect(roleHomePath(user.role));
}
