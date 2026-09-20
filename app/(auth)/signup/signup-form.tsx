"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useFormState } from "react-dom";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { AlertCircle, CheckCircle2, PlusCircle, Building2, Search, X, Loader2 } from "lucide-react";
import { SEXES, SEX_LABELS } from "@/lib/constants";
import {
  signUpAction,
  checkClinicDuplicateAction,
  createClinicAction,
  type FormState,
} from "../actions";

type Role = "PATIENT" | "DOCTOR" | "RECEPTIONIST" | "CLINIC_ADMIN";
type StaffRole = "RECEPTIONIST" | "CLINIC_ADMIN";

const initialState: FormState = {};

const ROLE_TABS: { value: Role; label: string }[] = [
  { value: "PATIENT", label: "Patient" },
  { value: "DOCTOR", label: "Doctor" },
  { value: "RECEPTIONIST", label: "Clinic staff" },
];

function FieldError({ error }: { error?: string }) {
  if (!error) return null;
  return <p className="form-error">{error}</p>;
}

export function SignUpForm({
  specializations,
  clinics,
  disabled,
}: {
  specializations: { id: string; name: string }[];
  clinics: { id: string; name: string; city: string }[];
  disabled: boolean;
}) {
  const [state, formAction, pending] = useFormState(signUpAction, initialState);
  const [role, setRole] = useState<Role>("PATIENT");
  const [staffRole, setStaffRole] = useState<StaffRole>("RECEPTIONIST");
  const [specializationId, setSpecializationId] = useState("");
  const [clinicId, setClinicId] = useState("");
  const [sex, setSex] = useState("");
  const [clinicOptions, setClinicOptions] = useState(clinics);

  // "+ Add a clinic not listed" inline form state
  const [showAddClinic, setShowAddClinic] = useState(false);
  const [newClinicName, setNewClinicName] = useState("");
  const [newClinicCity, setNewClinicCity] = useState("");
  const [newClinicArea, setNewClinicArea] = useState("");
  const [newClinicAddress, setNewClinicAddress] = useState("");
  const [duplicateMatch, setDuplicateMatch] = useState<{
    id: string;
    name: string;
    city: string;
    area: string;
  } | null>(null);
  const [duplicateNoneFound, setDuplicateNoneFound] = useState(false);
  const [checkingDuplicate, setCheckingDuplicate] = useState(false);
  const [createClinicPending, setCreateClinicPending] = useState(false);
  const [createClinicError, setCreateClinicError] = useState<string | null>(null);
  const [createdClinicIds, setCreatedClinicIds] = useState<string[]>([]);

  const isDoctor = role === "DOCTOR";
  const isStaff = role === "RECEPTIONIST" || role === "CLINIC_ADMIN";
  const effectiveRole = isStaff ? staffRole : role;
  const isRedirecting = Boolean(state.redirectUrl);

  useEffect(() => {
    if (state.redirectUrl) {
      window.location.replace(state.redirectUrl);
    }
  }, [state.redirectUrl]);

  async function handleCheckDuplicate() {
    if (newClinicName.trim().length < 2) return;
    setCheckingDuplicate(true);
    setDuplicateNoneFound(false);
    try {
      const res = await checkClinicDuplicateAction(newClinicName, newClinicCity);
      if (res.exists && res.match) {
        setDuplicateMatch(res.match);
        setDuplicateNoneFound(false);
      } else {
        setDuplicateMatch(null);
        setDuplicateNoneFound(true);
      }
    } finally {
      setCheckingDuplicate(false);
    }
  }

  async function handleCreateClinicSubmit() {
    setCreateClinicPending(true);
    setCreateClinicError(null);
    try {
      const res = await createClinicAction({
        name: newClinicName,
        city: newClinicCity,
        area: newClinicArea,
        address_line: newClinicAddress,
      });

      if (!res.success || !res.clinic) {
        setCreateClinicError(res.error ?? "Failed to create clinic");
        return;
      }

      setClinicOptions((prev) => [
        ...prev,
        { id: res.clinic!.id, name: res.clinic!.name, city: res.clinic!.city },
      ]);
      setClinicId(res.clinic.id);
      setCreatedClinicIds((prev) => [...prev, res.clinic!.id]);
      setShowAddClinic(false);
      setNewClinicName("");
      setNewClinicCity("");
      setNewClinicArea("");
      setNewClinicAddress("");
      setDuplicateMatch(null);
    } finally {
      setCreateClinicPending(false);
    }
  }

  return (
    <div className="rounded-lg border bg-card p-6 shadow-sm">
      <h1 className="text-lg font-semibold tracking-tight">Create your account</h1>
      <p className="mt-1 text-sm text-muted-foreground">
        Choose your role — the account, profile and role-specific records are created together.
      </p>

      {state.error ? (
        <Alert variant="destructive" className="mt-4">
          <AlertCircle aria-hidden />
          <AlertDescription>{state.error}</AlertDescription>
        </Alert>
      ) : null}
      {state.success ? (
        <Alert variant="success" className="mt-4">
          <CheckCircle2 aria-hidden />
          <AlertDescription>{state.success}</AlertDescription>
        </Alert>
      ) : null}

      <Tabs
        value={isStaff ? "RECEPTIONIST" : role}
        onValueChange={(v) => {
          setRole(v as Role);
          setShowAddClinic(false);
        }}
        className="mt-4"
      >
        <TabsList className="grid w-full grid-cols-3">
          {ROLE_TABS.map((tab) => (
            <TabsTrigger key={tab.value} value={tab.value}>
              {tab.label}
            </TabsTrigger>
          ))}
        </TabsList>
      </Tabs>

      <form action={formAction} className="mt-5 space-y-4">
        <input type="hidden" name="role" value={effectiveRole} />

        {isStaff ? (
          <div className="space-y-1.5">
            <Label>Staff role</Label>
            <div className="grid grid-cols-2 gap-2">
              {(["RECEPTIONIST", "CLINIC_ADMIN"] as StaffRole[]).map((r) => (
                <button
                  key={r}
                  type="button"
                  onClick={() => {
                    setStaffRole(r);
                    setShowAddClinic(false);
                  }}
                  aria-pressed={staffRole === r}
                  className={
                    "rounded-md border px-3 py-2 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring " +
                    (staffRole === r
                      ? "border-primary bg-secondary text-secondary-foreground"
                      : "border-input bg-card text-muted-foreground hover:bg-muted")
                  }
                >
                  {r === "RECEPTIONIST" ? "Receptionist" : "Clinic Admin"}
                </button>
              ))}
            </div>
          </div>
        ) : null}

        <div className="grid gap-4 sm:grid-cols-2">
          <div className="space-y-1.5">
            <Label htmlFor="full_name">Full name</Label>
            <Input
              id="full_name"
              name="full_name"
              autoComplete="name"
              placeholder={isDoctor ? "Dr. Aarav Deshmukh" : "Your full name"}
              required
              invalid={!!state.fieldErrors?.full_name}
              disabled={disabled || pending || isRedirecting}
            />
            <FieldError error={state.fieldErrors?.full_name} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="phone">Mobile number</Label>
            <Input
              id="phone"
              name="phone"
              type="tel"
              inputMode="tel"
              placeholder="98XXXXXXXX"
              autoComplete="tel"
              required
              invalid={!!state.fieldErrors?.phone}
              disabled={disabled || pending || isRedirecting}
            />
            <FieldError error={state.fieldErrors?.phone} />
          </div>
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div className="space-y-1.5">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              name="email"
              type="email"
              autoComplete="email"
              placeholder="you@example.com"
              required
              invalid={!!state.fieldErrors?.email}
              disabled={disabled || pending || isRedirecting}
            />
            <FieldError error={state.fieldErrors?.email} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              name="password"
              type="password"
              autoComplete="new-password"
              placeholder="Min 8 characters, letters + numbers"
              required
              invalid={!!state.fieldErrors?.password}
              disabled={disabled || pending || isRedirecting}
            />
            <FieldError error={state.fieldErrors?.password} />
          </div>
        </div>

        {role === "PATIENT" ? (
          <div className="grid gap-4 sm:grid-cols-3">
            <div className="space-y-1.5">
              <Label htmlFor="date_of_birth">Date of birth (optional)</Label>
              <Input
                id="date_of_birth"
                name="date_of_birth"
                type="date"
                max={new Date().toISOString().slice(0, 10)}
                disabled={disabled || pending || isRedirecting}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="sex">Gender (optional)</Label>
              <input type="hidden" name="sex" value={sex} />
              <Select value={sex} onValueChange={setSex} disabled={disabled || pending || isRedirecting}>
                <SelectTrigger id="sex">
                  <SelectValue placeholder="Select" />
                </SelectTrigger>
                <SelectContent>
                  {SEXES.map((s) => (
                    <SelectItem key={s} value={s}>
                      {SEX_LABELS[s]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="city">City (optional)</Label>
              <Input id="city" name="city" placeholder="Pune" disabled={disabled || pending || isRedirecting} />
            </div>
          </div>
        ) : null}

        {isDoctor ? (
          <>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-1.5">
                <Label htmlFor="qualification">Qualification</Label>
                <Input
                  id="qualification"
                  name="qualification"
                  placeholder="MBBS, MD (General Medicine)"
                  required
                  invalid={!!state.fieldErrors?.qualification}
                  disabled={disabled || pending || isRedirecting}
                />
                <FieldError error={state.fieldErrors?.qualification} />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="registration_number">Medical registration no.</Label>
                <Input
                  id="registration_number"
                  name="registration_number"
                  placeholder="MMC-2019-12345"
                  required
                  invalid={!!state.fieldErrors?.registration_number}
                  disabled={disabled || pending || isRedirecting}
                />
                <FieldError error={state.fieldErrors?.registration_number} />
              </div>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-1.5">
                <Label htmlFor="experience_years">Experience (years)</Label>
                <Input
                  id="experience_years"
                  name="experience_years"
                  type="number"
                  min={0}
                  max={60}
                  placeholder="5"
                  required
                  invalid={!!state.fieldErrors?.experience_years}
                  disabled={disabled || pending || isRedirecting}
                />
                <FieldError error={state.fieldErrors?.experience_years} />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="consultation_fee">Consultation fee (₹, optional)</Label>
                <Input
                  id="consultation_fee"
                  name="consultation_fee"
                  type="number"
                  min={0}
                  placeholder="500"
                  invalid={!!state.fieldErrors?.consultation_fee}
                  disabled={disabled || pending || isRedirecting}
                />
                <FieldError error={state.fieldErrors?.consultation_fee} />
              </div>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-1.5">
                <Label htmlFor="specialization_id">Specialization</Label>
                <input type="hidden" name="specialization_id" value={specializationId} />
                <Select
                  value={specializationId}
                  onValueChange={setSpecializationId}
                  disabled={disabled || pending || isRedirecting}
                >
                  <SelectTrigger id="specialization_id" invalid={!!state.fieldErrors?.specialization_id}>
                    <SelectValue
                      placeholder={specializations.length === 0 ? "None available yet" : "Select specialization"}
                    />
                  </SelectTrigger>
                  <SelectContent>
                    {specializations.map((s) => (
                      <SelectItem key={s.id} value={s.id}>
                        {s.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <FieldError error={state.fieldErrors?.specialization_id} />
                {specializations.length === 0 ? (
                  <p className="text-xs text-muted-foreground">
                    No specializations yet — they are created by the seed script or a clinic admin.
                  </p>
                ) : null}
              </div>

              <div className="space-y-1.5">
                <div className="flex items-center justify-between">
                  <Label htmlFor="clinic_id">Clinic (optional — join later)</Label>
                  <button
                    type="button"
                    onClick={() => setShowAddClinic(!showAddClinic)}
                    className="flex items-center gap-1 text-xs font-medium text-primary hover:underline"
                  >
                    <PlusCircle className="h-3.5 w-3.5" />
                    Add a clinic not listed
                  </button>
                </div>
                <input type="hidden" name="clinic_id" value={clinicId} />
                <Select value={clinicId} onValueChange={setClinicId} disabled={disabled || pending || isRedirecting}>
                  <SelectTrigger id="clinic_id">
                    <SelectValue
                      placeholder={clinicOptions.length === 0 ? "No clinics yet" : "Select a clinic"}
                    />
                  </SelectTrigger>
                  <SelectContent>
                    {clinicOptions.map((c) => (
                      <SelectItem key={c.id} value={c.id}>
                        {c.name} — {c.city}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <p className="text-xs text-muted-foreground">
                  Pick where you practise, or create a clinic to become affiliated.
                </p>
                {clinicId ? (
                  createdClinicIds.includes(clinicId) ? (
                    <div className="mt-2 rounded-md border border-emerald-500/30 bg-emerald-500/10 p-2.5 text-xs text-emerald-800 dark:text-emerald-300">
                      <input type="hidden" name="is_new_clinic" value="true" />
                      ✓ You registered this clinic. No doctor invite code required.
                    </div>
                  ) : (
                    <div className="mt-3 space-y-1.5">
                      <Label htmlFor="doctor_invite_code">Clinic doctor invite code</Label>
                      <Input
                        id="doctor_invite_code"
                        name="doctor_invite_code"
                        placeholder="6-character code (e.g. 7A8B9C)"
                        required
                        invalid={!!state.fieldErrors?.doctor_invite_code}
                        disabled={disabled || pending || isRedirecting}
                      />
                      <FieldError error={state.fieldErrors?.doctor_invite_code} />
                      <p className="text-xs text-muted-foreground">
                        Required to join this clinic. Ask your clinic administrator for the doctor invite code.
                      </p>
                    </div>
                  )
                ) : null}
              </div>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="about">About you (optional)</Label>
              <Textarea
                id="about"
                name="about"
                rows={3}
                placeholder="A short professional description patients will see."
                disabled={disabled || pending || isRedirecting}
              />
            </div>
          </>
        ) : null}

        {/* Inline "+ Add a clinic not listed" form for Doctor and Clinic Admin */}
        {showAddClinic && (isDoctor || staffRole === "CLINIC_ADMIN") ? (
          <div className="rounded-lg border-2 border-primary/20 bg-primary/5 p-4 space-y-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Building2 className="h-4 w-4 text-primary" />
                <h3 className="text-sm font-semibold">Register New Clinic</h3>
              </div>
              <button
                type="button"
                onClick={() => setShowAddClinic(false)}
                className="text-muted-foreground hover:text-foreground"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            {createClinicError ? (
              <Alert variant="destructive" className="py-2 text-xs">
                <AlertCircle className="h-3.5 w-3.5" />
                <AlertDescription>{createClinicError}</AlertDescription>
              </Alert>
            ) : null}

            <div className="grid gap-3 sm:grid-cols-2">
              <div className="space-y-1">
                <Label htmlFor="new_clinic_name" className="text-xs">Clinic Name</Label>
                <Input
                  id="new_clinic_name"
                  placeholder="e.g. Apex Health Clinic"
                  value={newClinicName}
                  onChange={(e) => {
                    setNewClinicName(e.target.value);
                    setDuplicateMatch(null);
                  }}
                  onBlur={handleCheckDuplicate}
                  disabled={createClinicPending}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor="new_clinic_city" className="text-xs">City</Label>
                <Input
                  id="new_clinic_city"
                  placeholder="e.g. Pune"
                  value={newClinicCity}
                  onChange={(e) => {
                    setNewClinicCity(e.target.value);
                    setDuplicateMatch(null);
                  }}
                  onBlur={handleCheckDuplicate}
                  disabled={createClinicPending}
                />
              </div>
            </div>

            {duplicateMatch ? (
              <div className="rounded-md border border-amber-500/40 bg-amber-500/10 p-3 text-xs text-amber-900 dark:text-amber-200">
                <div className="flex items-start justify-between gap-2">
                  <div>
                    <p className="font-semibold">Did you mean this one?</p>
                    <p className="mt-0.5">
                      <strong>{duplicateMatch.name}</strong> — {duplicateMatch.area}, {duplicateMatch.city}
                    </p>
                  </div>
                  <Button
                    type="button"
                    size="sm"
                    variant="outline"
                    className="h-7 text-xs shrink-0"
                    onClick={() => {
                      setClinicId(duplicateMatch.id);
                      setShowAddClinic(false);
                      setDuplicateMatch(null);
                      setDuplicateNoneFound(false);
                    }}
                  >
                    Use this clinic
                  </Button>
                </div>
              </div>
            ) : null}

            {!duplicateMatch && duplicateNoneFound ? (
              <div className="rounded-md border border-emerald-500/40 bg-emerald-500/10 p-2.5 text-xs text-emerald-800 dark:text-emerald-300">
                ✓ No duplicates found — &ldquo;{newClinicName}&rdquo; is available{newClinicCity ? ` in ${newClinicCity}` : ""}.
              </div>
            ) : null}

            <div className="grid gap-3 sm:grid-cols-2">
              <div className="space-y-1">
                <Label htmlFor="new_clinic_area" className="text-xs">Area / Locality</Label>
                <Input
                  id="new_clinic_area"
                  placeholder="e.g. Kothrud"
                  value={newClinicArea}
                  onChange={(e) => setNewClinicArea(e.target.value)}
                  disabled={createClinicPending}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor="new_clinic_address" className="text-xs">Street Address</Label>
                <Input
                  id="new_clinic_address"
                  placeholder="e.g. Shop 4, Mayur Colony"
                  value={newClinicAddress}
                  onChange={(e) => setNewClinicAddress(e.target.value)}
                  disabled={createClinicPending}
                />
              </div>
            </div>

            <div className="flex items-center justify-between pt-1">
              <Button
                type="button"
                variant="ghost"
                size="sm"
                className="text-xs"
                onClick={handleCheckDuplicate}
                disabled={checkingDuplicate || !newClinicName || !newClinicCity}
              >
                <Search className="h-3.5 w-3.5 mr-1" />
                {checkingDuplicate ? "Checking..." : "Check duplicate"}
              </Button>
              <div className="flex gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  className="text-xs"
                  onClick={() => setShowAddClinic(false)}
                  disabled={createClinicPending}
                >
                  Cancel
                </Button>
                <Button
                  type="button"
                  size="sm"
                  className="text-xs"
                  loading={createClinicPending}
                  disabled={
                    createClinicPending ||
                    !newClinicName.trim() ||
                    !newClinicCity.trim() ||
                    !newClinicArea.trim() ||
                    !newClinicAddress.trim()
                  }
                  onClick={handleCreateClinicSubmit}
                >
                  Create &amp; select clinic
                </Button>
              </div>
            </div>
          </div>
        ) : null}

        {/* Staff role views */}
        {isStaff && staffRole === "RECEPTIONIST" ? (
          <>
            <div className="space-y-1.5">
              <Label htmlFor="receptionist_clinic_id">Your clinic</Label>
              <input type="hidden" name="clinic_id" value={clinicId} />
              <Select value={clinicId} onValueChange={setClinicId} disabled={disabled || pending || isRedirecting}>
                <SelectTrigger id="receptionist_clinic_id" invalid={!!state.fieldErrors?.clinic_id}>
                  <SelectValue placeholder={clinicOptions.length === 0 ? "No clinics yet" : "Select your clinic"} />
                </SelectTrigger>
                <SelectContent>
                  {clinicOptions.map((c) => (
                    <SelectItem key={c.id} value={c.id}>
                      {c.name} — {c.city}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <FieldError error={state.fieldErrors?.clinic_id} />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="staff_invite_code">Clinic staff invite code</Label>
              <Input
                id="staff_invite_code"
                name="staff_invite_code"
                placeholder="6-character code (e.g. 7A8B9C)"
                required
                invalid={!!state.fieldErrors?.staff_invite_code}
                disabled={disabled || pending || isRedirecting}
              />
              <FieldError error={state.fieldErrors?.staff_invite_code} />
              <p className="text-xs text-muted-foreground">
                Receptionists must provide their clinic&apos;s invite code. Ask your clinic administrator or doctor for this code.
              </p>
            </div>
          </>
        ) : null}

        {isStaff && staffRole === "CLINIC_ADMIN" ? (
          <>
            <div className="space-y-1.5">
              <div className="flex items-center justify-between">
                <Label htmlFor="admin_clinic_id">Your clinic</Label>
                <button
                  type="button"
                  onClick={() => setShowAddClinic(!showAddClinic)}
                  className="flex items-center gap-1 text-xs font-medium text-primary hover:underline"
                >
                  <PlusCircle className="h-3.5 w-3.5" />
                  Add a clinic not listed
                </button>
              </div>
              <input type="hidden" name="clinic_id" value={clinicId} />
              <Select value={clinicId} onValueChange={setClinicId} disabled={disabled || pending || isRedirecting}>
                <SelectTrigger id="admin_clinic_id" invalid={!!state.fieldErrors?.clinic_id}>
                  <SelectValue placeholder={clinicOptions.length === 0 ? "No clinics yet" : "Select your clinic"} />
                </SelectTrigger>
                <SelectContent>
                  {clinicOptions.map((c) => (
                    <SelectItem key={c.id} value={c.id}>
                      {c.name} — {c.city}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <FieldError error={state.fieldErrors?.clinic_id} />
            </div>
            {clinicId ? (
              createdClinicIds.includes(clinicId) ? (
                <div className="rounded-md border border-emerald-500/30 bg-emerald-500/10 p-3 text-xs text-emerald-800 dark:text-emerald-300">
                  <input type="hidden" name="is_new_clinic" value="true" />
                  <p className="font-semibold">✓ Founding Administrator</p>
                  <p className="mt-0.5">
                    You registered this clinic in this session. You will be set as its founding administrator with full management access — no verification code required.
                  </p>
                </div>
              ) : (
                <div className="space-y-1.5">
                  <Label htmlFor="clinic_admin_claim_code">Clinic admin verification code</Label>
                  <Input
                    id="clinic_admin_claim_code"
                    name="clinic_admin_claim_code"
                    placeholder="e.g. ADM-688EC6"
                    required
                    invalid={!!state.fieldErrors?.clinic_admin_claim_code}
                    disabled={disabled || pending || isRedirecting}
                  />
                  <FieldError error={state.fieldErrors?.clinic_admin_claim_code} />
                  <p className="text-xs text-muted-foreground">
                    Required to claim an existing clinic. This verification code is generated when the clinic is created. Each clinic can have at most one active administrator.
                  </p>
                </div>
              )
            ) : null}
          </>
        ) : null}

        <Button
          type="submit"
          className="w-full"
          loading={pending || isRedirecting}
          disabled={disabled || pending || isRedirecting}
        >
          {isRedirecting ? "Creating account…" : "Create account"}
        </Button>
      </form>

      <p className="mt-4 text-center text-sm text-muted-foreground">
        Already have an account?{" "}
        <Link href="/login" replace className="font-medium text-primary hover:underline">
          Sign in
        </Link>
      </p>
    </div>
  );
}
