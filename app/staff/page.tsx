import type { Metadata } from "next";

export const metadata: Metadata = { title: "Reception dashboard" };

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { CalendarDays } from "lucide-react";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";
import { formatDateWithDay } from "@/lib/utils";

export default async function StaffDashboard() {
  const user = await requireRole(["RECEPTIONIST"], "/staff");
  const clinic = await getStaffClinicContext(user.id);

  return (
    <div className="page-container space-y-6 py-8">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">Reception dashboard</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {formatDateWithDay(new Date())}
          {clinic ? ` · ${clinic.name}, ${clinic.city}` : ""}
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <CalendarDays className="h-4 w-4 text-primary" aria-hidden /> Today&apos;s operations
          </CardTitle>
          <CardDescription>
            Today&apos;s appointments, walk-in registration, check-in and the live token queue land
            here with the clinic-operations module (Phase 3). Nothing is simulated before that.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {!clinic ? (
            <p className="text-sm text-muted-foreground">
              You are not linked to a clinic yet — ask your clinic admin to add you.
            </p>
          ) : (
            <p className="text-sm text-muted-foreground">
              You are set up for <span className="font-medium text-foreground">{clinic.name}</span>.
              The live queue board and appointment management tools will appear on this page.
            </p>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
