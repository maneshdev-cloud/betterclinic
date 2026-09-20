"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { FieldError } from "@/components/shared/field-error";
import { checkClinicDuplicateAction } from "@/app/(auth)/actions";
import {
  linkDoctorToExistingClinicAction,
  registerAndLinkClinicAction,
  type LinkClinicResult,
} from "@/app/doctor/clinics/actions";
import {
  Building2,
  Plus,
  Link2,
  AlertCircle,
  CheckCircle2,
  Loader2,
  X,
  AlertTriangle,
} from "lucide-react";

interface LinkClinicModalProps {
  clinics: { id: string; name: string; city: string; area: string }[];
  triggerText?: string;
  triggerVariant?: "default" | "outline" | "secondary";
  initialOpen?: boolean;
  onSuccess?: () => void;
}

export function LinkClinicModal({
  clinics,
  triggerText = "Link or Register Clinic",
  triggerVariant = "outline",
  initialOpen = false,
  onSuccess,
}: LinkClinicModalProps) {
  const router = useRouter();
  const [open, setOpen] = useState(initialOpen);
  const [activeTab, setActiveTab] = useState<"link" | "register">("link");
  const [isPending, startTransition] = useTransition();
  const [status, setStatus] = useState<LinkClinicResult>({ success: false });

  // Link existing form state
  const [selectedClinicId, setSelectedClinicId] = useState("");
  const [doctorInviteCode, setDoctorInviteCode] = useState("");

  // Register new clinic form state
  const [regName, setRegName] = useState("");
  const [regCity, setRegCity] = useState("");
  const [regArea, setRegArea] = useState("");
  const [regAddress, setRegAddress] = useState("");
  const [duplicateWarning, setDuplicateWarning] = useState<{
    id: string;
    name: string;
    city: string;
    area: string;
  } | null>(null);
  const [checkingDuplicate, setCheckingDuplicate] = useState(false);

  async function checkDuplicate() {
    if (regName.trim().length < 2 || regCity.trim().length < 2) {
      setDuplicateWarning(null);
      return;
    }
    setCheckingDuplicate(true);
    try {
      const res = await checkClinicDuplicateAction(regName, regCity);
      if (res.exists && res.match) {
        setDuplicateWarning(res.match);
      } else {
        setDuplicateWarning(null);
      }
    } catch {
      setDuplicateWarning(null);
    } finally {
      setCheckingDuplicate(false);
    }
  }

  function handleOpen() {
    setStatus({ success: false });
    setDuplicateWarning(null);
    setOpen(true);
  }

  function handleClose() {
    setOpen(false);
    setStatus({ success: false });
  }

  function handleLinkSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus({ success: false });

    startTransition(async () => {
      const res = await linkDoctorToExistingClinicAction(selectedClinicId, doctorInviteCode);
      setStatus(res);
      if (res.success) {
        setTimeout(() => {
          setOpen(false);
          router.refresh();
          if (onSuccess) onSuccess();
        }, 800);
      }
    });
  }

  function handleRegisterSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus({ success: false });

    startTransition(async () => {
      const res = await registerAndLinkClinicAction({
        name: regName,
        city: regCity,
        area: regArea,
        address_line: regAddress,
      });
      setStatus(res);
      if (res.success) {
        setTimeout(() => {
          setOpen(false);
          router.refresh();
          if (onSuccess) onSuccess();
        }, 800);
      }
    });
  }

  return (
    <>
      <Button variant={triggerVariant} size="sm" onClick={handleOpen} className="gap-1.5">
        <Plus className="h-4 w-4" />
        {triggerText}
      </Button>

      {open && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-xs p-4 animate-in fade-in duration-200">
          <div className="relative w-full max-w-lg rounded-xl border border-border bg-card p-6 shadow-xl space-y-5 max-h-[90vh] overflow-y-auto">
            {/* Header */}
            <div className="flex items-start justify-between">
              <div>
                <h2 className="text-lg font-bold tracking-tight">Add Clinic Affiliation</h2>
                <p className="text-xs text-muted-foreground mt-0.5">
                  Link an existing clinic via invite code, or register a new clinic for your practice.
                </p>
              </div>
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 text-muted-foreground hover:text-foreground"
                onClick={handleClose}
              >
                <X className="h-4 w-4" />
              </Button>
            </div>

            {/* Mode selection tabs */}
            <div className="grid grid-cols-2 gap-2 rounded-lg bg-muted p-1 text-xs font-medium">
              <button
                type="button"
                onClick={() => {
                  setActiveTab("link");
                  setStatus({ success: false });
                }}
                className={`flex items-center justify-center gap-1.5 rounded-md py-2 transition-colors ${
                  activeTab === "link"
                    ? "bg-background text-foreground shadow-xs font-semibold"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                <Link2 className="h-3.5 w-3.5" />
                Link Existing Clinic
              </button>
              <button
                type="button"
                onClick={() => {
                  setActiveTab("register");
                  setStatus({ success: false });
                }}
                className={`flex items-center justify-center gap-1.5 rounded-md py-2 transition-colors ${
                  activeTab === "register"
                    ? "bg-background text-foreground shadow-xs font-semibold"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                <Building2 className="h-3.5 w-3.5" />
                Register New Clinic
              </button>
            </div>

            {status.error ? (
              <Alert variant="destructive">
                <AlertCircle className="h-4 w-4" />
                <AlertDescription>{status.error}</AlertDescription>
              </Alert>
            ) : null}

            {status.success ? (
              <Alert className="border-emerald-500/50 bg-emerald-50 text-emerald-900 dark:bg-emerald-950/40 dark:text-emerald-200">
                <CheckCircle2 className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
                <AlertDescription>Clinic successfully linked to your profile!</AlertDescription>
              </Alert>
            ) : null}

            {/* Option A: Link Existing Clinic */}
            {activeTab === "link" && (
              <form onSubmit={handleLinkSubmit} className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="existing_clinic_id">Select Clinic *</Label>
                  <select
                    id="existing_clinic_id"
                    value={selectedClinicId}
                    onChange={(e) => setSelectedClinicId(e.target.value)}
                    required
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                  >
                    <option value="" disabled>
                      Choose a clinic...
                    </option>
                    {clinics.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name} — {c.area}, {c.city}
                      </option>
                    ))}
                  </select>
                  <FieldError error={status.fieldErrors?.clinic_id} />
                </div>

                <div className="space-y-1.5">
                  <Label htmlFor="doctor_invite_code">Clinic Doctor Invite Code *</Label>
                  <Input
                    id="doctor_invite_code"
                    value={doctorInviteCode}
                    onChange={(e) => setDoctorInviteCode(e.target.value)}
                    placeholder="e.g. DOC-AB12"
                    required
                  />
                  <p className="text-[11px] text-muted-foreground">
                    Ask the clinic administrator for their clinic&apos;s doctor invite code.
                  </p>
                  <FieldError error={status.fieldErrors?.doctor_invite_code} />
                </div>

                <div className="flex justify-end gap-2 pt-2">
                  <Button type="button" variant="ghost" size="sm" onClick={handleClose}>
                    Cancel
                  </Button>
                  <Button
                    type="submit"
                    size="sm"
                    disabled={isPending || !selectedClinicId || !doctorInviteCode}
                    className="gap-1.5 min-w-[120px]"
                  >
                    {isPending ? (
                      <>
                        <Loader2 className="h-3.5 w-3.5 animate-spin" />
                        Linking...
                      </>
                    ) : (
                      <>
                        <Link2 className="h-3.5 w-3.5" />
                        Link Clinic
                      </>
                    )}
                  </Button>
                </div>
              </form>
            )}

            {/* Option B: Register New Clinic */}
            {activeTab === "register" && (
              <form onSubmit={handleRegisterSubmit} className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="new_clinic_name">Clinic Name *</Label>
                  <Input
                    id="new_clinic_name"
                    value={regName}
                    onChange={(e) => setRegName(e.target.value)}
                    onBlur={checkDuplicate}
                    placeholder="e.g. Apex Health Clinic"
                    required
                  />
                </div>

                <div className="grid gap-3 sm:grid-cols-2">
                  <div className="space-y-1.5">
                    <Label htmlFor="new_clinic_city">City *</Label>
                    <Input
                      id="new_clinic_city"
                      value={regCity}
                      onChange={(e) => setRegCity(e.target.value)}
                      onBlur={checkDuplicate}
                      placeholder="e.g. Mumbai"
                      required
                    />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="new_clinic_area">Area / Locality *</Label>
                    <Input
                      id="new_clinic_area"
                      value={regArea}
                      onChange={(e) => setRegArea(e.target.value)}
                      placeholder="e.g. Bandra West"
                      required
                    />
                  </div>
                </div>

                <div className="space-y-1.5">
                  <Label htmlFor="new_clinic_address">Address Line *</Label>
                  <Textarea
                    id="new_clinic_address"
                    value={regAddress}
                    onChange={(e) => setRegAddress(e.target.value)}
                    placeholder="Full clinic street address..."
                    rows={2}
                    required
                  />
                </div>

                {/* Deduplication warning */}
                {duplicateWarning ? (
                  <div className="rounded-lg border border-amber-300 bg-amber-50 p-3 text-xs text-amber-900 dark:border-amber-900/50 dark:bg-amber-950/30 dark:text-amber-200 space-y-1">
                    <div className="flex items-center gap-1.5 font-semibold">
                      <AlertTriangle className="h-4 w-4 text-amber-600 dark:text-amber-400" />
                      Possible Existing Clinic Found
                    </div>
                    <p>
                      <strong>{duplicateWarning.name}</strong> in {duplicateWarning.area},{" "}
                      {duplicateWarning.city} already exists in the system.
                    </p>
                    <button
                      type="button"
                      onClick={() => {
                        setSelectedClinicId(duplicateWarning.id);
                        setActiveTab("link");
                        setDuplicateWarning(null);
                      }}
                      className="text-primary underline font-medium hover:opacity-80"
                    >
                      Link to that clinic with an invite code instead →
                    </button>
                  </div>
                ) : null}

                <div className="flex justify-end gap-2 pt-2">
                  <Button type="button" variant="ghost" size="sm" onClick={handleClose}>
                    Cancel
                  </Button>
                  <Button
                    type="submit"
                    size="sm"
                    disabled={isPending || !regName || !regCity || !regArea || !regAddress}
                    className="gap-1.5 min-w-[140px]"
                  >
                    {isPending ? (
                      <>
                        <Loader2 className="h-3.5 w-3.5 animate-spin" />
                        Registering...
                      </>
                    ) : (
                      <>
                        <Building2 className="h-3.5 w-3.5" />
                        Register & Link
                      </>
                    )}
                  </Button>
                </div>
              </form>
            )}
          </div>
        </div>
      )}
    </>
  );
}
