"use client";

import Link from "next/link";
import { useEffect, useState, useTransition } from "react";
import { useFormState } from "react-dom";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useRouter } from "next/navigation";
import { AlertCircle, CheckCircle2, Sparkles, User, Stethoscope, Users, Building2, Loader2 } from "lucide-react";
import { signInAction, quickDemoLoginAction, type FormState } from "../actions";
import type { Role } from "@/lib/constants";

const initialState: FormState = {};

export function LoginForm({ nextPath, disabled = false }: { nextPath: string | null; disabled?: boolean }) {
  const router = useRouter();
  const [state, formAction, pending] = useFormState(signInAction, initialState);
  const [demoPendingRole, setDemoPendingRole] = useState<Role | null>(null);
  const [isPending, startTransition] = useTransition();

  const isRedirecting = Boolean(state.redirectUrl) || Boolean(demoPendingRole);

  useEffect(() => {
    if (state.redirectUrl) {
      router.replace(state.redirectUrl);
      router.refresh();
    }
  }, [state.redirectUrl, router]);

  const handleQuickDemo = (role: Role) => {
    setDemoPendingRole(role);
    startTransition(async () => {
      try {
        const res = await quickDemoLoginAction(role);
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
      <div className="mt-5 rounded-xl border border-primary/20 bg-primary/5 p-3.5">
        <p className="text-xs font-semibold text-primary flex items-center gap-1.5 mb-2.5">
          <span>⚡ Instant 1-Click Role Access:</span>
        </p>
        <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => handleQuickDemo("PATIENT")}
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
            onClick={() => handleQuickDemo("DOCTOR")}
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
