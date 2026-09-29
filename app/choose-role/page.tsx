import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { requireUser } from "@/services/auth/service";
import { roleHomePath } from "@/lib/constants";
import { WorkspaceSelector } from "@/components/auth/workspace-selector";

export const metadata: Metadata = {
  title: "Select your role · Better Clinic",
};
export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function ChooseRolePage() {
  const user = await requireUser("/choose-role");

  // If user only has one role, skip straight to their dashboard
  if (user.roles.length <= 1) {
    redirect(roleHomePath(user.role));
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-muted/20 px-4 py-12">
      <WorkspaceSelector
        roles={user.roles}
        currentRole={user.role}
        userFullName={user.fullName}
      />
    </div>
  );
}
