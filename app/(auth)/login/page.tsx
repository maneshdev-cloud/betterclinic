import type { Metadata } from "next";
import { LoginForm } from "./login-form";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";

export const metadata: Metadata = { title: "Sign in" };
export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function LoginPage({
  searchParams,
}: {
  searchParams: { next?: string };
}) {
  const configured = isSupabaseConfigured();

  return (
    <div className="space-y-6">
      {!configured ? <SetupNotice /> : null}
      <LoginForm nextPath={searchParams.next ?? null} disabled={!configured} />
    </div>
  );
}
