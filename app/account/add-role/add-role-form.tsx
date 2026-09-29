"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { FieldError } from "@/components/shared/field-error";
import { ROLE_LABELS, type Role } from "@/lib/constants";
import { addRoleAction, type AddRoleState } from "./actions";
import { Building2, Stethoscope, User, Users, CheckCircle2, AlertCircle, ArrowRight, Loader2 } from "lucide-react";

interface AddRoleFormProps {
  existingRoles: Role[];
  availableRoles: Role[];
  specializations: { id: string; name: string }[];
  clinics: { id: string; name: string; city: string }[];
}

const ROLE_INFO: Record<
  Role,
  { title: string; description: string; icon: React.ComponentType<{ className?: string }> }
> = {
  PATIENT: {
    title: "Patient",
    description: "Book appointments, view prescriptions and medical records, and track live queue wait times.",
    icon: User,
  },
  DOCTOR: {
    title: "Doctor",
    description: "Manage patient consultations, prescribe medications, and manage queues.",
    icon: Stethoscope,
  },
  RECEPTIONIST: {
    title: "Receptionist",
    description: "Handle front-desk check-ins, issue tokens, and coordinate clinic queues.",
    icon: Users,
  },
  CLINIC_ADMIN: {
    title: "Clinic Administrator",
    description: "Manage clinic hours, onboard staff and doctors, and monitor analytics.",
    icon: Building2,
  },
};

