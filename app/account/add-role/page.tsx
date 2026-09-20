import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { requireUser } from "@/services/auth/service";
import { createClient } from "@/lib/supabase/server";
import { ROLES, type Role } from "@/lib/constants";
import { AddRoleForm } from "./add-role-form";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";

export const metadata: Metadata = {
  title: "Add Another Role · Better Clinic",
};
export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function AddRolePage() {
  const user = await requireUser("/account/add-role");

  const existingRoles = user.roles;
  const availableRoles = (ROLES as readonly Role[]).filter((r) => !existingRoles.includes(r));

  const supabase = await createClient();
  const [specResult, clinicResult] = await Promise.all([
    supabase.from("specializations").select("id, name").order("name"),
    supabase.from("clinics").select("id, name, city").eq("is_active", true).order("name").limit(100),
  ]);

  const specializations = (specResult.data as { id: string; name: string }[]) ?? [];
  const clinics = (clinicResult.data as { id: string; name: string; city: string }[]) ?? [];

  return (
    <div className="min-h-screen bg-muted/20 py-10 px-4 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-2xl space-y-6">
        <div>
          <Link
            href="/"
            className="inline-flex items-center gap-1.5 text-xs font-medium text-muted-foreground hover:text-foreground mb-4 transition-colors"
          >
            <ArrowLeft className="h-3.5 w-3.5" />
            Back to dashboard
          </Link>
          <h1 className="text-2xl font-bold tracking-tight text-foreground">Add Another Role</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Expand your Better Clinic access. Add a new role to your existing account without creating a new login.
          </p>
        </div>

        <AddRoleForm
          existingRoles={existingRoles}
          availableRoles={availableRoles}
          specializations={specializations}
          clinics={clinics}
        />
      </div>
    </div>
  );
}
