import { AppShell } from "@/components/layout/app-shell";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";

export const dynamic = "force-dynamic";

export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  if (!isSupabaseConfigured()) {
    return (
      <div className="page-container py-10">
        <SetupNotice />
      </div>
    );
  }

  const user = await requireRole(["CLINIC_ADMIN"], "/admin");
  const clinic = await getStaffClinicContext(user.id);

  return (
    <AppShell
      userName={user.fullName}
      userEmail={user.email}
      userRole={user.role}
      avatarUrl={user.avatarUrl}
      settingsHref="/admin/settings"
      availableRoles={user.roles}
      userId={user.id}
      notificationsHref="/admin/notifications"
      contextLabel={clinic ? clinic.name : "No clinic assigned"}
    >
      {children}
    </AppShell>
  );
}
