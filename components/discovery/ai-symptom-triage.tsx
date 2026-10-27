"use client";

import { useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import {
  Sparkles,
  Search,
  AlertTriangle,
  ArrowRight,
  HelpCircle,
  PhoneCall,
  CheckCircle,
  Clock,
  RotateCcw,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { triageSymptomsAction } from "@/services/doctors/ai-triage-actions";
import type { TriageResult } from "@/lib/assistant/symptom-triage";
import { toast } from "sonner";

interface AiSymptomTriageProps {
  specializations: string[];
}

const SAMPLE_SYMPTOMS = [
  {
    label: "Fever & Cough (3 days)",
    text: "I have had fever 101F, body ache, sore throat, and a dry cough for the last 3 days.",
  },
  {
    label: "Throbbing Headache",
    text: "Sudden throbbing headache on left side with light sensitivity and nausea for 2 days.",
  },
  {
    label: "Knee Joint Pain",
    text: "Severe knee pain and stiffness every morning, difficulty climbing stairs and walking.",
  },
  {
    label: "Chest Tightness (Emergency Test)",
    text: "Sudden heavy chest pressure radiating to my left arm with trouble breathing.",
  },
  {
    label: "Itchy Skin Rash",
    text: "Red itchy hives and rash spreading across my arms and neck after eating outside.",
  },
];

export function AiSymptomTriage({ specializations }: AiSymptomTriageProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [symptoms, setSymptoms] = useState("");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<TriageResult | null>(null);
  const [expanded, setExpanded] = useState(false);

  const handleTriage = async (textToUse = symptoms) => {
    const text = textToUse.trim();
    if (text.length < 3) {
      toast.error("Please enter a few words describing what you feel");
      return;
    }

    setLoading(true);
    setResult(null);

    const res = await triageSymptomsAction({
      symptoms: text,
      availableSpecializations: specializations,
    });

    if (res.ok && res.data) {
      setResult(res.data);
      if (res.data.isEmergency) {
        toast.error("Emergency symptoms detected. Please seek immediate emergency medical care!");
      } else {
        toast.success(`Recommended: ${res.data.recommendedSpecialization}`);
      }
    } else {
      toast.error(res.error ?? "Could not analyze symptoms. Please try again.");
    }
    setLoading(false);
  };

  const handleApplySpecialty = (specialty: string) => {
    const params = new URLSearchParams(searchParams?.toString() ?? "");
    params.set("specialization", specialty);
    params.delete("page");
    router.push(`/patient/doctors?${params.toString()}`);
    toast.info(`Filtered doctors for ${specialty}`);
  };

  const resetTriage = () => {
    setSymptoms("");
    setResult(null);
  };

  return (
    <Card className="border-primary/20 bg-gradient-to-br from-primary/5 via-background to-indigo-50/20 dark:to-indigo-950/10 shadow-sm">
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/15 text-primary">
              <Sparkles className="h-4 w-4 text-primary animate-pulse" />
            </div>
            <div>
              <CardTitle className="text-base font-semibold flex items-center gap-2">
                Not sure which doctor to book?
                <Badge variant="outline" className="border-primary/30 bg-primary/10 text-primary text-[11px] font-normal">
                  ✨ AI Symptom Triage
                </Badge>
              </CardTitle>
              <p className="text-xs text-muted-foreground mt-0.5">
                Describe what you are experiencing in plain words, and we'll match you to the right specialty.
              </p>
            </div>
          </div>

          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={() => setExpanded((prev) => !prev)}
            className="text-xs text-muted-foreground hover:text-foreground"
          >
            {expanded ? "Collapse ▲" : "Try Symptom Finder ▼"}
          </Button>
        </div>
      </CardHeader>

      {expanded && (
        <CardContent className="space-y-4 pt-1 animate-in fade-in-50 duration-200">
          {/* Common symptom queries */}
          <div className="space-y-1.5">
            <div className="flex items-center justify-between">
              <span className="text-[11px] font-medium text-muted-foreground">
                Common symptom scenarios (Click to explore):
              </span>
              {symptoms && (
                <button
                  type="button"
                  onClick={resetTriage}
                  className="text-[11px] text-muted-foreground hover:text-foreground inline-flex items-center gap-1"
                >
                  <RotateCcw className="h-3 w-3" /> Reset
                </button>
              )}
            </div>
            <div className="flex flex-wrap gap-1.5">
              {SAMPLE_SYMPTOMS.map((sample) => (
                <button
                  key={sample.label}
                  type="button"
                  onClick={() => {
                    setSymptoms(sample.text);
                    void handleTriage(sample.text);
                  }}
                  disabled={loading}
                  className="rounded-full border border-border bg-background px-2.5 py-1 text-xs font-medium text-muted-foreground hover:border-primary hover:text-foreground hover:bg-muted/50 transition-all shadow-2xs"
                >
                  + {sample.label}
                </button>
              ))}
            </div>
          </div>

          {/* Text Input */}
          <div className="space-y-2">
            <Textarea
              value={symptoms}
              onChange={(e) => setSymptoms(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                  e.preventDefault();
                  void handleTriage();
                }
              }}
              placeholder="e.g. I have a throbbing headache since yesterday, sensitive to bright lights and slight nausea..."
              rows={2}
              disabled={loading}
              className="text-sm resize-none bg-background"
            />
            <div className="flex items-center justify-between">
              <span className="text-[11px] text-muted-foreground">
                Answers are grounded in medical triage rules. Never replaces doctor consultation.
              </span>
              <Button
                type="button"
                size="sm"
                onClick={() => void handleTriage()}
                disabled={loading || symptoms.trim().length < 3}
                className="gap-1.5"
              >
                <Search className="h-3.5 w-3.5" />
                {loading ? "Analyzing Symptoms…" : "Find Right Specialist"}
              </Button>
            </div>
          </div>

          {/* Result Card */}
          {result && (
            <div className="space-y-3 pt-2 animate-in fade-in-50">
              {result.isEmergency ? (
                /* Emergency Alert */
                <div className="rounded-lg border-2 border-red-500/80 bg-red-50/90 dark:bg-red-950/40 p-4 text-red-950 dark:text-red-200 space-y-3 shadow-md">
                  <div className="flex items-start gap-2.5">
                    <AlertTriangle className="h-5 w-5 text-red-600 dark:text-red-400 shrink-0 mt-0.5" />
                    <div className="space-y-1">
                      <p className="font-bold text-sm">
                        🚨 EMERGENCY SAFETY WARNING: Immediate Attention Required
                      </p>
                      <p className="text-xs leading-relaxed opacity-95">
                        {result.emergencyMessage ||
                          "Your symptoms match critical red-flag conditions. Please do not wait for an outpatient appointment."}
                      </p>
                    </div>
                  </div>
                  <div className="flex flex-wrap items-center gap-2 pt-1">
                    <a
                      href="tel:108"
                      className="inline-flex items-center gap-1.5 rounded-md bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 text-xs font-semibold shadow-xs"
                    >
                      <PhoneCall className="h-3.5 w-3.5" /> Call 108 (Ambulance)
                    </a>
                    <a
                      href="tel:112"
                      className="inline-flex items-center gap-1.5 rounded-md border border-red-300 bg-white/80 dark:bg-red-900/40 text-red-700 dark:text-red-200 px-3 py-1.5 text-xs font-semibold"
                    >
                      Call 112 (All-in-one Emergency)
                    </a>
                  </div>
                </div>
              ) : (
                /* Routine / Same-Day Recommendation */
                <div className="rounded-lg border bg-card p-4 space-y-3 shadow-sm">
                  <div className="flex flex-wrap items-center justify-between gap-2 border-b pb-2.5">
                    <div className="flex items-center gap-2">
                      <CheckCircle className="h-4 w-4 text-emerald-600" />
                      <span className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                        Recommended Specialty
                      </span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Badge
                        variant={result.urgencyLevel === "SAME_DAY" ? "warning" : "outline"}
                        className="text-[11px]"
                      >
                        <Clock className="mr-1 h-3 w-3" />
                        {result.urgencyLevel === "SAME_DAY" ? "Same-Day Preferred" : "Routine Consultation"}
                      </Badge>
                      <Badge
                        variant="outline"
                        className={
                          result.usedLlm
                            ? "border-emerald-300 bg-emerald-50 text-emerald-700 text-[11px]"
                            : "border-sky-300 bg-sky-50 text-sky-700 text-[11px]"
                        }
                      >
                        {result.usedLlm ? "Clinical Intelligence Triage" : "Standard Triage Protocol"}
                      </Badge>
                    </div>
                  </div>

                  {/* Main Recommendation */}
                  <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 bg-primary/5 p-3 rounded-md">
                    <div>
                      <p className="text-base font-bold text-foreground">
                        {result.recommendedSpecialization}
                      </p>
                      <p className="text-xs text-muted-foreground mt-0.5">
                        {result.reasoning}
                      </p>
                    </div>

                    <Button
                      type="button"
                      size="sm"
                      onClick={() => handleApplySpecialty(result.recommendedSpecialization)}
                      className="gap-1.5 shrink-0 bg-primary hover:bg-primary/90 text-primary-foreground font-medium"
                    >
                      Show {result.recommendedSpecialization} Doctors
                      <ArrowRight className="h-3.5 w-3.5" />
                    </Button>
                  </div>

                  {/* Questions to prepare */}
                  {result.questionsToPrepare.length > 0 && (
                    <div className="pt-1 text-xs space-y-1.5">
                      <p className="font-semibold text-muted-foreground flex items-center gap-1">
                        <HelpCircle className="h-3.5 w-3.5 text-primary" />
                        Questions to prepare for your consultation:
                      </p>
                      <ul className="list-disc pl-5 space-y-0.5 text-muted-foreground">
                        {result.questionsToPrepare.map((q, idx) => (
                          <li key={idx}>{q}</li>
                        ))}
                      </ul>
                    </div>
                  )}
                </div>
              )}
            </div>
          )}
        </CardContent>
      )}
    </Card>
  );
}
