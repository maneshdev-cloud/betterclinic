import type { Metadata } from "next";
import Link from "next/link";
import { Users } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { UrlSearch } from "@/components/shared/url-search";
import { UserAvatar } from "@/components/shared/user-avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listDoctorPatients } from "@/services/clinical/service";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { formatDate } from "@/lib/utils";

export const metadata: Metadata = { title: "My patients" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

export default async function DoctorPatientsPage({ searchParams }: PageProps) {
  const user = await requireRole(["DOCTOR"], "/doctor/patients");
  const params = searchParamsToObject(searchParams);
  const query = params.q ?? "";
  const page = Math.max(1, Number(params.page) || 1);

  const supabase = await createClient();
  const result = await listDoctorPatients(supabase, user.id, query, page);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My patients"
        description="Patients you have an appointment or consultation history with."
      />

      <UrlSearch
        basePath="/doctor/patients"
        value={query}
        placeholder="Search by name…"
        ariaLabel="Search patients by name"
      />

      {result.items.length === 0 ? (
        <EmptyState
          icon={Users}
          title={query ? "No matching patients" : "No patients yet"}
          description={
            query
              ? "Try a different spelling of the name."
              : "Patients appear here once they book an appointment or complete a consultation with you."
          }
        />
      ) : (
        <div className="space-y-3">
          {result.items.map((patient) => (
            <Card key={patient.id}>
              <CardContent className="flex flex-col gap-3 p-4 sm:flex-row sm:items-center sm:justify-between">
                <div className="flex items-center gap-3">
                  <UserAvatar name={patient.name} src={patient.avatar_url} />
                  <div>
                    <Link
                      href={`/doctor/patients/${patient.id}`}
                      className="font-medium hover:underline"
                    >
                      {patient.name}
                    </Link>
                    <p className="text-sm text-muted-foreground">
                      {patient.last_visit ? `Last visit ${formatDate(patient.last_visit)}` : "No completed visits yet"}
                      {patient.upcoming > 0 ? ` · ${patient.upcoming} upcoming` : ""}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <Badge variant="outline">{patient.visits} visit{patient.visits === 1 ? "" : "s"}</Badge>
                  <Link
                    href={`/doctor/patients/${patient.id}`}
                    className="text-sm text-muted-foreground underline-offset-2 hover:underline"
                  >
                    View record →
                  </Link>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <Pagination
        page={result.page}
        totalPages={result.totalPages}
        buildHref={(nextPage) =>
          `/doctor/patients${buildQueryString({ q: query || undefined, page: nextPage === 1 ? undefined : nextPage })}`
        }
      />
    </div>
  );
}
