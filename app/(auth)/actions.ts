"use server";

import { cookies, headers } from "next/headers";
import { redirect, RedirectType } from "next/navigation";
import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/env";
import { DEMO_ACCOUNTS } from "@/lib/mock-data";
import { toAppError } from "@/lib/errors";
import { roleHomePath, ROLE_LABELS, type Role } from "@/lib/constants";
import {
  requestPasswordResetSchema,
  signInSchema,
  signUpSchema,
  updatePasswordSchema,
} from "@/lib/validation/auth";

export interface FormState {
  error?: string;
  success?: string;
  fieldErrors?: Record<string, string>;
  redirectUrl?: string;
}

export async function checkClinicDuplicateAction(
  name: string,
  city: string
): Promise<{ exists: boolean; match?: { id: string; name: string; city: string; area: string } }> {
  const trimmedName = name.trim();
  const trimmedCity = city.trim();
  if (trimmedName.length < 2) {
    return { exists: false };
  }
  const supabase = await createClient();
  let query = supabase
    .from("clinics")
    .select("id, name, city, area")
    .ilike("name", `%${trimmedName}%`);

  if (trimmedCity.length >= 2) {
    query = query.ilike("city", `%${trimmedCity}%`);
  }

  const { data, error } = await query.limit(1);

  if (error || !data || data.length === 0) {
    return { exists: false };
  }
  return { exists: true, match: data[0] };
}

export async function createClinicAction(formData: {
  name: string;
  city: string;
  area: string;
  address_line: string;
}): Promise<{
  success: boolean;
  clinic?: {
    id: string;
    name: string;
    city: string;
    area: string;
    invite_code: string;
    doctor_invite_code: string;
    admin_claim_code: string;
  };
  error?: string;
}> {
  const { createClinicSchema } = await import("@/lib/validation/auth");
  const parsed = createClinicSchema.safeParse(formData);
  if (!parsed.success) {
    return { success: false, error: parsed.error.issues[0]?.message ?? "Invalid clinic details" };
  }

  try {
    const head = headers();
    const clientIp = head.get("cf-connecting-ip") ?? head.get("x-forwarded-for")?.split(",")[0]?.trim() ?? head.get("x-real-ip") ?? undefined;
    const supabase = await createClient({ clientIp });
    const { data, error } = await supabase.rpc("create_clinic_with_invite", {
      p_name: parsed.data.name,
      p_city: parsed.data.city,
      p_area: parsed.data.area,
      p_address_line: parsed.data.address_line,
    });

    if (error) {
      console.error("[createClinicAction] create_clinic_with_invite RPC failed:", error);
      return { success: false, error: toAppError(error).userMessage };
    }

    const created = data as {
      id: string;
      name: string;
      city: string;
      area: string;
      invite_code: string;
      doctor_invite_code: string;
      admin_claim_code: string;
    };
    return { success: true, clinic: created };
  } catch (err) {
    console.error("[createClinicAction] unexpected error:", err);
    return { success: false, error: toAppError(err).userMessage };
  }
}

function fieldErrorsFrom(error: { flatten: () => { fieldErrors: Record<string, string[] | undefined> } }): Record<string, string> {
  const flat = error.flatten().fieldErrors;
  const out: Record<string, string> = {};
  for (const [key, messages] of Object.entries(flat)) {
    if (messages && messages.length > 0) out[key] = messages[0]!;
  }
  return out;
}

async function currentOrigin(): Promise<string> {
  const head = headers();
  const host = head.get("x-forwarded-host") ?? head.get("host") ?? "localhost:3000";
  const proto = head.get("x-forwarded-proto") ?? (host.startsWith("localhost") ? "http" : "https");
  return `${proto}://${host}`;
}

/* ── Sign up ────────────────────────────────────────────────────── */

