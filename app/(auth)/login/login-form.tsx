"use client";

import Link from "next/link";
import { useEffect, useState, useTransition } from "react";
import { useFormState } from "react-dom";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useRouter } from "next/navigation";
import { AlertCircle, CheckCircle2, Sparkles, User, Stethoscope, Users, Building2, Loader2, ArrowRight } from "lucide-react";
import { signInAction, quickDemoLoginAction, type FormState } from "../actions";
import type { Role } from "@/lib/constants";
import { DEMO_DOCTORS, DEMO_PATIENTS } from "@/lib/mock-data";
import { cn } from "@/lib/utils";

const initialState: FormState = {};

export function LoginForm({ nextPath, disabled = false }: { nextPath: string | null; disabled?: boolean }) {
  const router = useRouter();
  const [state, formAction, pending] = useFormState(signInAction, initialState);
  const [demoPendingRole, setDemoPendingRole] = useState<Role | null>(null);
  const [selectedDoctorId, setSelectedDoctorId] = useState<string>("8c493931-d94c-45cb-8b93-ae5aedd08d23");
  const [selectedPatientId, setSelectedPatientId] = useState<string>(
    DEMO_PATIENTS[0]?.id || "00000000-0000-0000-0000-000000000020"
  );
  const [isPending, startTransition] = useTransition();

  const isRedirecting = Boolean(state.redirectUrl) || Boolean(demoPendingRole);

  useEffect(() => {
    if (state.redirectUrl) {
      router.replace(state.redirectUrl);
      router.refresh();
    }
  }, [state.redirectUrl, router]);

  const handleQuickDemo = (role: Role, doctorId?: string, patientId?: string) => {
    setDemoPendingRole(role);
    startTransition(async () => {
      try {
        const res = await quickDemoLoginAction(role, doctorId, patientId);
        if (res.redirectUrl) {
          router.replace(res.redirectUrl);
          router.refresh();
        }
      } catch {
        setDemoPendingRole(null);
      }
    });
  };

  return (
    <div className="rounded-2xl border border-border/80 bg-card p-6 sm:p-8 shadow-lg">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-bold tracking-tight text-foreground">Sign in</h1>
        <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-0.5 text-[11px] font-semibold text-primary">
          <Sparkles className="h-3 w-3" /> Quick Access
        </span>
      </div>
      <p className="mt-1 text-xs sm:text-sm text-muted-foreground">
        Welcome back. Enter your credentials or choose a role below to sign in instantly.
      </p>

      {/* ── 1-CLICK INSTANT ROLE SWITCHER ────────────────────────── */}
      <div className="mt-5 rounded-xl border border-primary/20 bg-primary/5 p-3.5 space-y-3">
        <p className="text-xs font-semibold text-primary flex items-center gap-1.5">
          <span>⚡ Instant 1-Click Role Access:</span>
        </p>
        <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => handleQuickDemo("PATIENT", undefined, selectedPatientId)}
            disabled={isRedirecting || pending}
            className="h-10 text-xs font-semibold flex items-center justify-center gap-1.5 border-border bg-card hover:bg-primary hover:text-primary-foreground transition-all"
          >
            {demoPendingRole === "PATIENT" ? (
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
            ) : (
              <User className="h-3.5 w-3.5 text-teal-600 dark:text-teal-400" />
            )}
            <span>Patient</span>
          </Button>

          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => handleQuickDemo("DOCTOR", selectedDoctorId)}
            disabled={isRedirecting || pending}
            className="h-10 text-xs font-semibold flex items-center justify-center gap-1.5 border-border bg-card hover:bg-primary hover:text-primary-foreground transition-all"
          >
            {demoPendingRole === "DOCTOR" ? (
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
            ) : (
              <Stethoscope className="h-3.5 w-3.5 text-emerald-600 dark:text-emerald-400" />
            )}
            <span>Doctor</span>
          </Button>

          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => handleQuickDemo("RECEPTIONIST")}
            disabled={isRedirecting || pending}
            className="h-10 text-xs font-semibold flex items-center justify-center gap-1.5 border-border bg-card hover:bg-primary hover:text-primary-foreground transition-all"
          >
            {demoPendingRole === "RECEPTIONIST" ? (
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
            ) : (
              <Users className="h-3.5 w-3.5 text-sky-600 dark:text-sky-400" />
            )}
            <span>Staff</span>
          </Button>

          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => handleQuickDemo("CLINIC_ADMIN")}
            disabled={isRedirecting || pending}
            className="h-10 text-xs font-semibold flex items-center justify-center gap-1.5 border-border bg-card hover:bg-primary hover:text-primary-foreground transition-all"
          >
            {demoPendingRole === "CLINIC_ADMIN" ? (
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
            ) : (
              <Building2 className="h-3.5 w-3.5 text-amber-600 dark:text-amber-400" />
            )}
            <span>Admin</span>
          </Button>
        </div>

        {/* Demo Patient Selection */}
        <div className="pt-2.5 border-t border-primary/20 space-y-2">
          <div className="flex items-center justify-between">
            <Label htmlFor="demo-patient-select" className="text-xs font-semibold text-foreground flex items-center gap-1.5">
              <User className="h-3.5 w-3.5 text-teal-600 dark:text-teal-400" />
              <span>Demo Patient:</span>
            </Label>
            <span className="text-[10px] text-teal-700 dark:text-teal-300 font-semibold bg-teal-50 dark:bg-teal-950/60 px-2 py-0.5 rounded-full border border-teal-200 dark:border-teal-800">
              New: Aditi Rao (Knee sprain)
            </span>
          </div>

          <div className="flex flex-col sm:flex-row gap-2">
            <div className="relative flex-1">
              <select
                id="demo-patient-select"
                value={selectedPatientId}
                onChange={(e) => setSelectedPatientId(e.target.value)}
                disabled={isRedirecting || pending}
                className="w-full h-9 rounded-lg border border-border bg-card px-2.5 text-xs font-medium text-foreground shadow-2xs focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary"
              >
                {DEMO_PATIENTS.map((pat) => (
                  <option key={pat.id} value={pat.id}>
                    {pat.name} — {pat.bloodGroup} (DOB: {pat.dob})
                  </option>
                ))}
              </select>
            </div>
            <Button
              type="button"
              size="sm"
              onClick={() => handleQuickDemo("PATIENT", undefined, selectedPatientId)}
              disabled={isRedirecting || pending}
              className="h-9 px-3 text-xs font-semibold gap-1.5 bg-teal-600 hover:bg-teal-700 text-white shrink-0 shadow-2xs"
            >
              {demoPendingRole === "PATIENT" ? (
                <Loader2 className="h-3.5 w-3.5 animate-spin" />
              ) : (
                <ArrowRight className="h-3.5 w-3.5" />
              )}
              <span>Log in as Patient</span>
            </Button>
          </div>

          <div className="flex flex-wrap items-center gap-1.5 pt-1">
            <span className="text-[10px] font-medium text-muted-foreground mr-0.5">Quick switch:</span>
            {DEMO_PATIENTS.map((pat) => {
              const isSelected = selectedPatientId === pat.id;
              return (
                <button
                  key={pat.id}
                  type="button"
                  onClick={() => {
                    setSelectedPatientId(pat.id);
                    handleQuickDemo("PATIENT", undefined, pat.id);
                  }}
                  disabled={isRedirecting || pending}
                  title={`${pat.name} (${pat.bloodGroup}, DOB: ${pat.dob})`}
                  className={cn(
                    "inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-medium transition-all border shadow-2xs",
                    isSelected
                      ? "border-teal-500 bg-teal-50 dark:bg-teal-950/50 text-teal-700 dark:text-teal-300 font-semibold ring-1 ring-teal-500/30"
                      : "border-border/80 bg-background/80 text-muted-foreground hover:border-teal-500 hover:text-foreground hover:bg-teal-50/40"
                  )}
                >
                  <span className="font-medium">{pat.name}</span>
                  <span className="opacity-60 text-[9px]">({pat.bloodGroup})</span>
                  {pat.id === DEMO_PATIENTS[0]?.id && (
                    <span className="ml-0.5 text-[8px] bg-teal-600 text-white px-1 rounded-full uppercase tracking-wider font-bold">New</span>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Doctor Demo Selection Section */}
        <div className="pt-2.5 border-t border-primary/20 space-y-2">
          <div className="flex items-center justify-between">
            <Label htmlFor="demo-doctor-select" className="text-xs font-semibold text-foreground flex items-center gap-1.5">
              <Stethoscope className="h-3.5 w-3.5 text-emerald-600 dark:text-emerald-400" />
              <span>Choose Demo Doctor ({DEMO_DOCTORS.length} available):</span>
            </Label>
            <span className="text-[10px] text-muted-foreground font-medium">
              Pick any specialty
            </span>
          </div>

          <div className="flex flex-col sm:flex-row gap-2">
            <div className="relative flex-1">
              <select
                id="demo-doctor-select"
                value={selectedDoctorId}
                onChange={(e) => setSelectedDoctorId(e.target.value)}
                disabled={isRedirecting || pending}
                className="w-full h-9 rounded-lg border border-border bg-card px-2.5 text-xs font-medium text-foreground shadow-2xs focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary"
              >
                {DEMO_DOCTORS.map((doc) => (
                  <option key={doc.id} value={doc.id}>
                    {doc.name} — {doc.specialization} ({doc.city})
                  </option>
                ))}
              </select>
            </div>
            <Button
              type="button"
              size="sm"
              onClick={() => handleQuickDemo("DOCTOR", selectedDoctorId)}
              disabled={isRedirecting || pending}
              className="h-9 px-3 text-xs font-semibold gap-1.5 bg-emerald-600 hover:bg-emerald-700 text-white shrink-0 shadow-2xs"
            >
              {demoPendingRole === "DOCTOR" ? (
                <Loader2 className="h-3.5 w-3.5 animate-spin" />
              ) : (
                <ArrowRight className="h-3.5 w-3.5" />
              )}
              <span>Log in as Doctor</span>
            </Button>
          </div>

          <div className="flex flex-wrap items-center gap-1.5 pt-1">
            <span className="text-[10px] font-medium text-muted-foreground mr-0.5">Quick switch:</span>
            {DEMO_DOCTORS.map((doc) => {
              const isSelected = selectedDoctorId === doc.id;
              return (
                <button
                  key={doc.id}
                  type="button"
                  onClick={() => {
                    setSelectedDoctorId(doc.id);
                    handleQuickDemo("DOCTOR", doc.id);
                  }}
                  disabled={isRedirecting || pending}
                  title={`${doc.name} (${doc.qualification}) - ${doc.specialization}`}
                  className={cn(
                    "inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-medium transition-all border shadow-2xs",
                    isSelected
                      ? "border-emerald-500 bg-emerald-50 dark:bg-emerald-950/50 text-emerald-700 dark:text-emerald-300 font-semibold ring-1 ring-emerald-500/30"
                      : "border-border/80 bg-background/80 text-muted-foreground hover:border-emerald-500 hover:text-foreground hover:bg-emerald-50/40"
                  )}
                >
                  <span className="truncate max-w-[120px]">{doc.name.replace("Dr. ", "")}</span>
                  <span className="opacity-60 text-[9px]">({doc.specialization})</span>
                </button>
              );
            })}
          </div>
        </div>
      </div>

      <div className="my-5 flex items-center gap-3 text-xs font-medium text-muted-foreground uppercase">
        <div className="h-px flex-1 bg-border" />
        <span>or sign in with email</span>
        <div className="h-px flex-1 bg-border" />
      </div>

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

      <form action={formAction} className="space-y-4" id="login-form">
        {nextPath ? <input type="hidden" id="login-next" name="next" value={nextPath} /> : null}
        <div className="space-y-1.5">
          <Label htmlFor="email" className="text-xs font-semibold">Email address</Label>
          <Input
            id="email"
            name="email"
            type="email"
            autoComplete="email"
            placeholder="you@example.com"
            required
            invalid={!!state.fieldErrors?.email}
            disabled={pending || isRedirecting}
            className="h-11 rounded-xl"
          />
          {state.fieldErrors?.email ? <p className="form-error">{state.fieldErrors.email}</p> : null}
        </div>
        <div className="space-y-1.5">
          <div className="flex items-center justify-between">
            <Label htmlFor="password" className="text-xs font-semibold">Password</Label>
            <Link
              href="/forgot-password"
              className="text-xs text-muted-foreground hover:text-foreground hover:underline"
            >
              Forgot password?
            </Link>
          </div>
          <Input
            id="password"
            name="password"
            type="password"
            autoComplete="current-password"
            placeholder="••••••••"
            required
            invalid={!!state.fieldErrors?.password}
            disabled={pending || isRedirecting}
            className="h-11 rounded-xl"
          />
          {state.fieldErrors?.password ? (
            <p className="form-error">{state.fieldErrors.password}</p>
          ) : null}
        </div>
        <Button
          type="submit"
          className="w-full h-11 rounded-xl font-semibold shadow-sm"
          loading={pending || isRedirecting}
          disabled={isRedirecting}
        >
          {isRedirecting ? "Signing in…" : "Sign in"}
        </Button>
      </form>

      <p className="mt-5 text-center text-xs sm:text-sm text-muted-foreground">
        New to Better Clinic?{" "}
        <Link href="/signup" className="font-semibold text-primary hover:underline">
          Create an account
        </Link>
      </p>
    </div>
  );
}
