import { AppShell } from "@/components/layout/app-shell";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";

export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function StaffLayout({ children }: { children: React.ReactNode }) {
  if (!isSupabaseConfigured()) {
    return (
      <div className="page-container py-10">
        <SetupNotice />
      </div>
    );
  }

  const user = await requireRole(["RECEPTIONIST"], "/staff");
  const clinic = await getStaffClinicContext(user.id);

  return (
    <AppShell
      userName={user.fullName}
      userEmail={user.email}
      userRole={user.role}
      avatarUrl={user.avatarUrl}
      settingsHref="/staff/settings"
      availableRoles={user.roles}
      userId={user.id}
      notificationsHref="/staff/notifications"
      contextLabel={clinic ? clinic.name : "No clinic assigned"}
    >
      {children}
    </AppShell>
  );
}
