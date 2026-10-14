import { AppShell } from "@/components/layout/app-shell";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";
import { requireRole } from "@/services/auth/service";

export const dynamic = "force-dynamic";

export default async function PatientLayout({ children }: { children: React.ReactNode }) {
  const user = await requireRole(["PATIENT"], "/patient");

  return (
    <AppShell
      userName={user.fullName}
      userEmail={user.email}
      userRole={user.role}
      avatarUrl={user.avatarUrl}
      settingsHref="/patient/settings"
      availableRoles={user.roles}
      userId={user.id}
      notificationsHref="/patient/notifications"
    >
      {children}
    </AppShell>
  );
}
