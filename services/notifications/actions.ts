"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { getSessionUser } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import { markAllNotificationsRead, markNotificationRead } from "@/services/notifications/service";

/** Mark one notification as read (own rows only — RLS enforced). */
export async function markNotificationReadAction(notificationId: string): Promise<ActionResult> {
  try {
    const user = await getSessionUser();
    if (!user) return { ok: false, error: "Please sign in again." };
    const supabase = await createClient();
    await markNotificationRead(supabase, user.id, notificationId);
    revalidatePath("/patient/notifications");
    revalidatePath("/doctor/notifications");
    revalidatePath("/staff/notifications");
    revalidatePath("/admin/notifications");
    return { ok: true };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/** Mark every unread notification as read. */
export async function markAllNotificationsReadAction(): Promise<ActionResult<{ updated: number }>> {
  try {
    const user = await getSessionUser();
    if (!user) return { ok: false, error: "Please sign in again." };
    const supabase = await createClient();
    const updated = await markAllNotificationsRead(supabase, user.id);
    revalidatePath("/patient/notifications");
    revalidatePath("/doctor/notifications");
    revalidatePath("/staff/notifications");
    revalidatePath("/admin/notifications");
    return { ok: true, data: { updated } };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
