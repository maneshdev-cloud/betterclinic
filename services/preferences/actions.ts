"use server";

import { cookies } from "next/headers";
import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { getSessionUser } from "@/services/auth/service";
import { AppError, toAppError } from "@/lib/errors";
import type { UserPreferences } from "./service";

export async function updateUserPreferencesAction(
  updates: Partial<Omit<UserPreferences, "userId">>
): Promise<{ ok: boolean; error?: string }> {
  try {
    const user = await getSessionUser();
    if (!user) {
      throw new AppError("UNAUTHENTICATED", "You must be signed in to update preferences.");
    }
    const supabase = await createClient();

    const dbPayload: Record<string, unknown> = {
      user_id: user.id,
      updated_at: new Date().toISOString(),
    };

    if (updates.theme !== undefined) {
      dbPayload.theme = updates.theme;
      const cookieStore = cookies();
      cookieStore.set("bc_theme", updates.theme, { path: "/", maxAge: 60 * 60 * 24 * 365 });
    }
    if (updates.soundEnabled !== undefined) dbPayload.sound_enabled = updates.soundEnabled;
    if (updates.notifyAppointments !== undefined) dbPayload.notify_appointments = updates.notifyAppointments;
    if (updates.notifyQueue !== undefined) dbPayload.notify_queue = updates.notifyQueue;
    if (updates.notifyPrescriptions !== undefined) dbPayload.notify_prescriptions = updates.notifyPrescriptions;
    if (updates.notifyFollowups !== undefined) dbPayload.notify_followups = updates.notifyFollowups;
    if (updates.notifyReminders !== undefined) dbPayload.notify_reminders = updates.notifyReminders;
    if (updates.anonymousReviews !== undefined) dbPayload.anonymous_reviews = updates.anonymousReviews;
    if (updates.publicFee !== undefined) dbPayload.public_fee = updates.publicFee;
    if (updates.showEmergencyContact !== undefined) dbPayload.show_emergency_contact = updates.showEmergencyContact;
    if (updates.aiAssistantEnabled !== undefined) dbPayload.ai_assistant_enabled = updates.aiAssistantEnabled;
    if (updates.aiResponseLength !== undefined) dbPayload.ai_response_length = updates.aiResponseLength;

    const { error } = await supabase
      .from("user_preferences")
      .upsert(dbPayload, { onConflict: "user_id" });

    if (error) {
      console.error("[updateUserPreferencesAction] upsert error:", error);
      return { ok: false, error: toAppError(error).userMessage };
    }

    revalidatePath("/", "layout");
    return { ok: true };
  } catch (err) {
    console.error("[updateUserPreferencesAction] error:", err);
    return { ok: false, error: toAppError(err).userMessage };
  }
}
