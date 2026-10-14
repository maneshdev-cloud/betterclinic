import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import { SetupNotice } from "@/components/shared/setup-notice";
import { isSupabaseConfigured } from "@/lib/env";
import AuthSectionTwo from "@/components/ui/auth-section-2";

export const metadata: Metadata = { title: "Create account · Better Clinic" };
export const dynamic = "force-dynamic";
export const revalidate = 0;

import { MOCK_SPECIALIZATIONS, MOCK_CLINICS } from "@/lib/mock-data";

export default async function SignUpPage() {
  const configured = isSupabaseConfigured();

  let specializations: { id: string; name: string }[] = MOCK_SPECIALIZATIONS;
  let clinics: { id: string; name: string; city: string }[] = MOCK_CLINICS;

  if (configured) {
    try {
      const supabase = await createClient();
      const [specResult, clinicResult] = await Promise.all([
        supabase.from("specializations").select("id, name").order("name"),
        supabase.from("clinics").select("id, name, city").eq("is_active", true).order("name").limit(100),
      ]);
      if (specResult.data && specResult.data.length > 0) {
        specializations = specResult.data as typeof specializations;
      }
      if (clinicResult.data && clinicResult.data.length > 0) {
        clinics = clinicResult.data as typeof clinics;
      }
    } catch {
      // Database unreachable — fallback arrays already assigned
    }
  }

  return (
    <div>
      <AuthSectionTwo
        specializations={specializations}
        clinics={clinics}
        disabled={false}
      />
    </div>
  );
}
