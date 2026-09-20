"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Pill, Plus, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { savePrescriptionAction } from "@/services/clinical/actions";
import type { PrescriptionView } from "@/services/clinical/service";
import {
  PRESCRIPTION_FREQUENCIES,
  FOOD_RELATIONS,
  FREQUENCY_LABELS,
  FOOD_RELATION_LABELS,
  FREQUENCY_TIMES,
} from "@/lib/constants";
import { formatTimeString } from "@/lib/utils";

interface DraftItem {
  medicine_name: string;
  generic_name: string;
  strength: string;
  dose: string;
  frequency: string;
  duration_days: string;
  instructions: string;
  food_relation: string;
}

const EMPTY_ITEM: DraftItem = {
  medicine_name: "",
  generic_name: "",
  strength: "",
  dose: "",
  frequency: "BD",
  duration_days: "5",
  instructions: "",
  food_relation: "AFTER_FOOD",
};

/** Prescription builder — adds medicines to the consultation's prescription. */
export function PrescriptionEditor({
  consultationId,
  existing,
}: {
  consultationId: string;
  existing: PrescriptionView | null;
}) {
  const router = useRouter();
  const [drafts, setDrafts] = useState<DraftItem[]>([{ ...EMPTY_ITEM }]);
  const [notes, setNotes] = useState(existing?.notes ?? "");
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const updateDraft = (index: number, patch: Partial<DraftItem>) => {
    setDrafts((current) => current.map((draft, i) => (i === index ? { ...draft, ...patch } : draft)));
  };

  const handleSave = async () => {
    setPending(true);
    setError(null);
    const result = await savePrescriptionAction({
      consultationId,
      notes,
      items: drafts.map((draft) => ({
        medicine_name: draft.medicine_name,
        generic_name: draft.generic_name,
        strength: draft.strength,
        dose: draft.dose,
        frequency: draft.frequency,
        duration_days: draft.duration_days,
        instructions: draft.instructions,
        food_relation: draft.food_relation,
      })),
    });
    if (result.ok) {
      toast.success(`Prescription saved — ${result.data?.items ?? 0} medicine(s), schedule generated`);
      setDrafts([{ ...EMPTY_ITEM }]);
      router.refresh();
    } else {
      setError(result.error ?? "Could not save the prescription.");
    }
    setPending(false);
  };

  const firstInvalid =
    drafts.find((draft) => draft.medicine_name.trim().length < 2 || draft.dose.trim().length < 1) !== undefined;

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Pill className="h-5 w-5 text-muted-foreground" aria-hidden /> Prescription
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-5">
        {/* Existing prescription */}
        {existing && existing.items.length > 0 ? (
          <div className="space-y-2">
            {existing.items.map((item) => {
              const times = FREQUENCY_TIMES[item.frequency as keyof typeof FREQUENCY_TIMES];
              return (
                <div key={item.id} className="rounded-lg border p-3 text-sm">
                  <p className="font-medium">
                    {item.medicine_name}
                    {item.strength ? ` (${item.strength})` : ""} — {item.dose}
                  </p>
                  <p className="mt-0.5 text-muted-foreground">
                    {FREQUENCY_LABELS[item.frequency]} · {item.duration_days} day
                    {item.duration_days === 1 ? "" : "s"}
                    {item.food_relation !== "NOT_SPECIFIED" ? ` · ${FOOD_RELATION_LABELS[item.food_relation]}` : ""}
                  </p>
                  {times ? (
                    <p className="mt-0.5 text-xs text-muted-foreground">
                      Scheduled at {times.map((time) => formatTimeString(time)).join(", ")}
                    </p>
                  ) : (
                    <p className="mt-0.5 text-xs text-muted-foreground">No daily schedule (as-needed dose)</p>
                  )}
                  {item.instructions ? (
                    <p className="mt-0.5 text-xs text-muted-foreground">{item.instructions}</p>
                  ) : null}
                </div>
              );
            })}
            <p className="text-xs text-muted-foreground">
              Saving below adds medicines to this prescription — existing items stay unchanged.
            </p>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            No prescription yet. Add medicines below — the daily medication schedule is generated automatically from
            frequency and duration.
          </p>
        )}

        {/* Builder */}
        {drafts.map((draft, index) => (
          <div key={index} className="space-y-3 rounded-lg border p-3">
            <div className="flex items-center justify-between">
              <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                Medicine {index + 1}
              </p>
              {drafts.length > 1 ? (
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setDrafts((current) => current.filter((_, i) => i !== index))}
                  aria-label={`Remove medicine ${index + 1}`}
                >
                  <Trash2 className="h-4 w-4" aria-hidden />
                </Button>
              ) : null}
            </div>

            <div className="grid gap-3 sm:grid-cols-2">
              <div className="space-y-1">
                <Label htmlFor={`rx-${index}-name`} className="text-xs text-muted-foreground">
                  Medicine name *
                </Label>
                <Input
                  id={`rx-${index}-name`}
                  value={draft.medicine_name}
                  onChange={(event) => updateDraft(index, { medicine_name: event.target.value })}
                  placeholder="e.g. Paracetamol"
                  disabled={pending}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`rx-${index}-strength`} className="text-xs text-muted-foreground">
                  Strength
                </Label>
                <Input
                  id={`rx-${index}-strength`}
                  value={draft.strength}
                  onChange={(event) => updateDraft(index, { strength: event.target.value })}
                  placeholder="e.g. 500mg"
                  disabled={pending}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`rx-${index}-dose`} className="text-xs text-muted-foreground">
                  Dose *
                </Label>
                <Input
                  id={`rx-${index}-dose`}
                  value={draft.dose}
                  onChange={(event) => updateDraft(index, { dose: event.target.value })}
                  placeholder="e.g. 1 tablet"
                  disabled={pending}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`rx-${index}-duration`} className="text-xs text-muted-foreground">
                  Duration (days) *
                </Label>
                <Input
                  id={`rx-${index}-duration`}
                  type="number"
                  min={1}
                  max={365}
                  value={draft.duration_days}
                  onChange={(event) => updateDraft(index, { duration_days: event.target.value })}
                  disabled={pending}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`rx-${index}-frequency`} className="text-xs text-muted-foreground">
                  Frequency *
                </Label>
                <Select value={draft.frequency} onValueChange={(value) => updateDraft(index, { frequency: value })}>
                  <SelectTrigger id={`rx-${index}-frequency`} className="w-full">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {PRESCRIPTION_FREQUENCIES.map((frequency) => (
                      <SelectItem key={frequency} value={frequency}>
                        {FREQUENCY_LABELS[frequency]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1">
                <Label htmlFor={`rx-${index}-food`} className="text-xs text-muted-foreground">
                  Food relation
                </Label>
                <Select value={draft.food_relation} onValueChange={(value) => updateDraft(index, { food_relation: value })}>
                  <SelectTrigger id={`rx-${index}-food`} className="w-full">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {FOOD_RELATIONS.map((relation) => (
                      <SelectItem key={relation} value={relation}>
                        {FOOD_RELATION_LABELS[relation]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1 sm:col-span-2">
                <Label htmlFor={`rx-${index}-instructions`} className="text-xs text-muted-foreground">
                  Instructions
                </Label>
                <Input
                  id={`rx-${index}-instructions`}
                  value={draft.instructions}
                  onChange={(event) => updateDraft(index, { instructions: event.target.value })}
                  placeholder="e.g. Take with warm water"
                  disabled={pending}
                />
              </div>
            </div>
            {draft.frequency !== "SOS" && draft.frequency !== "STAT" ? (
              <Badge variant="outline">
                Schedule: {(FREQUENCY_TIMES as Record<string, string[]>)[draft.frequency]
                  ?.map((time) => formatTimeString(time))
                  .join(", ")}
              </Badge>
            ) : (
              <Badge variant="outline">No daily schedule row</Badge>
            )}
          </div>
        ))}

        <div className="flex flex-wrap items-center gap-2">
          <Button variant="outline" size="sm" onClick={() => setDrafts((current) => [...current, { ...EMPTY_ITEM }])} disabled={pending}>
            <Plus className="mr-1.5 h-4 w-4" aria-hidden /> Add medicine
          </Button>
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="rx-notes">General notes (shown on the prescription)</Label>
          <Input
            id="rx-notes"
            value={notes}
            onChange={(event) => setNotes(event.target.value)}
            placeholder="e.g. Complete the full course"
            maxLength={500}
            disabled={pending}
          />
        </div>

        {error ? (
          <p className="text-sm text-red-600" role="alert">
            {error}
          </p>
        ) : null}

        <Button onClick={handleSave} disabled={pending || firstInvalid}>
          <Pill className="mr-1.5 h-4 w-4" aria-hidden />
          {pending ? "Saving…" : "Save prescription"}
        </Button>
      </CardContent>
    </Card>
  );
}
