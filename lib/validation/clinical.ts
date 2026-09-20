import { z } from "zod";
import { uuidSchema } from "@/lib/validation/auth";
import {
  PRESCRIPTION_FREQUENCIES,
  FOOD_RELATIONS,
  MEDICAL_HISTORY_TYPES,
} from "@/lib/constants";

/* ── Consultation notes ────────────────────────────────────────── */

export const consultationNotesSchema = z.object({
  chief_complaint: z.string().trim().max(300).optional().or(z.literal("")),
  symptoms: z.string().trim().max(1000).optional().or(z.literal("")),
  clinical_notes: z.string().trim().max(4000).optional().or(z.literal("")),
  assessment: z.string().trim().max(2000).optional().or(z.literal("")),
});

export type ConsultationNotesInput = z.infer<typeof consultationNotesSchema>;

/* ── Prescriptions ─────────────────────────────────────────────── */

export const prescriptionItemSchema = z.object({
  medicine_name: z.string().trim().min(2, "Medicine name is required").max(120),
  generic_name: z.string().trim().max(120).optional().or(z.literal("")),
  strength: z.string().trim().max(40).optional().or(z.literal("")),
  dose: z.string().trim().min(1, "Dose is required (e.g. 1 tablet)").max(60),
  frequency: z.enum(PRESCRIPTION_FREQUENCIES),
  duration_days: z.coerce
    .number()
    .int("Whole days only")
    .min(1, "At least 1 day")
    .max(365, "At most 365 days"),
  instructions: z.string().trim().max(300).optional().or(z.literal("")),
  food_relation: z.enum(FOOD_RELATIONS).default("NOT_SPECIFIED"),
});

export const prescriptionSchema = z.object({
  consultationId: uuidSchema,
  notes: z.string().trim().max(500).optional().or(z.literal("")),
  items: z.array(prescriptionItemSchema).min(1, "Add at least one medicine").max(15),
});

export type PrescriptionItemInput = z.infer<typeof prescriptionItemSchema>;
export type PrescriptionInput = z.infer<typeof prescriptionSchema>;

/* ── Diagnoses ─────────────────────────────────────────────────── */

export const diagnosisSchema = z.object({
  consultationId: uuidSchema,
  name: z.string().trim().min(2, "Diagnosis name is required").max(160),
  description: z.string().trim().max(500).optional().or(z.literal("")),
  code: z.string().trim().max(30).optional().or(z.literal("")),
  is_primary: z.boolean().default(false),
});

export type DiagnosisInput = z.infer<typeof diagnosisSchema>;

/* ── Medical history entries (recorded by doctors) ─────────────── */

export const medicalHistorySchema = z.object({
  patientId: uuidSchema,
  record_type: z.enum(MEDICAL_HISTORY_TYPES),
  title: z.string().trim().min(2, "Title is required").max(120),
  description: z.string().trim().max(500).optional().or(z.literal("")),
});

export type MedicalHistoryInput = z.infer<typeof medicalHistorySchema>;

/* ── Follow-ups ────────────────────────────────────────────────── */

const isoDate = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "Pick a date");

export const followUpSchema = z.object({
  consultationId: uuidSchema,
  scheduled_date: isoDate,
  reason: z.string().trim().min(3, "Describe the reason for the follow-up").max(200),
  instructions: z.string().trim().max(500).optional().or(z.literal("")),
});

export type FollowUpInput = z.infer<typeof followUpSchema>;
