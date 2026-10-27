"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { saveConsultationNotesAction } from "@/services/clinical/actions";
import { AiSoapCopilot } from "@/components/clinical/ai-soap-copilot";
import type { PatientClinicalContext } from "@/lib/assistant/soap-generator";

interface ConsultationFormProps {
  consultationId: string;
  initial: {
    chief_complaint: string | null;
    symptoms: string | null;
    clinical_notes: string | null;
    assessment: string | null;
  };
  patientContext?: PatientClinicalContext;
}

const FIELDS = [
  { key: "chief_complaint", label: "Chief complaint", placeholder: "e.g. Fever with body ache for 3 days", rows: 2 },
  { key: "symptoms", label: "Symptoms", placeholder: "Observed / reported symptoms", rows: 3 },
  { key: "clinical_notes", label: "Clinical notes", placeholder: "Examination findings, vitals, observations", rows: 5 },
  { key: "assessment", label: "Assessment", placeholder: "Diagnosis reasoning and plan", rows: 3 },
] as const;

/** Consultation narrative fields with explicit save (no silent autosave). */
export function ConsultationForm({ consultationId, initial, patientContext }: ConsultationFormProps) {
  const router = useRouter();
  const [values, setValues] = useState({
    chief_complaint: initial.chief_complaint ?? "",
    symptoms: initial.symptoms ?? "",
    clinical_notes: initial.clinical_notes ?? "",
    assessment: initial.assessment ?? "",
  });
  const [dirty, setDirty] = useState(false);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setValues({
      chief_complaint: initial.chief_complaint ?? "",
      symptoms: initial.symptoms ?? "",
      clinical_notes: initial.clinical_notes ?? "",
      assessment: initial.assessment ?? "",
    });
    setDirty(false);
  }, [initial]);

  const handleSave = async () => {
    setPending(true);
    setError(null);
    const result = await saveConsultationNotesAction({ consultationId, ...values });
    if (result.ok) {
      toast.success("Notes saved");
      setDirty(false);
      router.refresh();
    } else {
      setError(result.error ?? "Could not save.");
    }
    setPending(false);
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between pb-3 border-b">
        <div>
          <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            Documentation Fields
          </p>
          <p className="text-xs text-muted-foreground">
            Type notes directly or generate using the AI Clinical Copilot.
          </p>
        </div>
        <AiSoapCopilot
          consultationId={consultationId}
          patientContext={patientContext}
          onApply={(data) => {
            setValues({
              chief_complaint: data.chief_complaint,
              symptoms: data.symptoms,
              clinical_notes: data.clinical_notes,
              assessment: data.assessment,
            });
            setDirty(true);
          }}
        />
      </div>
      {FIELDS.map((field) => (
        <div key={field.key} className="space-y-1.5">
          <Label htmlFor={`consult-${field.key}`}>{field.label}</Label>
          <Textarea
            id={`consult-${field.key}`}
            value={values[field.key]}
            placeholder={field.placeholder}
            rows={field.rows}
            disabled={pending}
            onChange={(event) => {
              setValues((current) => ({ ...current, [field.key]: event.target.value }));
              setDirty(true);
            }}
          />
        </div>
      ))}
      {error ? (
        <p className="text-sm text-red-600" role="alert">
          {error}
        </p>
      ) : null}
      <div className="flex items-center gap-3">
        <Button onClick={handleSave} disabled={pending || !dirty}>
          <Save className="mr-1.5 h-4 w-4" aria-hidden />
          {pending ? "Saving…" : "Save notes"}
        </Button>
        {dirty ? <span className="text-xs text-muted-foreground">Unsaved changes</span> : null}
      </div>
    </div>
  );
}
