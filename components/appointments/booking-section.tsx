"use client";

import { useState } from "react";
import { Building2 } from "lucide-react";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { SlotPicker, type SlotSelection } from "@/components/appointments/slot-picker";
import { BookingDialog } from "@/components/appointments/booking-dialog";

export interface BookingClinic {
  id: string;
  name: string;
  city: string;
  area: string;
  availableDows: number[];
}

interface BookingSectionProps {
  doctorId: string;
  doctorName: string;
  fee: number | null;
  clinics: BookingClinic[];
}

/**
 * Clinic selector + slot picker + booking confirmation, used on the
 * doctor profile page. All data flows from the real availability tables.
 */
export function BookingSection({ doctorId, doctorName, fee, clinics }: BookingSectionProps) {
  const [clinicId, setClinicId] = useState(clinics[0]?.id ?? "");
  const [selection, setSelection] = useState<SlotSelection | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);

  const activeClinic = clinics.find((clinic) => clinic.id === clinicId) ?? clinics[0];

  return (
    <div className="space-y-4">
      {clinics.length > 1 ? (
        <div className="space-y-1.5">
          <Label htmlFor="booking-clinic">Clinic</Label>
          <Select value={clinicId} onValueChange={setClinicId}>
            <SelectTrigger id="booking-clinic" className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {clinics.map((clinic) => (
                <SelectItem key={clinic.id} value={clinic.id}>
                  {clinic.name} — {clinic.area}, {clinic.city}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      ) : null}

      {activeClinic ? (
        <SlotPicker
          key={activeClinic.id}
          doctorId={doctorId}
          clinicId={activeClinic.id}
          availableDows={activeClinic.availableDows}
          onSelectSlot={(slot) => {
            setSelection(slot);
            setDialogOpen(true);
          }}
        />
      ) : (
        <p className="flex items-center gap-2 text-sm text-muted-foreground">
          <Building2 className="h-4 w-4" aria-hidden /> This doctor is not linked to a clinic yet.
        </p>
      )}

      <BookingDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        selection={selection}
        doctorName={doctorName}
        clinicName={activeClinic ? `${activeClinic.name} (${activeClinic.area}, ${activeClinic.city})` : ""}
        fee={fee}
      />
    </div>
  );
}
