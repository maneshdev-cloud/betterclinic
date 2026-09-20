"use server";

import { cookies } from "next/headers";
import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { toAppError } from "@/lib/errors";
import { roleHomePath, type Role } from "@/lib/constants";

export interface AddRoleState {
  error?: string;
  fieldErrors?: Record<string, string>;
  redirectUrl?: string;
}

export async function addRoleAction(formData: FormData): Promise<AddRoleState> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { error: "You must be signed in to add another role." };
  }

  const role = formData.get("role") as Role;
  if (!role || !["PATIENT", "DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"].includes(role)) {
    return { error: "Please select a valid role to add." };
  }

  const metadata: Record<string, string> = {
    role,
  };

  if (role === "PATIENT") {
    const dob = formData.get("date_of_birth") as string;
    const sex = formData.get("sex") as string;
    const city = formData.get("city") as string;
    if (dob) metadata.date_of_birth = dob;
    if (sex) metadata.sex = sex;
    if (city) metadata.city = city;
  } else if (role === "DOCTOR") {
    const qualification = (formData.get("qualification") as string)?.trim() || "MBBS";
    const regNumber = (formData.get("registration_number") as string)?.trim();
    const expYears = (formData.get("experience_years") as string)?.trim() || "0";
    const fee = (formData.get("consultation_fee") as string)?.trim() || "500";
    const specId = formData.get("specialization_id") as string;
    const clinicId = formData.get("clinic_id") as string;
    const docInviteCode = (formData.get("doctor_invite_code") as string)?.trim();
    const about = (formData.get("about") as string)?.trim();

    if (!regNumber) {
      return { fieldErrors: { registration_number: "Registration number is required" } };
    }

    metadata.qualification = qualification;
    metadata.registration_number = regNumber;
    metadata.experience_years = expYears;
    metadata.consultation_fee = fee;
    if (specId) metadata.specialization_id = specId;
    if (about) metadata.about = about;

    if (clinicId) {
      metadata.clinic_id = clinicId;
      if (docInviteCode) {
        metadata.doctor_invite_code = docInviteCode;
      } else {
        return { fieldErrors: { doctor_invite_code: "Clinic doctor invite code is required to link" } };
      }
    }
  } else if (role === "RECEPTIONIST") {
    const clinicId = formData.get("clinic_id") as string;
    const staffCode = (formData.get("staff_invite_code") as string)?.trim();
    if (!clinicId) {
      return { fieldErrors: { clinic_id: "Please select a clinic" } };
    }
    if (!staffCode) {
      return { fieldErrors: { staff_invite_code: "Staff invite code is required" } };
    }
    metadata.clinic_id = clinicId;
    metadata.staff_invite_code = staffCode;
  } else if (role === "CLINIC_ADMIN") {
    const clinicId = formData.get("clinic_id") as string;
    const adminCode = (formData.get("clinic_admin_claim_code") as string)?.trim();
    if (!clinicId) {
      return { fieldErrors: { clinic_id: "Please select a clinic" } };
    }
    if (!adminCode) {
      return { fieldErrors: { clinic_admin_claim_code: "Admin claim code is required" } };
    }
    metadata.clinic_id = clinicId;
    metadata.clinic_admin_claim_code = adminCode;
  }

  try {
    const { error: rpcError } = await supabase.rpc("add_profile_role", {
      p_user_id: user.id,
      p_role: role,
      p_data: metadata,
    });

    if (rpcError) {
      return { error: toAppError(rpcError).userMessage };
    }

    const cookieStore = cookies();
    cookieStore.set("bc_active_role", role, { path: "/", maxAge: 60 * 60 * 24 * 30 });
    revalidatePath("/", "layout");

    return { redirectUrl: roleHomePath(role) };
  } catch (err) {
    return { error: toAppError(err).userMessage };
  }
}
