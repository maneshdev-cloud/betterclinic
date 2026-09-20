import type { Metadata } from "next";
import { SettingsView } from "@/components/settings/settings-view";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getUserPreferences } from "@/services/preferences/service";
import type { Patient } from "@/lib/types/database";

export const metadata: Metadata = { title: "Settings" };

export default async function PatientSettingsPage() {
  const user = await requireRole(["PATIENT"], "/patient/settings");
  const supabase = await createClient();

  const [profileRes, patientRes, preferences] = await Promise.all([
    supabase.from("profiles").select("avatar_url").eq("id", user.id).single(),
    supabase.from("patients").select("*").eq("id", user.id).maybeSingle(),
    getUserPreferences(supabase, user.id),
  ]);

  const avatarUrl = (profileRes.data as { avatar_url: string | null } | null)?.avatar_url ?? null;

  return (
    <SettingsView
      userId={user.id}
      avatarUrl={avatarUrl}
      fullName={user.fullName}
      email={user.email}
      phone={user.phone}
      role="PATIENT"
      patient={(patientRes.data as Patient) ?? null}
      preferences={preferences}
    />
  );
}
