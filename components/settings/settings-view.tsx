"use client";

import { useFormState } from "react-dom";
import { Bell, Copy, KeyRound, LogOut, SlidersHorizontal, UserCircle } from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { AlertCircle, CheckCircle2 } from "lucide-react";
import { updateProfileAction } from "@/services/users/actions";
import { AvatarUpload } from "@/components/settings/avatar-upload";
import { updatePasswordAction, signOutAction, type FormState } from "@/app/(auth)/actions";
import { SEXES, SEX_LABELS, type Role } from "@/lib/constants";
import type { Patient } from "@/lib/types/database";
import { useState } from "react";

import { PreferencesForm } from "@/components/settings/preferences-form";
import { type UserPreferences, DEFAULT_PREFERENCES } from "@/services/preferences/service";

const BLOOD_GROUPS = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"] as const;

const initialProfileState: FormState = {};
const initialPasswordState: FormState = {};

export interface InviteCodeItem {
  clinicId: string;
  clinicName: string;
  clinicCity: string;
  code: string;
  doctorCode?: string | null;
  adminClaimCode?: string | null;
}

interface SettingsViewProps {
  userId: string;
  avatarUrl: string | null;
  fullName: string;
  email: string;
  phone: string | null;
  role: Role;
  patient?: Patient | null;
  inviteCodes?: InviteCodeItem[];
  preferences?: UserPreferences;
  clinicsSection?: React.ReactNode;
}

