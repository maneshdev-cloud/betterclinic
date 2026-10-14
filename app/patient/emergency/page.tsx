import type { Metadata } from "next";
import { PhoneCall, Siren } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { LiveRefresh } from "@/components/queue/live-refresh";
import { EmergencyDemo } from "@/components/emergency/emergency-demo";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getEmergencyCard, listPatientEmergencyRequests, getAppEnv } from "@/services/emergency/service";

export const metadata: Metadata = { title: "Emergency Assistance" };

export default async function PatientEmergencyPage() {
  const user = await requireRole(["PATIENT"], "/patient/emergency");
  const supabase = await createClient();

  const [requests, card, appEnv] = await Promise.all([
    listPatientEmergencyRequests(supabase, user.id),
    getEmergencyCard(supabase, user.id),
    getAppEnv(supabase),
  ]);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Emergency Assistance"
        description="Urgent assistance module — for life-threatening situations, call emergency services immediately."
      />

      {/* Real emergency callout — always first */}
      <div className="flex items-start gap-3 rounded-lg border-2 border-red-300 bg-red-50 p-4">
        <PhoneCall className="mt-0.5 h-5 w-5 shrink-0 text-red-700" aria-hidden />
        <div>
          <p className="font-semibold text-red-800">
            In a critical emergency, call 108 (ambulance) or 112 immediately.
          </p>
          <p className="mt-0.5 text-sm text-red-700">
            Requests raised here are recorded in the clinic system for urgent staff triage.
          </p>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2">
          <LiveRefresh channelKey="patient-emergency" filters={`emergency_requests:patient_id=eq.${user.id}`}>
            <EmergencyDemo
              demoMode={appEnv === "demo"}
              requests={requests.map((request) => ({
                id: request.id,
                description: request.description,
                locationText: request.location_text,
                status: request.status,
                isDemo: request.is_demo,
                createdAt: request.created_at,
                receivedAt: request.received_at,
                acknowledgedAt: request.acknowledged_at,
                closedAt: request.closed_at,
              }))}
            />
          </LiveRefresh>
        </div>

        {/* Emergency card — the data a responder needs, from real records */}
        <div className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Siren className="h-4 w-4 text-red-600" aria-hidden /> My emergency card
              </CardTitle>
              <CardDescription>From your medical record — visible to you and your doctors.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-3 text-sm">
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground">Blood group</span>
                <span className="font-semibold">{card.bloodGroup ?? "Not recorded"}</span>
              </div>
              <div>
                <p className="text-muted-foreground">Allergies</p>
                {card.allergies.length > 0 ? (
                  <div className="mt-1 flex flex-wrap gap-1.5">
                    {card.allergies.map((allergy) => (
                      <span
                        key={allergy}
                        className="rounded-full bg-red-100 px-2.5 py-0.5 text-xs font-medium text-red-800"
                      >
                        {allergy}
                      </span>
                    ))}
                  </div>
                ) : (
                  <p className="mt-0.5">None recorded</p>
                )}
              </div>
              <div>
                <p className="text-muted-foreground">Chronic conditions</p>
                {card.conditions.length > 0 ? (
                  <div className="mt-1 flex flex-wrap gap-1.5">
                    {card.conditions.map((condition) => (
                      <span
                        key={condition}
                        className="rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-medium text-amber-800"
                      >
                        {condition}
                      </span>
                    ))}
                  </div>
                ) : (
                  <p className="mt-0.5">None recorded</p>
                )}
              </div>
              <div className="border-t pt-3">
                <p className="text-muted-foreground">Emergency contact</p>
                {card.emergencyContactName || card.emergencyContactPhone ? (
                  <p className="mt-0.5 font-medium">
                    {card.emergencyContactName ?? "—"}
                    {card.emergencyContactPhone ? ` · ${card.emergencyContactPhone}` : ""}
                  </p>
                ) : (
                  <p className="mt-0.5">
                    Not recorded — add one in{" "}
                    <a href="/patient/settings" className="font-medium underline">
                      Settings
                    </a>
                    .
                  </p>
                )}
              </div>
            </CardContent>
          </Card>

          {appEnv !== "demo" ? (
            <p className="rounded-lg border bg-muted/40 p-3 text-xs text-muted-foreground">
              Requests are recorded and audited by clinic triage staff.
            </p>
          ) : null}
        </div>
      </div>
    </div>
  );
}
