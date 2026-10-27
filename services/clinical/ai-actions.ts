"use server";

import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import {
  generateSoapNote,
  type SoapNote,
  type PatientClinicalContext,
} from "@/lib/assistant/soap-generator";
import { z } from "zod";

const soapInputSchema = z.object({
  consultationId: z.string().uuid("Invalid consultation ID"),
  notes: z.string().trim().min(3, "Please provide at least a few keywords or symptoms (min 3 characters)").max(3000),
  patientContext: z
    .object({
      patientName: z.string().optional(),
      age: z.union([z.number(), z.string()]).nullable().optional(),
      gender: z.string().nullable().optional(),
      sex: z.string().nullable().optional(),
      visitReason: z.string().nullable().optional(),
      allergies: z.array(z.string()).optional(),
      conditions: z.array(z.string()).optional(),
    })
    .optional(),
});

export async function generateSoapNoteAction(input: {
  consultationId: string;
  notes: string;
  patientContext?: PatientClinicalContext;
}): Promise<ActionResult<SoapNote>> {
  try {
    await requireRole(["DOCTOR"], "/doctor/consultations");
    const parsed = soapInputSchema.safeParse(input);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Invalid notes input." };
    }

    const note = await generateSoapNote(parsed.data.notes, parsed.data.patientContext);
    return { ok: true, data: note };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
