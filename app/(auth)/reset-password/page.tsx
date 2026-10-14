import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { Stethoscope } from "lucide-react";
import { ResetPasswordForm } from "./reset-password-form";
import { getSessionUser } from "@/services/auth/service";

export const metadata: Metadata = { title: "Set new password · Better Clinic" };

export default async function ResetPasswordPage() {
  const user = await getSessionUser();
  if (!user) redirect("/forgot-password");

  return (
    <div className="flex min-h-screen flex-col items-center justify-center p-4 sm:p-8">
      <div className="w-full max-w-md space-y-6">
        <Link href="/" className="flex items-center justify-center gap-2.5 mb-2 group">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm">
            <Stethoscope className="h-5 w-5" aria-hidden />
          </div>
          <span className="text-lg font-bold tracking-tight">Better Clinic</span>
        </Link>
        <ResetPasswordForm />
      </div>
    </div>
  );
}
