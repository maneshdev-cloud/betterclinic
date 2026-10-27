"use client";

import { useState, useRef, useEffect } from "react";
import {
  Sparkles,
  Stethoscope,
  Mic,
  MicOff,
  Wand2,
  Check,
  AlertCircle,
  ArrowRight,
  RotateCcw,
} from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { generateSoapNoteAction } from "@/services/clinical/ai-actions";
import type { SoapNote, PatientClinicalContext } from "@/lib/assistant/soap-generator";
import { toast } from "sonner";

interface AiSoapCopilotProps {
  consultationId: string;
  patientContext?: PatientClinicalContext;
  onApply: (data: {
    chief_complaint: string;
    symptoms: string;
    clinical_notes: string;
    assessment: string;
  }) => void;
}

const CLINICAL_TEMPLATES = [
  {
    label: "Acute Pharyngitis / Flu",
    text: "Patient has severe sore throat with difficulty swallowing for 3 days. Fever 101.2 F, chills, mild dry cough. No shortness of breath. Vitals: BP 120/80, HR 88, SpO2 98%. On examination: pharyngeal congestion and bilateral tonsillar erythema, chest clear to auscultation. Diagnosis: Acute Viral Pharyngitis. Plan: symptomatic antipyretics, warm saline gargles, hydration.",
  },
  {
    label: "Hypertension Review",
    text: "Follow-up visit for hypertension. Patient is asymptomatic today, compliant with morning medication. BP measured 142/90 mmHg, Pulse 74 bpm regular, SpO2 99%. Cardiovascular: S1/S2 heard, no murmurs. Mild trace pedal edema. Advised low salt diet, daily brisk walking, monitor BP log for 1 week.",
  },
  {
    label: "Acute Gastroenteritis",
    text: "Watery loose stools 5-6 episodes since yesterday after eating outside food. Mild cramping periumbilical pain, nausea, low-grade fever 99.8 F. Vitals: BP 110/72, HR 96, dry tongue. Abdomen soft, mild diffuse tenderness, no guarding or rigidity. Diagnosis: Acute Gastroenteritis. Plan: Oral Rehydration Salts (ORS), probiotics, bland diet.",
  },
  {
    label: "Migraine / Tension Headache",
    text: "Throbbing unilateral left temple headache for 2 days. Accompanied by photophobia and nausea. Denies visual aura, weakness, or fever. Vitals normal: BP 124/82, HR 70. Neurological examination intact, cranial nerves normal, neck supple. Provisional diagnosis: Migraine without aura.",
  },
];

