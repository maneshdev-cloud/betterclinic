import type { Metadata } from "next";
import Link from "next/link";
import { Building2, MapPin, Phone, Mail, Clock, CalendarDays, Plus } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { LinkClinicModal } from "@/components/doctor/link-clinic-modal";

export const metadata: Metadata = { title: "My Clinics" };

export default async function DoctorClinicsPage() {
  const user = await requireRole(["DOCTOR"], "/doctor/clinics");
  const supabase = await createClient();

  const [{ data: doctorClinics }, { data: allClinicsData }] = await Promise.all([
    supabase
      .from("doctor_clinics")
      .select("clinic:clinics!inner(id, name, city, area, address_line, contact_phone, contact_email, facilities, avg_rating)")
      .eq("doctor_id", user.id),
    supabase
      .from("clinics")
      .select("id, name, city, area")
      .eq("is_active", true)
      .order("name"),
  ]);

  const clinics = ((doctorClinics ?? []) as unknown as { clinic: any }[]).map((row) => row.clinic);
  const allClinics = (allClinicsData as { id: string; name: string; city: string; area: string }[]) ?? [];

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Practising Clinics"
        description="View and manage the clinic locations where you consult and accept patient appointments."
        actions={
          <div className="flex items-center gap-2">
            <LinkClinicModal
              clinics={allClinics}
              triggerText="Link Clinic"
              triggerVariant="default"
            />
            <LinkClinicModal
              clinics={allClinics}
              triggerText="Register Clinic"
              triggerVariant="outline"
            />
          </div>
        }
      />

      {clinics.length === 0 ? (
        <EmptyState
          icon={Building2}
          title="Not linked to any clinics yet"
          description="Link to an existing healthcare facility using your invite code or register your own clinic."
          action={
            <LinkClinicModal
              clinics={allClinics}
              triggerText="Link or Register Clinic"
              triggerVariant="default"
            />
          }
        />
      ) : (
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {clinics.map((clinic) => (
            <Card key={clinic.id} className="flex flex-col justify-between hover:shadow-md transition-shadow">
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between gap-2">
                  <div className="flex items-center gap-2.5">
                    <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 text-primary shrink-0">
                      <Building2 className="h-5 w-5" />
                    </div>
                    <div>
                      <CardTitle className="text-base font-semibold leading-tight">{clinic.name}</CardTitle>
                      <p className="text-xs text-muted-foreground mt-0.5">
                        {clinic.area}, {clinic.city}
                      </p>
                    </div>
                  </div>
                  {clinic.avg_rating ? (
                    <Badge variant="outline" className="text-xs bg-amber-500/10 text-amber-700 dark:text-amber-400 border-amber-500/30">
                      ★ {Number(clinic.avg_rating).toFixed(1)}
                    </Badge>
                  ) : null}
                </div>
              </CardHeader>
              <CardContent className="space-y-4 pt-0">
                <div className="space-y-2 text-xs text-muted-foreground border-t pt-3">
                  {clinic.address_line && (
                    <p className="flex items-start gap-2">
                      <MapPin className="h-3.5 w-3.5 shrink-0 text-muted-foreground mt-0.5" />
                      <span>{clinic.address_line}</span>
                    </p>
                  )}
                  {clinic.contact_phone && (
                    <p className="flex items-center gap-2">
                      <Phone className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
                      <span>{clinic.contact_phone}</span>
                    </p>
                  )}
                  {clinic.contact_email && (
                    <p className="flex items-center gap-2">
                      <Mail className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
                      <span>{clinic.contact_email}</span>
                    </p>
                  )}
                </div>

                {Array.isArray(clinic.facilities) && clinic.facilities.length > 0 && (
                  <div className="flex flex-wrap gap-1.5 pt-1">
                    {clinic.facilities.slice(0, 3).map((f: string) => (
                      <span key={f} className="rounded-md bg-muted px-2 py-0.5 text-[11px] font-medium text-muted-foreground">
                        {f}
                      </span>
                    ))}
                    {clinic.facilities.length > 3 && (
                      <span className="text-[10px] text-muted-foreground self-center">
                        +{clinic.facilities.length - 3} more
                      </span>
                    )}
                  </div>
                )}

                <div className="pt-2 flex items-center gap-2 border-t">
                  <Button asChild variant="outline" size="sm" className="w-full text-xs">
                    <Link href={`/doctor/availability`}>
                      <CalendarDays className="mr-1.5 h-3.5 w-3.5" /> Set Hours
                    </Link>
                  </Button>
                  <Button asChild size="sm" className="w-full text-xs">
                    <Link href={`/patient/clinics/${clinic.id}`}>
                      View Details
                    </Link>
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
