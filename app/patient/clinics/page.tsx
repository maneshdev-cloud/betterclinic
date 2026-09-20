import type { Metadata } from "next";
import { SearchX } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { ClinicCard } from "@/components/discovery/clinic-card";
import { ClinicFilters } from "@/components/discovery/clinic-filters";
import { createClient } from "@/lib/supabase/server";
import { searchClinics, listClinicCities, listClinicAreas } from "@/services/clinics/service";
import { listSpecializations } from "@/services/doctors/service";
import { clinicSearchSchema } from "@/lib/validation/appointments";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { pluralize } from "@/lib/utils";

export const metadata: Metadata = { title: "Clinics" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

export default async function PatientClinicsPage({ searchParams }: PageProps) {
  const parsed = clinicSearchSchema.safeParse(searchParamsToObject(searchParams));
  const filters = parsed.success ? parsed.data : clinicSearchSchema.parse({});

  const supabase = await createClient();
  const [result, cities, areas, specializations] = await Promise.all([
    searchClinics(supabase, filters),
    listClinicCities(supabase),
    filters.city ? listClinicAreas(supabase, filters.city) : Promise.resolve([]),
    listSpecializations(supabase),
  ]);

  const buildHref = (page: number) =>
    `/patient/clinics${buildQueryString({
      q: filters.q || undefined,
      city: filters.city || undefined,
      area: filters.area || undefined,
      specialization: filters.specialization || undefined,
      minRating: filters.minRating,
      sort: filters.sort === "rating" ? undefined : filters.sort,
      page: page === 1 ? undefined : page,
    })}`;

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Clinics"
        description="Browse clinics, their doctors, facilities and working hours."
      />

      <ClinicFilters
        values={{
          q: filters.q,
          city: filters.city,
          area: filters.area,
          specialization: filters.specialization ?? "",
          minRating: filters.minRating !== undefined ? String(filters.minRating) : "",
          sort: filters.sort,
        }}
        cities={cities}
        areas={areas}
        specializations={specializations}
      />

      <p className="text-sm text-muted-foreground" aria-live="polite">
        {result.total > 0 ? `${pluralize(result.total, "clinic")} found` : "No clinics matched"}
        {result.total > result.pageSize ? ` · page ${result.page} of ${result.totalPages}` : ""}
      </p>

      {result.items.length === 0 ? (
        <EmptyState
          icon={SearchX}
          title="No clinics match these filters"
          description="Try clearing the area or specialization filter, or search a different city."
        />
      ) : (
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          {result.items.map((clinic) => (
            <ClinicCard key={clinic.id} clinic={clinic} />
          ))}
        </div>
      )}

      <Pagination page={result.page} totalPages={result.totalPages} buildHref={buildHref} />
    </div>
  );
}
