"use client";

import Link from "next/link";
import { useFormState } from "react-dom";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AlertCircle, CheckCircle2 } from "lucide-react";
import { updatePasswordAction, type FormState } from "../actions";

const initialState: FormState = {};

export function ResetPasswordForm() {
  const [state, formAction, pending] = useFormState(updatePasswordAction, initialState);

  return (
    <div className="rounded-lg border bg-card p-6 shadow-sm">
      <h1 className="text-lg font-semibold tracking-tight">Set a new password</h1>
      <p className="mt-1 text-sm text-muted-foreground">
        Choose a strong password for your account.
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
          <Label htmlFor="password">New password</Label>
          <Input
            id="password"
            name="password"
            type="password"
            autoComplete="new-password"
            placeholder="Min 8 characters, letters + numbers"
            required
            invalid={!!state.fieldErrors?.password}
            disabled={pending}
          />
          {state.fieldErrors?.password ? (
            <p className="form-error">{state.fieldErrors.password}</p>
          ) : null}
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="confirmPassword">Confirm new password</Label>
          <Input
            id="confirmPassword"
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
        <Button type="submit" className="w-full" loading={pending}>
          Update password
        </Button>
      </form>

      <p className="mt-4 text-center text-sm text-muted-foreground">
        <Link href="/" className="font-medium text-primary hover:underline">
          Continue to the app →
        </Link>
      </p>
    </div>
  );
}
