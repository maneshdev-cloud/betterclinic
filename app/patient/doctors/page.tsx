import { Suspense } from "react";
import type { Metadata } from "next";
import { SearchX } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { DoctorCard } from "@/components/discovery/doctor-card";
import { DoctorFilters } from "@/components/discovery/doctor-filters";
import { AiSymptomTriage } from "@/components/discovery/ai-symptom-triage";
import { DoctorCardSkeleton } from "@/components/shared/skeletons";
import { createClient } from "@/lib/supabase/server";
import { searchDoctors, listSpecializations, DOCTOR_PAGE_SIZE } from "@/services/doctors/service";
import { listClinicCities } from "@/services/clinics/service";
import { doctorSearchSchema, type DoctorSearchInput } from "@/lib/validation/appointments";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { pluralize } from "@/lib/utils";

export const metadata: Metadata = { title: "Find doctors" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

async function DoctorsListContent({
  filters,
  buildHref,
}: {
  filters: DoctorSearchInput;
  buildHref: (page: number) => string;
}) {
  const supabase = await createClient();
  const result = await searchDoctors(supabase, filters);

  return (
    <>
      <p className="text-sm text-muted-foreground" aria-live="polite">
        {result.total > 0
          ? `${pluralize(result.total, "doctor")} found`
          : "No doctors matched"}
        {result.total > DOCTOR_PAGE_SIZE
          ? ` · showing page ${result.page} of ${result.totalPages}`
          : ""}
      </p>

      {result.items.length === 0 ? (
        <EmptyState
          icon={SearchX}
          title="No doctors match these filters"
          description="Try widening your search — clear a filter, choose a different city, or remove the fee cap."
        />
      ) : (
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          {result.items.map((doctor) => (
            <DoctorCard key={doctor.id} doctor={doctor} />
          ))}
        </div>
      )}

      <Pagination page={result.page} totalPages={result.totalPages} buildHref={buildHref} />
    </>
  );
}

export default async function PatientDoctorsPage({ searchParams }: PageProps) {
  const parsed = doctorSearchSchema.safeParse(searchParamsToObject(searchParams));
  const filters = parsed.success ? parsed.data : doctorSearchSchema.parse({});

  const supabase = await createClient();
  const [specializations, cities] = await Promise.all([
    listSpecializations(supabase),
    listClinicCities(supabase),
  ]);

  const buildHref = (page: number) =>
    `/patient/doctors${buildQueryString({
      q: filters.q || undefined,
      specialization: filters.specialization || undefined,
      city: filters.city || undefined,
      maxFee: filters.maxFee,
      minRating: filters.minRating,
      availableToday: filters.availableToday || undefined,
      acceptingPatients: filters.acceptingPatients || undefined,
      sort: filters.sort === "rating" ? undefined : filters.sort,
      page: page === 1 ? undefined : page,
    })}`;

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Find doctors"
        description="Search real doctor profiles by specialization, city, fee, rating and same-day availability."
      />

      <AiSymptomTriage specializations={specializations.map((s) => s.name)} />

      <DoctorFilters
        values={{
          q: filters.q,
          specialization: filters.specialization ?? "",
          city: filters.city,
          maxFee: filters.maxFee !== undefined ? String(filters.maxFee) : "",
          minRating: filters.minRating !== undefined ? String(filters.minRating) : "",
          availableToday: filters.availableToday,
          acceptingPatients: filters.acceptingPatients,
          sort: filters.sort,
        }}
        specializations={specializations}
        cities={cities}
      />

      <Suspense
        fallback={
          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
            {Array.from({ length: 6 }).map((_, i) => (
              <DoctorCardSkeleton key={i} />
            ))}
          </div>
        }
      >
        <DoctorsListContent filters={filters} buildHref={buildHref} />
      </Suspense>
    </div>
  );
}
