import type { Metadata } from "next";
import Link from "next/link";
import { CalendarClock, Clock, ListOrdered, MonitorPlay } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { LiveRefresh } from "@/components/queue/live-refresh";
import { TokenChip } from "@/components/queue/token-chip";
import { CheckInButton } from "@/components/queue/check-in-button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import {
  getPatientQueueStatus,
  listCheckinableAppointments,
} from "@/services/queue/service";
import { waitLabel } from "@/lib/queue";
import { formatTimeString, nowClinicTime } from "@/lib/utils";

export const metadata: Metadata = { title: "My queue" };

const EVENT_LABELS: Record<string, string> = {
  CREATED: "Joined the queue",
  CALLED: "Token called",
  RECALLED: "Token called again",
  SKIPPED: "Returned to the queue",
  RESUMED: "Back in the queue",
  PRIORITY_CHANGED: "Priority updated",
  STARTED: "Consultation started",
  COMPLETED: "Consultation completed",
  CANCELLED: "Left the queue",
};

export default async function PatientQueuePage() {
  const user = await requireRole(["PATIENT"], "/patient/queue");
  const supabase = await createClient();

  const [status, checkinable] = await Promise.all([
    getPatientQueueStatus(supabase, user.id),
    listCheckinableAppointments(supabase, user.id),
  ]);

  const nowTime = nowClinicTime();

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My queue"
        description="Live token status and queue position, updated in real time."
      />

      <LiveRefresh
        channelKey={`patient-queue-${user.id}`}
        filters={`queue_entries:patient_id=eq.${user.id};appointments:patient_id=eq.${user.id}`}
      >
        {status ? (
          <div className="grid gap-6 lg:grid-cols-[1fr_340px]">
            <div className="space-y-6">
              <Card className="border-primary/30">
                <CardContent className="space-y-4 p-6">
                  <TokenChip entry={status.entry} size="lg" />
                  <div className="grid gap-3 sm:grid-cols-3">
                    <div className="rounded-lg border bg-muted/30 p-3">
                      <p className="text-2xl font-semibold text-foreground">
                        {status.entry.status === "WAITING" ? status.position : "—"}
                      </p>
                      <p className="text-xs text-muted-foreground">Your position</p>
                    </div>
                    <div className="rounded-lg border bg-muted/30 p-3">
                      <p className="text-2xl font-semibold text-foreground">{status.peopleAhead}</p>
                      <p className="text-xs text-muted-foreground">Patients ahead</p>
                    </div>
                    <div className="rounded-lg border bg-muted/30 p-3">
                      <p className="text-2xl font-semibold text-foreground">
                        {status.entry.status === "WAITING"
                          ? waitLabel(status.estimatedWaitMinutes)
                          : "Your turn"}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {status.estimateBasis === "consultations"
                          ? "Est. from this doctor's past consultations"
                          : status.estimateBasis === "slot-length"
                            ? "Est. from slot length"
                            : "Estimated wait"}
                      </p>
                    </div>
                  </div>
                  <p className="text-sm text-muted-foreground">
                    {status.entry.doctor_name} · {status.entry.visit_reason}
                  </p>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="text-base">Your queue timeline</CardTitle>
                </CardHeader>
                <CardContent>
                  <ol className="space-y-3">
                    {status.queueEvents.map((event) => (
                      <li key={event.id} className="flex items-baseline gap-3 text-sm">
                        <span className="mt-1 h-2 w-2 shrink-0 rounded-full bg-primary" aria-hidden />
                        <span>
                          {EVENT_LABELS[event.event_type] ?? event.event_type}
                          <span className="ml-2 text-xs text-muted-foreground">
                            {new Date(event.created_at).toLocaleTimeString("en-IN", {
                              timeZone: "Asia/Kolkata",
                              hour: "numeric",
                              minute: "2-digit",
                            })}
                          </span>
                        </span>
                      </li>
                    ))}
                  </ol>
                </CardContent>
              </Card>
            </div>

            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2 text-base">
                    <MonitorPlay className="h-4 w-4 text-muted-foreground" aria-hidden /> Now serving
                  </CardTitle>
                </CardHeader>
                <CardContent className="text-sm">
                  {status.nowServing ? (
                    <div className="space-y-1">
                      <p className="font-mono text-2xl font-bold text-primary">{status.nowServing.token_code}</p>
                      <p className="text-muted-foreground">{status.nowServing.doctor_name}</p>
                      <p className="text-xs text-muted-foreground">
                        {status.waitingCount} patient{status.waitingCount === 1 ? "" : "s"} waiting in total
                      </p>
                    </div>
                  ) : (
                    <p className="text-muted-foreground">No one is being served right now.</p>
                  )}
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2 text-base">
                    <ListOrdered className="h-4 w-4 text-muted-foreground" aria-hidden /> How this works
                  </CardTitle>
                </CardHeader>
                <CardContent className="text-sm text-muted-foreground">
                  <ul className="list-inside list-disc space-y-1">
                    <li>Urgent tokens are called before normal ones — the queue order is computed by the database.</li>
                    <li>Your wait estimate uses this doctor&apos;s real completed consultations (or slot length if none yet).</li>
                    <li>You&apos;ll be notified in the app when your token is called.</li>
                  </ul>
                </CardContent>
              </Card>
            </div>
          </div>
        ) : (
          <EmptyState
            icon={Clock}
            title="You are not in a queue right now"
            description="Check in for today's appointment below, or book one to get a token when you arrive."
            action={
              <Button asChild size="sm">
                <Link href="/patient/doctors">Book an appointment</Link>
              </Button>
            }
          />
        )}

        {/* Today's appointments that can still be checked in */}
        {checkinable.length > 0 ? (
          <Card>
            <CardHeader>
              <CardTitle className="text-base">Today&apos;s appointments</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {checkinable.map((appointment) => {
                const windowPassed = appointment.end_time <= nowTime;
                return (
                  <div
                    key={appointment.id}
                    className="flex flex-col gap-2 rounded-lg border p-3 sm:flex-row sm:items-center sm:justify-between"
                  >
                    <div className="text-sm">
                      <p className="font-medium">
                        {appointment.doctor_name} · {formatTimeString(appointment.start_time)} –{" "}
                        {formatTimeString(appointment.end_time)}
                      </p>
                      <p className="text-muted-foreground">
                        {appointment.clinic_name} — {appointment.visit_reason}
                      </p>
                    </div>
                    {windowPassed ? (
                      <p className="text-xs text-muted-foreground">
                        Time window passed — please contact reception
                      </p>
                    ) : (
                      <CheckInButton appointmentId={appointment.id} mode="patient" />
                    )}
                  </div>
                );
              })}
            </CardContent>
          </Card>
        ) : status ? null : (
          <Card>
            <CardContent className="flex items-center gap-2 p-4 text-sm text-muted-foreground">
              <CalendarClock className="h-4 w-4 shrink-0" aria-hidden />
              No appointments left to check in for today. Check in on the day of your appointment.
            </CardContent>
          </Card>
        )}
      </LiveRefresh>
    </div>
  );
}
