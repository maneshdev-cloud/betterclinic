"use server";

import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import {
  generatePrescriptionExplanation,
  type PrescriptionExplanation,
  type PrescriptionExplanationInput,
} from "@/lib/assistant/prescription-explainer";
import { z } from "zod";

const prescriptionExplainerSchema = z.object({
  doctor_name: z.string().min(1),
  clinic_name: z.string().optional(),
  notes: z.string().nullable().optional(),
  language: z.enum(["en", "hi"]).default("en"),
  items: z.array(
    z.object({
      medicine_name: z.string().min(1),
      strength: z.string().nullable().optional(),
      dose: z.string().min(1),
      frequency: z.string().min(1),
      duration_days: z.number().int().min(1),
      food_relation: z.string().default("NOT_SPECIFIED"),
      instructions: z.string().nullable().optional(),
    })
  ).min(1, "Prescription has no items to explain"),
});

export async function explainPrescriptionAction(
  input: PrescriptionExplanationInput
): Promise<ActionResult<PrescriptionExplanation>> {
  try {
    await requireRole(["PATIENT", "DOCTOR"], "/patient/prescriptions");
    const parsed = prescriptionExplainerSchema.safeParse(input);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Invalid prescription data." };
    }

    const explanation = await generatePrescriptionExplanation(parsed.data);
    return { ok: true, data: explanation };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
