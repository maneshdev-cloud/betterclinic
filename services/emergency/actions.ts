"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { errorMessage } from "@/lib/errors";
import type { ActionResult } from "@/services/availability/actions";

const emergencySchema = z.object({
  description: z.string().trim().min(5, "Describe what is happening (at least 5 characters)").max(500),
  locationText: z.string().trim().min(3, "Where are you? (address / landmark)").max(200),
});

/**
 * Raise an emergency request. The DB function records it, notifies the
 * patient (with the honest prototype disclaimer) and writes an audit
 * row. In a real emergency the UI always shows 108/112 first.
 */
export async function createEmergencyRequestAction(input: {
  description: string;
  locationText: string;
}): Promise<ActionResult<{ requestId: string; status: string }>> {
  try {
    await requireRole(["PATIENT"], "/patient/emergency");
    const parsed = emergencySchema.safeParse(input ?? {});
    if (!parsed.success) {
      return { ok: false, error: parsed.error.issues[0]?.message ?? "Please check the form." };
    }

    const supabase = await createClient();
    const { data, error } = await supabase.rpc("create_emergency_request", {
      p_description: parsed.data.description,
      p_location_text: parsed.data.locationText,
    });
    if (error) throw error;
    const row = (data as unknown as { id: string; status: string }[] | null)?.[0] ?? (data as unknown as { id: string; status: string } | null);
    revalidatePath("/patient/emergency");
    return {
      ok: true,
      data: { requestId: row?.id ?? "", status: row?.status ?? "CREATED" },
    };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}

/**
 * Advance a demo request through CREATED → RECEIVED → ACKNOWLEDGED →
 * CLOSED. The DB function refuses outside demo mode and for other
 * patients' requests.
 */
export async function advanceEmergencyDemoAction(
  requestId: string
): Promise<ActionResult<{ status: string }>> {
  try {
    await requireRole(["PATIENT"], "/patient/emergency");
    const id = z.string().uuid().safeParse(requestId ?? "");
    if (!id.success) return { ok: false, error: "Invalid request id." };

    const supabase = await createClient();
    const { data, error } = await supabase.rpc("emergency_advance_demo", {
      p_request_id: id.data,
    });
    if (error) throw error;
    const row = (data as unknown as { status: string }[] | null)?.[0] ?? (data as unknown as { status: string } | null);
    revalidatePath("/patient/emergency");
    return { ok: true, data: { status: row?.status ?? "UNKNOWN" } };
  } catch (error) {
    return { ok: false, error: errorMessage(error) };
  }
}
