"use server";

import { cookies } from "next/headers";
import { revalidatePath } from "next/cache";
import { HIDE_DEMO_COOKIE } from "@/lib/demo-constants";
import { verifyDeveloperAccess } from "@/lib/demo";
import { createAdminClient } from "@/lib/supabase/admin";

/**
 * Server action to toggle the hide demo data cookie.
 */
export async function toggleHideDemoAction(enable: boolean) {
  const cookieStore = cookies();
  if (enable) {
    cookieStore.set(HIDE_DEMO_COOKIE, "true", {
      path: "/",
      maxAge: 60 * 60 * 24 * 30, // 30 days
      httpOnly: false,
      sameSite: "lax",
    });
  } else {
    cookieStore.set(HIDE_DEMO_COOKIE, "false", {
      path: "/",
      maxAge: 0,
    });
  }

  revalidatePath("/", "layout");
  return { success: true, hideDemo: enable };
}

/**
 * Server action to execute scoped deletion of all synthetic rows.
 * Requires confirmation phrase "Better Clinic" and strict developer authentication.
 * 1. App-level identity check (verifyDeveloperAccess)
 * 2. Confirmation phrase check
 * 3. Privileged database call via createAdminClient()
 */
export async function deleteDemoDataAction(confirmationPhrase: string) {
  const auth = await verifyDeveloperAccess();
  if (!auth.authorized) {
    return { success: false, error: auth.reason };
  }

  if (confirmationPhrase.trim().toLowerCase() !== "better clinic") {
    return {
      success: false,
      error: 'Confirmation phrase mismatch. Please type "Better Clinic" exactly to confirm.',
    };
  }

  const adminClient = createAdminClient();
  const { data, error } = await adminClient.rpc("purge_synthetic_data");

  if (error) {
    return { success: false, error: error.message };
  }

  revalidatePath("/", "layout");
  return { success: true, report: data };
}
