import type { Metadata } from "next";
import Link from "next/link";
import { ClipboardList } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listDoctorConsultations } from "@/services/clinical/service";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { UrlSearch } from "@/components/shared/url-search";
import { formatDate, formatTimeString, cn } from "@/lib/utils";

export const metadata: Metadata = { title: "Consultations" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

const STATUS_TABS = [
  { key: "all", label: "All" },
  { key: "IN_PROGRESS", label: "In progress" },
  { key: "COMPLETED", label: "Completed" },
] as const;

export default async function DoctorConsultationsPage({ searchParams }: PageProps) {
  const user = await requireRole(["DOCTOR"], "/doctor/consultations");
  const params = searchParamsToObject(searchParams);
  const status = params.status === "IN_PROGRESS" || params.status === "COMPLETED" ? params.status : undefined;
  const q = typeof params.q === "string" ? params.q.trim() : "";
  const page = Math.max(1, Number(params.page) || 1);

  const supabase = await createClient();
  const result = await listDoctorConsultations(supabase, user.id, status, page, q || undefined);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Consultations"
        description="Your consultation records — open one to add notes, prescriptions, diagnoses and follow-ups."
        actions={
          <Button asChild variant="outline" size="sm">
            <Link href="/doctor/queue">Go to live queue</Link>
          </Button>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex w-full max-w-sm rounded-lg border bg-muted/40 p-1" role="tablist" aria-label="Status filter">
          {STATUS_TABS.map((tab) => (
            <Link
              key={tab.key}
              role="tab"
              aria-selected={(status ?? "all") === tab.key}
              href={`/doctor/consultations${buildQueryString({
                status: tab.key === "all" ? undefined : tab.key,
                q: q || undefined,
                page: undefined,
              })}`}
            className={cn(
              "flex-1 rounded-md px-3 py-1.5 text-center text-sm font-medium transition-colors",
              (status ?? "all") === tab.key
                ? "bg-background text-foreground shadow-sm"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            {tab.label}
          </Link>
          ))}
        </div>
        <UrlSearch
          basePath="/doctor/consultations"
          value={q}
          placeholder="Search patient name…"
          ariaLabel="Search consultations by patient name"
          extraParams={{ status }}
        />
      </div>

      {result.items.length === 0 ? (
        <EmptyState
          icon={ClipboardList}
          title={q ? "No consultations match your search" : "No consultations yet"}
          description={
            q
              ? `No consultations with a patient named “${q}”. Try another name or clear the search.`
              : "Start a consultation from your live queue — it will appear here with notes, prescriptions and follow-ups."
          }
          action={
            <Button asChild size="sm">
              <Link href="/doctor/queue">Open live queue</Link>
            </Button>
          }
        />
      ) : (
        <div className="space-y-3">
          {result.items.map((consultation) => (
            <Card key={consultation.id}>
              <CardContent className="flex flex-col gap-3 p-4 sm:flex-row sm:items-center sm:justify-between">
                <div className="min-w-0 space-y-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge variant={consultation.status === "COMPLETED" ? "success" : "info"}>
                      {consultation.status === "COMPLETED" ? "Completed" : "In progress"}
                    </Badge>
                    {consultation.has_prescription ? <Badge variant="outline">Prescription</Badge> : null}
                  </div>
                  <p className="font-medium text-foreground">{consultation.patient_name}</p>
                  <p className="text-sm text-muted-foreground">
                    {formatDate(consultation.started_at)} · {formatTimeString(consultation.appointment_time)} ·{" "}
                    {consultation.chief_complaint || "No chief complaint recorded"}
                  </p>
                </div>
                <Button asChild size="sm" variant={consultation.status === "IN_PROGRESS" ? "default" : "outline"}>
                  <Link href={`/doctor/consultations/${consultation.id}`}>
                    {consultation.status === "IN_PROGRESS" ? "Open workspace" : "View record"}
                  </Link>
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <Pagination
        page={result.page}
        totalPages={result.totalPages}
        buildHref={(nextPage) =>
          `/doctor/consultations${buildQueryString({ status, q: q || undefined, page: nextPage === 1 ? undefined : nextPage })}`
        }
      />
    </div>
  );
}
