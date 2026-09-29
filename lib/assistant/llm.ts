import "server-only";
import { env, isAiConfigured } from "@/lib/env";
import type { AssistantContext } from "@/lib/assistant/fallback";

/**
 * Groq LLM provider for the health assistant (server-only — the key never
 * reaches the browser). Groq exposes an OpenAI-compatible /chat/completions
 * endpoint.
 *
 * Grounding & Safety:
 * - Read-only architecture: zero tool/mutation functions are exposed.
 * - Every call is grounded strictly in the patient's real database records.
 * - History is capped to the last 4 user/assistant exchanges (8 messages max).
 * - Full safety instructions are re-injected on every single call.
 * - Temperature is locked low (0.15) for consistent, non-hallucinatory output.
 * - max_tokens is hard-capped (~350) to prevent runaway generation.
 */

import { withRetry } from "@/lib/network/with-retry";

export interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

export const SYSTEM_PROMPT = `You are the "Better Clinic" health assistant. You are an informational assistant inside a patient clinic portal.

STRICT MEDICAL SAFETY & GROUNDING RULES:
1. Ground every factual claim about the patient strictly in the PATIENT CONTEXT provided below. Never invent appointments, doctors, medications, dosages, allergies, or conditions.
2. You are NOT a doctor. You must NEVER diagnose medical conditions, interpret clinical symptoms, prescribe medications, or recommend changes to medication dosages (such as increasing, decreasing, or stopping a drug).
3. If a patient asks for medical advice, treatment recommendations, or changes to their dosage, you MUST explicitly deflect and advise them to consult their treating doctor or clinic.
4. If the patient describes an emergency (such as chest pain, trouble breathing, severe bleeding, sudden numbness, or self-harm thoughts), tell them to immediately call 108 (ambulance) or 112, or go to the nearest emergency room.
5. Keep answers concise, factual, and direct (a few sentences). Do not speculate.
6. If a question cannot be answered from the provided records, say so honestly and direct the patient to the relevant section (Find doctors, Appointments, Medications, Prescriptions, Follow-ups, Live queue).`;

export function contextToPrompt(context: AssistantContext): string {
  const parts: string[] = [`Patient first name: ${context.patientName.split(" ")[0] || "unknown"}`];

  parts.push(
    context.upcomingAppointments.length > 0
      ? `Upcoming appointments: ${context.upcomingAppointments
          .map((a) => `${a.date} ${a.start_time} with ${a.doctor_name} at ${a.clinic_name} (${a.status})`)
          .join("; ")}`
      : "Upcoming appointments: none"
  );
  parts.push(
    context.activeMedications.length > 0
      ? `Active medications: ${context.activeMedications
          .map((m) => `${m.medicine_name} ${m.dose} at ${m.times.join("/")} until ${m.end_date}`)
          .join("; ")}`
      : "Active medications: none"
  );
  parts.push(`Recorded allergies: ${context.allergies.length > 0 ? context.allergies.join(", ") : "none"}`);
  parts.push(`Chronic conditions: ${context.conditions.length > 0 ? context.conditions.join(", ") : "none"}`);
  parts.push(
    context.upcomingFollowUps.length > 0
      ? `Upcoming follow-ups: ${context.upcomingFollowUps
          .map((f) => `${f.scheduled_date} — ${f.reason} (${f.doctor_name})`)
          .join("; ")}`
      : "Upcoming follow-ups: none"
  );
  parts.push(
    context.queue
      ? `Queue today: token ${context.queue.token_code}, status ${context.queue.status}${context.queue.position ? `, position ${context.queue.position} (${context.queue.people_ahead} ahead)` : ""}`
      : "Queue today: not in queue"
  );

  return parts.join("\n");
}

/**
 * Ask the Groq LLM. Returns null when Groq is not configured, the request fails
 * (e.g. 429 rate limit, timeout, network error), or the response is empty.
 * Callers then fall back gracefully to the deterministic records answer.
 */
export async function generateLlmReply(
  history: ChatMessage[],
  message: string,
  context: AssistantContext,
  responseLength: "concise" | "detailed" = "concise"
): Promise<string | null> {
  if (!isAiConfigured()) return null;

  const styleInstruction =
    responseLength === "detailed"
      ? "RESPONSE STYLE: Detailed mode. Provide thorough, clear explanations while remaining strictly grounded in the patient context and adhering to safety rules."
      : "RESPONSE STYLE: Concise mode. Keep answers short, crisp, and direct (1-3 sentences or a small bulleted list).";

  // Hard cap history to last 4 exchanges (8 messages max)
  const cappedHistory = history.slice(-8);

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 15000);

  try {
    const response = await withRetry(
      () =>
        fetch(`${env.ai.baseUrl.replace(/\/$/, "")}/chat/completions`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${env.ai.apiKey}`,
          },
          body: JSON.stringify({
            model: env.ai.model,
            // Low temperature: sticks tightly to context without improvising
            temperature: 0.15,
            // Hard cap max_tokens to prevent runaway generations
            max_tokens: 350,
            messages: [
              { role: "system", content: `${SYSTEM_PROMPT}\n\n${styleInstruction}` },
              { role: "system", content: `PATIENT CONTEXT (real database records):\n${contextToPrompt(context)}` },
              // Re-inject safety instructions
              {
                role: "system",
                content: "SAFETY REMINDER: Never diagnose or prescribe. Never suggest altering doses. Only refer to entities present in PATIENT CONTEXT.",
              },
              ...cappedHistory,
              { role: "user", content: message },
            ],
          }),
          signal: controller.signal,
        }),
      { retries: 2, backoffs: [300, 800] }
    );

    if (!response.ok) {
      console.warn(`[Groq AI] API responded with status ${response.status}: ${response.statusText}`);
      return null;
    }

    const payload = (await response.json()) as {
      choices?: { message?: { content?: string } }[];
    };

    const content = payload.choices?.[0]?.message?.content?.trim();
    return content && content.length > 0 ? content : null;
  } catch (error) {
    console.warn("[Groq AI] Call failed or timed out:", error);
    return null;
  } finally {
    clearTimeout(timeout);
  }
}
