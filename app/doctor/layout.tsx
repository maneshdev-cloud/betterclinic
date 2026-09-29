import { AppShell } from "@/components/layout/app-shell";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";
import { requireRole } from "@/services/auth/service";

export const dynamic = "force-dynamic";

export default async function DoctorLayout({ children }: { children: React.ReactNode }) {
  if (!isSupabaseConfigured()) {
    return (
      <div className="page-container py-10">
        <SetupNotice />
      </div>
    );
  }

  const user = await requireRole(["DOCTOR"], "/doctor");

  return (
    <AppShell
      userName={user.fullName}
      userEmail={user.email}
      userRole={user.role}
      avatarUrl={user.avatarUrl}
      settingsHref="/doctor/settings"
      availableRoles={user.roles}
      userId={user.id}
      notificationsHref="/doctor/notifications"
    >
      {children}
    </AppShell>
  );
}
