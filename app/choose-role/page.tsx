import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { requireUser } from "@/services/auth/service";
import { roleHomePath, ROLE_LABELS, type Role } from "@/lib/constants";
import { switchRoleAction } from "@/app/(auth)/actions";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Building2, Stethoscope, User, Users, ArrowRight } from "lucide-react";

export const metadata: Metadata = {
  title: "Select your role · Better Clinic",
};
export const dynamic = "force-dynamic";
export const revalidate = 0;

const ROLE_DETAILS: Record<
  Role,
  { title: string; description: string; icon: React.ComponentType<{ className?: string }> }
> = {
  PATIENT: {
    title: "Patient",
    description: "Book appointments, track live queue tokens, and view medical records.",
    icon: User,
  },
  DOCTOR: {
    title: "Doctor",
    description: "Manage consultations, write prescriptions, and call patients from the queue.",
    icon: Stethoscope,
  },
  RECEPTIONIST: {
    title: "Receptionist",
    description: "Check in patients, issue queue tokens, and coordinate clinic flow.",
    icon: Users,
  },
  CLINIC_ADMIN: {
    title: "Clinic Administrator",
    description: "Manage clinic hours, onboard doctors and staff, and view operational analytics.",
    icon: Building2,
  },
};

export default async function ChooseRolePage() {
  const user = await requireUser("/choose-role");

  // If user only has one role, skip straight to their dashboard
  if (user.roles.length <= 1) {
    redirect(roleHomePath(user.role));
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-muted/20 px-4 py-12">
      <div className="w-full max-w-lg space-y-6">
        <div className="text-center">
          <h1 className="text-2xl font-bold tracking-tight">Choose your workspace</h1>
          <p className="mt-2 text-sm text-muted-foreground">
            Welcome, <strong>{user.fullName}</strong>. Your account has multiple active roles. Select which
            workspace you want to use for this session.
          </p>
        </div>

        <div className="space-y-3">
          {user.roles.map((r) => {
            const info = ROLE_DETAILS[r];
            const Icon = info.icon;
            const isCurrent = user.role === r;

            return (
              <Card
                key={r}
                className={`transition-all hover:border-primary hover:shadow-md ${
                  isCurrent ? "border-primary/60 bg-primary/5" : ""
                }`}
              >
                <CardContent className="p-4 flex items-center justify-between gap-4">
                  <div className="flex items-start gap-3.5">
                    <div className="rounded-lg bg-primary/10 p-2 text-primary shrink-0">
                      <Icon className="h-5 w-5" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <p className="font-semibold text-sm">{info.title}</p>
                        {isCurrent ? (
                          <span className="rounded bg-primary/20 px-1.5 py-0.2 text-[10px] font-medium text-primary">
                            Current
                          </span>
                        ) : null}
                      </div>
                      <p className="text-xs text-muted-foreground mt-0.5">{info.description}</p>
                    </div>
                  </div>

                  <form
                    action={async () => {
                      "use server";
                      await switchRoleAction(r);
                    }}
                  >
                    <Button size="sm" variant={isCurrent ? "default" : "outline"} className="shrink-0 gap-1">
                      Continue
                      <ArrowRight className="h-3.5 w-3.5" />
                    </Button>
                  </form>
                </CardContent>
              </Card>
            );
          })}
        </div>

        <p className="text-center text-xs text-muted-foreground">
          You can switch between your roles anytime using the profile menu in the top navigation.
        </p>
      </div>
    </div>
  );
}
