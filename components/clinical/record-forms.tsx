"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Stethoscope, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { addDiagnosisAction, addMedicalHistoryAction } from "@/services/clinical/actions";
import { MEDICAL_HISTORY_TYPES, MEDICAL_HISTORY_LABELS } from "@/lib/constants";

/** Inline form to record a diagnosis for a consultation. */
export function DiagnosisForm({ consultationId }: { consultationId: string }) {
  const router = useRouter();
  const [name, setName] = useState("");
  const [code, setCode] = useState("");
  const [isPrimary, setIsPrimary] = useState(false);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async () => {
    setPending(true);
    setError(null);
    const result = await addDiagnosisAction({
      consultationId,
      name,
      code,
      is_primary: isPrimary,
    });
    if (result.ok) {
      toast.success("Diagnosis recorded");
      setName("");
      setCode("");
      setIsPrimary(false);
      router.refresh();
    } else {
      setError(result.error ?? "Could not record the diagnosis.");
    }
    setPending(false);
  };

  return (
    <div className="space-y-3">
      <div className="grid gap-3 sm:grid-cols-[1fr_120px]">
        <div className="space-y-1">
          <Label htmlFor="diagnosis-name" className="text-xs text-muted-foreground">
            Diagnosis *
          </Label>
          <Input
            id="diagnosis-name"
            value={name}
            onChange={(event) => setName(event.target.value)}
            placeholder="e.g. Acute viral fever"
            maxLength={160}
            disabled={pending}
          />
        </div>
        <div className="space-y-1">
          <Label htmlFor="diagnosis-code" className="text-xs text-muted-foreground">
            Code (ICD)
          </Label>
          <Input
            id="diagnosis-code"
            value={code}
            onChange={(event) => setCode(event.target.value)}
            placeholder="e.g. B34.9"
            maxLength={30}
            disabled={pending}
          />
        </div>
      </div>
      <label className="flex cursor-pointer items-center gap-2 text-sm">
        <Checkbox checked={isPrimary} onCheckedChange={(checked) => setIsPrimary(checked === true)} id="diagnosis-primary" />
        <Label htmlFor="diagnosis-primary" className="cursor-pointer font-normal">
          Primary diagnosis
        </Label>
      </label>
      {error ? (
        <p className="text-sm text-red-600" role="alert">
          {error}
        </p>
      ) : null}
      <Button size="sm" variant="outline" onClick={handleSubmit} disabled={pending || name.trim().length < 2}>
        <Plus className="mr-1.5 h-4 w-4" aria-hidden />
        {pending ? "Saving…" : "Add diagnosis"}
      </Button>
    </div>
  );
}

/** Doctor records an allergy / chronic condition / history entry for a patient. */
export function MedicalHistoryForm({ patientId, compact = false }: { patientId: string; compact?: boolean }) {
  const router = useRouter();
  const [recordType, setRecordType] = useState<string>("ALLERGY");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async () => {
    setPending(true);
    setError(null);
    const result = await addMedicalHistoryAction({
      patientId,
      record_type: recordType,
      title,
      description,
    });
    if (result.ok) {
      toast.success("Medical history entry recorded");
      setTitle("");
      setDescription("");
      router.refresh();
    } else {
      setError(result.error ?? "Could not record the entry.");
    }
    setPending(false);
  };

  return (
    <div className="space-y-3">
      <div className={compact ? "grid gap-3 sm:grid-cols-[180px_1fr]" : "grid gap-3 sm:grid-cols-2"}>
        <div className="space-y-1">
          <Label htmlFor={`history-type-${patientId.slice(0, 8)}`} className="text-xs text-muted-foreground">
            Type
          </Label>
          <Select value={recordType} onValueChange={setRecordType}>
            <SelectTrigger id={`history-type-${patientId.slice(0, 8)}`} className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {MEDICAL_HISTORY_TYPES.map((type) => (
                <SelectItem key={type} value={type}>
                  {MEDICAL_HISTORY_LABELS[type]}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-1">
          <Label htmlFor={`history-title-${patientId.slice(0, 8)}`} className="text-xs text-muted-foreground">
            Title *
          </Label>
          <Input
            id={`history-title-${patientId.slice(0, 8)}`}
            value={title}
            onChange={(event) => setTitle(event.target.value)}
            placeholder={recordType === "ALLERGY" ? "e.g. Penicillin" : "e.g. Type 2 diabetes"}
            maxLength={120}
            disabled={pending}
          />
        </div>
      </div>
      <div className="space-y-1">
        <Label htmlFor={`history-description-${patientId.slice(0, 8)}`} className="text-xs text-muted-foreground">
          Details (optional)
        </Label>
        <Input
          id={`history-description-${patientId.slice(0, 8)}`}
          value={description}
          onChange={(event) => setDescription(event.target.value)}
          placeholder="e.g. Diagnosed 2019, on metformin"
          maxLength={500}
          disabled={pending}
        />
      </div>
      {error ? (
        <p className="text-sm text-red-600" role="alert">
          {error}
        </p>
      ) : null}
      <Button size="sm" variant="outline" onClick={handleSubmit} disabled={pending || title.trim().length < 2}>
        <Stethoscope className="mr-1.5 h-4 w-4" aria-hidden />
        {pending ? "Saving…" : "Record entry"}
      </Button>
    </div>
  );
}
