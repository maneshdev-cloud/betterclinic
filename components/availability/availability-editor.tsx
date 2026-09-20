"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Coffee, Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { DAYS_OF_WEEK } from "@/lib/constants";
import { cn } from "@/lib/utils";
import { saveAvailabilityAction } from "@/services/availability/actions";
import { availabilityPayloadSchema, type AvailabilityDayInput } from "@/lib/validation/appointments";
import type { DoctorClinicOption } from "@/services/availability/service";

interface DayState {
  enabled: boolean;
  startTime: string;
  endTime: string;
  breakEnabled: boolean;
  breakStart: string;
  breakEnd: string;
  slotDurationMinutes: number;
}

const DEFAULT_DAY: DayState = {
  enabled: false,
  startTime: "09:00",
  endTime: "17:00",
  breakEnabled: false,
  breakStart: "13:00",
  breakEnd: "14:00",
  slotDurationMinutes: 15,
};

const SLOT_DURATIONS = [5, 10, 15, 20, 30, 45, 60, 90, 120];

function defaultWeek(): DayState[] {
  return DAYS_OF_WEEK.map(() => ({ ...DEFAULT_DAY }));
}

/** Minimal shape the editor needs for a saved availability row. */
export interface AvailabilityRow {
  clinic_id: string;
  day_of_week: number;
  start_time: string;
  end_time: string;
  break_start: string | null;
  break_end: string | null;
  slot_duration_minutes: number;
}

/** Load saved rows into editor state (one window per day; first row wins). */
function weekFromRows(rows: AvailabilityRow[]): DayState[] {
  const week = defaultWeek();
  for (const row of rows) {
    const day = week[row.day_of_week];
    if (day && !day.enabled) {
      day.enabled = true;
      day.startTime = row.start_time.slice(0, 5);
      day.endTime = row.end_time.slice(0, 5);
      day.breakEnabled = !!(row.break_start && row.break_end);
      day.breakStart = (row.break_start ?? "13:00").slice(0, 5);
      day.breakEnd = (row.break_end ?? "14:00").slice(0, 5);
      day.slotDurationMinutes = row.slot_duration_minutes;
    }
  }
  return week;
}

interface AvailabilityEditorProps {
  clinics: DoctorClinicOption[];
  initialByClinic: Record<string, AvailabilityRow[]>;
}

/**
 * Weekly availability editor for doctors: one working window (+ optional
 * break + slot length) per weekday per clinic. Saving replaces the
 * schedule for the selected clinic; already-booked slots are preserved
 * and free future slots regenerate on demand.
 */
