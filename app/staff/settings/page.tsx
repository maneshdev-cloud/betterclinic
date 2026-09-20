import type { Metadata } from "next";
import { SettingsView } from "@/components/settings/settings-view";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getUserPreferences } from "@/services/preferences/service";

export const metadata: Metadata = { title: "Settings" };

export default async function StaffSettingsPage() {
  const user = await requireRole(["RECEPTIONIST"], "/staff/settings");
  const supabase = await createClient();

  const [profileRow, preferences] = await Promise.all([
    supabase.from("profiles").select("avatar_url").eq("id", user.id).single(),
    getUserPreferences(supabase, user.id),
  ]);

  const avatarUrl = (profileRow.data as { avatar_url: string | null } | null)?.avatar_url ?? null;

  return (
    <SettingsView
      userId={user.id}
      avatarUrl={avatarUrl}
      fullName={user.fullName}
      email={user.email}
      phone={user.phone}
      role="RECEPTIONIST"
      patient={null}
      preferences={preferences}
    />
  );
}
