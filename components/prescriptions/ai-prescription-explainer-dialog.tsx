"use client";

import { useState } from "react";
import {
  Sparkles,
  Clock,
  Sun,
  Sunrise,
  Sunset,
  Moon,
  Zap,
  ShieldAlert,
  Info,
  CheckCircle2,
  Calendar,
  Pill,
} from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { explainPrescriptionAction } from "@/services/clinical/ai-prescription-actions";
import type {
  PrescriptionExplanation,
  PrescriptionExplanationInput,
  TimelineSlot,
} from "@/lib/assistant/prescription-explainer";
import { toast } from "sonner";

interface AiPrescriptionExplainerDialogProps {
  prescription: PrescriptionExplanationInput;
}

function getSlotIcon(key: TimelineSlot["slotKey"]) {
  switch (key) {
    case "morning":
      return <Sunrise className="h-4 w-4 text-amber-500" />;
    case "afternoon":
      return <Sun className="h-4 w-4 text-orange-500" />;
    case "evening":
      return <Sunset className="h-4 w-4 text-rose-500" />;
    case "bedtime":
      return <Moon className="h-4 w-4 text-indigo-500" />;
    case "as_needed":
      return <Zap className="h-4 w-4 text-amber-600" />;
  }
}

export function AiPrescriptionExplainerDialog({
  prescription,
}: AiPrescriptionExplainerDialogProps) {
  const [open, setOpen] = useState(false);
  const [language, setLanguage] = useState<"en" | "hi">("en");
  const [loading, setLoading] = useState(false);
  const [explanation, setExplanation] = useState<PrescriptionExplanation | null>(null);

  const loadExplanation = async (lang: "en" | "hi") => {
    setLoading(true);
    setLanguage(lang);

    const res = await explainPrescriptionAction({
      ...prescription,
      language: lang,
    });

    if (res.ok && res.data) {
      setExplanation(res.data);
    } else {
      toast.error(res.error ?? "Could not load prescription explanation");
    }
    setLoading(false);
  };

  const handleOpen = (newOpen: boolean) => {
    setOpen(newOpen);
    if (newOpen && !explanation) {
      void loadExplanation(language);
    }
  };

  const handleLanguageChange = (newLang: "en" | "hi") => {
    if (newLang === language && explanation) return;
    void loadExplanation(newLang);
  };

  return (
    <Dialog open={open} onOpenChange={handleOpen}>
      <DialogTrigger asChild>
        <Button
          type="button"
          size="sm"
          variant="outline"
          className="border-primary/30 text-primary hover:bg-primary/10 gap-1.5 font-medium"
        >
          <Sparkles className="h-3.5 w-3.5 text-primary" aria-hidden />
          AI Explain & Schedule
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-2xl sm:max-w-3xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-b pb-3">
            <div>
              <DialogTitle className="text-lg font-semibold flex items-center gap-2">
                <Pill className="h-5 w-5 text-primary" />
                Prescription Explainer & Daily Schedule
              </DialogTitle>
              <DialogDescription className="text-xs text-muted-foreground mt-0.5">
                Dr. {prescription.doctor_name} · {prescription.clinic_name || "Better Clinic"}
              </DialogDescription>
            </div>

            <div className="flex items-center gap-1 rounded-lg border bg-muted/40 p-1 self-start sm:self-auto">
              <button
                type="button"
                onClick={() => handleLanguageChange("en")}
                disabled={loading}
                className={`rounded px-2.5 py-1 text-xs font-medium transition-all ${
                  language === "en"
                    ? "bg-background text-foreground shadow-xs"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                English
              </button>
              <button
                type="button"
                onClick={() => handleLanguageChange("hi")}
                disabled={loading}
                className={`rounded px-2.5 py-1 text-xs font-medium transition-all ${
                  language === "hi"
                    ? "bg-background text-foreground shadow-xs"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                हिंदी (Hindi)
              </button>
            </div>
          </div>
        </DialogHeader>

        {loading ? (
          <div className="flex flex-col items-center justify-center py-12 text-center gap-3">
            <Sparkles className="h-8 w-8 animate-spin text-primary" />
            <p className="text-sm font-medium">Analyzing prescription & building timeline…</p>
            <p className="text-xs text-muted-foreground">
              Translating dosing frequencies and food relations into a daily schedule
            </p>
          </div>
        ) : explanation ? (
          <div className="space-y-6 pt-1">
            <div className="rounded-lg border bg-primary/5 p-3.5 text-sm leading-relaxed">
              <div className="flex items-center justify-between gap-2 mb-1.5">
                <span className="text-xs font-semibold uppercase tracking-wider text-primary flex items-center gap-1">
                  <Info className="h-3.5 w-3.5" />
                  {language === "hi" ? "सारांश व परामर्श" : "Overview"}
                </span>
                <Badge
                  variant="outline"
                  className={
                    explanation.usedLlm
                      ? "border-emerald-300 bg-emerald-50 text-emerald-700 text-[11px]"
                      : "border-sky-300 bg-sky-50 text-sky-700 text-[11px]"
                  }
                >
                  {explanation.usedLlm ? "AI Clinical Intelligence" : "Verified Clinical Protocol"}
                </Badge>
              </div>
              <p className="text-xs text-foreground/90">{explanation.summary}</p>
            </div>

            <div className="space-y-3">
              <h4 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground flex items-center gap-1.5">
                <Clock className="h-4 w-4 text-primary" />
                {language === "hi" ? "दैनिक दवा समय-सारणी (Daily Timeline)" : "Your Daily Medication Schedule"}
              </h4>

              <div className="grid gap-3 sm:grid-cols-2">
                {explanation.timeline.map((slot) => (
                  <div
                    key={slot.slotKey}
                    className="flex flex-col rounded-lg border bg-card p-3 shadow-2xs hover:shadow-xs transition-shadow"
                  >
                    <div className="flex items-center gap-2 border-b pb-2 mb-2 font-medium text-xs">
                      {getSlotIcon(slot.slotKey)}
                      <span className="font-semibold text-foreground">{slot.timeLabel}</span>
                    </div>
                    <ul className="space-y-2 flex-1">
                      {slot.medicines.map((med, i) => (
                        <li key={i} className="text-xs space-y-0.5">
                          <p className="font-medium text-foreground">{med.name}</p>
                          <p className="text-muted-foreground flex items-center gap-1">
                            <span>Dose: {med.dose}</span> ·
                            <span className="text-primary font-medium">{med.foodAdvice}</span>
                          </p>
                          {med.instructions ? (
                            <p className="text-[11px] text-amber-700 dark:text-amber-400 italic">
                              Note: {med.instructions}
                            </p>
                          ) : null}
                        </li>
                      ))}
                    </ul>
                  </div>
                ))}
              </div>
            </div>

            <div className="space-y-3">
              <h4 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground flex items-center gap-1.5">
                <CheckCircle2 className="h-4 w-4 text-emerald-600" />
                {language === "hi" ? "दवाओं का विवरण और उद्देश्य" : "Why Each Medicine Was Prescribed"}
              </h4>

              <div className="space-y-2.5">
                {explanation.medicines.map((med, i) => (
                  <div key={i} className="rounded-lg border p-3 text-xs space-y-1.5 bg-card">
                    <div className="flex items-center justify-between gap-2">
                      <p className="font-semibold text-sm text-foreground">{med.name}</p>
                      <Badge variant="secondary" className="text-[11px]">
                        <Calendar className="mr-1 h-3 w-3" />
                        {med.duration}
                      </Badge>
                    </div>
                    <p className="text-muted-foreground">
                      <strong className="text-foreground">{language === "hi" ? "उद्देश्य: " : "Purpose: "}</strong>
                      {med.purpose}
                    </p>
                    <p className="text-muted-foreground">
                      <strong className="text-foreground">{language === "hi" ? "लेने का तरीका: " : "How to take: "}</strong>
                      {med.howToTake}
                    </p>
                    {med.precautions ? (
                      <p className="text-amber-700 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/30 p-1.5 rounded text-[11px]">
                        ⚠️ {med.precautions}
                      </p>
                    ) : null}
                  </div>
                ))}
              </div>
            </div>

            <div className="rounded-lg border border-amber-200/70 bg-amber-50/50 dark:border-amber-900/40 dark:bg-amber-950/20 p-3.5 text-xs space-y-2">
              <div className="flex items-center gap-1.5 font-semibold text-amber-900 dark:text-amber-200">
                <ShieldAlert className="h-4 w-4 shrink-0" />
                {language === "hi" ? "दवा छूट जाने पर क्या करें?" : "What If You Miss a Dose?"}
              </div>
              <p className="text-amber-900/90 dark:text-amber-300/90 leading-relaxed">
                {explanation.missedDoseAdvice}
              </p>

              {explanation.safetyTips.length > 0 && (
                <div className="pt-2 border-t border-amber-200/50 dark:border-amber-900/40">
                  <p className="font-semibold text-amber-900 dark:text-amber-200 mb-1">
                    {language === "hi" ? "महत्वपूर्ण सुरक्षा निर्देश:" : "Safety Guidelines:"}
                  </p>
                  <ul className="list-disc pl-4 space-y-0.5 text-amber-900/90 dark:text-amber-300/90">
                    {explanation.safetyTips.map((tip, idx) => (
                      <li key={idx}>{tip}</li>
                    ))}
                  </ul>
                </div>
              )}
            </div>

            <p className="text-[11px] text-muted-foreground text-center">
              This automated explanation is grounded strictly in your clinic records. Always follow the instructions of Dr. {prescription.doctor_name}.
            </p>
          </div>
        ) : null}
      </DialogContent>
    </Dialog>
  );
}
