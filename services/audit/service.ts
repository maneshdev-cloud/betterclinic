import type { SupabaseClient } from "@supabase/supabase-js";
import type { SearchResult } from "@/services/doctors/service";
import { pageRange, totalPages } from "@/lib/utils";

/**
 * Audit log viewer for clinic admins. RLS already restricts reads to
 * the admin's own clinic (audit_select_admin); these helpers add
 * filtering and pagination on top.
 */

export const AUDIT_PAGE_SIZE = 20;

export interface AuditLogItem {
  id: string;
  action: string;
  entityType: string;
  entityId: string | null;
  actorName: string | null;
  actorRole: string | null;
  patientName: string | null;
  metadata: Record<string, unknown>;
  createdAt: string;
}

export interface AuditFilters {
  action?: string;
  entityType?: string;
  from?: string;
  to?: string;
}

export async function listAuditLogs(
  client: SupabaseClient,
  clinicId: string,
  page: number,
  filters: AuditFilters
): Promise<SearchResult<AuditLogItem>> {
  let countQuery = client
    .from("audit_logs")
    .select("id", { count: "exact", head: true })
    .eq("clinic_id", clinicId);
  let rowsQuery = client
    .from("audit_logs")
    .select(
      `id, action, entity_type, entity_id, actor_id, actor_role, patient_id, metadata, created_at,
       actor:profiles!audit_logs_actor_id_fkey(full_name)`
    )
    .eq("clinic_id", clinicId)
    .order("created_at", { ascending: false })
    .range(pageRange(page, AUDIT_PAGE_SIZE).from, pageRange(page, AUDIT_PAGE_SIZE).to);

  if (filters.action) {
    countQuery = countQuery.eq("action", filters.action);
    rowsQuery = rowsQuery.eq("action", filters.action);
  }
  if (filters.entityType) {
    countQuery = countQuery.eq("entity_type", filters.entityType);
    rowsQuery = rowsQuery.eq("entity_type", filters.entityType);
  }
  if (filters.from) {
    countQuery = countQuery.gte("created_at", `${filters.from}T00:00:00+05:30`);
    rowsQuery = rowsQuery.gte("created_at", `${filters.from}T00:00:00+05:30`);
  }
  if (filters.to) {
    countQuery = countQuery.lt("created_at", `${addDay(filters.to)}T00:00:00+05:30`);
    rowsQuery = rowsQuery.lt("created_at", `${addDay(filters.to)}T00:00:00+05:30`);
  }

  const [countRes, rowsRes] = await Promise.all([countQuery, rowsQuery]);
  if (countRes.error) throw countRes.error;
  if (rowsRes.error) throw rowsRes.error;

  const rows = (rowsRes.data ?? []) as unknown as {
    id: string;
    action: string;
    entity_type: string;
    entity_id: string | null;
    actor_id: string | null;
    actor_role: string | null;
    patient_id: string | null;
    metadata: Record<string, unknown>;
    created_at: string;
    actor: { full_name: string } | null;
  }[];

  // Patient names live in profiles (patients.id = profiles.id).
  const patientIds = Array.from(new Set(rows.map((r) => r.patient_id).filter((id): id is string => Boolean(id))));
  const patientNames = new Map<string, string>();
  if (patientIds.length > 0) {
    const { data: profileRows } = await client
      .from("profiles")
      .select("id, full_name")
      .in("id", patientIds);
    for (const row of ((profileRows ?? []) as unknown as { id: string; full_name: string }[])) {
      patientNames.set(row.id, row.full_name);
    }
  }

  const items: AuditLogItem[] = rows.map((row) => ({
    id: row.id,
    action: row.action,
    entityType: row.entity_type,
    entityId: row.entity_id,
    actorName: row.actor?.full_name ?? null,
    actorRole: row.actor_role,
    patientName: row.patient_id ? patientNames.get(row.patient_id) ?? null : null,
    metadata: row.metadata ?? {},
    createdAt: row.created_at,
  }));

  const total = countRes.count ?? items.length;
  return {
    items,
    total,
    page,
    pageSize: AUDIT_PAGE_SIZE,
    totalPages: totalPages(total, AUDIT_PAGE_SIZE),
  };
}

/** Distinct actions present for this clinic (for the filter dropdown). */
export async function listAuditActionOptions(client: SupabaseClient, clinicId: string): Promise<string[]> {
  const { data, error } = await client
    .from("audit_logs")
    .select("action")
    .eq("clinic_id", clinicId)
    .order("action");
  if (error) throw error;
  const actions = Array.from(new Set(((data ?? []) as unknown as { action: string }[]).map((r) => r.action)));
  return actions.sort();
}

function addDay(dateStr: string): string {
  const base = new Date(`${dateStr}T12:00:00Z`);
  base.setUTCDate(base.getUTCDate() + 1);
  return base.toISOString().slice(0, 10);
}
