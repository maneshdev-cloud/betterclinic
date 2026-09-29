import type { Metadata } from "next";
import { FileText, ClipboardList, Pill, Stethoscope } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getPatientTimeline } from "@/services/clinical/service";
import { formatDate } from "@/lib/utils";
import { MEDICAL_HISTORY_LABELS } from "@/lib/constants";
import { LiveRefresh } from "@/components/queue/live-refresh";

export const metadata: Metadata = { title: "Medical records" };

const KIND_META = {
  CONSULTATION: { icon: Stethoscope, label: "Consultation", tone: "info" as const },
  PRESCRIPTION: { icon: Pill, label: "Prescription", tone: "secondary" as const },
  HISTORY: { icon: ClipboardList, label: "History", tone: "outline" as const },
};

export default async function PatientRecordsPage() {
  const user = await requireRole(["PATIENT"], "/patient/records");
  const supabase = await createClient();
  const { entries, allergies, conditions } = await getPatientTimeline(supabase, user.id);

  return (
    <div className="page-container space-y-6 py-8">
      <LiveRefresh
        channelKey={`patient-records-${user.id}`}
        filters={`consultations:patient_id=eq.${user.id};prescriptions:patient_id=eq.${user.id};patient_medical_history:patient_id=eq.${user.id}`}
        showIndicator
      />
      <PageHeader
        title="Medical records"
        description="Your consolidated health timeline — consultations, prescriptions and recorded history."
      />

      {(allergies.length > 0 || conditions.length > 0) && (
        <div className="grid gap-3 sm:grid-cols-2">
          {allergies.length > 0 ? (
            <Card className="border-red-200 bg-red-50">
              <CardContent className="p-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-red-700">Allergies</p>
                <p className="mt-1 text-sm text-red-700">{allergies.join(", ")}</p>
              </CardContent>
            </Card>
          ) : null}
          {conditions.length > 0 ? (
            <Card>
              <CardContent className="p-4">
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Chronic conditions</p>
                <p className="mt-1 text-sm">{conditions.join(", ")}</p>
              </CardContent>
            </Card>
          ) : null}
        </div>
      )}

      <Card>
        <CardHeader>
          <CardTitle>Health timeline</CardTitle>
        </CardHeader>
        <CardContent>
          {entries.length === 0 ? (
            <EmptyState
              icon={FileText}
              title="Nothing on record yet"
              description="Your timeline builds up as you complete consultations and doctors record history entries."
            />
          ) : (
            <ol className="space-y-0">
              {entries.slice(0, 60).map((entry, index) => {
                const meta = KIND_META[entry.kind];
                return (
                  <li key={`${entry.kind}-${entry.id}`} className="relative flex gap-3 pb-5 last:pb-0">
                    {index < entries.length - 1 ? (
                      <span className="absolute left-[7px] top-5 h-full w-px bg-border" aria-hidden />
                    ) : null}
                    <span className="mt-1 flex h-[15px] w-[15px] shrink-0 items-center justify-center rounded-full border-2 border-primary bg-background">
                      <meta.icon className="h-2.5 w-2.5 text-primary" aria-hidden />
                    </span>
                    <div className="min-w-0 flex-1">
                      <div className="flex flex-wrap items-center gap-2">
                        <p className="text-sm font-medium">{entry.title}</p>
                        <Badge variant={meta.tone}>{meta.label}</Badge>
                      </div>
                      {entry.description ? (
                        <p className="mt-0.5 text-sm text-muted-foreground">{entry.description}</p>
                      ) : null}
                      <p className="mt-0.5 text-xs text-muted-foreground">
                        {formatDate(entry.date)} · {entry.meta === "ALLERGY" || entry.meta === "CHRONIC_CONDITION"
                          ? MEDICAL_HISTORY_LABELS[entry.meta as keyof typeof MEDICAL_HISTORY_LABELS]
                          : entry.meta}
                      </p>
                    </div>
                  </li>
                );
              })}
            </ol>
          )}
          {entries.length > 60 ? (
            <p className="mt-4 text-xs text-muted-foreground">
              Showing your 60 most recent record events of {entries.length}.
            </p>
          ) : null}
        </CardContent>
      </Card>
    </div>
  );
}
