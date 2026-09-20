import type { Metadata } from "next";
import { CalendarClock } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listPatientFollowUps } from "@/services/clinical/service";
import { formatDate } from "@/lib/utils";

export const metadata: Metadata = { title: "My follow-ups" };

const STATUS_BADGE: Record<string, "info" | "success" | "muted" | "destructive"> = {
  SCHEDULED: "info",
  COMPLETED: "success",
  CANCELLED: "muted",
  MISSED: "destructive",
};

export default async function PatientFollowUpsPage() {
  const user = await requireRole(["PATIENT"], "/patient/follow-ups");
  const supabase = await createClient();
  const { upcoming, past } = await listPatientFollowUps(supabase, user.id);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My follow-ups"
        description="Return visits your doctors scheduled after consultations."
      />

      <section className="space-y-3" aria-labelledby="upcoming-follow-ups">
        <h2 id="upcoming-follow-ups" className="text-base font-semibold">
          Upcoming ({upcoming.length})
        </h2>
        {upcoming.length === 0 ? (
          <EmptyState
            icon={CalendarClock}
            title="No upcoming follow-ups"
            description="When a doctor asks you to return for a review, it will appear here with instructions."
          />
        ) : (
          upcoming.map((fu) => (
            <Card key={fu.id} className="border-primary/30">
              <CardContent className="space-y-1.5 p-4">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <p className="font-medium">{formatDate(fu.scheduled_date)}</p>
                  <Badge variant="info">Upcoming</Badge>
                </div>
                <p className="text-sm text-muted-foreground">
                  {fu.reason} · with {fu.doctor_name}
                </p>
                {fu.instructions ? (
                  <p className="rounded-md bg-muted/50 p-2 text-sm text-muted-foreground">{fu.instructions}</p>
                ) : null}
              </CardContent>
            </Card>
          ))
        )}
      </section>

      {past.length > 0 ? (
        <section className="space-y-3" aria-labelledby="past-follow-ups">
          <h2 id="past-follow-ups" className="text-base font-semibold">
            Past ({past.length})
          </h2>
          {past.slice(0, 10).map((fu) => (
            <Card key={fu.id}>
              <CardContent className="flex flex-wrap items-center justify-between gap-2 p-4 text-sm">
                <div>
                  <p className="font-medium">{formatDate(fu.scheduled_date)} — {fu.reason}</p>
                  <p className="text-muted-foreground">{fu.doctor_name}</p>
                </div>
                <Badge variant={STATUS_BADGE[fu.status] ?? "muted"}>{fu.status.toLowerCase()}</Badge>
              </CardContent>
            </Card>
          ))}
          {past.length > 10 ? (
            <p className="text-xs text-muted-foreground">
              Showing your 10 most recent past follow-ups of {past.length} (full history stays in your
              medical records).
            </p>
          ) : null}
        </section>
      ) : null}
    </div>
  );
}
