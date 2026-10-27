import type { Metadata } from "next";
import { Users } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { UserAvatar } from "@/components/shared/user-avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { CopyButton } from "@/components/shared/copy-button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext, getClinicInviteCode } from "@/services/clinics/service";
import { listClinicStaff } from "@/services/admin/service";
import { formatDate } from "@/lib/utils";

export const metadata: Metadata = { title: "Staff" };

/**
 * Staff accounts linked to this clinic (read-only). New staff create
 * their own account at signup using the clinic invite code — accounts
 * are never created or edited here.
 */
export default async function AdminStaffPage() {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin/staff");
  const clinic = await getStaffClinicContext(user.id);

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <PageHeader title="Staff" description="No clinic is linked to this admin account." />
      </div>
    );
  }

  const supabase = await createClient();
  const [staff, inviteCode] = await Promise.all([
    listClinicStaff(supabase, clinic.id),
    getClinicInviteCode(clinic.id),
  ]);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Clinic staff"
        description={`Receptionists and admins with access to ${clinic.name}.`}
      />

      <Card>
        <CardContent className="flex flex-wrap items-center justify-between gap-3 py-4">
          <div>
            <p className="text-sm font-medium">Invite code for new staff</p>
            <p className="text-xs text-muted-foreground">
              Receptionists enter this code at signup to link their account to this clinic.
            </p>
          </div>
          {inviteCode ? (
            <div className="flex items-center gap-2">
              <code className="rounded-md border bg-muted/50 px-3 py-2 text-sm font-semibold tracking-wide">
                {inviteCode}
              </code>
              <CopyButton value={inviteCode} />
            </div>
          ) : (
            <span className="text-sm text-muted-foreground">No invite code found.</span>
          )}
        </CardContent>
      </Card>

      {staff.length === 0 ? (
        <EmptyState
          icon={Users}
          title="No staff accounts yet"
          description="Share the invite code above — staff create their own accounts at signup."
        />
      ) : (
        <div className="space-y-3">
          {staff.map((member) => (
            <Card key={member.userId}>
              <CardContent className="flex flex-wrap items-center justify-between gap-4 py-4">
                <div className="flex min-w-0 items-center gap-3">
                  <UserAvatar name={member.name} size="lg" />
                  <div className="min-w-0">
                    <p className="font-medium">
                      {member.name}
                      {member.userId === user.id ? (
                        <span className="ml-2 text-xs text-muted-foreground">(you)</span>
                      ) : null}
                    </p>
                    <p className="truncate text-xs text-muted-foreground">
                      {member.email}
                      {member.phone ? ` · ${member.phone}` : ""}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <Badge variant={member.role === "CLINIC_ADMIN" ? "default" : "muted"}>
                    {member.role === "CLINIC_ADMIN" ? "Clinic admin" : "Receptionist"}
                  </Badge>
                  {!member.active ? <Badge variant="outline">Inactive</Badge> : null}
                  <div className="text-right text-xs text-muted-foreground">
                    <p>Member since {formatDate(member.memberSince.slice(0, 10))}</p>
                    <p>
                      {member.auditEvents} recorded action{member.auditEvents === 1 ? "" : "s"}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <p className="text-xs text-muted-foreground">
        Activity counts come from this clinic&apos;s audit log (capped at the most recent 2,000 events).
        Staff access revocations are managed via central clinic administration.
      </p>
    </div>
  );
}
