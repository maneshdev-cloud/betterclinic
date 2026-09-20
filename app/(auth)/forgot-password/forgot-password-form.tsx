"use client";

import Link from "next/link";
import { useFormState } from "react-dom";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AlertCircle, CheckCircle2 } from "lucide-react";
import { requestPasswordResetAction, type FormState } from "../actions";

const initialState: FormState = {};

export function ForgotPasswordForm() {
  const [state, formAction, pending] = useFormState(requestPasswordResetAction, initialState);

  return (
    <div className="rounded-lg border bg-card p-6 shadow-sm">
      <h1 className="text-lg font-semibold tracking-tight">Reset your password</h1>
      <p className="mt-1 text-sm text-muted-foreground">
        Enter the email you registered with and we&apos;ll send a reset link.
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
            disabled={pending}
          />
          {state.fieldErrors?.email ? (
            <p className="form-error">{state.fieldErrors.email}</p>
          ) : null}
        </div>
        <Button type="submit" className="w-full" loading={pending}>
          Send reset link
        </Button>
      </form>

      <p className="mt-4 text-center text-sm text-muted-foreground">
        <Link href="/login" className="font-medium text-primary hover:underline">
          ← Back to sign in
        </Link>
      </p>
    </div>
  );
}
