import type { Metadata } from "next";
import Link from "next/link";
import { ClipboardList } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { PrintButton } from "@/components/shared/print-button";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listPatientPrescriptions } from "@/services/clinical/service";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { formatDate } from "@/lib/utils";
import { FREQUENCY_LABELS, FOOD_RELATION_LABELS } from "@/lib/constants";
import { LiveRefresh } from "@/components/queue/live-refresh";

export const metadata: Metadata = { title: "My prescriptions" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

export default async function PatientPrescriptionsPage({ searchParams }: PageProps) {
  const user = await requireRole(["PATIENT"], "/patient/prescriptions");
  const params = searchParamsToObject(searchParams);
  const page = Math.max(1, Number(params.page) || 1);

  const supabase = await createClient();
  const result = await listPatientPrescriptions(supabase, user.id, page);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My prescriptions"
        description="Prescriptions issued to you after consultations, with full dosing details."
        actions={<PrintButton label="Print list" />}
      />

      <LiveRefresh
        channelKey={`patient-prescriptions-${user.id}`}
        filters={`prescriptions:patient_id=eq.${user.id}`}
      >
        {result.items.length === 0 ? (
          <EmptyState
            icon={ClipboardList}
            title="No prescriptions yet"
            description="Prescriptions appear here after a doctor consults you and prescribes medication."
            action={
              <Button asChild size="sm">
                <Link href="/patient/doctors">Find a doctor</Link>
              </Button>
            }
          />
        ) : (
          <div className="space-y-4">
            {result.items.map((rx) => (
              <Card key={rx.id} className="print:break-inside-avoid">
                <CardHeader className="flex-row items-start justify-between space-y-0">
                  <CardTitle className="text-base">
                    {formatDate(rx.prescription_date)} · {rx.doctor_name}
                    {rx.doctor_qualification ? (
                      <span className="block text-sm font-normal text-muted-foreground">
                        {rx.doctor_qualification} · {rx.clinic_name}
                      </span>
                    ) : null}
                  </CardTitle>
                  <Badge variant={rx.status === "ACTIVE" ? "info" : "muted"}>{rx.status.toLowerCase()}</Badge>
                </CardHeader>
                <CardContent className="space-y-3">
                  <ul className="divide-y">
                    {rx.items.map((item) => (
                      <li key={item.id} className="py-2.5">
                        <p className="text-sm font-medium">
                          {item.medicine_name}
                          {item.strength ? ` (${item.strength})` : ""}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          {item.dose} · {FREQUENCY_LABELS[item.frequency]} · {item.duration_days} day
                          {item.duration_days === 1 ? "" : "s"}
                          {item.food_relation !== "NOT_SPECIFIED" ? ` · ${FOOD_RELATION_LABELS[item.food_relation]}` : ""}
                        </p>
                        {item.instructions ? (
                          <p className="mt-0.5 text-xs text-muted-foreground">{item.instructions}</p>
                        ) : null}
                      </li>
                    ))}
                  </ul>
                  {rx.notes ? <p className="text-sm text-muted-foreground">Note: {rx.notes}</p> : null}
                  <div className="flex justify-end print:hidden">
                    <PrintButton label="Print prescription" />
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
            `/patient/prescriptions${buildQueryString({ page: nextPage === 1 ? undefined : nextPage })}`
          }
        />
      </LiveRefresh>
    </div>
  );
}
