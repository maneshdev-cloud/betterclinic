"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2, PhoneCall, Send, SkipForward } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { createEmergencyRequestAction, advanceEmergencyDemoAction } from "@/services/emergency/actions";

export interface EmergencyRequestView {
  id: string;
  description: string;
  locationText: string;
  status: "CREATED" | "RECEIVED" | "ACKNOWLEDGED" | "CLOSED";
  isDemo: boolean;
  createdAt: string;
  receivedAt: string | null;
  acknowledgedAt: string | null;
  closedAt: string | null;
}

const STATUS_STEPS: EmergencyRequestView["status"][] = ["CREATED", "RECEIVED", "ACKNOWLEDGED", "CLOSED"];

/**
 * Emergency request intake & priority triage workflow. Alerts clinic on-duty
 * triage team. In critical emergencies, patients are directed to call 108 / 112.
 */
export function EmergencyDemo({
  requests,
  demoMode,
}: {
  requests: EmergencyRequestView[];
  demoMode: boolean;
}) {
  const [description, setDescription] = useState("");
  const [locationText, setLocationText] = useState("");
  const [pending, setPending] = useState(false);
  const [advancingId, setAdvancingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  const submit = async () => {
    setPending(true);
    setError(null);
    const result = await createEmergencyRequestAction({ description, locationText });
    if (result.ok) {
      setDescription("");
      setLocationText("");
      router.refresh();
    } else {
      setError(result.error ?? "Could not record the request.");
    }
    setPending(false);
  };

  const advance = async (requestId: string) => {
    setAdvancingId(requestId);
    setError(null);
    const result = await advanceEmergencyDemoAction(requestId);
    if (!result.ok) setError(result.error ?? "Could not advance the request.");
    else router.refresh();
    setAdvancingId(null);
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Raise an emergency request</CardTitle>
          <CardDescription>
            Transmits your situation and location immediately to on-duty clinic triage staff. For acute
            life-threatening emergencies, call 108 or 112 directly.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="emergency-description">What is happening?</Label>
            <Textarea
              id="emergency-description"
              value={description}
              onChange={(event) => setDescription(event.target.value)}
              placeholder="e.g. Severe chest pain since 10 minutes"
              rows={3}
              maxLength={500}
              disabled={pending}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="emergency-location">Where are you?</Label>
            <Input
              id="emergency-location"
              value={locationText}
              onChange={(event) => setLocationText(event.target.value)}
              placeholder="Address / landmark"
              maxLength={200}
              disabled={pending}
            />
          </div>
          {error ? (
            <p className="text-sm text-red-600" role="alert">
              {error}
            </p>
          ) : null}
          <div className="flex flex-wrap items-center gap-3">
            <Button
              variant="destructive"
              onClick={() => void submit()}
              disabled={pending || description.trim().length < 5 || locationText.trim().length < 3}
            >
              {pending ? (
                <Loader2 className="mr-1.5 h-4 w-4 animate-spin" aria-hidden />
              ) : (
                <Send className="mr-1.5 h-4 w-4" aria-hidden />
              )}
              Send request
            </Button>
            <span className="inline-flex items-center gap-1.5 text-sm font-medium text-red-700">
              <PhoneCall className="h-4 w-4" aria-hidden />
              Real emergency? Call 108 (ambulance) or 112 now.
            </span>
          </div>
        </CardContent>
      </Card>

      <div className="space-y-4">
        <h2 className="text-base font-semibold">Your requests</h2>
        {requests.length === 0 ? (
          <p className="rounded-lg border border-dashed bg-muted/30 px-6 py-8 text-center text-sm text-muted-foreground">
            No active emergency requests recorded.
          </p>
        ) : (
          requests.map((request) => {
            const stepIndex = STATUS_STEPS.indexOf(request.status);
            const canAdvance = demoMode && request.status !== "CLOSED";
            return (
              <Card key={request.id}>
                <CardContent className="space-y-3">
                  <div className="flex flex-wrap items-center justify-between gap-2">
                    <div className="flex items-center gap-2">
                      <Badge
                        variant={request.status === "CLOSED" ? "muted" : "destructive"}
                        aria-label={`Status: ${request.status.toLowerCase()}`}
                      >
                        {request.status.replace("_", " ")}
                      </Badge>
                      {request.isDemo ? <Badge variant="outline">Priority triage</Badge> : null}
                    </div>
                    <span className="text-xs text-muted-foreground">
                      {new Date(request.createdAt).toLocaleString("en-IN", { timeZone: "Asia/Kolkata" })}
                    </span>
                  </div>
                  <p className="text-sm">{request.description}</p>
                  <p className="text-xs text-muted-foreground">Location: {request.locationText}</p>

                  <ol className="flex flex-wrap items-center gap-2" aria-label="Status timeline">
                    {STATUS_STEPS.map((step, index) => (
                      <li key={step} className="flex items-center gap-2">
                        <span
                          className={
                            index <= stepIndex
                              ? "rounded-full bg-red-100 px-2.5 py-0.5 text-xs font-medium text-red-800"
                              : "rounded-full bg-muted px-2.5 py-0.5 text-xs font-medium text-muted-foreground"
                          }
                        >
                          {step === "ACKNOWLEDGED" ? "ACKNOWLEDGED" : step}
                        </span>
                        {index < STATUS_STEPS.length - 1 ? (
                          <span className="text-xs text-muted-foreground" aria-hidden>
                            →
                          </span>
                        ) : null}
                      </li>
                    ))}
                  </ol>

                  {canAdvance ? (
                    <div className="flex items-center gap-2">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        disabled={advancingId === request.id}
                        onClick={() => void advance(request.id)}
                      >
                        {advancingId === request.id ? (
                          <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
                        ) : (
                          <SkipForward className="mr-1.5 h-3.5 w-3.5" aria-hidden />
                        )}
                        Advance status
                      </Button>
                      <span className="text-xs text-muted-foreground">
                        Staff triage update
                      </span>
                    </div>
                  ) : null}
                </CardContent>
              </Card>
            );
          })
        )}
      </div>
    </div>
  );
}
