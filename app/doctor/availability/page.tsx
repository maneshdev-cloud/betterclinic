import type { Metadata } from "next";
import { PageHeader } from "@/components/shared/page-header";
import { Card, CardContent } from "@/components/ui/card";
import { AvailabilityEditor } from "@/components/availability/availability-editor";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getDoctorClinicOptions } from "@/services/availability/service";
import { getDoctorAvailability } from "@/services/doctors/service";

export const metadata: Metadata = { title: "My availability" };

export default async function DoctorAvailabilityPage() {
  const user = await requireRole(["DOCTOR"], "/doctor/availability");
  const supabase = await createClient();

  const [clinics, availabilityRows] = await Promise.all([
    getDoctorClinicOptions(supabase, user.id),
    getDoctorAvailability(supabase, user.id),
  ]);

  const initialByClinic: Record<string, typeof availabilityRows> = {};
  for (const row of availabilityRows) {
    (initialByClinic[row.clinic_id] ??= []).push(row);
  }

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My availability"
        description="Set your weekly schedule per clinic. Patients see free slots generated from these times — nothing is auto-created."
      />

      <Card>
        <CardContent className="p-4 text-sm text-muted-foreground">
          <p className="font-medium text-foreground">How this works</p>
          <ul className="mt-1.5 list-inside list-disc space-y-1">
            <li>Enable a day, set the working window, an optional break, and the slot length.</li>
            <li>Slots are generated on demand for the next 60 days when a patient opens your profile.</li>
            <li>Saving keeps every already-booked slot; only unbooked future slots are rebuilt.</li>
          </ul>
        </CardContent>
      </Card>

      <AvailabilityEditor clinics={clinics} initialByClinic={initialByClinic} />
    </div>
  );
}
