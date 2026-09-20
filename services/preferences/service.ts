import type { SupabaseClient } from "@supabase/supabase-js";

export interface UserPreferences {
  userId: string;
  theme: "system" | "light" | "dark";
  soundEnabled: boolean;
  notifyAppointments: boolean;
  notifyQueue: boolean;
  notifyPrescriptions: boolean;
  notifyFollowups: boolean;
  notifyReminders: boolean;
  anonymousReviews: boolean;
  publicFee: boolean;
  showEmergencyContact: boolean;
  aiAssistantEnabled: boolean;
  aiResponseLength: "concise" | "detailed";
}

export const DEFAULT_PREFERENCES: Omit<UserPreferences, "userId"> = {
  theme: "system",
  soundEnabled: false,
  notifyAppointments: true,
  notifyQueue: true,
  notifyPrescriptions: true,
  notifyFollowups: true,
  notifyReminders: true,
  anonymousReviews: false,
  publicFee: true,
  showEmergencyContact: true,
  aiAssistantEnabled: true,
  aiResponseLength: "concise",
};

interface DbPreferencesRow {
  user_id: string;
  theme: "system" | "light" | "dark";
  sound_enabled: boolean;
  notify_appointments: boolean;
  notify_queue: boolean;
  notify_prescriptions: boolean;
  notify_followups: boolean;
  notify_reminders: boolean;
  anonymous_reviews: boolean;
  public_fee: boolean;
  show_emergency_contact: boolean;
  ai_assistant_enabled: boolean;
  ai_response_length: "concise" | "detailed";
}

export async function getUserPreferences(
  client: SupabaseClient,
  userId: string
): Promise<UserPreferences> {
  const { data, error } = await client
    .from("user_preferences")
    .select("*")
    .eq("user_id", userId)
    .maybeSingle();

  if (error || !data) {
    return {
      userId,
      ...DEFAULT_PREFERENCES,
    };
  }

  const row = data as unknown as DbPreferencesRow;
  return {
    userId: row.user_id,
    theme: row.theme ?? "system",
    soundEnabled: row.sound_enabled ?? false,
    notifyAppointments: row.notify_appointments ?? true,
    notifyQueue: row.notify_queue ?? true,
    notifyPrescriptions: row.notify_prescriptions ?? true,
    notifyFollowups: row.notify_followups ?? true,
    notifyReminders: row.notify_reminders ?? true,
    anonymousReviews: row.anonymous_reviews ?? false,
    publicFee: row.public_fee ?? true,
    showEmergencyContact: row.show_emergency_contact ?? true,
    aiAssistantEnabled: row.ai_assistant_enabled ?? true,
    aiResponseLength: row.ai_response_length ?? "concise",
  };
}
