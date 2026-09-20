import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { FileText } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { UserAvatar } from "@/components/shared/user-avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { MedicalHistoryForm } from "@/components/clinical/record-forms";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getPatientOverview } from "@/services/clinical/service";
import { ageFrom, formatDate, formatTime } from "@/lib/utils";
import {
  MEDICAL_HISTORY_LABELS,
  SEX_LABELS,
  FREQUENCY_LABELS,
  FOOD_RELATION_LABELS,
} from "@/lib/constants";

interface PageProps {
  params: { id: string };
}

export const metadata: Metadata = { title: "Patient record" };

export default async function DoctorPatientPage({ params }: PageProps) {
  const supabase = await createClient();
  // RLS: doctors only load patients they have a care relationship with.
  const overview = await getPatientOverview(supabase, params.id);
  if (!overview) notFound();

  const { patient, medicalHistory, consultations, prescriptions, followUps } = overview;
  const age = ageFrom(patient.date_of_birth);
  const allergies = medicalHistory.filter((h) => h.record_type === "ALLERGY" && h.is_active);
  const conditions = medicalHistory.filter((h) => h.record_type === "CHRONIC_CONDITION" && h.is_active);
  const today = new Date().toLocaleDateString("en-CA", { timeZone: "Asia/Kolkata" });

  return (
    <div className="page-container space-y-6 py-8">
      <nav aria-label="Breadcrumb" className="text-sm text-muted-foreground">
        <Link href="/doctor/patients" className="hover:underline">
          ← Back to patients
        </Link>
      </nav>

      <PageHeader title={patient.name} description="Patient record" />

      <div className="grid gap-6 lg:grid-cols-[1fr_340px]">
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Consultation history ({consultations.length})</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {consultations.length === 0 ? (
                <EmptyState icon={FileText} title="No consultations" description="No consultation records for this patient yet." />
              ) : (
                consultations.map((consultation) => (
                  <div key={consultation.id} className="rounded-lg border p-3 text-sm">
                    <div className="flex flex-wrap items-center justify-between gap-2">
                      <Link href={`/doctor/consultations/${consultation.id}`} className="font-medium hover:underline">
                        {formatDate(consultation.started_at)} — {consultation.chief_complaint || "Consultation"}
                      </Link>
                      <div className="flex gap-1.5">
                        <Badge variant={consultation.status === "COMPLETED" ? "success" : "info"}>
                          {consultation.status === "COMPLETED" ? "Completed" : "In progress"}
                        </Badge>
                        {consultation.has_prescription ? <Badge variant="outline">Rx</Badge> : null}
                      </div>
                    </div>
                    <p className="mt-1 text-muted-foreground">
                      {consultation.appointment_date} · {consultation.appointment_time.slice(0, 5)}
                    </p>
                  </div>
                ))
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Prescriptions ({prescriptions.length})</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {prescriptions.length === 0 ? (
                <p className="text-sm text-muted-foreground">No prescriptions on record.</p>
              ) : (
                prescriptions.map((rx) => (
                  <div key={rx.id} className="rounded-lg border p-3 text-sm">
                    <p className="font-medium">
                      {formatDate(rx.prescription_date)} — {rx.doctor_name}
                    </p>
                    <ul className="mt-1.5 space-y-1">
                      {rx.items.map((item) => (
                        <li key={item.id} className="text-muted-foreground">
                          {item.medicine_name}
                          {item.strength ? ` (${item.strength})` : ""} — {item.dose},{" "}
                          {FREQUENCY_LABELS[item.frequency].toLowerCase()}, {item.duration_days}d
                          {item.food_relation !== "NOT_SPECIFIED"
                            ? `, ${FOOD_RELATION_LABELS[item.food_relation].toLowerCase()}`
                            : ""}
                        </li>
                      ))}
                    </ul>
                  </div>
                ))
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Follow-ups ({followUps.length})</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 text-sm">
              {followUps.length === 0 ? (
                <p className="text-sm text-muted-foreground">No follow-ups scheduled.</p>
              ) : (
                followUps.map((fu) => (
                  <div key={fu.id} className="flex flex-wrap items-center justify-between gap-2 rounded-lg border p-3">
                    <div>
                      <p className="font-medium">
                        {formatDate(fu.scheduled_date)} — {fu.reason}
                      </p>
                      {fu.instructions ? <p className="text-muted-foreground">{fu.instructions}</p> : null}
                    </div>
                    <Badge variant={fu.status === "SCHEDULED" && fu.scheduled_date >= today ? "info" : "muted"}>
                      {fu.status === "SCHEDULED" && fu.scheduled_date >= today ? "Upcoming" : fu.status.toLowerCase()}
                    </Badge>
                  </div>
                ))
              )}
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardContent className="space-y-3 p-5">
              <div className="flex items-center gap-3">
                <UserAvatar name={patient.name} src={patient.avatar_url} size="lg" />
                <div>
                  <p className="font-medium">{patient.name}</p>
                  <p className="text-sm text-muted-foreground">
                    {[age ? `${age} yrs` : null, patient.sex ? SEX_LABELS[patient.sex] : null, patient.blood_group]
                      .filter(Boolean)
                      .join(" · ") || "—"}
                  </p>
                </div>
              </div>
              {allergies.length > 0 ? (
                <div className="rounded-lg border border-red-200 bg-red-50 p-3">
                  <p className="text-xs font-semibold uppercase tracking-wide text-red-700">Allergies</p>
                  <p className="mt-0.5 text-sm text-red-700">{allergies.map((a) => a.title).join(", ")}</p>
                </div>
              ) : null}
              {conditions.length > 0 ? (
                <div>
                  <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Chronic conditions</p>
                  <p className="text-sm">{conditions.map((c) => c.title).join(", ")}</p>
                </div>
              ) : null}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-base">Medical history</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {medicalHistory.length === 0 ? (
                <p className="text-sm text-muted-foreground">Nothing recorded yet.</p>
              ) : (
                <ul className="space-y-2 text-sm">
                  {medicalHistory.map((entry) => (
                    <li key={entry.id}>
                      <p className="font-medium">
                        {entry.title}{" "}
                        <span className="text-xs font-normal text-muted-foreground">
                          {MEDICAL_HISTORY_LABELS[entry.record_type]}
                        </span>
                      </p>
                      {entry.description ? <p className="text-muted-foreground">{entry.description}</p> : null}
                    </li>
                  ))}
                </ul>
              )}
              <Separator />
              <MedicalHistoryForm patientId={patient.id} compact />
            </CardContent>
          </Card>

          <Button asChild variant="outline" size="sm" className="w-full">
            <Link href="/doctor/consultations">All consultations</Link>
          </Button>
        </div>
      </div>
    </div>
  );
}