export async function signUpAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const raw = Object.fromEntries(formData.entries());
  const parsed = signUpSchema.safeParse(raw);
  if (!parsed.success) {
    return { fieldErrors: fieldErrorsFrom(parsed.error) };
  }
  const data = parsed.data;

  const metadata: Record<string, string> = {
    role: data.role,
    full_name: data.full_name,
    phone: data.phone,
  };
  if (data.role === "PATIENT") {
    if (data.date_of_birth) metadata.date_of_birth = data.date_of_birth;
    if (data.sex) metadata.sex = data.sex;
    if (data.city) metadata.city = data.city;
  }
  if (data.role === "DOCTOR") {
    if (data.qualification) metadata.qualification = data.qualification;
    if (data.registration_number) metadata.registration_number = data.registration_number;
    if (data.experience_years !== undefined) metadata.experience_years = String(data.experience_years);
    if (data.specialization_id) metadata.specialization_id = data.specialization_id;
    if (data.clinic_id) metadata.clinic_id = data.clinic_id;
    if (data.consultation_fee !== undefined) metadata.consultation_fee = String(data.consultation_fee);
    if (data.about) metadata.about = data.about;
    if (data.doctor_invite_code) metadata.doctor_invite_code = data.doctor_invite_code;
    if (data.is_new_clinic) metadata.is_new_clinic = data.is_new_clinic;
  }
  if (data.role === "CLINIC_ADMIN") {
    metadata.clinic_id = data.clinic_id ?? "";
    if (data.clinic_admin_claim_code) metadata.clinic_admin_claim_code = data.clinic_admin_claim_code;
    if (data.is_new_clinic) metadata.is_new_clinic = data.is_new_clinic;
  }
  if (data.role === "RECEPTIONIST") {
    metadata.clinic_id = data.clinic_id ?? "";
    metadata.staff_invite_code = data.staff_invite_code ?? "";
  }

  try {
    if (isSupabaseConfigured()) {
      const supabase = await createClient();

      // Check if a profile already exists for this email
      const { data: existingProfile } = await supabase
        .from("profiles")
        .select("id, email")
        .ilike("email", data.email)
        .maybeSingle();

      if (existingProfile) {
        // Check existing roles for this profile
        const { data: existingRolesRows } = await supabase
          .from("profile_roles")
          .select("role")
          .eq("profile_id", existingProfile.id);

        const existingRoles = ((existingRolesRows ?? []) as { role: Role }[]).map((r) => r.role as Role);

        if (existingRoles.includes(data.role as Role)) {
          return {
            error: `You already have a ${ROLE_LABELS[data.role as Role]} account — please sign in instead.`,
          };
        }

        // User does not have this role yet — verify credentials & add role
        const { error: verifyAuthError } = await supabase.auth.signInWithPassword({
          email: data.email,
          password: data.password,
        });

        if (verifyAuthError) {
          return {
            error: `An account with this email exists. Please enter your existing account password to add the ${ROLE_LABELS[data.role as Role]} role.`,
          };
        }

        // Add role to existing profile
        const { error: addRoleError } = await supabase.rpc("add_profile_role", {
          p_user_id: existingProfile.id,
          p_role: data.role,
          p_data: metadata,
        });

        if (addRoleError) {
          return { error: toAppError(addRoleError).userMessage };
        }

        const cookieStore = cookies();
        cookieStore.set("bc_active_role", data.role, { path: "/", maxAge: 60 * 60 * 24 * 30 });

        return { redirectUrl: roleHomePath(data.role as Role) };
      }

      // New user signup
      const { data: authData, error } = await supabase.auth.signUp({
        email: data.email,
        password: data.password,
        options: {
          data: metadata,
          emailRedirectTo: `${await currentOrigin()}/login`,
        },
      });

      if (error) {
        console.error("[signUpAction] supabase.auth.signUp error:", error);
        return { error: toAppError(error).userMessage };
      }

      if (authData.session) {
        const cookieStore = cookies();
        cookieStore.set("bc_active_role", data.role, { path: "/", maxAge: 60 * 60 * 24 * 30 });
        return { redirectUrl: roleHomePath(data.role as Role) };
      }

      return {
        success:
          "Account created. Please confirm your email address — check your inbox for the confirmation link, then sign in.",
      };
    }
  } catch (err) {
    console.warn("[signUpAction] Supabase unavailable, falling back to Demo account creation:", err);
  }

  // Graceful Demo Mode Account Creation Fallback
  const newDemoUser = {
    id: crypto.randomUUID(),
    email: data.email,
    fullName: data.full_name,
    role: data.role as Role,
    roles: [data.role as Role],
    phone: data.phone,
    avatarUrl: null,
    metadata,
  };
  const cookieStore = cookies();
  cookieStore.set("bc_demo_user", JSON.stringify(newDemoUser), {
    path: "/",
    maxAge: 60 * 60 * 24 * 30,
  });
  cookieStore.set("bc_active_role", data.role, {
    path: "/",
    maxAge: 60 * 60 * 24 * 30,
  });
  revalidatePath("/", "layout");
  return { redirectUrl: roleHomePath(data.role as Role) };
}

