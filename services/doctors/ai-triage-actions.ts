"use server";

import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import {
  triageSymptoms,
  type TriageResult,
} from "@/lib/assistant/symptom-triage";
import { z } from "zod";

const triageSchema = z.object({
  symptoms: z
    .string()
    .trim()
    .min(3, "Please write at least a few words describing what you feel (min 3 characters)")
    .max(1000, "Please keep symptoms description under 1000 characters"),
  availableSpecializations: z.array(z.string()).optional(),
});

export async function triageSymptomsAction(input: {
  symptoms: string;
  availableSpecializations?: string[];
}): Promise<ActionResult<TriageResult>> {
  try {
    const parsed = triageSchema.safeParse(input);
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Invalid symptom description." };
    }

    const result = await triageSymptoms(parsed.data.symptoms, parsed.data.availableSpecializations);
    return { ok: true, data: result };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
