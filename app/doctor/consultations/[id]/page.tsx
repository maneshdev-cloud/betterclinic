import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { PageHeader } from "@/components/shared/page-header";
import { UserAvatar } from "@/components/shared/user-avatar";
import { ConsultationForm } from "@/components/clinical/consultation-form";
import { PrescriptionEditor } from "@/components/clinical/prescription-editor";
import { FollowUpDialog } from "@/components/clinical/follow-up-dialog";
import { DiagnosisForm, MedicalHistoryForm } from "@/components/clinical/record-forms";
import { CompleteConsultationButton } from "@/components/clinical/complete-consultation-button";
import { createClient } from "@/lib/supabase/server";
import { getConsultationWorkspace } from "@/services/clinical/service";
import { ageFrom, formatDate, formatTime } from "@/lib/utils";
import {
  MEDICAL_HISTORY_LABELS,
  SEX_LABELS,
} from "@/lib/constants";

interface PageProps {
  params: { id: string };
}

export const metadata: Metadata = { title: "Consultation workspace" };

export default async function ConsultationWorkspacePage({ params }: PageProps) {
  const supabase = await createClient();
  const workspace = await getConsultationWorkspace(supabase, params.id);
  if (!workspace) notFound();

  const { consultation, patient, appointment, clinic_name, prescription, diagnoses, followUps, medicalHistory, pastConsultations } = workspace;
  const age = ageFrom(patient.date_of_birth);
  const allergies = medicalHistory.filter((h) => h.record_type === "ALLERGY" && h.is_active);
  const conditions = medicalHistory.filter((h) => h.record_type === "CHRONIC_CONDITION" && h.is_active);

  return (
    <div className="page-container space-y-6 py-8">
      <nav aria-label="Breadcrumb" className="text-sm text-muted-foreground">
        <Link href="/doctor/consultations" className="hover:underline">
          ← Back to consultations
        </Link>
      </nav>

      <PageHeader
        title={`${patient.name} — consultation`}
        description={`${formatDate(appointment.date)} · ${formatTime(appointment.start_time)} · ${clinic_name}`}
        actions={
          consultation.status === "IN_PROGRESS" ? (
            <>
              <FollowUpDialog consultationId={consultation.id} existingCount={followUps.length} />
              <CompleteConsultationButton consultationId={consultation.id} patientName={patient.name} />
            </>
          ) : (
            <Badge variant="success">Completed {consultation.completed_at ? formatDate(consultation.completed_at) : ""}</Badge>
          )
        }
      />

      <div className="grid gap-6 lg:grid-cols-[1fr_340px]">
        {/* Left: workspace */}
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Visit reason</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 text-sm">
              <p className="text-muted-foreground">{appointment.visit_reason || "—"}</p>
              <div className="flex gap-2 pt-1">
                <Badge variant="outline">{appointment.type === "WALK_IN" ? "Walk-in" : "Scheduled"}</Badge>
                <Badge variant="outline">Status: {appointment.status}</Badge>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Clinical documentation</CardTitle>
            </CardHeader>
            <CardContent>
              <ConsultationForm
                consultationId={consultation.id}
                initial={{
                  chief_complaint: consultation.chief_complaint,
                  symptoms: consultation.symptoms,
                  clinical_notes: consultation.clinical_notes,
                  assessment: consultation.assessment,
                }}
                patientContext={{
                  patientName: patient.name,
                  age: age,
                  gender: patient.sex,
                  sex: patient.sex,
                  visitReason: appointment.visit_reason,
                  allergies: allergies.map((a) => a.title),
                  conditions: conditions.map((c) => c.title),
                }}
              />
            </CardContent>
          </Card>

          <PrescriptionEditor consultationId={consultation.id} existing={prescription} />

          <Card>
            <CardHeader>
              <CardTitle>Diagnoses</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              {diagnoses.length > 0 ? (
                <ul className="space-y-2 text-sm">
                  {diagnoses.map((diagnosis) => (
                    <li key={diagnosis.id} className="flex items-start justify-between gap-3 rounded-lg border p-3">
                      <div>
                        <p className="font-medium">
                          {diagnosis.name}
                          {diagnosis.is_primary ? (
                            <Badge className="ml-2" variant="secondary">
                              Primary
                            </Badge>
                          ) : null}
                        </p>
                        {diagnosis.description ? (
                          <p className="text-muted-foreground">{diagnosis.description}</p>
                        ) : null}
                      </div>
                      {diagnosis.code ? <Badge variant="outline">{diagnosis.code}</Badge> : null}
                    </li>
                  ))}
                </ul>
              ) : (
                <p className="text-sm text-muted-foreground">No diagnoses recorded yet.</p>
              )}
              <DiagnosisForm consultationId={consultation.id} />
            </CardContent>
          </Card>

          {followUps.length > 0 ? (
            <Card>
              <CardHeader>
                <CardTitle>Follow-ups</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2 text-sm">
                {followUps.map((followUp) => (
                  <div key={followUp.id} className="rounded-lg border p-3">
                    <p className="font-medium">
                      {formatDate(followUp.scheduled_date)} — {followUp.reason}
                    </p>
                    {followUp.instructions ? (
                      <p className="text-muted-foreground">{followUp.instructions}</p>
                    ) : null}
                  </div>
                ))}
              </CardContent>
            </Card>
          ) : null}
        </div>

        {/* Right: patient context */}
        <div className="space-y-6">
          <Card>
            <CardContent className="space-y-3 p-5">
              <div className="flex items-center gap-3">
                <UserAvatar name={patient.name} src={patient.avatar_url} size="lg" />
                <div>
                  <Link
                    href={`/doctor/patients/${patient.id}`}
                    className="font-medium hover:underline"
                  >
                    {patient.name}
                  </Link>
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
                <p className="text-sm text-muted-foreground">No history recorded.</p>
              ) : (
                <ul className="space-y-2 text-sm">
                  {medicalHistory.slice(0, 8).map((entry) => (
                    <li key={entry.id}>
                      <p className="font-medium">
                        {entry.title}{" "}
                        <span className="text-xs font-normal text-muted-foreground">
                          {MEDICAL_HISTORY_LABELS[entry.record_type]}
                        </span>
                      </p>
                      {entry.description ? (
                        <p className="text-muted-foreground">{entry.description}</p>
                      ) : null}
                    </li>
                  ))}
                </ul>
              )}
              <Separator />
              <MedicalHistoryForm patientId={patient.id} compact />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-base">Past consultations</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {pastConsultations.length === 0 ? (
                <p className="text-sm text-muted-foreground">No earlier consultations on record.</p>
              ) : (
                <ul className="space-y-2 text-sm">
                  {pastConsultations.map((past) => (
                    <li key={past.id}>
                      <Link href={`/doctor/consultations/${past.id}`} className="font-medium hover:underline">
                        {formatDate(past.started_at)} — {past.chief_complaint || "Consultation"}
                      </Link>
                      <p className="text-xs text-muted-foreground">
                        {past.doctor_name}
                        {past.assessment ? ` · ${past.assessment.slice(0, 80)}` : ""}
                      </p>
                    </li>
                  ))}
                </ul>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
