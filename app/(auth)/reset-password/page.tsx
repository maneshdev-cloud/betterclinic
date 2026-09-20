import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { ResetPasswordForm } from "./reset-password-form";
import { getSessionUser } from "@/services/auth/service";

export const metadata: Metadata = { title: "Set new password" };

export default async function ResetPasswordPage() {
  // The email link lands here with a recovery session; without one there
  // is nothing to update, so bounce to the request page.
  const user = await getSessionUser();
  if (!user) redirect("/forgot-password");

  return <ResetPasswordForm />;
}
