import "server-only";
import { env, isAiConfigured } from "@/lib/env";
import type { AssistantContext } from "@/lib/assistant/fallback";

/**
 * Optional LLM provider for the assistant (server-only — the key never
 * reaches the browser). Any OpenAI-compatible chat-completions endpoint
 * works. Every call is grounded in the patient's real database context;
 * if the provider is not configured or fails, the caller falls back to
 * the deterministic engine (lib/assistant/fallback.ts).
 */

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

const SYSTEM_PROMPT = `You are the "Better Clinic" health assistant for a patient. You are a helpful prototype assistant inside a clinic application.

STRICT RULES:
- Ground every factual claim about the patient in the PATIENT CONTEXT provided. Never invent appointments, medications, allergies or anything else.
- You are NOT a doctor: do not diagnose, prescribe, or interpret symptoms. Encourage consulting a doctor for medical questions.
- If the patient describes an emergency (chest pain, breathing trouble, heavy bleeding, unconsciousness, suicidal thoughts), tell them to call 108 (ambulance) or 112 immediately and stop.
- Keep answers short and plain (a few sentences, or a small list). Use the context data verbatim for dates/times/names.
- If the question cannot be answered from the context, say so honestly and point to the relevant app page (Find doctors, Appointments, Medications, Prescriptions, Follow-ups, Live queue).`;

function contextToPrompt(context: AssistantContext): string {
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
 * Ask the configured LLM. Returns null when no provider is configured,
 * the request fails, or the response is unusable — callers must then
 * use the deterministic fallback.
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
      ? "RESPONSE STYLE: Detailed mode. Provide thorough, comprehensive explanations with clear step-by-step guidance and additional context while remaining strictly grounded in the patient context."
      : "RESPONSE STYLE: Concise mode. Keep answers short, crisp, and direct (1-2 sentences or a small bulleted list).";

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 20000);
  try {
    const response = await fetch(`${env.ai.baseUrl.replace(/\/$/, "")}/chat/completions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${env.ai.apiKey}`,
      },
      body: JSON.stringify({
        model: env.ai.model,
        temperature: 0.2,
        max_tokens: responseLength === "detailed" ? 500 : 250,
        messages: [
          { role: "system", content: `${SYSTEM_PROMPT}\n\n${styleInstruction}` },
          { role: "system", content: `PATIENT CONTEXT (real database records):\n${contextToPrompt(context)}` },
          ...history.slice(-8),
          { role: "user", content: message },
        ],
      }),
      signal: controller.signal,
    });

    if (!response.ok) return null;
    const payload = (await response.json()) as {
      choices?: { message?: { content?: string } }[];
    };
    const content = payload.choices?.[0]?.message?.content?.trim();
    return content && content.length > 0 ? content : null;
  } catch {
    return null;
  } finally {
    clearTimeout(timeout);
  }
}