function ProfileForm({ userId, avatarUrl, fullName, phone, patient }: Omit<SettingsViewProps, "email" | "role">) {
  const [state, formAction, pending] = useFormState(updateProfileAction, initialProfileState);
  const [sex, setSex] = useState(patient?.sex ?? "");

  return (
    <Card>
      <CardHeader>
        <CardTitle>Profile</CardTitle>
        <CardDescription>Your name and contact details, visible where appropriate.</CardDescription>
      </CardHeader>
      <CardContent>
        {state.error ? (
          <Alert variant="destructive" className="mb-4">
            <AlertCircle aria-hidden />
            <AlertDescription>{state.error}</AlertDescription>
          </Alert>
        ) : null}
        {state.success ? (
          <Alert variant="success" className="mb-4">
            <CheckCircle2 aria-hidden />
            <AlertDescription>{state.success}</AlertDescription>
          </Alert>
        ) : null}
        <div className='mb-6 rounded-lg border bg-muted/20 p-4'>
          <AvatarUpload userId={userId} name={fullName} currentUrl={avatarUrl} />
        </div>
        <form action={formAction} className="space-y-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Label htmlFor="full_name">Full name</Label>
              <Input
                id="full_name"
                name="full_name"
                defaultValue={fullName}
                required
                invalid={!!state.fieldErrors?.full_name}
                disabled={pending}
              />
              {state.fieldErrors?.full_name ? (
                <p className="form-error">{state.fieldErrors.full_name}</p>
              ) : null}
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="phone">Mobile number</Label>
              <Input
                id="phone"
                name="phone"
                type="tel"
                defaultValue={phone ?? ""}
                required
                invalid={!!state.fieldErrors?.phone}
                disabled={pending}
              />
              {state.fieldErrors?.phone ? <p className="form-error">{state.fieldErrors.phone}</p> : null}
            </div>
          </div>

          {patient ? (
            <>
              <div className="grid gap-4 sm:grid-cols-3">
                <div className="space-y-1.5">
                  <Label htmlFor="date_of_birth">Date of birth</Label>
                  <Input
                    id="date_of_birth"
                    name="date_of_birth"
                    type="date"
                    defaultValue={patient.date_of_birth ?? ""}
                    max={new Date().toISOString().slice(0, 10)}
                    disabled={pending}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="sex">Gender</Label>
                  <input type="hidden" name="sex" value={sex} />
                  <Select value={sex || undefined} onValueChange={setSex} disabled={pending}>
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
                  <Label htmlFor="blood_group">Blood group</Label>
                  <Input
                    id="blood_group"
                    name="blood_group"
                    list="blood-groups"
                    defaultValue={patient.blood_group ?? ""}
                    placeholder="e.g. O+"
                    disabled={pending}
                  />
                  <datalist id="blood-groups">
                    {BLOOD_GROUPS.map((b) => (
                      <option key={b} value={b} />
                    ))}
                  </datalist>
                </div>
              </div>
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="space-y-1.5">
                  <Label htmlFor="city">City</Label>
                  <Input id="city" name="city" defaultValue={patient.city ?? ""} disabled={pending} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="area">Area / locality</Label>
                  <Input id="area" name="area" defaultValue={patient.area ?? ""} disabled={pending} />
                </div>
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="address_line">Address</Label>
                <Input
                  id="address_line"
                  name="address_line"
                  defaultValue={patient.address_line ?? ""}
                  disabled={pending}
                />
              </div>
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="space-y-1.5">
                  <Label htmlFor="emergency_contact_name">Emergency contact name</Label>
                  <Input
                    id="emergency_contact_name"
                    name="emergency_contact_name"
                    defaultValue={patient.emergency_contact_name ?? ""}
                    disabled={pending}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="emergency_contact_phone">Emergency contact phone</Label>
                  <Input
                    id="emergency_contact_phone"
                    name="emergency_contact_phone"
                    type="tel"
                    defaultValue={patient.emergency_contact_phone ?? ""}
                    disabled={pending}
                  />
                </div>
              </div>
            </>
          ) : null}

          <Button type="submit" loading={pending}>
            Save changes
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}

function PasswordForm() {
  const [state, formAction, pending] = useFormState(updatePasswordAction, initialPasswordState);

  return (
    <Card>
      <CardHeader>
        <CardTitle>Security</CardTitle>
        <CardDescription>Change your password. You stay signed in afterwards.</CardDescription>
      </CardHeader>
      <CardContent>
        {state.error ? (
          <Alert variant="destructive" className="mb-4">
            <AlertCircle aria-hidden />
            <AlertDescription>{state.error}</AlertDescription>
          </Alert>
        ) : null}
        {state.success ? (
          <Alert variant="success" className="mb-4">
            <CheckCircle2 aria-hidden />
            <AlertDescription>{state.success}</AlertDescription>
          </Alert>
        ) : null}
        <form action={formAction} className="max-w-sm space-y-4">
          <div className="space-y-1.5">
            <Label htmlFor="new_password">New password</Label>
            <Input
              id="new_password"
              name="password"
              type="password"
              autoComplete="new-password"
              required
              invalid={!!state.fieldErrors?.password}
              disabled={pending}
            />
            {state.fieldErrors?.password ? (
              <p className="form-error">{state.fieldErrors.password}</p>
            ) : null}
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="confirm_password">Confirm new password</Label>
            <Input
              id="confirm_password"
              name="confirmPassword"
              type="password"
              autoComplete="new-password"
              required
              invalid={!!state.fieldErrors?.confirmPassword}
              disabled={pending}
            />
            {state.fieldErrors?.confirmPassword ? (
              <p className="form-error">{state.fieldErrors.confirmPassword}</p>
            ) : null}
          </div>
          <Button type="submit" loading={pending}>
            Update password
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}

function InviteCodesSection({ inviteCodes }: { inviteCodes: InviteCodeItem[] }) {
  const [copiedCode, setCopiedCode] = useState<string | null>(null);

  const copyToClipboard = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopiedCode(code);
    setTimeout(() => setCopiedCode(null), 2500);
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Staff Invite Codes</CardTitle>
        <CardDescription>
          Share your clinic&apos;s invite code with receptionists so they can link directly to your clinic when signing up.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {inviteCodes.length === 0 ? (
          <p className="text-sm text-muted-foreground">
            You are not affiliated with any clinic yet. Join a clinic or create one to view invite codes.
          </p>
        ) : (
          inviteCodes.map((item) => (
            <div
              key={item.clinicId}
              className="flex flex-col gap-3 rounded-lg border p-4 bg-muted/20"
            >
              <div>
                <p className="font-medium text-sm text-foreground">{item.clinicName}</p>
                <p className="text-xs text-muted-foreground">{item.clinicCity}</p>
              </div>
              <div className="flex flex-wrap items-center gap-3 pt-1">
                <div className="flex items-center gap-2">
                  <span className="text-xs text-muted-foreground font-medium">Staff code:</span>
                  <code className="rounded bg-muted px-2.5 py-1 font-mono text-sm font-bold tracking-wider text-primary border">
                    {item.code}
                  </code>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    className="h-8 gap-1.5 text-xs"
                    onClick={() => copyToClipboard(item.code)}
                  >
                    {copiedCode === item.code ? (
                      <>
                        <CheckCircle2 className="h-3.5 w-3.5 text-emerald-500" />
                        Copied!
                      </>
                    ) : (
                      <>
                        <Copy className="h-3.5 w-3.5" />
                        Copy
                      </>
                    )}
                  </Button>
                </div>

                {item.doctorCode ? (
                  <div className="flex items-center gap-2">
                    <span className="text-xs text-muted-foreground font-medium">Doctor code:</span>
                    <code className="rounded bg-muted px-2.5 py-1 font-mono text-sm font-bold tracking-wider text-primary border">
                      {item.doctorCode}
                    </code>
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      className="h-8 gap-1.5 text-xs"
                      onClick={() => copyToClipboard(item.doctorCode!)}
                    >
                      {copiedCode === item.doctorCode ? (
                        <>
                          <CheckCircle2 className="h-3.5 w-3.5 text-emerald-500" />
                          Copied!
                        </>
                      ) : (
                        <>
                          <Copy className="h-3.5 w-3.5" />
                          Copy
                        </>
                      )}
                    </Button>
                  </div>
                ) : null}

                {item.adminClaimCode ? (
                  <div className="flex items-center gap-2">
                    <span className="text-xs text-muted-foreground font-medium">Admin claim code:</span>
                    <code className="rounded bg-muted px-2.5 py-1 font-mono text-sm font-bold tracking-wider text-amber-700 dark:text-amber-300 border">
                      {item.adminClaimCode}
                    </code>
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      className="h-8 gap-1.5 text-xs"
                      onClick={() => copyToClipboard(item.adminClaimCode!)}
                    >
                      {copiedCode === item.adminClaimCode ? (
                        <>
                          <CheckCircle2 className="h-3.5 w-3.5 text-emerald-500" />
                          Copied!
                        </>
                      ) : (
                        <>
                          <Copy className="h-3.5 w-3.5" />
                          Copy
                        </>
                      )}
                    </Button>
                  </div>
                ) : null}
              </div>
            </div>
          ))
        )}
      </CardContent>
    </Card>
  );
}

/** One compact settings surface reused by every role. */
export function SettingsView({
  userId,
  avatarUrl,
  fullName,
  email,
  phone,
  role,
  patient,
  inviteCodes,
  preferences,
  clinicsSection,
}: SettingsViewProps) {
  return (
    <div className="page-container max-w-3xl space-y-6 py-8">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">Settings</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Manage your profile, account security and preferences.
        </p>
      </div>

      <Tabs defaultValue="profile">
        <TabsList className="flex w-full flex-wrap">
          <TabsTrigger value="profile">
            <UserCircle className="h-4 w-4" aria-hidden /> Profile
          </TabsTrigger>
          {role === "DOCTOR" || role === "CLINIC_ADMIN" ? (
            <TabsTrigger value="invite-codes">
              <KeyRound className="h-4 w-4" aria-hidden /> Clinic invite codes
            </TabsTrigger>
          ) : null}
          <TabsTrigger value="security">
            <KeyRound className="h-4 w-4" aria-hidden /> Security
          </TabsTrigger>
          <TabsTrigger value="preferences">
            <SlidersHorizontal className="h-4 w-4" aria-hidden /> Preferences
          </TabsTrigger>
        </TabsList>

        <TabsContent value="profile" className="space-y-6">
          <ProfileForm userId={userId} avatarUrl={avatarUrl} fullName={fullName} phone={phone} patient={patient} />
          {clinicsSection}
          {inviteCodes && inviteCodes.length > 0 ? (
            <InviteCodesSection inviteCodes={inviteCodes} />
          ) : null}
        </TabsContent>

        {role === "DOCTOR" || role === "CLINIC_ADMIN" ? (
          <TabsContent value="invite-codes">
            <InviteCodesSection inviteCodes={inviteCodes ?? []} />
          </TabsContent>
        ) : null}

        <TabsContent value="security">
          <PasswordForm />
          <Card className="mt-4">
            <CardHeader>
              <CardTitle>Sign out</CardTitle>
              <CardDescription>End your session on this device.</CardDescription>
            </CardHeader>
            <CardContent>
              <form
                action={async () => {
                  try {
                    await signOutAction();
                  } finally {
                    window.location.replace("/");
                  }
                }}
              >
                <Button type="submit" variant="outline">
                  <LogOut className="h-4 w-4" aria-hidden /> Sign out
                </Button>
              </form>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="preferences">
          <PreferencesForm
            initialPreferences={preferences ?? { userId, ...DEFAULT_PREFERENCES }}
            role={role}
          />
        </TabsContent>
      </Tabs>
    </div>
  );
}
