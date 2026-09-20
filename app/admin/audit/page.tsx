import type { Metadata } from "next";
import Link from "next/link";
import { ScrollText } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";
import { listAuditLogs, listAuditActionOptions, AUDIT_PAGE_SIZE } from "@/services/audit/service";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { formatDateTime } from "@/lib/utils";

export const metadata: Metadata = { title: "Audit log" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

const ENTITY_TYPES = ["APPOINTMENT", "QUEUE_ENTRY", "CONSULTATION", "PRESCRIPTION", "EMERGENCY", "PROFILE", "FOLLOW_UP"];

/**
 * Read-only audit trail for clinic admins. Every row was written by a
 * database function at the moment a real event happened — this page
 * only filters and displays them.
 */
export default async function AdminAuditPage({ searchParams }: PageProps) {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin/audit");
  const clinic = await getStaffClinicContext(user.id);
  const params = searchParamsToObject(searchParams);

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <PageHeader title="Audit log" description="No clinic is linked to this admin account." />
      </div>
    );
  }

  const page = Math.max(1, Number(params.page) || 1);
  const action = typeof params.action === "string" && params.action ? params.action : undefined;
  const entityType = typeof params.entity === "string" && params.entity ? params.entity : undefined;
  const from = typeof params.from === "string" && /^\d{4}-\d{2}-\d{2}$/.test(params.from) ? params.from : undefined;
  const to = typeof params.to === "string" && /^\d{4}-\d{2}-\d{2}$/.test(params.to) ? params.to : undefined;

  const supabase = await createClient();
  const [result, actionOptions] = await Promise.all([
    listAuditLogs(supabase, clinic.id, page, { action, entityType, from, to }),
    listAuditActionOptions(supabase, clinic.id),
  ]);

  const buildHref = (nextPage: number) =>
    `/admin/audit${buildQueryString({ action, entity: entityType, from, to, page: nextPage === 1 ? undefined : nextPage })}`;

  const hasFilters = Boolean(action || entityType || from || to);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Audit log"
        description={`Every recorded clinic event for ${clinic.name} — who did what, when. Written by the database at event time.`}
      />

      {/* Filters: plain GET form — URL state, no client JS required */}
      <form method="GET" action="/admin/audit" className="flex flex-wrap items-end gap-3">
        <div>
          <label htmlFor="audit-action" className="mb-1 block text-xs font-medium text-muted-foreground">
            Action
          </label>
          <select
            id="audit-action"
            name="action"
            defaultValue={action ?? ""}
            className="h-9 rounded-md border bg-background px-3 text-sm"
          >
            <option value="">All actions</option>
            {actionOptions.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label htmlFor="audit-entity" className="mb-1 block text-xs font-medium text-muted-foreground">
            Entity
          </label>
          <select
            id="audit-entity"
            name="entity"
            defaultValue={entityType ?? ""}
            className="h-9 rounded-md border bg-background px-3 text-sm"
          >
            <option value="">All entities</option>
            {ENTITY_TYPES.map((type) => (
              <option key={type} value={type}>
                {type}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label htmlFor="audit-from" className="mb-1 block text-xs font-medium text-muted-foreground">
            From
          </label>
          <input
            id="audit-from"
            name="from"
            type="date"
            defaultValue={from ?? ""}
            className="h-9 rounded-md border bg-background px-3 text-sm"
          />
        </div>
        <div>
          <label htmlFor="audit-to" className="mb-1 block text-xs font-medium text-muted-foreground">
            To
          </label>
          <input
            id="audit-to"
            name="to"
            type="date"
            defaultValue={to ?? ""}
            className="h-9 rounded-md border bg-background px-3 text-sm"
          />
        </div>
        <button
          type="submit"
          className="h-9 rounded-md border bg-background px-4 text-sm font-medium hover:bg-muted/50"
        >
          Apply filters
        </button>
        {hasFilters ? (
          <Link href="/admin/audit" className="text-sm text-muted-foreground underline hover:text-foreground">
            Clear
          </Link>
        ) : null}
      </form>

      <p className="text-sm text-muted-foreground">
        {result.total} event{result.total === 1 ? "" : "s"} found
        {result.total > AUDIT_PAGE_SIZE ? ` · showing page ${result.page} of ${result.totalPages}` : ""}
      </p>

      {result.items.length === 0 ? (
        <EmptyState
          icon={ScrollText}
          title="No audit events match"
          description={
            hasFilters
              ? "Try clearing the filters — events appear here as soon as real clinic activity happens."
              : "Events appear here as soon as real clinic activity happens (bookings, check-ins, queue calls…)."
          }
        />
      ) : (
        <div className="space-y-2">
          {result.items.map((log) => (
            <Card key={log.id}>
              <CardContent className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 py-4">
                <div className="min-w-0">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge variant="muted" className="font-mono text-[11px]">
                      {log.action}
                    </Badge>
                    <span className="text-xs text-muted-foreground">{log.entityType}</span>
                  </div>
                  <p className="mt-1 truncate text-sm">
                    <span className="font-medium">{log.actorName ?? "System"}</span>
                    <span className="text-muted-foreground">
                      {" "}
                      ({(log.actorRole ?? "—").toLowerCase()})
                    </span>
                    {log.patientName ? (
                      <span className="text-muted-foreground"> · patient: {log.patientName}</span>
                    ) : null}
                  </p>
                </div>
                <time className="text-xs text-muted-foreground" dateTime={log.createdAt}>
                  {formatDateTime(log.createdAt)}
                </time>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <Pagination page={result.page} totalPages={result.totalPages} buildHref={buildHref} />
    </div>
  );
}
