"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { createClient } from "@/lib/supabase/server";
import { toAppError } from "@/lib/errors";
import { profileUpdateSchema } from "@/lib/validation/auth";
import type { FormState } from "@/app/(auth)/actions";

/**
 * Set the signed-in user's avatar to a file they uploaded themselves.
 * Only URLs inside this project's public "avatars" storage bucket are
 * accepted (or empty to remove) — profiles.avatar_url can never point
 * at an arbitrary host.
 */
export async function setAvatarUrlAction(avatarUrl: string): Promise<{ ok: boolean; error?: string }> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { ok: false, error: "Please sign in again." };

  const parsed = z
    .string()
    .refine((value) => value === "" || /^https?:\/\/.+/ .test(value), "Invalid avatar URL")
    .safeParse(avatarUrl ?? "");
  if (!parsed.success) return { ok: false, error: "Invalid avatar URL." };

  const bucketPrefix = `/storage/v1/object/public/avatars/`;
  if (parsed.data !== "") {
    const expectedOrigin = new URL(
      process.env.NEXT_PUBLIC_SUPABASE_URL ?? "http://localhost"
    ).origin;
    let url: URL;
    try {
      url = new URL(parsed.data);
    } catch {
      return { ok: false, error: "Invalid avatar URL." };
    }
    if (url.origin !== expectedOrigin || !url.pathname.startsWith(bucketPrefix)) {
      return { ok: false, error: "Avatar must come from this app's storage bucket." };
    }
  }

  const { error } = await supabase
    .from("profiles")
    .update({ avatar_url: parsed.data || null })
    .eq("id", user.id);
  if (error) return { ok: false, error: toAppError(error).userMessage };

  revalidatePath("/", "layout");
  return { ok: true };
}

/**
 * Update the signed-in user's own profile (name, phone) and, for
 * patients, their demographic details. RLS only allows touching
 * your own rows.
 */
export async function updateProfileAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { error: "Please sign in again." };

  const parsed = profileUpdateSchema.safeParse({
    full_name: formData.get("full_name"),
    phone: formData.get("phone"),
  });
  if (!parsed.success) {
    const flat = parsed.error.flatten().fieldErrors;
    return {
      fieldErrors: Object.fromEntries(
        Object.entries(flat).map(([k, v]) => [k, v?.[0] ?? "Invalid value"])
      ),
    };
  }

  try {
    const { error: profileError } = await supabase
      .from("profiles")
      .update({ full_name: parsed.data.full_name, phone: parsed.data.phone })
      .eq("id", user.id);
    if (profileError) throw profileError;

    // Patient demographics (best-effort — only patients have this row)
    const { data: roleData } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();

    if (roleData?.role === "PATIENT") {
      const dob = formData.get("date_of_birth");
      const sex = formData.get("sex");
      const bloodGroup = formData.get("blood_group");
      const city = formData.get("city");
      const area = formData.get("area");
      const addressLine = formData.get("address_line");
      const emergencyName = formData.get("emergency_contact_name");
      const emergencyPhone = formData.get("emergency_contact_phone");

      const { error: patientError } = await supabase
        .from("patients")
        .update({
          ...(dob ? { date_of_birth: String(dob) } : {}),
          ...(sex ? { sex: sex as "MALE" | "FEMALE" | "OTHER" } : {}),
          ...(bloodGroup ? { blood_group: String(bloodGroup) } : {}),
          ...(city ? { city: String(city) } : {}),
          ...(area ? { area: String(area) } : {}),
          ...(addressLine ? { address_line: String(addressLine) } : {}),
          ...(emergencyName ? { emergency_contact_name: String(emergencyName) } : {}),
          ...(emergencyPhone ? { emergency_contact_phone: String(emergencyPhone) } : {}),
        })
        .eq("id", user.id);
      if (patientError) throw patientError;
    }

    revalidatePath("/", "layout");
    return { success: "Profile updated." };
  } catch (err) {
    return { error: toAppError(err).userMessage };
  }
}
