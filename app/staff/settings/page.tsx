import type { Metadata } from "next";
import { SettingsView } from "@/components/settings/settings-view";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getUserPreferences } from "@/services/preferences/service";

export const metadata: Metadata = { title: "Settings" };

export default async function StaffSettingsPage() {
  const user = await requireRole(["RECEPTIONIST"], "/staff/settings");
  const supabase = await createClient();

  const preferences = await getUserPreferences(supabase, user.id);

  return (
    <SettingsView
      userId={user.id}
      avatarUrl={user.avatarUrl}
      fullName={user.fullName}
      email={user.email}
      phone={user.phone}
      role="RECEPTIONIST"
      patient={null}
      preferences={preferences}
    />
  );
}
