import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { getSessionUser } from "@/services/auth/service";
import { roleHomePath, type Role } from "@/lib/constants";
import { WorkspaceSelector } from "@/components/auth/workspace-selector";

export const metadata: Metadata = {
  title: "Select your role · Better Clinic",
};
export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function ChooseRolePage() {
  const user = await getSessionUser();
  const allRoles: Role[] = ["PATIENT", "DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"];
  const roles = user && user.roles.length > 1 ? user.roles : allRoles;

  return (
    <div className="relative flex min-h-screen items-center justify-center bg-background px-4 py-12">
      <div className="pointer-events-none fixed inset-0 -z-10 medical-soft-bg" />
      <WorkspaceSelector
        roles={roles}
        currentRole={user?.role ?? "PATIENT"}
        userFullName={user?.fullName ?? "Healthcare Professional"}
      />
    </div>
  );
}
