import type { Metadata } from "next";
import { SettingsView, type InviteCodeItem } from "@/components/settings/settings-view";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getUserPreferences } from "@/services/preferences/service";
import { getStaffClinicContext, getClinicInviteCodes } from "@/services/clinics/service";

export const metadata: Metadata = { title: "Settings" };

export default async function AdminSettingsPage() {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin/settings");
  const supabase = await createClient();

  const [preferences, clinic] = await Promise.all([
    getUserPreferences(supabase, user.id),
    getStaffClinicContext(user.id),
  ]);

  const avatarUrl = user.avatarUrl;

  let inviteCodes: InviteCodeItem[] = [];
  if (clinic) {
    const codes = await getClinicInviteCodes(clinic.id);
    inviteCodes = [
      {
        clinicId: clinic.id,
        clinicName: clinic.name,
        clinicCity: clinic.city,
        code: codes.staffCode ?? "—",
        doctorCode: codes.doctorCode,
        adminClaimCode: codes.adminClaimCode,
      },
    ];
  }

  return (
    <SettingsView
      userId={user.id}
      avatarUrl={avatarUrl}
      fullName={user.fullName}
      email={user.email}
      phone={user.phone}
      role="CLINIC_ADMIN"
      patient={null}
      inviteCodes={inviteCodes}
      preferences={preferences}
    />
  );
}