export function AvailabilityEditor({ clinics, initialByClinic }: AvailabilityEditorProps) {
  const router = useRouter();
  const [clinicId, setClinicId] = useState(clinics[0]?.clinic_id ?? "");
  const [week, setWeek] = useState<DayState[]>(() =>
    weekFromRows(initialByClinic[clinics[0]?.clinic_id ?? ""] ?? [])
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const activeDays = useMemo(() => week.filter((day) => day.enabled).length, [week]);

  if (clinics.length === 0) {
    return (
      <Card>
        <CardContent className="p-6 text-sm text-muted-foreground">
          You are not linked to any clinic yet. Availability is managed per clinic — ask the clinic
          admin to add you first.
        </CardContent>
      </Card>
    );
  }

  const updateDay = (index: number, patch: Partial<DayState>) => {
    setWeek((current) => current.map((day, i) => (i === index ? { ...day, ...patch } : day)));
  };

  const handleClinicChange = (nextClinicId: string) => {
    setClinicId(nextClinicId);
    setWeek(weekFromRows(initialByClinic[nextClinicId] ?? []));
    setError(null);
  };

  const handleSave = async () => {
    const payload = {
      clinicId,
      days: week.map((day, index): AvailabilityDayInput => ({
        dayOfWeek: index,
        enabled: day.enabled,
        startTime: day.startTime,
        endTime: day.endTime,
        breakEnabled: day.breakEnabled,
        breakStart: day.breakEnabled ? day.breakStart : null,
        breakEnd: day.breakEnabled ? day.breakEnd : null,
        slotDurationMinutes: day.slotDurationMinutes,
      })),
    };
    const parsed = availabilityPayloadSchema.safeParse(payload);
    if (!parsed.success) {
      setError(parsed.error.issues[0]?.message ?? "Please check the schedule.");
      return;
    }
    setSaving(true);
    setError(null);
    const result = await saveAvailabilityAction(parsed.data);
    if (result.ok) {
      toast.success("Schedule saved", {
        description: `${activeDays} active ${activeDays === 1 ? "day" : "days"} · free future slots will refresh automatically.`,
      });
      router.refresh();
    } else {
      setError(result.error ?? "Could not save the schedule.");
    }
    setSaving(false);
  };

  return (
    <div className="space-y-4">
      <div className="space-y-1.5">
        <Label htmlFor="availability-clinic">Clinic</Label>
        <Select value={clinicId} onValueChange={handleClinicChange}>
          <SelectTrigger id="availability-clinic" className="w-full sm:max-w-md">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {clinics.map((clinic) => (
              <SelectItem key={clinic.clinic_id} value={clinic.clinic_id}>
                {clinic.clinic_name} — {clinic.area}, {clinic.city}
                {clinic.is_primary ? " (primary)" : ""}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="grid gap-3 lg:grid-cols-2">
        {DAYS_OF_WEEK.map((meta, index) => {
          const day = week[index]!;
          return (
            <Card
              key={meta.value}
              className={cn("transition-opacity", !day.enabled && "opacity-75")}
              data-day={meta.label}
            >
              <CardContent className="space-y-3 p-4">
                <label className="flex cursor-pointer items-center gap-2">
                  <Checkbox
                    checked={day.enabled}
                    onCheckedChange={(checked) => updateDay(index, { enabled: checked === true })}
                    id={`day-${meta.value}-enabled`}
                  />
                  <Label htmlFor={`day-${meta.value}-enabled`} className="cursor-pointer font-medium">
                    {meta.label}
                  </Label>
                </label>

                <div className={cn("grid gap-3", day.enabled ? "grid-cols-2" : "hidden")}>
                  <div className="space-y-1">
                    <Label htmlFor={`day-${meta.value}-start`} className="text-xs text-muted-foreground">
                      From
                    </Label>
                    <Input
                      id={`day-${meta.value}-start`}
                      type="time"
                      value={day.startTime}
                      onChange={(event) => updateDay(index, { startTime: event.target.value })}
                    />
                  </div>
                  <div className="space-y-1">
                    <Label htmlFor={`day-${meta.value}-end`} className="text-xs text-muted-foreground">
                      To
                    </Label>
                    <Input
                      id={`day-${meta.value}-end`}
                      type="time"
                      value={day.endTime}
                      onChange={(event) => updateDay(index, { endTime: event.target.value })}
                    />
                  </div>

                  <label className="col-span-2 flex cursor-pointer items-center gap-2 text-sm">
                    <Checkbox
                      checked={day.breakEnabled}
                      onCheckedChange={(checked) => updateDay(index, { breakEnabled: checked === true })}
                      id={`day-${meta.value}-break`}
                    />
                    <Label htmlFor={`day-${meta.value}-break`} className="flex cursor-pointer items-center gap-1.5 font-normal">
                      <Coffee className="h-4 w-4 text-muted-foreground" aria-hidden /> Break
                    </Label>
                  </label>

                  {day.breakEnabled ? (
                    <div className="col-span-2 grid grid-cols-2 gap-3">
                      <div className="space-y-1">
                        <Label htmlFor={`day-${meta.value}-break-start`} className="text-xs text-muted-foreground">
                          Break from
                        </Label>
                        <Input
                          id={`day-${meta.value}-break-start`}
                          type="time"
                          value={day.breakStart}
                          onChange={(event) => updateDay(index, { breakStart: event.target.value })}
                        />
                      </div>
                      <div className="space-y-1">
                        <Label htmlFor={`day-${meta.value}-break-end`} className="text-xs text-muted-foreground">
                          Back at
                        </Label>
                        <Input
                          id={`day-${meta.value}-break-end`}
                          type="time"
                          value={day.breakEnd}
                          onChange={(event) => updateDay(index, { breakEnd: event.target.value })}
                        />
                      </div>
                    </div>
                  ) : null}

                  <div className="col-span-2 space-y-1">
                    <Label htmlFor={`day-${meta.value}-duration`} className="text-xs text-muted-foreground">
                      Slot length
                    </Label>
                    <Select
                      value={String(day.slotDurationMinutes)}
                      onValueChange={(value) => updateDay(index, { slotDurationMinutes: Number(value) })}
                    >
                      <SelectTrigger id={`day-${meta.value}-duration`} className="w-full">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        {SLOT_DURATIONS.map((minutes) => (
                          <SelectItem key={minutes} value={String(minutes)}>
                            {minutes} minutes
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {error ? (
        <p className="text-sm text-red-600" role="alert">
          {error}
        </p>
      ) : null}

      <div className="flex flex-col items-start justify-between gap-2 border-t pt-4 sm:flex-row sm:items-center">
        <p className="text-xs text-muted-foreground">
          Saving replaces this clinic&apos;s weekly schedule. Already-booked slots are kept; free future
          slots regenerate from the new times.
        </p>
        <Button onClick={handleSave} disabled={saving}>
          <Save className="mr-1.5 h-4 w-4" aria-hidden />
          {saving ? "Saving…" : "Save schedule"}
        </Button>
      </div>
    </div>
  );
}
