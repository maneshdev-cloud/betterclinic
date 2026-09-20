import { z } from "zod";

/* ── Primitives ────────────────────────────────────────────────── */

export const emailSchema = z
  .string()
  .trim()
  .min(1, "Email is required")
  .email("Enter a valid email address")
  .transform((v) => v.toLowerCase());

/** Indian mobile numbers: optional +91, 10 digits starting 6-9. */
export const phoneSchema = z
  .string()
  .trim()
  .min(1, "Phone number is required")
  .regex(/^(\+91[\s-]?)?[6-9]\d{9}$/, "Enter a valid 10-digit Indian mobile number")
  .transform((v) => v.replace(/[\s-]/g, ""));

export const passwordSchema = z
  .string()
  .min(8, "Password must be at least 8 characters")
  .max(72, "Password is too long")
  .regex(/[a-zA-Z]/, "Password must contain a letter")
  .regex(/[0-9]/, "Password must contain a number");

export const fullNameSchema = z
  .string()
  .trim()
  .min(2, "Enter your full name")
  .max(80, "Name is too long");

export const uuidSchema = z.string().uuid("Select a valid option");

/* ── Auth ──────────────────────────────────────────────────────── */

export const signInSchema = z.object({
  email: emailSchema,
  password: z.string().min(1, "Enter your password"),
});
export type SignInInput = z.infer<typeof signInSchema>;

const patientFields = z.object({
  date_of_birth: z
    .string()
    .optional()
    .refine((v) => !v || /^\d{4}-\d{2}-\d{2}$/.test(v), "Enter a valid date"),
  sex: z.enum(["MALE", "FEMALE", "OTHER"]).optional().or(z.literal("")).transform((v) => (v === "" ? undefined : v)),
  city: z.string().trim().max(60).optional(),
});

const doctorFields = z.object({
  qualification: z
    .string()
    .trim()
    .min(2, "Enter your qualification (e.g. MBBS, MD)")
    .max(120),
  registration_number: z
    .string()
    .trim()
    .min(3, "Enter your medical registration number")
    .max(40),
  experience_years: z.coerce
    .number()
    .int("Experience must be a whole number")
    .min(0, "Experience cannot be negative")
    .max(60, "Experience looks too high"),
  specialization_id: uuidSchema,
  clinic_id: uuidSchema.optional().or(z.literal("")),
  consultation_fee: z.coerce
    .number()
    .int("Fee must be a whole number")
    .min(0, "Fee cannot be negative")
    .max(20000, "Fee looks too high")
    .optional(),
  about: z.string().trim().max(600).optional(),
  doctor_invite_code: z.string().trim().optional(),
  is_new_clinic: z.string().optional(),
});

const receptionistFields = z.object({
  clinic_id: uuidSchema,
  staff_invite_code: z
    .string()
    .trim()
    .min(4, "Enter the clinic's staff invite code")
    .max(24),
});

const clinicAdminFields = z.object({
  clinic_id: uuidSchema,
  clinic_admin_claim_code: z.string().trim().optional(),
  is_new_clinic: z.string().optional(),
});

export const createClinicSchema = z.object({
  name: z.string().trim().min(3, "Clinic name must be at least 3 characters").max(100),
  city: z.string().trim().min(2, "City is required").max(60),
  area: z.string().trim().min(2, "Area / locality is required").max(100),
  address_line: z.string().trim().min(3, "Address is required").max(255),
});
export type CreateClinicInput = z.infer<typeof createClinicSchema>;

export const signUpSchema = z
  .object({
    role: z.enum(["PATIENT", "DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"]),
    full_name: fullNameSchema,
    email: emailSchema,
    phone: phoneSchema,
    password: passwordSchema,
    // role-specific (validated per role below)
    date_of_birth: z.string().optional(),
    sex: z.enum(["MALE", "FEMALE", "OTHER"]).optional().or(z.literal("")).transform((v) => (v === "" ? undefined : v)),
    city: z.string().optional(),
    qualification: z.string().optional(),
    registration_number: z.string().optional(),
    experience_years: z.coerce.number().optional(),
    specialization_id: z.string().optional(),
    clinic_id: z.string().optional(),
    consultation_fee: z.coerce.number().optional(),
    about: z.string().optional(),
    staff_invite_code: z.string().optional(),
    doctor_invite_code: z.string().optional(),
    clinic_admin_claim_code: z.string().optional(),
    is_new_clinic: z.string().optional(),
  })
  .superRefine((data, ctx) => {
    if (data.role === "DOCTOR") {
      const result = doctorFields.safeParse({
        qualification: data.qualification,
        registration_number: data.registration_number,
        experience_years: data.experience_years,
        specialization_id: data.specialization_id,
        clinic_id: data.clinic_id,
        consultation_fee: data.consultation_fee,
        about: data.about,
        doctor_invite_code: data.doctor_invite_code,
        is_new_clinic: data.is_new_clinic,
      });
      if (!result.success) {
        for (const issue of result.error.issues) {
          ctx.addIssue({ code: z.ZodIssueCode.custom, path: [issue.path[0] ?? "form"], message: issue.message });
        }
      }
      if (
        data.clinic_id &&
        data.clinic_id.trim() !== "" &&
        data.is_new_clinic !== "true" &&
        (!data.doctor_invite_code || data.doctor_invite_code.trim().length < 4)
      ) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["doctor_invite_code"],
          message: "Enter the clinic's doctor invite code to join this clinic",
        });
      }
    }
    if (data.role === "RECEPTIONIST") {
      const result = receptionistFields.safeParse({
        clinic_id: data.clinic_id,
        staff_invite_code: data.staff_invite_code,
      });
      if (!result.success) {
        for (const issue of result.error.issues) {
          ctx.addIssue({ code: z.ZodIssueCode.custom, path: [issue.path[0] ?? "form"], message: issue.message });
        }
      }
    }
    if (data.role === "CLINIC_ADMIN") {
      const result = clinicAdminFields.safeParse({
        clinic_id: data.clinic_id,
        clinic_admin_claim_code: data.clinic_admin_claim_code,
        is_new_clinic: data.is_new_clinic,
      });
      if (!result.success) {
        for (const issue of result.error.issues) {
          ctx.addIssue({ code: z.ZodIssueCode.custom, path: [issue.path[0] ?? "form"], message: issue.message });
        }
      }
      if (
        data.clinic_id &&
        data.clinic_id.trim() !== "" &&
        data.is_new_clinic !== "true" &&
        (!data.clinic_admin_claim_code || data.clinic_admin_claim_code.trim().length < 4)
      ) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["clinic_admin_claim_code"],
          message: "Enter the clinic admin verification code to claim this clinic",
        });
      }
    }
    if (data.role === "PATIENT" && data.date_of_birth !== undefined) {
      const result = patientFields.safeParse({
        date_of_birth: data.date_of_birth,
        sex: data.sex,
        city: data.city,
      });
      if (!result.success) {
        for (const issue of result.error.issues) {
          ctx.addIssue({ code: z.ZodIssueCode.custom, path: [issue.path[0] ?? "form"], message: issue.message });
        }
      }
    }
  });
export type SignUpInput = z.infer<typeof signUpSchema>;

export const requestPasswordResetSchema = z.object({ email: emailSchema });
export const updatePasswordSchema = z
  .object({
    password: passwordSchema,
    confirmPassword: z.string().min(1, "Confirm your password"),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
  });

/* ── Profile settings ──────────────────────────────────────────── */

export const profileUpdateSchema = z.object({
  full_name: fullNameSchema,
  phone: phoneSchema,
});