export function AiSoapCopilot({
  consultationId,
  patientContext,
  onApply,
}: AiSoapCopilotProps) {
  const [open, setOpen] = useState(false);
  const [rawNotes, setRawNotes] = useState("");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<SoapNote | null>(null);
  const [isRecording, setIsRecording] = useState(false);
  const [speechSupported, setSpeechSupported] = useState(false);
  const recognitionRef = useRef<any>(null);

  // Editable generated fields
  const [draft, setDraft] = useState({
    chief_complaint: "",
    symptoms: "",
    clinical_notes: "",
    assessment: "",
  });

  useEffect(() => {
    // Check Web Speech API support
    if (typeof window !== "undefined") {
      const SpeechRecognition =
        (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
      if (SpeechRecognition) {
        setSpeechSupported(true);
        const recog = new SpeechRecognition();
        recog.continuous = true;
        recog.interimResults = true;
        recog.lang = "en-IN";

        recog.onresult = (event: any) => {
          let transcript = "";
          for (let i = event.resultIndex; i < event.results.length; i++) {
            transcript += event.results[i][0].transcript;
          }
          if (transcript.trim()) {
            setRawNotes((prev) => (prev ? `${prev} ${transcript}` : transcript));
          }
        };

        recog.onerror = () => {
          setIsRecording(false);
        };

        recog.onend = () => {
          setIsRecording(false);
        };

        recognitionRef.current = recog;
      }
    }
  }, []);

  const toggleRecording = () => {
    if (!recognitionRef.current) return;
    if (isRecording) {
      recognitionRef.current.stop();
      setIsRecording(false);
    } else {
      try {
        recognitionRef.current.start();
        setIsRecording(true);
        toast.info("Listening... speak your observations");
      } catch (e) {
        console.warn("Could not start speech recognition:", e);
      }
    }
  };

  const handleGenerate = async (notesToUse = rawNotes) => {
    if (!notesToUse.trim()) {
      toast.error("Please enter observations or select a quick template");
      return;
    }

    setLoading(true);
    setResult(null);

    const res = await generateSoapNoteAction({
      consultationId,
      notes: notesToUse,
      patientContext,
    });

    if (res.ok && res.data) {
      setResult(res.data);
      setDraft({
        chief_complaint: res.data.chief_complaint,
        symptoms: res.data.symptoms,
        clinical_notes: res.data.clinical_notes,
        assessment: res.data.assessment,
      });
      toast.success(
        res.data.usedLlm
          ? "Generated clinical SOAP note with AI Intelligence"
          : "Structured with Clinical Decision Engine"
      );
    } else {
      toast.error(res.error ?? "Failed to generate SOAP note");
    }
    setLoading(false);
  };

  const handleApplyToForm = () => {
    onApply(draft);
    setOpen(false);
    toast.success("Applied to consultation form! Click 'Save notes' to persist.");
  };

  const resetAll = () => {
    setRawNotes("");
    setResult(null);
    if (isRecording && recognitionRef.current) {
      recognitionRef.current.stop();
      setIsRecording(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button
          type="button"
          size="sm"
          className="relative inline-flex items-center gap-1.5 overflow-hidden bg-gradient-to-r from-teal-600 to-indigo-600 text-white shadow-sm transition-all hover:from-teal-500 hover:to-indigo-500 hover:shadow-md"
        >
          <Sparkles className="h-4 w-4 animate-pulse text-amber-200" aria-hidden />
          <span className="font-medium">AI Clinical Copilot</span>
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-3xl sm:max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <div className="flex items-center gap-2">
            <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
              <Stethoscope className="h-5 w-5" />
            </div>
            <div>
              <DialogTitle className="text-lg font-semibold flex items-center gap-2">
                Clinical Copilot · SOAP Note Generator
                <Badge variant="outline" className="border-teal-300 bg-teal-50 text-teal-800 text-[11px] font-normal">
                  Doctor Assist
                </Badge>
              </DialogTitle>
              <DialogDescription className="text-xs text-muted-foreground">
                Convert fragmented notes, vitals, or dictated thoughts into clean clinical SOAP documentation.
              </DialogDescription>
            </div>
          </div>
        </DialogHeader>

        {/* Patient Context Header */}
        {patientContext && (
          <div className="flex flex-wrap items-center gap-2 rounded-md border bg-muted/40 p-2.5 text-xs">
            <span className="font-semibold text-foreground">Patient Context:</span>
            {patientContext.patientName && (
              <Badge variant="secondary" className="font-medium">
                {patientContext.patientName}
                {patientContext.age ? ` (${patientContext.age}y)` : ""}
              </Badge>
            )}
            {patientContext.visitReason && (
              <span className="text-muted-foreground">
                Reason: <strong className="text-foreground">{patientContext.visitReason}</strong>
              </span>
            )}
            {patientContext.allergies && patientContext.allergies.length > 0 ? (
              <Badge variant="destructive" className="flex items-center gap-1">
                <AlertCircle className="h-3 w-3" />
                Allergies: {patientContext.allergies.join(", ")}
              </Badge>
            ) : (
              <span className="text-emerald-700 dark:text-emerald-400 font-medium">✓ No known allergies</span>
            )}
            {patientContext.conditions && patientContext.conditions.length > 0 && (
              <Badge variant="outline" className="text-sky-700 border-sky-300">
                Conditions: {patientContext.conditions.join(", ")}
              </Badge>
            )}
          </div>
        )}

        {/* Standard Clinical Case Templates */}
        <div className="space-y-1.5">
          <div className="flex items-center justify-between">
            <Label className="text-xs font-medium text-muted-foreground">
              Standard Clinical Case Templates (Click to fill):
            </Label>
            {rawNotes && (
              <button
                type="button"
                onClick={resetAll}
                className="text-xs text-muted-foreground hover:text-foreground inline-flex items-center gap-1"
              >
                <RotateCcw className="h-3 w-3" /> Clear
              </button>
            )}
          </div>
          <div className="flex flex-wrap gap-1.5">
            {CLINICAL_TEMPLATES.map((tmpl) => (
              <button
                key={tmpl.label}
                type="button"
                onClick={() => {
                  setRawNotes(tmpl.text);
                  void handleGenerate(tmpl.text);
                }}
                disabled={loading}
                className="rounded-full border border-border bg-background px-3 py-1 text-xs font-medium text-muted-foreground hover:border-primary hover:text-foreground transition-all shadow-2xs hover:bg-muted/50"
              >
                + {tmpl.label}
              </button>
            ))}
          </div>
        </div>

        {/* Raw Doctor Notes Input */}
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <Label htmlFor="raw-clinical-notes" className="text-xs font-semibold">
              Doctor's Raw Notes / Observations / Vitals:
            </Label>
            {speechSupported && (
              <Button
                type="button"
                size="sm"
                variant={isRecording ? "destructive" : "outline"}
                onClick={toggleRecording}
                className="h-7 text-xs gap-1.5 px-2.5"
              >
                {isRecording ? (
                  <>
                    <MicOff className="h-3.5 w-3.5 animate-pulse" /> Stop Listening
                  </>
                ) : (
                  <>
                    <Mic className="h-3.5 w-3.5" /> Dictate Notes
                  </>
                )}
              </Button>
            )}
          </div>
          <Textarea
            id="raw-clinical-notes"
            value={rawNotes}
            onChange={(e) => setRawNotes(e.target.value)}
            placeholder="Type or dictate observations, e.g.: Patient has fever 101F since 2 days, sore throat, BP 120/80, throat congested, diagnosis: acute pharyngitis..."
            rows={3}
            disabled={loading}
            className="text-sm resize-none"
          />
        </div>

        {/* Generate Trigger */}
        <div className="flex items-center justify-between pt-1">
          <p className="text-[11px] text-muted-foreground">
            Grounded in clinical safety. Outputs structured Subjective, Objective, Assessment, and Plan.
          </p>
          <Button
            type="button"
            onClick={() => void handleGenerate()}
            disabled={loading || !rawNotes.trim()}
            className="bg-primary hover:bg-primary/90 text-primary-foreground gap-1.5"
          >
            <Wand2 className="h-4 w-4" />
            {loading ? "Structuring Note…" : "Generate Structured Note"}
          </Button>
        </div>

        {/* Structured Results Preview */}
        {result && (
          <div className="space-y-3 rounded-lg border bg-card p-4 shadow-sm animate-in fade-in-50">
            <div className="flex items-center justify-between border-b pb-2">
              <span className="text-xs font-semibold uppercase tracking-wider text-muted-foreground flex items-center gap-1.5">
                <Check className="h-4 w-4 text-emerald-600" />
                Structured Clinical Documentation
              </span>
              <Badge
                variant="outline"
                className={
                  result.usedLlm
                    ? "border-emerald-300 bg-emerald-50 text-emerald-700 text-xs"
                    : "border-sky-300 bg-sky-50 text-sky-700 text-xs"
                }
              >
                {result.usedLlm ? "AI Clinical Intelligence" : "Standard Clinical Parser"}
              </Badge>
            </div>

            <div className="grid gap-3 sm:grid-cols-2">
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-primary">Chief Complaint</Label>
                <Textarea
                  value={draft.chief_complaint}
                  onChange={(e) => setDraft((d) => ({ ...d, chief_complaint: e.target.value }))}
                  rows={2}
                  className="text-xs bg-muted/20"
                />
              </div>

              <div className="space-y-1">
                <Label className="text-xs font-semibold text-primary">Symptoms (Subjective)</Label>
                <Textarea
                  value={draft.symptoms}
                  onChange={(e) => setDraft((d) => ({ ...d, symptoms: e.target.value }))}
                  rows={2}
                  className="text-xs bg-muted/20"
                />
              </div>

              <div className="space-y-1">
                <Label className="text-xs font-semibold text-primary">Clinical Notes & Vitals (Objective)</Label>
                <Textarea
                  value={draft.clinical_notes}
                  onChange={(e) => setDraft((d) => ({ ...d, clinical_notes: e.target.value }))}
                  rows={3}
                  className="text-xs bg-muted/20"
                />
              </div>

              <div className="space-y-1">
                <Label className="text-xs font-semibold text-primary">Assessment & Plan</Label>
                <Textarea
                  value={draft.assessment}
                  onChange={(e) => setDraft((d) => ({ ...d, assessment: e.target.value }))}
                  rows={3}
                  className="text-xs bg-muted/20"
                />
              </div>
            </div>

            {result.suggested_advice && (
              <div className="rounded-md border border-amber-200/60 bg-amber-50/50 p-2.5 text-xs text-amber-900 dark:border-amber-900/40 dark:bg-amber-950/20 dark:text-amber-200">
                <span className="font-semibold">Patient Lifestyle & Recovery Advice: </span>
                {result.suggested_advice}
              </div>
            )}
          </div>
        )}

        <DialogFooter className="gap-2 sm:justify-between border-t pt-3">
          <Button type="button" variant="ghost" onClick={() => setOpen(false)} size="sm">
            Cancel
          </Button>
          {result && (
            <Button
              type="button"
              onClick={handleApplyToForm}
              className="gap-1.5 bg-emerald-600 hover:bg-emerald-700 text-white font-medium"
            >
              Apply to Consultation Form
              <ArrowRight className="h-4 w-4" />
            </Button>
          )}
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
