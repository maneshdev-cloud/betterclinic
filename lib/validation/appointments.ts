import { z } from "zod";
import { uuidSchema } from "@/lib/validation/auth";

export const visitReasonSchema = z
  .string()
  .trim()
  .min(3, "Describe the reason for your visit (at least 3 characters)")
  .max(500, "Keep the reason under 500 characters");

export const cancelReasonSchema = z
  .string()
  .trim()
  .max(200, "Keep the reason under 200 characters")
  .optional()
  .or(z.literal(""));

export const rescheduleReasonSchema = cancelReasonSchema;

export const bookAppointmentSchema = z.object({
  slotId: uuidSchema,
  visitReason: visitReasonSchema,
});

export const rescheduleSchema = z.object({
  appointmentId: uuidSchema,
  newSlotId: uuidSchema,
  reason: rescheduleReasonSchema,
});

export const cancelSchema = z.object({
  appointmentId: uuidSchema,
  reason: cancelReasonSchema,
});

/** Date string YYYY-MM-DD */
export const dateStringSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "Invalid date");

export const slotDateSchema = dateStringSchema.refine(
  (value) => {
    const date = new Date(`${value}T00:00:00`);
    return !Number.isNaN(date.getTime());
  },
  { message: "Invalid date" }
);

/* ── Doctor search (URL params) ─────────────────────────────────── */

export const doctorSearchSchema = z.object({
  q: z.string().trim().max(80).optional().default(""),
  specialization: uuidSchema.optional().or(z.literal("")),
  city: z.string().trim().max(60).optional().default(""),
  maxFee: z.coerce.number().int().min(0).max(20000).optional(),
  minRating: z.coerce.number().min(0).max(5).optional(),
  availableToday: z.coerce.boolean().optional().default(false),
  acceptingPatients: z.coerce.boolean().optional().default(false),
  sort: z.enum(["rating", "experience", "fee_asc", "fee_desc"]).optional().default("rating"),
  page: z.coerce.number().int().min(1).optional().default(1),
});

export type DoctorSearchInput = z.infer<typeof doctorSearchSchema>;

export const clinicSearchSchema = z.object({
  q: z.string().trim().max(80).optional().default(""),
  city: z.string().trim().max(60).optional().default(""),
  area: z.string().trim().max(60).optional().default(""),
  specialization: uuidSchema.optional().or(z.literal("")),
  minRating: z.coerce.number().min(0).max(5).optional(),
  sort: z.enum(["rating", "name"]).optional().default("rating"),
  page: z.coerce.number().int().min(1).optional().default(1),
});

export type ClinicSearchInput = z.infer<typeof clinicSearchSchema>;

/* ── Availability editor payload ────────────────────────────────── */

const timeString = z.string().regex(/^\d{2}:\d{2}$/, "Invalid time");

export const availabilityDaySchema = z
  .object({
    dayOfWeek: z.number().int().min(0).max(6),
    enabled: z.boolean(),
    startTime: timeString.default("09:00"),
    endTime: timeString.default("17:00"),
    breakEnabled: z.boolean().default(false),
    breakStart: timeString.nullable().default(null),
    breakEnd: timeString.nullable().default(null),
    slotDurationMinutes: z.number().int().min(5).max(120).default(15),
  })
  .superRefine((day, ctx) => {
    if (!day.enabled) return;
    if (day.endTime <= day.startTime) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["endTime"],
        message: "End time must be after start time",
      });
    }
    if (day.breakEnabled) {
      if (!day.breakStart || !day.breakEnd) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["breakStart"],
          message: "Set both break start and end, or turn the break off",
        });
      } else if (day.breakEnd <= day.breakStart) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["breakEnd"],
          message: "Break end must be after break start",
        });
      } else if (day.breakStart <= day.startTime || day.breakEnd >= day.endTime) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["breakStart"],
          message: "The break must fit inside the working window",
        });
      }
    }
  });

export const availabilityPayloadSchema = z.object({
  clinicId: uuidSchema,
  days: z.array(availabilityDaySchema).length(7),
});

export type AvailabilityDayInput = z.infer<typeof availabilityDaySchema>;
export type AvailabilityPayloadInput = z.infer<typeof availabilityPayloadSchema>;
