import { Suspense } from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { CalendarX2 } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Pagination } from "@/components/shared/pagination";
import { EmptyState } from "@/components/shared/empty-state";
import { AppointmentCard } from "@/components/appointments/appointment-card";
import { AppointmentCardActions } from "@/components/appointments/appointment-card-actions";
import { LiveRefresh } from "@/components/queue/live-refresh";
import { AppointmentsListSkeleton } from "@/components/shared/skeletons";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listPatientAppointments, type AppointmentTab } from "@/services/appointments/service";
import { searchParamsToObject, buildQueryString } from "@/lib/search-params";
import { pluralize } from "@/lib/utils";

export const metadata: Metadata = { title: "My appointments" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

const TABS: { key: AppointmentTab; label: string }[] = [
  { key: "upcoming", label: "Upcoming" },
  { key: "past", label: "Past" },
];

async function AppointmentsContent({
  tab,
  page,
  buildHref,
}: {
  tab: AppointmentTab;
  page: number;
  buildHref: (nextTab: AppointmentTab, nextPage: number) => string;
}) {
  const user = await requireRole(["PATIENT"], "/patient/appointments");
  const supabase = await createClient();
  const result = await listPatientAppointments(supabase, user.id, tab, page);

  return (
    <div className="space-y-4">
      <p className="text-sm text-muted-foreground" aria-live="polite">
        {tab === "upcoming"
          ? result.total > 0
            ? `${pluralize(result.total, "upcoming appointment")}`
            : "No upcoming appointments"
          : result.total > 0
            ? `${pluralize(result.total, "past appointment")}`
            : "No past appointments"}
      </p>

      <LiveRefresh
        channelKey={`patient-appointments-${user.id}`}
        filters={`appointments:patient_id=eq.${user.id}`}
      >
        {result.items.length === 0 ? (
          <EmptyState
            icon={CalendarX2}
            title={tab === "upcoming" ? "Nothing booked yet" : "No past appointments"}
            description={
              tab === "upcoming"
                ? "Find a doctor, pick a slot and your booking will appear here with live status."
                : "Appointments you've completed, cancelled or missed will show up here."
            }
            action={
              tab === "upcoming" ? (
                <Button asChild size="sm">
                  <Link href="/patient/doctors">Find a doctor</Link>
                </Button>
              ) : undefined
            }
          />
        ) : (
          <div className="space-y-3">
            {result.items.map((appointment) => (
              <AppointmentCard
                key={appointment.id}
                appointment={appointment}
                actions={<AppointmentCardActions appointment={appointment} />}
              />
            ))}
          </div>
        )}
      </LiveRefresh>

      <Pagination
        page={result.page}
        totalPages={result.totalPages}
        buildHref={(nextPage) => buildHref(tab, nextPage)}
      />
    </div>
  );
}

export default function PatientAppointmentsPage({ searchParams }: PageProps) {
  const params = searchParamsToObject(searchParams);
  const tab: AppointmentTab = params.tab === "past" ? "past" : "upcoming";
  const page = Math.max(1, Number(params.page) || 1);

  const buildHref = (nextTab: AppointmentTab, nextPage: number) =>
    `/patient/appointments${buildQueryString({
      tab: nextTab === "upcoming" ? undefined : nextTab,
      page: nextPage === 1 ? undefined : nextPage,
    })}`;

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My appointments"
        description="Your bookings across all clinics — book, reschedule or cancel."
        actions={
          <Button asChild size="sm">
            <Link href="/patient/doctors">Book new appointment</Link>
          </Button>
        }
      />

      {/* URL-driven tabs — renders IMMEDIATELY without waiting for DB */}
      <div
        className="flex w-full max-w-xs rounded-lg border bg-muted/40 p-1"
        role="tablist"
        aria-label="Appointment tabs"
      >
        {TABS.map((item) => (
          <Link
            key={item.key}
            href={buildHref(item.key, 1)}
            role="tab"
            aria-selected={tab === item.key}
            className={cn(
              "flex-1 rounded-md px-3 py-1.5 text-center text-sm font-medium transition-colors",
              tab === item.key
                ? "bg-background shadow-sm text-foreground"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            {item.label}
          </Link>
        ))}
      </div>

      <Suspense fallback={<AppointmentsListSkeleton count={4} />}>
        <AppointmentsContent tab={tab} page={page} buildHref={buildHref} />
      </Suspense>
    </div>
  );
}