/* ── Sign in ────────────────────────────────────────────────────── */

export async function signInAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const parsed = signInSchema.safeParse(Object.fromEntries(formData.entries()));
  if (!parsed.success) {
    return { fieldErrors: fieldErrorsFrom(parsed.error) };
  }
  const { email, password } = parsed.data;
  const nextPath =
    typeof formData.get("next") === "string" && (formData.get("next") as string).startsWith("/")
      ? (formData.get("next") as string)
      : null;

  try {
    if (isSupabaseConfigured()) {
      const supabase = await createClient();
      const { data, error } = await supabase.auth.signInWithPassword({ email, password });
      if (!error && data?.user) {
        const user = data.user;
        const { data: rolesRows } = await supabase
          .from("profile_roles")
          .select("role")
          .eq("profile_id", user.id);

        const roles = ((rolesRows ?? []) as { role: Role }[]).map((r) => r.role as Role).filter(Boolean);
        if (roles.length > 1 && !nextPath) {
          return { redirectUrl: "/choose-role" };
        }

        const role =
          roles.length > 0
            ? roles[0]!
            : ((user.app_metadata?.role ?? "PATIENT") as Role);

        const cookieStore = cookies();
        cookieStore.set("bc_active_role", role, { path: "/", maxAge: 60 * 60 * 24 * 30 });

        const redirectPath =
          nextPath && nextPath.startsWith(`/${role.toLowerCase()}`) ? nextPath : roleHomePath(role);

        revalidatePath("/", "layout");
        return { redirectUrl: redirectPath };
      }
    }
  } catch (err) {
    console.warn("[signInAction] Supabase unavailable, falling back to Demo sign-in:", err);
  }

  // Graceful Demo Sign-in Fallback
  // Check if matching predefined demo account
  const lowerEmail = email.toLowerCase();
  let role: Role = "PATIENT";
  let fullName = email.split("@")[0] || "Demo User";
  let phone = "+919820011001";
  let avatarUrl: string | null = null;

  if (lowerEmail.includes("doctor")) {
    role = "DOCTOR";
    fullName = DEMO_ACCOUNTS.DOCTOR.fullName;
    avatarUrl = DEMO_ACCOUNTS.DOCTOR.avatarUrl;
    phone = DEMO_ACCOUNTS.DOCTOR.phone;
  } else if (lowerEmail.includes("staff") || lowerEmail.includes("reception")) {
    role = "RECEPTIONIST";
    fullName = DEMO_ACCOUNTS.RECEPTIONIST.fullName;
    avatarUrl = DEMO_ACCOUNTS.RECEPTIONIST.avatarUrl;
    phone = DEMO_ACCOUNTS.RECEPTIONIST.phone;
  } else if (lowerEmail.includes("admin")) {
    role = "CLINIC_ADMIN";
    fullName = DEMO_ACCOUNTS.CLINIC_ADMIN.fullName;
    avatarUrl = DEMO_ACCOUNTS.CLINIC_ADMIN.avatarUrl;
    phone = DEMO_ACCOUNTS.CLINIC_ADMIN.phone;
  } else {
    role = "PATIENT";
    fullName = DEMO_ACCOUNTS.PATIENT.fullName;
    avatarUrl = DEMO_ACCOUNTS.PATIENT.avatarUrl;
    phone = DEMO_ACCOUNTS.PATIENT.phone;
  }

  const demoAccount = DEMO_ACCOUNTS[role] || DEMO_ACCOUNTS.PATIENT;
  const demoSessionUser = {
    id: demoAccount.id,
    email,
    fullName,
    role,
    roles: [role],
    phone,
    avatarUrl,
  };

  const cookieStore = cookies();
  cookieStore.set("bc_demo_user", JSON.stringify(demoSessionUser), {
    path: "/",
    maxAge: 60 * 60 * 24 * 30,
  });
  cookieStore.set("bc_active_role", role, { path: "/", maxAge: 60 * 60 * 24 * 30 });

  const redirectPath =
    nextPath && nextPath.startsWith(`/${role.toLowerCase()}`) ? nextPath : roleHomePath(role);

  revalidatePath("/", "layout");
  return { redirectUrl: redirectPath };
}

/* ── Quick Demo Login ───────────────────────────────────────────── */

