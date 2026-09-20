import type { Metadata } from "next";
import Link from "next/link";
import { Clock } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LiveRefresh } from "@/components/queue/live-refresh";
import { TokenChip } from "@/components/queue/token-chip";
import { CallNextButton, QueueEntryActions } from "@/components/queue/queue-entry-actions";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getDoctorClinicOptions } from "@/services/availability/service";
import { listDoctorQueueToday, averageConsultationMinutes } from "@/services/queue/service";
import { bucketQueue } from "@/lib/queue";
import { buildQueryString } from "@/lib/search-params";
import { formatTimeString } from "@/lib/utils";
import { cn } from "@/lib/utils";

export const metadata: Metadata = { title: "My queue" };

interface PageProps {
  searchParams: Record<string, string | string[] | undefined>;
}

export default async function DoctorQueuePage({ searchParams }: PageProps) {
  const user = await requireRole(["DOCTOR"], "/doctor/queue");
  const supabase = await createClient();

  const clinics = await getDoctorClinicOptions(supabase, user.id);
  if (clinics.length === 0) {
    return (
      <div className="page-container py-8">
        <PageHeader title="My queue" />
        <EmptyState
          title="No clinic linked"
          description="You are not linked to a clinic yet, so there is no queue to manage."
        />
      </div>
    );
  }

  const requested = Array.isArray(searchParams.clinic) ? searchParams.clinic[0] : searchParams.clinic;
  const activeClinic = clinics.find((c) => c.clinic_id === requested) ?? clinics[0]!;

  const [entries, avgConsult] = await Promise.all([
    listDoctorQueueToday(supabase, activeClinic.clinic_id, user.id),
    averageConsultationMinutes(supabase, user.id),
  ]);
  const buckets = bucketQueue(entries);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My queue"
        description={`${activeClinic.clinic_name} — ${activeClinic.area}, ${activeClinic.city}`}
        actions={
          clinics.length > 1 ? (
            <div className="flex flex-wrap gap-1" role="tablist" aria-label="Clinic">
              {clinics.map((clinic) => (
                <Link
                  key={clinic.clinic_id}
                  role="tab"
                  aria-selected={clinic.clinic_id === activeClinic.clinic_id}
                  href={`/doctor/queue${buildQueryString({ clinic: clinic.clinic_id === clinics[0]!.clinic_id ? undefined : clinic.clinic_id })}`}
                  className={cn(
                    "rounded-md border px-2.5 py-1 text-xs font-medium",
                    clinic.clinic_id === activeClinic.clinic_id
                      ? "border-primary bg-primary text-primary-foreground"
                      : "text-muted-foreground hover:bg-muted"
                  )}
                >
                  {clinic.clinic_name}
                </Link>
              ))}
            </div>
          ) : undefined
        }
      />

      <LiveRefresh
        channelKey={`doctor-queue-${user.id}`}
        filters={`queue_entries:doctor_id=eq.${user.id};appointments:doctor_id=eq.${user.id}`}
      >
        {/* Now serving */}
        <Card className="border-primary/30">
          <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center sm:justify-between">
            {buckets.inConsultation.length > 0 || buckets.called.length > 0 ? (
              (() => {
                const current =
                  buckets.inConsultation[0] ??
                  [...buckets.called].sort(
                    (a, b) => new Date(b.called_at ?? 0).getTime() - new Date(a.called_at ?? 0).getTime()
                  )[0]!;
                return (
                  <div className="space-y-2">
                    <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                      {current.status === "IN_CONSULTATION" ? "In consultation" : "Now calling"}
                    </p>
                    <TokenChip entry={current} />
                    <p className="text-sm text-muted-foreground">
                      {current.patient_name} · {current.visit_reason}
                    </p>
                  </div>
                );
              })()
            ) : (
              <p className="text-sm text-muted-foreground">No one is being served right now.</p>
            )}
            <div className="flex flex-col items-start gap-2 sm:items-end">
              <CallNextButton
                clinicId={activeClinic.clinic_id}
                doctorId={user.id}
                disabled={buckets.waiting.length === 0}
              />
              <p className="text-xs text-muted-foreground">
                {buckets.waiting.length} waiting ·{" "}
                {avgConsult !== null
                  ? `avg consultation ~${Math.round(avgConsult)} min (real data)`
                  : "no completed consultations yet"}
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Waiting list */}
        <Card>
          <CardHeader>
            <CardTitle>Waiting ({buckets.waiting.length})</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {buckets.waiting.length === 0 ? (
              <EmptyState
                icon={Clock}
                title="Queue is empty"
                description="Patients appear here the moment they check in or are registered as walk-ins."
              />
            ) : (
              buckets.waiting.map((entry, index) => (
                <div
                  key={entry.id}
                  className="flex flex-col gap-3 rounded-lg border p-3 lg:flex-row lg:items-center lg:justify-between"
                >
                  <div className="flex items-start gap-3">
                    <span className="mt-1 inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-muted text-xs font-semibold text-muted-foreground">
                      {index + 1}
                    </span>
                    <div className="text-sm">
                      <p className="font-medium">
                        {entry.patient_name}
                        {entry.appointment_type === "WALK_IN" ? (
                          <span className="ml-2 text-xs font-normal text-muted-foreground">walk-in</span>
                        ) : (
                          <span className="ml-2 text-xs font-normal text-muted-foreground">
                            {formatTimeString(entry.appointment_time)} booked
                          </span>
                        )}
                      </p>
                      <p className="text-muted-foreground">{entry.visit_reason}</p>
                    </div>
                  </div>
                  <QueueEntryActions entry={entry} />
                </div>
              ))
            )}
          </CardContent>
        </Card>

        {/* Skipped tokens can be resumed */}
        {buckets.skipped.length > 0 ? (
          <Card>
            <CardHeader>
              <CardTitle>Skipped ({buckets.skipped.length})</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {buckets.skipped.map((entry) => (
                <div
                  key={entry.id}
                  className="flex flex-col gap-3 rounded-lg border p-3 lg:flex-row lg:items-center lg:justify-between"
                >
                  <div className="text-sm">
                    <p className="font-medium">{entry.patient_name}</p>
                    <p className="text-muted-foreground">{entry.visit_reason}</p>
                  </div>
                  <QueueEntryActions entry={entry} showStart={false} />
                </div>
              ))}
            </CardContent>
          </Card>
        ) : null}

        {/* Done today */}
        {buckets.finished.length > 0 ? (
          <Card>
            <CardHeader>
              <CardTitle>Finished today ({buckets.finished.length})</CardTitle>
            </CardHeader>
            <CardContent>
              <ul className="space-y-1.5 text-sm text-muted-foreground">
                {buckets.finished.map((entry) => (
                  <li key={entry.id} className="flex items-center justify-between gap-3">
                    <span>
                      <span className="font-mono font-semibold text-foreground">{entry.token_code}</span>{" "}
                      {entry.patient_name}
                    </span>
                    <span className="text-xs">
                      {entry.status === "COMPLETED" ? "Consulted" : entry.status === "CANCELLED" ? "Left" : "No-show"}
                    </span>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>
        ) : null}
      </LiveRefresh>
    </div>
  );
}
