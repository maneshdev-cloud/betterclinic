import { Suspense } from "react";
import type { Metadata } from "next";
import { PageHeader } from "@/components/shared/page-header";
import { AnalyticsView } from "@/components/analytics/analytics-view";
import { DashboardSkeleton } from "@/components/shared/skeletons";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";
import { getClinicAnalytics } from "@/services/analytics/service";
import { searchParamsToObject } from "@/lib/search-params";

export const metadata: Metadata = { title: "Analytics" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

async function AnalyticsContent({
  clinicId,
  params,
  doctorId,
}: {
  clinicId: string;
  params: Record<string, string>;
  doctorId?: string;
}) {
  const supabase = await createClient();
  const analytics = await getClinicAnalytics(supabase, clinicId, params, doctorId);

  return (
    <AnalyticsView
      analytics={analytics}
      basePath="/admin/analytics"
      selectedDoctorId={doctorId}
      doctorOptions={analytics.doctors.map((doctor) => ({ id: doctor.doctorId, name: doctor.name }))}
    />
  );
}

export default async function AdminAnalyticsPage({ searchParams }: PageProps) {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin/analytics");
  const clinic = await getStaffClinicContext(user.id);
  const params = searchParamsToObject(searchParams);
  const doctorId = typeof params.doctor === "string" && params.doctor.length > 0 ? params.doctor : undefined;

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <PageHeader title="Analytics" description="No clinic is linked to this admin account." />
      </div>
    );
  }

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Clinic analytics"
        description={`Real operational data for ${clinic.name} — appointments, queue performance and doctor activity.`}
      />
      <Suspense fallback={<DashboardSkeleton title="Loading analytics…" />}>
        <AnalyticsContent clinicId={clinic.id} params={params} doctorId={doctorId} />
      </Suspense>
    </div>
  );
}
