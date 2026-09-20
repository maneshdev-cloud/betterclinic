"use server";

import { revalidatePath } from "next/cache";
import { headers } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import { toAppError } from "@/lib/errors";

export interface LinkClinicResult {
  success: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
  clinic?: {
    id: string;
    name: string;
    city: string;
    area: string;
  };
}

/** Link doctor to an existing clinic using the clinic's doctor invite code. */
export async function linkDoctorToExistingClinicAction(
  clinicId: string,
  doctorInviteCode: string
): Promise<LinkClinicResult> {
  const trimmedClinicId = clinicId?.trim();
  const trimmedCode = doctorInviteCode?.trim();

  if (!trimmedClinicId) {
    return { success: false, fieldErrors: { clinic_id: "Please select a clinic to link" } };
  }
  if (!trimmedCode) {
    return { success: false, fieldErrors: { doctor_invite_code: "Doctor invite code is required" } };
  }

  try {
    const supabase = await createClient();
    const { error } = await supabase.rpc("link_doctor_to_clinic", {
      p_clinic_id: trimmedClinicId,
      p_doctor_code: trimmedCode,
    });

    if (error) {
      return { success: false, error: toAppError(error).userMessage };
    }

    revalidatePath("/doctor");
    revalidatePath("/doctor/settings");
    return { success: true };
  } catch (err) {
    return { success: false, error: toAppError(err).userMessage };
  }
}

/** Register a new clinic with deduplication check and link doctor to it. */
export async function registerAndLinkClinicAction(formData: {
  name: string;
  city: string;
  area: string;
  address_line: string;
}): Promise<LinkClinicResult> {
  const { createClinicSchema } = await import("@/lib/validation/auth");
  const parsed = createClinicSchema.safeParse(formData);
  if (!parsed.success) {
    return {
      success: false,
      error: parsed.error.issues[0]?.message ?? "Invalid clinic details",
    };
  }

  try {
    const head = headers();
    const clientIp = head.get("cf-connecting-ip") ?? head.get("x-forwarded-for")?.split(",")[0]?.trim() ?? head.get("x-real-ip") ?? undefined;
    const supabase = await createClient({ clientIp });

    // 1. Create clinic with invites
    const { data: clinicData, error: createError } = await supabase.rpc(
      "create_clinic_with_invite",
      {
        p_name: parsed.data.name,
        p_city: parsed.data.city,
        p_area: parsed.data.area,
        p_address_line: parsed.data.address_line,
      }
    );

    if (createError) {
      return { success: false, error: toAppError(createError).userMessage };
    }

    const created = clinicData as {
      id: string;
      name: string;
      city: string;
      area: string;
      doctor_invite_code: string;
    };

    // 2. Link doctor to the newly created clinic
    const { error: linkError } = await supabase.rpc("link_doctor_to_clinic", {
      p_clinic_id: created.id,
      p_doctor_code: created.doctor_invite_code,
    });

    if (linkError) {
      return { success: false, error: toAppError(linkError).userMessage };
    }

    revalidatePath("/doctor");
    revalidatePath("/doctor/settings");
    return {
      success: true,
      clinic: {
        id: created.id,
        name: created.name,
        city: created.city,
        area: created.area,
      },
    };
  } catch (err) {
    return { success: false, error: toAppError(err).userMessage };
  }
}
