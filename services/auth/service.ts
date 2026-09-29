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
  try {
    const supabase = await createClient();
    const {
      data: { user },
    } = await withRetry(() => supabase.auth.getUser());
    if (!user) return null;

    const [{ data: profile }, { data: rolesRows }] = await withRetry(
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
    );

    const roles: Role[] =
      rolesRows && rolesRows.length > 0
        ? (rolesRows.map((r) => r.role as Role).filter(Boolean))
        : [((profile?.role ?? user.app_metadata?.role ?? "PATIENT") as Role) ?? "PATIENT"];

    // Determine active role:
    // 1. From active role cookie if set and valid for this user
    // 2. Default to first role in roles list
    const cookieStore = cookies();
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