export function AddRoleForm({
  existingRoles,
  availableRoles,
  specializations,
  clinics,
}: AddRoleFormProps) {
  const router = useRouter();
  const [selectedRole, setSelectedRole] = useState<Role>(availableRoles[0] ?? "PATIENT");
  const [isPending, startTransition] = useTransition();
  const [state, setState] = useState<AddRoleState>({});
  const [selectedClinicId, setSelectedClinicId] = useState<string>("");

  if (availableRoles.length === 0) {
    return (
      <Card className="border-border">
        <CardContent className="pt-6 text-center space-y-3">
          <CheckCircle2 className="mx-auto h-12 w-12 text-emerald-500" />
          <h2 className="text-xl font-semibold">All roles registered</h2>
          <p className="text-sm text-muted-foreground">
            Your account already possesses all available roles across Better Clinic. You can switch between them anytime from your profile menu.
          </p>
          <Button onClick={() => router.push("/")} className="mt-4">
            Return to Dashboard
          </Button>
        </CardContent>
      </Card>
    );
  }

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setState({});
    const form = event.currentTarget;
    const formData = new FormData(form);
    formData.set("role", selectedRole);

    startTransition(async () => {
      const res = await addRoleAction(formData);
      if (res.error || res.fieldErrors) {
        setState(res);
      } else if (res.redirectUrl) {
        router.replace(res.redirectUrl);
        router.refresh();
      }
    });
  }

  return (
    <div className="space-y-6">
      {/* Existing roles summary */}
      <div className="rounded-lg border border-border/70 bg-muted/30 p-4">
        <p className="text-xs font-medium text-muted-foreground mb-2">Current Active Roles on Your Account:</p>
        <div className="flex flex-wrap gap-2">
          {existingRoles.map((r) => (
            <span
              key={r}
              className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-3 py-1 text-xs font-medium text-primary border border-primary/20"
            >
              <CheckCircle2 className="h-3.5 w-3.5" />
              {ROLE_LABELS[r]}
            </span>
          ))}
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        {state.error ? (
          <Alert variant="destructive">
            <AlertCircle className="h-4 w-4" />
            <AlertDescription>{state.error}</AlertDescription>
          </Alert>
        ) : null}

        {/* Role selection radio cards */}
        <div className="space-y-3">
          <Label className="text-sm font-semibold">Select role to add</Label>
          <div className="grid gap-3 sm:grid-cols-2">
            {availableRoles.map((r) => {
              const info = ROLE_INFO[r];
              const Icon = info.icon;
              const isSelected = selectedRole === r;

              return (
                <button
                  type="button"
                  key={r}
                  onClick={() => {
                    setSelectedRole(r);
                    setState({});
                  }}
                  className={`flex flex-col text-left p-4 rounded-xl border-2 transition-all ${
                    isSelected
                      ? "border-primary bg-primary/5 shadow-sm"
                      : "border-border hover:border-primary/40 bg-card"
                  }`}
                >
                  <div className="flex items-center gap-2.5 mb-1.5">
                    <div className={`p-1.5 rounded-md ${isSelected ? "bg-primary text-primary-foreground" : "bg-muted text-foreground"}`}>
                      <Icon className="h-4 w-4" />
                    </div>
                    <span className="font-semibold text-sm">{info.title}</span>
                  </div>
                  <p className="text-xs text-muted-foreground line-clamp-2">{info.description}</p>
                </button>
              );
            })}
          </div>
        </div>

        {/* Role-specific details */}
        <Card className="border-border shadow-sm">
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-semibold">
              {ROLE_LABELS[selectedRole]} Details
            </CardTitle>
            <CardDescription className="text-xs">
              Provide the required details to initialize your {ROLE_LABELS[selectedRole]} profile.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {selectedRole === "PATIENT" && (
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="space-y-1.5">
                  <Label htmlFor="date_of_birth">Date of birth</Label>
                  <Input id="date_of_birth" name="date_of_birth" type="date" />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="sex">Sex</Label>
                  <select
                    id="sex"
                    name="sex"
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                    defaultValue=""
                  >
                    <option value="" disabled>Select sex</option>
                    <option value="MALE">Male</option>
                    <option value="FEMALE">Female</option>
                    <option value="OTHER">Other</option>
                  </select>
                </div>
                <div className="space-y-1.5 sm:col-span-2">
                  <Label htmlFor="city">City</Label>
                  <Input id="city" name="city" placeholder="e.g. Mumbai, Pune" />
                </div>
              </div>
            )}

            {selectedRole === "DOCTOR" && (
              <div className="space-y-4">
                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-1.5">
                    <Label htmlFor="qualification">Qualification *</Label>
                    <Input id="qualification" name="qualification" defaultValue="MBBS, MD" required />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="registration_number">Medical Registration Number *</Label>
                    <Input
                      id="registration_number"
                      name="registration_number"
                      placeholder="e.g. MMC-123456"
                      required
                    />
                    <FieldError error={state.fieldErrors?.registration_number} />
                  </div>
                </div>

                <div className="grid gap-4 sm:grid-cols-3">
                  <div className="space-y-1.5">
                    <Label htmlFor="specialization_id">Specialization</Label>
                    <select
                      id="specialization_id"
                      name="specialization_id"
                      className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                    >
                      <option value="">General Medicine</option>
                      {specializations.map((s) => (
                        <option key={s.id} value={s.id}>{s.name}</option>
                      ))}
                    </select>
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="experience_years">Experience (Years)</Label>
                    <Input id="experience_years" name="experience_years" type="number" min="0" defaultValue="5" />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="consultation_fee">Consultation Fee (₹)</Label>
                    <Input id="consultation_fee" name="consultation_fee" type="number" min="0" defaultValue="500" />
                  </div>
                </div>

                <div className="space-y-1.5">
                  <Label htmlFor="about">About / Professional Bio</Label>
                  <Textarea id="about" name="about" placeholder="Brief summary of your clinical practice..." rows={2} />
                </div>

                <div className="rounded-lg border border-dashed border-border/80 p-3.5 space-y-3 bg-muted/10">
                  <p className="text-xs font-semibold">Affiliated Clinic (Optional)</p>
                  <p className="text-[11px] text-muted-foreground">
                    You can link to an existing clinic now or leave this blank and link/register clinics anytime later from your dashboard.
                  </p>
                  <div className="grid gap-3 sm:grid-cols-2">
                    <div className="space-y-1">
                      <Label htmlFor="clinic_id" className="text-xs">Clinic</Label>
                      <select
                        id="clinic_id"
                        name="clinic_id"
                        value={selectedClinicId}
                        onChange={(e) => setSelectedClinicId(e.target.value)}
                        className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                      >
                        <option value="">No clinic right now</option>
                        {clinics.map((c) => (
                          <option key={c.id} value={c.id}>{c.name} ({c.city})</option>
                        ))}
                      </select>
                    </div>
                    {selectedClinicId ? (
                      <div className="space-y-1">
                        <Label htmlFor="doctor_invite_code" className="text-xs">Clinic Doctor Invite Code *</Label>
                        <Input
                          id="doctor_invite_code"
                          name="doctor_invite_code"
                          placeholder="Enter invite code"
                        />
                        <FieldError error={state.fieldErrors?.doctor_invite_code} />
                      </div>
                    ) : null}
                  </div>
                </div>
              </div>
            )}

            {selectedRole === "RECEPTIONIST" && (
              <div className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="clinic_id">Select Clinic *</Label>
                  <select
                    id="clinic_id"
                    name="clinic_id"
                    required
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                  >
                    <option value="" disabled selected>Select a clinic...</option>
                    {clinics.map((c) => (
                      <option key={c.id} value={c.id}>{c.name} ({c.city})</option>
                    ))}
                  </select>
                  <FieldError error={state.fieldErrors?.clinic_id} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="staff_invite_code">Clinic Staff Invite Code *</Label>
                  <Input
                    id="staff_invite_code"
                    name="staff_invite_code"
                    placeholder="Enter staff invite code provided by your clinic admin"
                    required
                  />
                  <FieldError error={state.fieldErrors?.staff_invite_code} />
                </div>
              </div>
            )}

            {selectedRole === "CLINIC_ADMIN" && (
              <div className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="clinic_id">Select Clinic *</Label>
                  <select
                    id="clinic_id"
                    name="clinic_id"
                    required
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                  >
                    <option value="" disabled selected>Select a clinic...</option>
                    {clinics.map((c) => (
                      <option key={c.id} value={c.id}>{c.name} ({c.city})</option>
                    ))}
                  </select>
                  <FieldError error={state.fieldErrors?.clinic_id} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="clinic_admin_claim_code">Clinic Admin Claim Code *</Label>
                  <Input
                    id="clinic_admin_claim_code"
                    name="clinic_admin_claim_code"
                    placeholder="Enter admin verification / claim code"
                    required
                  />
                  <FieldError error={state.fieldErrors?.clinic_admin_claim_code} />
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        <div className="flex items-center justify-between pt-2">
          <Button
            type="button"
            variant="ghost"
            onClick={() => router.back()}
            disabled={isPending}
          >
            Cancel
          </Button>

          <Button type="submit" disabled={isPending} className="gap-2 min-w-[150px]">
            {isPending ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                Adding Role...
              </>
            ) : (
              <>
                Add {ROLE_LABELS[selectedRole]} Role
                <ArrowRight className="h-4 w-4" />
              </>
            )}
          </Button>
        </div>
      </form>
    </div>
  );
}
