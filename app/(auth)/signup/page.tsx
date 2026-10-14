import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";
import AuthSectionTwo from "@/components/ui/auth-section-2";

export const metadata: Metadata = { title: "Create account · Better Clinic" };
export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function SignUpPage() {
  const configured = isSupabaseConfigured();

  let specializations: { id: string; name: string }[] = [];
  let clinics: { id: string; name: string; city: string }[] = [];

  if (configured) {
    try {
      const supabase = await createClient();
      const [specResult, clinicResult] = await Promise.all([
        supabase.from("specializations").select("id, name").order("name"),
        supabase.from("clinics").select("id, name, city").eq("is_active", true).order("name").limit(100),
      ]);
      specializations = (specResult.data as typeof specializations) ?? [];
      clinics = (clinicResult.data as typeof clinics) ?? [];
    } catch {
      // Database unreachable — the form will show its own fallback states.
    }
  }

  return (
    <div>
      {!configured ? (
        <div className="p-4">
          <SetupNotice />
        </div>
      ) : null}
      <AuthSectionTwo
        specializations={specializations}
        clinics={clinics}
        disabled={!configured}
      />
    </div>
  );
}
