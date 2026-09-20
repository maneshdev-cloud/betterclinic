"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { UserPlus } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { cn } from "@/lib/utils";
import { createWalkInAction, searchPatientsAction } from "@/services/queue/actions";

interface PatientOption {
  id: string;
  full_name: string;
  email: string;
  phone: string | null;
}

interface WalkInDialogProps {
  doctors: { id: string; name: string; qualification: string }[];
}

/**
 * Register a walk-in at the desk: find the patient, pick the doctor and
 * priority, describe the visit — the SQL function creates the
 * appointment, check-in, queue entry and token in one transaction.
 */
export function WalkInDialog({ doctors }: WalkInDialogProps) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<PatientOption[]>([]);
  const [searching, setSearching] = useState(false);
  const [patient, setPatient] = useState<PatientOption | null>(null);
  const [doctorId, setDoctorId] = useState("");
  const [priority, setPriority] = useState<"NORMAL" | "HIGH" | "URGENT">("NORMAL");
  const [visitReason, setVisitReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  const reset = () => {
    setQuery("");
    setResults([]);
    setPatient(null);
    setDoctorId("");
    setPriority("NORMAL");
    setVisitReason("");
    setError(null);
    setPending(false);
  };

  const handleSearch = async (value: string) => {
    setQuery(value);
    if (value.trim().length < 2) {
      setResults([]);
      return;
    }
    setSearching(true);
    const result = await searchPatientsAction(value);
    setResults(result.ok && result.data ? result.data : []);
    setSearching(false);
  };

  const handleSubmit = async () => {
    setPending(true);
    setError(null);
    const result = await createWalkInAction({
      patientId: patient?.id ?? "",
      doctorId,
      visitReason,
      priority,
    });
    if (result.ok && result.data) {
      toast.success(`Walk-in registered — token ${result.data.tokenCode}`);
      setOpen(false);
      reset();
      router.refresh();
    } else {
      setError(result.error ?? "Could not register the walk-in.");
      setPending(false);
    }
  };

  return (
    <>
      <Button onClick={() => setOpen(true)} disabled={doctors.length === 0}>
        <UserPlus className="mr-1.5 h-4 w-4" aria-hidden /> Register walk-in
      </Button>

      <Dialog open={open} onOpenChange={(next) => !pending && (setOpen(next), next || reset())}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Register a walk-in</DialogTitle>
            <DialogDescription>
              Creates a walk-in appointment, checks the patient in and assigns a token immediately.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="walkin-patient">Patient</Label>
              {patient ? (
                <div className="flex items-center justify-between rounded-md border px-3 py-2 text-sm">
                  <span>
                    <span className="font-medium">{patient.full_name}</span>
                    <span className="ml-2 text-muted-foreground">{patient.email}</span>
                  </span>
                  <Button variant="ghost" size="sm" onClick={() => { setPatient(null); setResults([]); }}>
                    Change
                  </Button>
                </div>
              ) : (
                <>
                  <Input
                    id="walkin-patient"
                    value={query}
                    onChange={(event) => void handleSearch(event.target.value)}
                    placeholder="Search by name or email (min 2 characters)"
                    disabled={pending}
                  />
                  {searching ? (
                    <p className="text-xs text-muted-foreground">Searching…</p>
                  ) : null}
                  {results.length > 0 ? (
                    <ul className="max-h-44 overflow-y-auto rounded-md border" role="listbox" aria-label="Matching patients">
                      {results.map((option) => (
                        <li key={option.id}>
                          <button
                            type="button"
                            role="option"
                            aria-selected={false}
                            onClick={() => {
                              setPatient(option);
                              setResults([]);
                              setQuery("");
                            }}
                            className={cn(
                              "flex w-full flex-col items-start px-3 py-2 text-left text-sm hover:bg-muted",
                              "border-b last:border-b-0"
                            )}
                          >
                            <span className="font-medium">{option.full_name}</span>
                            <span className="text-xs text-muted-foreground">
                              {option.email}
                              {option.phone ? ` · ${option.phone}` : ""}
                            </span>
                          </button>
                        </li>
                      ))}
                    </ul>
                  ) : query.trim().length >= 2 && !searching ? (
                    <p className="text-xs text-muted-foreground">
                      No registered patient matches “{query}”. New patients must sign up in the app first.
                    </p>
                  ) : null}
                </>
              )}
            </div>

            <div className="grid gap-3 sm:grid-cols-2">
              <div className="space-y-1.5">
                <Label htmlFor="walkin-doctor">Doctor</Label>
                <Select value={doctorId || undefined} onValueChange={setDoctorId} disabled={pending}>
                  <SelectTrigger id="walkin-doctor" className="w-full">
                    <SelectValue placeholder="Choose a doctor" />
                  </SelectTrigger>
                  <SelectContent>
                    {doctors.map((doctor) => (
                      <SelectItem key={doctor.id} value={doctor.id}>
                        {doctor.name} — {doctor.qualification}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="walkin-priority">Priority</Label>
                <Select value={priority} onValueChange={(value) => setPriority(value as typeof priority)} disabled={pending}>
                  <SelectTrigger id="walkin-priority" className="w-full">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="NORMAL">Normal</SelectItem>
                    <SelectItem value="HIGH">High</SelectItem>
                    <SelectItem value="URGENT">Urgent</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="walkin-reason">Reason for visit</Label>
              <Textarea
                id="walkin-reason"
                value={visitReason}
                onChange={(event) => setVisitReason(event.target.value)}
                placeholder="e.g. High fever since last night"
                rows={2}
                maxLength={500}
                disabled={pending}
              />
            </div>

            {error ? (
              <p className="text-sm text-red-600" role="alert">
                {error}
              </p>
            ) : null}
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)} disabled={pending}>
              Cancel
            </Button>
            <Button
              onClick={handleSubmit}
              disabled={pending || !patient || !doctorId || visitReason.trim().length < 3}
            >
              {pending ? "Registering…" : "Register & assign token"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
