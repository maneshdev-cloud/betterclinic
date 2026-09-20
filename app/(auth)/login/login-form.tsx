"use client";

import Link from "next/link";
import { useEffect } from "react";
import { useFormState } from "react-dom";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AlertCircle, CheckCircle2, Loader2 } from "lucide-react";
import { signInAction, type FormState } from "../actions";

const initialState: FormState = {};

export function LoginForm({ nextPath, disabled }: { nextPath: string | null; disabled: boolean }) {
  const [state, formAction, pending] = useFormState(signInAction, initialState);
  const isRedirecting = Boolean(state.redirectUrl);

  useEffect(() => {
    if (state.redirectUrl) {
      window.location.replace(state.redirectUrl);
    }
  }, [state.redirectUrl]);

  return (
    <div className="rounded-lg border bg-card p-6 shadow-sm">
      <h1 className="text-lg font-semibold tracking-tight">Sign in</h1>
      <p className="mt-1 text-sm text-muted-foreground">
        Welcome back. Enter your credentials to continue.
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

      <form action={formAction} className="mt-5 space-y-4">
        {nextPath ? <input type="hidden" name="next" value={nextPath} /> : null}
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
            disabled={disabled || pending}
          />
          {state.fieldErrors?.email ? <p className="form-error">{state.fieldErrors.email}</p> : null}
        </div>
        <div className="space-y-1.5">
          <div className="flex items-center justify-between">
            <Label htmlFor="password">Password</Label>
            <Link
              href="/forgot-password"
              className="text-xs text-muted-foreground hover:text-foreground"
            >
              Forgot password?
            </Link>
          </div>
          <Input
            id="password"
            name="password"
            type="password"
            autoComplete="current-password"
            required
            invalid={!!state.fieldErrors?.password}
            disabled={disabled || pending}
          />
          {state.fieldErrors?.password ? (
            <p className="form-error">{state.fieldErrors.password}</p>
          ) : null}
        </div>
        <Button type="submit" className="w-full" loading={pending || isRedirecting} disabled={disabled || isRedirecting}>
          {isRedirecting ? "Signing in…" : "Sign in"}
        </Button>
      </form>

      <p className="mt-4 text-center text-sm text-muted-foreground">
        New to Better Clinic?{" "}
        <Link href="/signup" replace className="font-medium text-primary hover:underline">
          Create an account
        </Link>
      </p>
    </div>
  );
}
