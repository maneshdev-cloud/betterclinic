import "server-only";
import { cookies } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { HIDE_DEMO_COOKIE, TABLES_WITH_SYNTHETIC } from "@/lib/demo-constants";

export { HIDE_DEMO_COOKIE, TABLES_WITH_SYNTHETIC };

/**
 * Returns whether the global "Hide demo data" mode is currently active.
 */
export function isHideDemoEnabled(): boolean {
  try {
    const cookieStore = cookies();
    return cookieStore.get(HIDE_DEMO_COOKIE)?.value === "true";
  } catch {
    return false;
  }
}

/**
 * Verifies that the current authenticated user is the designated developer.
 */
export async function verifyDeveloperAccess() {
  const devEmail = process.env.DEVELOPER_EMAIL?.trim().toLowerCase();
  if (!devEmail) {
    return { authorized: false, reason: "DEVELOPER_EMAIL environment variable is not configured." };
  }

  const supabase = await createClient({ bypassHideDemo: true });
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user || !user.email || user.email.trim().toLowerCase() !== devEmail) {
    return { authorized: false, reason: "Unauthorized: Account email does not match allowlist." };
  }

  return { authorized: true, user };
}

/**
 * Fetch platform stats from the database function get_platform_stats(p_hide_demo).
 * Verifies developer access first, then uses privileged service-role admin client.
 */
export async function getPlatformStats(hideDemo?: boolean) {
  const auth = await verifyDeveloperAccess();
  if (!auth.authorized) {
    throw new Error(auth.reason || "Unauthorized: Developer access required.");
  }

  const shouldHide = hideDemo !== undefined ? hideDemo : isHideDemoEnabled();
  const adminClient = createAdminClient();
  const { data, error } = await adminClient.rpc("get_platform_stats", {
    p_hide_demo: shouldHide,
  });

  if (error) {
    throw new Error(`Failed to fetch platform statistics: ${error.message}`);
  }

  return data;
}
