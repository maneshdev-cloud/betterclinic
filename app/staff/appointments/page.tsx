import type { Metadata } from "next";
import Link from "next/link";
import { CalendarCheck2, CalendarX2, SearchX } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { Card, CardContent } from "@/components/ui/card";
import { StaffAppointmentRow } from "@/components/appointments/staff-appointment-table";
import { StaffSearch } from "@/components/appointments/staff-search";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";
import {
  listStaffToday,
  getStaffTodayCounts,
  listStaffUpcoming,
  listStaffPast,
  searchStaffAppointments,
} from "@/services/appointments/service";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { cn, pluralize } from "@/lib/utils";
import { LiveRefresh } from "@/components/queue/live-refresh";

export const metadata: Metadata = { title: "Appointments" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

type View = "today" | "upcoming" | "past";

const VIEWS: { key: View; label: string }[] = [
  { key: "today", label: "Today" },
  { key: "upcoming", label: "Upcoming" },
  { key: "past", label: "Past" },
];

function StatCard({ label, value, tone }: { label: string; value: number; tone?: string }) {
  return (
    <Card>
      <CardContent className="p-3">
        <p className={cn("text-xl font-semibold", tone)}>{value}</p>
        <p className="text-xs text-muted-foreground">{label}</p>
      </CardContent>
    </Card>
  );
}

export default async function StaffAppointmentsPage({ searchParams }: PageProps) {
  const user = await requireRole(["RECEPTIONIST"], "/staff/appointments");
  const supabase = await createClient();
  const clinic = await getStaffClinicContext(user.id);

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <EmptyState
          title="No clinic assigned"
          description="Your account is not linked to a clinic yet, so there is nothing to manage here."
        />
      </div>
    );
  }

  const params = searchParamsToObject(searchParams);
  const view: View = params.view === "upcoming" || params.view === "past" ? params.view : "today";
  const page = Math.max(1, Number(params.page) || 1);
  const q = params.q?.trim() ?? "";

  const searching = q.length > 0;
  const [counts, result] = await Promise.all([
    view === "today" || searching ? getStaffTodayCounts(supabase, clinic.id) : Promise.resolve(null),
    searching
      ? searchStaffAppointments(supabase, clinic.id, q, page)
      : view === "today"
        ? listStaffToday(supabase, clinic.id).then((items) => ({ items, total: 0, page: 1, pageSize: 15, totalPages: 1 }))
        : view === "upcoming"
          ? listStaffUpcoming(supabase, clinic.id, page)
          : listStaffPast(supabase, clinic.id, page),
  ]);

  const buildHref = (nextView: View, nextPage: number) =>
    `/staff/appointments${buildQueryString({
      q: q || undefined,
      view: nextView === "today" ? undefined : nextView,
      page: nextPage === 1 ? undefined : nextPage,
    })}`;

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Appointments"
        description={`${clinic.name} — confirm arrivals, flag no-shows and look up who is coming.`}
        actions={<StaffSearch value={q} currentTab={view} />}
      />

      {counts ? (
        <section aria-label="Today at a glance" className="grid grid-cols-2 gap-3 sm:grid-cols-4 xl:grid-cols-8">
          <StatCard label="Today total" value={counts.total} />
          <StatCard label="Booked" value={counts.booked} />
          <StatCard label="Confirmed" value={counts.confirmed} />
          <StatCard label="Checked in" value={counts.checkedIn} />
          <StatCard label="In consultation" value={counts.inConsultation} />
          <StatCard label="Completed" value={counts.completed} />
          <StatCard label="No-shows" value={counts.noShow} tone={counts.noShow > 0 ? "text-red-600" : undefined} />
          <StatCard label="Cancelled" value={counts.cancelled} />
        </section>
      ) : null}

      {!searching ? (
        <div className="flex w-full max-w-xs rounded-lg border bg-muted/40 p-1" role="tablist" aria-label="Appointment views">
          {VIEWS.map((item) => (
            <Link
              key={item.key}
              href={buildHref(item.key, 1)}
              role="tab"
              aria-selected={view === item.key}
              className={cn(
                "flex-1 rounded-md px-3 py-1.5 text-center text-sm font-medium transition-colors",
                view === item.key
                  ? "bg-background text-foreground shadow-sm"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              {item.label}
            </Link>
          ))}
        </div>
      ) : null}

      <p className="text-sm text-muted-foreground" aria-live="polite">
        {searching
          ? `Search results for “${q}” — ${pluralize(result.items.length, "appointment")} shown`
          : view === "today"
            ? `Today's schedule — ${pluralize(result.items.length, "appointment")}`
            : result.total > 0
              ? `${pluralize(result.total, "appointment")}`
              : "No appointments"}
        {searching ? (
          <>
            {" · "}
            <Link
              href={`/staff/appointments${buildQueryString({ view: view === "today" ? undefined : view })}`}
              className="underline underline-offset-2"
            >
              Clear search
            </Link>
          </>
        ) : null}
      </p>

      <LiveRefresh
        channelKey={`staff-appointments-${clinic.id}`}
        filters={`appointments:clinic_id=eq.${clinic.id}`}
      >
        {result.items.length === 0 ? (
          <EmptyState
            icon={searching ? SearchX : view === "today" ? CalendarCheck2 : CalendarX2}
            title={searching ? "No matching patients" : view === "today" ? "Nothing booked today" : view === "upcoming" ? "No upcoming appointments" : "No past appointments"}
            description={
              searching
                ? "Try a different spelling — search matches patient names."
                : "This list is generated from real bookings only."
            }
          />
        ) : (
          <div className="space-y-3">
            {result.items.map((appointment) => (
              <StaffAppointmentRow key={appointment.id} appointment={appointment} />
            ))}
          </div>
        )}

        {!searching && view !== "today" ? (
          <Pagination page={result.page} totalPages={result.totalPages} buildHref={(nextPage) => buildHref(view, nextPage)} />
        ) : null}
      </LiveRefresh>
    </div>
  );
}
