import type { Metadata } from "next";
import { CalendarCheck2, Clock } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LiveRefresh } from "@/components/queue/live-refresh";
import { TokenChip } from "@/components/queue/token-chip";
import { QueueEntryActions, CallNextButton } from "@/components/queue/queue-entry-actions";
import { CheckInButton } from "@/components/queue/check-in-button";
import { WalkInDialog } from "@/components/queue/walk-in-dialog";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getStaffClinicContext } from "@/services/clinics/service";
import {
  listClinicQueueToday,
  listClinicArrivals,
  listClinicDoctors,
} from "@/services/queue/service";
import { bucketQueue } from "@/lib/queue";
import { formatTimeString, nowClinicTime } from "@/lib/utils";

export const metadata: Metadata = { title: "Live queue" };

export default async function StaffQueuePage() {
  const user = await requireRole(["RECEPTIONIST"], "/staff/queue");
  const supabase = await createClient();
  const clinic = await getStaffClinicContext(user.id);

  if (!clinic) {
    return (
      <div className="page-container py-8">
        <EmptyState
          title="No clinic assigned"
          description="Your account is not linked to a clinic yet, so there is no queue to manage."
        />
      </div>
    );
  }

  const [entries, arrivals, doctors] = await Promise.all([
    listClinicQueueToday(supabase, clinic.id),
    listClinicArrivals(supabase, clinic.id),
    listClinicDoctors(supabase, clinic.id),
  ]);

  // Group the day's entries per doctor (board sections).
  const byDoctor = new Map<
    string,
    { name: string; entries: typeof entries }
  >();
  for (const entry of entries) {
    const group = byDoctor.get(entry.doctor_id) ?? { name: entry.doctor_name, entries: [] };
    group.entries.push(entry);
    byDoctor.set(entry.doctor_id, group);
  }
  const doctorSections = Array.from(byDoctor.entries()).map(([doctorId, group]) => ({
    doctorId,
    name: group.name,
    buckets: bucketQueue(group.entries),
  }));

  const nowTime = nowClinicTime();
  const pendingArrivals = arrivals.filter((a) => a.end_time > nowTime);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Live queue"
        description={`${clinic.name} — tokens, walk-ins and arrivals for today.`}
        actions={<WalkInDialog doctors={doctors} />}
      />

      <LiveRefresh
        channelKey={`staff-queue-${clinic.id}`}
        filters={`queue_entries:clinic_id=eq.${clinic.id};appointments:clinic_id=eq.${clinic.id}`}
      >
        {doctorSections.length === 0 ? (
          <EmptyState
            icon={Clock}
            title="The queue is empty"
            description="No tokens yet today. Check patients in from the arrivals list below or register a walk-in."
          />
        ) : (
          <div className="space-y-6">
            {doctorSections.map((section) => (
              <Card key={section.doctorId}>
                <CardHeader className="flex-row items-center justify-between space-y-0">
                  <CardTitle>{section.name}</CardTitle>
                  <CallNextButton
                    clinicId={clinic.id}
                    doctorId={section.doctorId}
                    disabled={section.buckets.waiting.length === 0}
                  />
                </CardHeader>
                <CardContent className="space-y-4">
                  {section.buckets.inConsultation.length + section.buckets.called.length > 0 ? (
                    (() => {
                      const current =
                        section.buckets.inConsultation[0] ??
                        [...section.buckets.called].sort(
                          (a, b) =>
                            new Date(b.called_at ?? 0).getTime() - new Date(a.called_at ?? 0).getTime()
                        )[0]!;
                      return (
                        <div className="flex flex-col gap-3 rounded-lg border border-primary/30 bg-primary/5 p-3 sm:flex-row sm:items-center sm:justify-between">
                          <div className="space-y-1.5">
                            <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                              {current.status === "IN_CONSULTATION" ? "In consultation" : "Now calling"}
                            </p>
                            <TokenChip entry={current} />
                            <p className="text-sm text-muted-foreground">{current.patient_name}</p>
                          </div>
                          <QueueEntryActions entry={current} showStart={false} />
                        </div>
                      );
                    })()
                  ) : null}

                  {section.buckets.waiting.length > 0 ? (
                    <div className="space-y-2">
                      {section.buckets.waiting.map((entry, index) => (
                        <div
                          key={entry.id}
                          className="flex flex-col gap-3 rounded-lg border p-3 lg:flex-row lg:items-center lg:justify-between"
                        >
                          <div className="flex items-start gap-3 text-sm">
                            <span className="mt-1 inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-muted text-xs font-semibold text-muted-foreground">
                              {index + 1}
                            </span>
                            <div>
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
                          <QueueEntryActions entry={entry} showStart={false} />
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-sm text-muted-foreground">No one waiting.</p>
                  )}

                  {section.buckets.skipped.length > 0 ? (
                    <div className="space-y-2 border-t pt-3">
                      <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                        Skipped
                      </p>
                      {section.buckets.skipped.map((entry) => (
                        <div
                          key={entry.id}
                          className="flex flex-col gap-3 rounded-lg border p-3 lg:flex-row lg:items-center lg:justify-between"
                        >
                          <p className="text-sm font-medium">
                            {entry.patient_name}
                            <span className="ml-2 font-mono text-xs text-muted-foreground">
                              {entry.token_code}
                            </span>
                          </p>
                          <QueueEntryActions entry={entry} showStart={false} />
                        </div>
                      ))}
                    </div>
                  ) : null}
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* Arrival desk */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CalendarCheck2 className="h-5 w-5 text-muted-foreground" aria-hidden />
              Expected arrivals — not checked in yet ({pendingArrivals.length})
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {pendingArrivals.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                No pending arrivals for the rest of today.
              </p>
            ) : (
              pendingArrivals.map((arrival) => (
                <div
                  key={arrival.id}
                  className="flex flex-col gap-2 rounded-lg border p-3 sm:flex-row sm:items-center sm:justify-between"
                >
                  <div className="text-sm">
                    <p className="font-medium">
                      {arrival.patient_name}
                      <span className="ml-2 text-xs font-normal text-muted-foreground">
                        {formatTimeString(arrival.start_time)} – {formatTimeString(arrival.end_time)}
                      </span>
                    </p>
                    <p className="text-muted-foreground">
                      {arrival.doctor_name} — {arrival.visit_reason}
                    </p>
                  </div>
                  <CheckInButton appointmentId={arrival.id} mode="staff" />
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </LiveRefresh>
    </div>
  );
}
