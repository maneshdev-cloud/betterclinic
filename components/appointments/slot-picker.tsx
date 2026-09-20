"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { CalendarDays, RefreshCw, Sunrise, Sun, Sunset } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { EmptyState } from "@/components/shared/empty-state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { getSlotsAction } from "@/services/availability/actions";
import { clinicDatePlusDays, todayClinicDate, dayOfWeek, formatTimeString, cn } from "@/lib/utils";

export interface SlotSelection {
  slotId: string;
  date: string;
  startTime: string;
  endTime: string;
}

interface SlotPickerProps {
  doctorId: string;
  clinicId: string;
  /** Days of week (0=Sun…6=Sat) on which the doctor has active availability here. */
  availableDows: number[];
  daysAhead?: number;
  onSelectSlot: (selection: SlotSelection) => void;
  selectLabel?: string;
}

interface SlotGroup {
  label: string;
  icon: typeof Sunrise;
  slots: { id: string; start_time: string; end_time: string }[];
}

function groupSlots(slots: { id: string; start_time: string; end_time: string }[]): SlotGroup[] {
  const groups: SlotGroup[] = [
    { label: "Morning", icon: Sunrise, slots: [] },
    { label: "Afternoon", icon: Sun, slots: [] },
    { label: "Evening", icon: Sunset, slots: [] },
  ];
  for (const slot of slots) {
    const hour = Number(slot.start_time.slice(0, 2));
    if (hour < 12) groups[0]!.slots.push(slot);
    else if (hour < 17) groups[1]!.slots.push(slot);
    else groups[2]!.slots.push(slot);
  }
  return groups.filter((group) => group.slots.length > 0);
}

/**
 * Date strip + time slots for one doctor/clinic. Slots are generated
 * server-side on demand (real availability data, nothing hard-coded) and
 * fetched through an authenticated server action.
 */
export function SlotPicker({
  doctorId,
  clinicId,
  availableDows,
  daysAhead = 14,
  onSelectSlot,
  selectLabel = "Select a time",
}: SlotPickerProps) {
  const today = useMemo(() => todayClinicDate(), []);
  const dates = useMemo(
    () =>
      Array.from({ length: daysAhead }, (_, i) => {
        const date = i === 0 ? today : clinicDatePlusDays(i);
        return {
          date,
          dow: dayOfWeek(date),
          dayLabel: i === 0 ? "Today" : i === 1 ? "Tomorrow" : undefined,
        };
      }),
    [daysAhead, today]
  );

  const firstBookable = useMemo(
    () => dates.find((d) => availableDows.includes(d.dow))?.date ?? null,
    [dates, availableDows]
  );

  const [selectedDate, setSelectedDate] = useState<string | null>(firstBookable);
  const [slots, setSlots] = useState<{ id: string; start_time: string; end_time: string }[]>([]);
  const [status, setStatus] = useState<"idle" | "loading" | "ready" | "error">("idle");
  const [errorMessage, setErrorMessage] = useState("");
  const [reloadKey, setReloadKey] = useState(0);

  // Follow the clinic when it changes (booking section clinic selector).
  useEffect(() => {
    setSelectedDate(firstBookable);
  }, [firstBookable]);

  const load = useCallback(async () => {
    if (!selectedDate) {
      setSlots([]);
      setStatus("idle");
      return;
    }
    setStatus("loading");
    const result = await getSlotsAction({ doctorId, clinicId, date: selectedDate });
    if (result.ok && result.data) {
      setSlots(result.data);
      setStatus("ready");
    } else {
      setSlots([]);
      setErrorMessage(result.error ?? "Could not load slots.");
      setStatus("error");
    }
  }, [doctorId, clinicId, selectedDate]);

  useEffect(() => {
    void load();
  }, [load, reloadKey]);

  if (availableDows.length === 0) {
    return (
      <EmptyState
        icon={CalendarDays}
        title="No schedule published yet"
        description="This doctor has not published availability at this clinic yet. Please check back later."
      />
    );
  }

  return (
    <div className="space-y-4">
      {/* Date strip */}
      <div className="-mx-1 flex gap-2 overflow-x-auto px-1 pb-1" role="radiogroup" aria-label="Choose a date">
        {dates.map((d) => {
          const disabled = !availableDows.includes(d.dow);
          const selected = selectedDate === d.date;
          return (
            <button
              key={d.date}
              type="button"
              role="radio"
              aria-checked={selected}
              disabled={disabled}
              onClick={() => setSelectedDate(d.date)}
              className={cn(
                "flex min-w-[4.5rem] shrink-0 flex-col items-center rounded-lg border px-3 py-2 text-sm transition-colors",
                selected && "border-primary bg-primary text-primary-foreground",
                !selected && !disabled && "hover:border-primary/60 hover:bg-muted",
                disabled && "cursor-not-allowed opacity-40"
              )}
            >
              <span className={cn("text-xs", selected ? "text-primary-foreground/80" : "text-muted-foreground")}>
                {d.dayLabel ??
                  new Date(`${d.date}T12:00:00Z`).toLocaleDateString("en-IN", {
                    weekday: "short",
                    timeZone: "UTC",
                  })}
              </span>
              <span className="mt-0.5 text-base font-semibold">
                {new Date(`${d.date}T12:00:00Z`).toLocaleDateString("en-IN", {
                  day: "numeric",
                  month: "short",
                  timeZone: "UTC",
                })}
              </span>
            </button>
          );
        })}
      </div>

      {/* Slots */}
      {status === "loading" ? (
        <div className="grid gap-2 sm:grid-cols-3" aria-label="Loading time slots">
          {Array.from({ length: 6 }, (_, i) => (
            <Skeleton key={i} className="h-9 w-full" />
          ))}
        </div>
      ) : status === "error" ? (
        <Alert variant="destructive">
          <AlertDescription className="flex items-center justify-between gap-3">
            <span>{errorMessage}</span>
            <Button variant="outline" size="sm" onClick={() => setReloadKey((k) => k + 1)}>
              <RefreshCw className="mr-1.5 h-3.5 w-3.5" aria-hidden /> Retry
            </Button>
          </AlertDescription>
        </Alert>
      ) : slots.length === 0 ? (
        <EmptyState
          icon={CalendarDays}
          title={selectedDate === today ? "No free slots left today" : "Fully booked"}
          description="All slots for this date are taken or unavailable. Try another date from the strip above."
        />
      ) : (
        <div className="space-y-4">
          {groupSlots(slots).map((group) => (
            <div key={group.label}>
              <p className="mb-2 inline-flex items-center gap-1.5 text-xs font-medium uppercase tracking-wide text-muted-foreground">
                <group.icon className="h-3.5 w-3.5" aria-hidden />
                {group.label}
              </p>
              <div className="grid grid-cols-3 gap-2 sm:grid-cols-4 lg:grid-cols-6" role="listbox" aria-label={`${group.label} slots`}>
                {group.slots.map((slot) => (
                  <button
                    key={slot.id}
                    type="button"
                    role="option"
                    aria-selected={false}
                    title={`${selectLabel} — ${formatTimeString(slot.start_time)}`}
                    onClick={() =>
                      onSelectSlot({
                        slotId: slot.id,
                        date: selectedDate!,
                        startTime: slot.start_time,
                        endTime: slot.end_time,
                      })
                    }
                    className="rounded-md border px-2 py-2 text-sm font-medium transition-colors hover:border-primary hover:bg-primary hover:text-primary-foreground"
                  >
                    {formatTimeString(slot.start_time)}
                  </button>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