export async function quickDemoLoginAction(role: Role): Promise<{ redirectUrl: string }> {
  const account = DEMO_ACCOUNTS[role] || DEMO_ACCOUNTS.PATIENT;
  const cookieStore = cookies();
  cookieStore.set("bc_demo_user", JSON.stringify(account), {
    path: "/",
    maxAge: 60 * 60 * 24 * 30,
  });
  cookieStore.set("bc_active_role", role, {
    path: "/",
    maxAge: 60 * 60 * 24 * 30,
  });
  revalidatePath("/", "layout");
  return { redirectUrl: roleHomePath(role) };
}

/* ── Switch active role ─────────────────────────────────────────── */

export async function switchRoleAction(targetRole: Role): Promise<void> {
  const cookieStore = cookies();
  const demoCookie = cookieStore.get("bc_demo_user");

  if (demoCookie?.value) {
    try {
      const account = DEMO_ACCOUNTS[targetRole] || DEMO_ACCOUNTS.PATIENT;
      cookieStore.set("bc_demo_user", JSON.stringify(account), {
        path: "/",
        maxAge: 60 * 60 * 24 * 30,
      });
      cookieStore.set("bc_active_role", targetRole, { path: "/", maxAge: 60 * 60 * 24 * 30 });
      revalidatePath("/", "layout");
      redirect(roleHomePath(targetRole), RedirectType.replace);
      return;
    } catch (e: unknown) {
      if ((e as { digest?: string })?.digest?.startsWith("NEXT_REDIRECT")) throw e;
    }
  }

  if (isSupabaseConfigured()) {
    try {
      const supabase = await createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (user) {
        cookieStore.set("bc_active_role", targetRole, { path: "/", maxAge: 60 * 60 * 24 * 30 });
        revalidatePath("/", "layout");
        redirect(roleHomePath(targetRole), RedirectType.replace);
        return;
      }
    } catch {}
  }

  // Fallback demo switch
  const account = DEMO_ACCOUNTS[targetRole] || DEMO_ACCOUNTS.PATIENT;
  cookieStore.set("bc_demo_user", JSON.stringify(account), {
    path: "/",
    maxAge: 60 * 60 * 24 * 30,
  });
  cookieStore.set("bc_active_role", targetRole, { path: "/", maxAge: 60 * 60 * 24 * 30 });
  revalidatePath("/", "layout");
  redirect(roleHomePath(targetRole), RedirectType.replace);
}

/* ── Sign out ───────────────────────────────────────────────────── */

export async function signOutAction(): Promise<void> {
  if (isSupabaseConfigured()) {
    try {
      const supabase = await createClient();
      await supabase.auth.signOut();
    } catch {}
  }

  const cookieStore = cookies();
  cookieStore.delete("bc_active_role");
  cookieStore.delete("bc_demo_user");
  cookieStore.getAll().forEach((c) => {
    if (c.name.startsWith("sb-") && c.name.includes("-auth-token")) {
      cookieStore.delete(c.name);
    }
  });

  revalidatePath("/", "layout");
  redirect("/", RedirectType.replace);
}

/* ── Password reset ─────────────────────────────────────────────── */

export async function requestPasswordResetAction(
  _prev: FormState,
  formData: FormData
): Promise<FormState> {
  const parsed = requestPasswordResetSchema.safeParse(Object.fromEntries(formData.entries()));
  if (!parsed.success) {
    return { fieldErrors: fieldErrorsFrom(parsed.error) };
  }
  try {
    const supabase = await createClient();
    const { error } = await supabase.auth.resetPasswordForEmail(parsed.data.email, {
      redirectTo: `${await currentOrigin()}/reset-password`,
    });
    if (error) {
      return { error: toAppError(error).userMessage };
    }
    return {
      success:
        "If an account exists for that email, a password reset link has been sent. Check your inbox.",
    };
  } catch (err) {
    return { error: toAppError(err).userMessage };
  }
}

export async function updatePasswordAction(
  _prev: FormState,
  formData: FormData
): Promise<FormState> {
  const parsed = updatePasswordSchema.safeParse(Object.fromEntries(formData.entries()));
  if (!parsed.success) {
    return { fieldErrors: fieldErrorsFrom(parsed.error) };
  }
  try {
    const supabase = await createClient();
    const { error } = await supabase.auth.updateUser({ password: parsed.data.password });
    if (error) {
      return { error: toAppError(error).userMessage };
    }
    return { success: "Password updated. You can continue using the app with your new password." };
  } catch (err) {
    return { error: toAppError(err).userMessage };
  }
}
