import type { Metadata } from "next";
import { SettingsView, type InviteCodeItem } from "@/components/settings/settings-view";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getUserPreferences } from "@/services/preferences/service";
import { LinkClinicModal } from "@/components/doctor/link-clinic-modal";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Building2 } from "lucide-react";

export const metadata: Metadata = { title: "Settings" };

export default async function DoctorSettingsPage() {
  const user = await requireRole(["DOCTOR"], "/doctor/settings");
  const supabase = await createClient();

  const [profileRow, preferences, doctorClinicsRes, allClinicsRes] = await Promise.all([
    supabase.from("profiles").select("avatar_url").eq("id", user.id).single(),
    getUserPreferences(supabase, user.id),
    supabase
      .from("doctor_clinics")
      .select("clinic_id, clinics (id, name, city, area)")
      .eq("doctor_id", user.id),
    supabase
      .from("clinics")
      .select("id, name, city, area")
      .eq("is_active", true)
      .order("name"),
  ]);

  const avatarUrl = (profileRow.data as { avatar_url: string | null } | null)?.avatar_url ?? null;
  const doctorClinics = doctorClinicsRes.data;
  const allClinics = (allClinicsRes.data as { id: string; name: string; city: string; area: string }[]) ?? [];

  let inviteCodes: InviteCodeItem[] = [];
  const affiliatedClinics: { id: string; name: string; city: string; area: string }[] = [];

  if (doctorClinics && doctorClinics.length > 0) {
    const clinicIds = doctorClinics.map((dc) => dc.clinic_id);
    const { data: codes } = await supabase
      .from("clinic_invite_codes")
      .select("clinic_id, code, doctor_code")
      .in("clinic_id", clinicIds);

    doctorClinics.forEach((dc) => {
      const clinic = (dc as unknown as { clinics: { id: string; name: string; city: string; area: string } | null }).clinics;
      if (clinic) {
        affiliatedClinics.push(clinic);
      }
      if (codes) {
        const matchingCode = codes.find((c) => c.clinic_id === dc.clinic_id);
        inviteCodes.push({
          clinicId: dc.clinic_id,
          clinicName: clinic?.name ?? "Clinic",
          clinicCity: clinic?.city ?? "",
          code: matchingCode?.code ?? "—",
          doctorCode: matchingCode?.doctor_code ?? null,
        });
      }
    });
  }

  const clinicsSection = (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between pb-3">
        <div>
          <CardTitle className="text-base font-semibold">Affiliated Clinics</CardTitle>
          <CardDescription className="text-xs">
            Clinics where you practice, consult, and manage queues.
          </CardDescription>
        </div>
        <LinkClinicModal clinics={allClinics} triggerText="Add Clinic" triggerVariant="outline" />
      </CardHeader>
      <CardContent>
        {affiliatedClinics.length === 0 ? (
          <div className="rounded-lg border border-dashed p-4 text-center space-y-2">
            <Building2 className="mx-auto h-8 w-8 text-muted-foreground/60" />
            <p className="text-sm font-medium text-muted-foreground">No clinics affiliated yet</p>
            <p className="text-xs text-muted-foreground max-w-sm mx-auto">
              Link your profile to an existing clinic with an invite code, or register a new clinic for your practice.
            </p>
            <div className="pt-1">
              <LinkClinicModal clinics={allClinics} triggerText="Link or Register Clinic" triggerVariant="default" />
            </div>
          </div>
        ) : (
          <div className="space-y-2.5">
            {affiliatedClinics.map((c) => (
              <div key={c.id} className="flex items-center justify-between rounded-lg border p-3">
                <div>
                  <p className="text-sm font-semibold">{c.name}</p>
                  <p className="text-xs text-muted-foreground">
                    {c.area}, {c.city}
                  </p>
                </div>
                <span className="rounded bg-primary/10 px-2 py-0.5 text-[10px] font-medium text-primary border border-primary/20">
                  Active Affiliation
                </span>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );

  return (
    <SettingsView
      userId={user.id}
      avatarUrl={avatarUrl}
      fullName={user.fullName}
      email={user.email}
      phone={user.phone}
      role="DOCTOR"
      patient={null}
      inviteCodes={inviteCodes}
      preferences={preferences}
      clinicsSection={clinicsSection}
    />
  );
}

