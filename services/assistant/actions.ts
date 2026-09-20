"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";
import { sendAssistantMessage } from "@/services/assistant/service";
import { z } from "zod";

const messageSchema = z
  .string()
  .trim()
  .min(2, "Please write a message (at least 2 characters)")
  .max(1000, "Keep messages under 1000 characters");

/**
 * Send a message to the health assistant. The reply is generated
 * server-side (LLM key stays on the server); without a configured
 * provider the deterministic, database-grounded engine answers.
 */
export async function sendAssistantMessageAction(
  message: string
): Promise<ActionResult<{ reply: string; usedLlm: boolean; intent: string }>> {
  try {
    const user = await requireRole(["PATIENT"], "/patient/assistant");
    const parsed = messageSchema.safeParse(message ?? "");
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check your message." };
    }

    const supabase = await createClient();
    const result = await sendAssistantMessage(supabase, user.id, user.fullName, parsed.data);
    revalidatePath("/patient/assistant");
    return { ok: true, data: result };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
