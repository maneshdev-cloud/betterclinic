import type { SupabaseClient } from "@supabase/supabase-js";
import type { AiMessage } from "@/lib/types/database";
import { buildFallbackReply, type AssistantContext } from "@/lib/assistant/fallback";
import { generateLlmReply } from "@/lib/assistant/llm";
import { listPatientAppointments } from "@/services/appointments/service";
import { listActiveMedications } from "@/services/clinical/service";
import { listPatientFollowUps } from "@/services/clinical/service";
import { getPatientQueueStatus } from "@/services/queue/service";

export interface AssistantMessageView {
  id: string;
  role: "USER" | "ASSISTANT";
  content: string;
  intent: string | null;
  usedLlm: boolean;
  createdAt: string;
}

/** Each patient has exactly one conversation (ai_conversations.patient_id unique). */
export async function getOrCreateConversation(
  client: SupabaseClient,
  patientId: string
): Promise<string> {
  const { data } = await client
    .from("ai_conversations")
    .select("id")
    .eq("patient_id", patientId)
    .maybeSingle();
  if (data) return (data as { id: string }).id;

  const { data: created, error } = await client
    .from("ai_conversations")
    .insert({ patient_id: patientId })
    .select("id")
    .single();
  if (error) throw error;
  return (created as { id: string }).id;
}

export async function listMessages(
  client: SupabaseClient,
  conversationId: string
): Promise<AssistantMessageView[]> {
  const { data, error } = await client
    .from("ai_messages")
    .select("id, role, content, intent, used_llm, created_at")
    .eq("conversation_id", conversationId)
    .order("created_at", { ascending: true })
    .limit(100);
  if (error) throw error;
  const rows = (data ?? []) as unknown as {
    id: string;
    role: AiMessage["role"];
    content: string;
    intent: string | null;
    used_llm: boolean;
    created_at: string;
  }[];
  return rows.map((row) => ({
    id: row.id,
    role: row.role,
    content: row.content,
    intent: row.intent,
    usedLlm: row.used_llm,
    createdAt: row.created_at,
  }));
}

/**
 * Build the assistant's view of the patient's real records. Every reply
 * — LLM or fallback — is grounded in exactly this data.
 */
export async function buildAssistantContext(
  client: SupabaseClient,
  patientId: string,
  patientName: string
): Promise<AssistantContext> {
  const [appointments, medications, followUps, queueStatus, historyRows] = await Promise.all([
    listPatientAppointments(client, patientId, "upcoming", 1),
    listActiveMedications(client, patientId),
    listPatientFollowUps(client, patientId),
    getPatientQueueStatus(client, patientId),
    client
      .from("medical_history")
      .select("record_type, title")
      .eq("patient_id", patientId)
      .eq("is_active", true)
      .in("record_type", ["ALLERGY", "CHRONIC_CONDITION"])
      .limit(30),
  ]);
  if (historyRows.error) throw historyRows.error;

  const history = (historyRows.data ?? []) as unknown as { record_type: string; title: string }[];

  return {
    patientName,
    upcomingAppointments: appointments.items.slice(0, 3).map((appt) => ({
      doctor_name: appt.doctor_name,
      clinic_name: appt.clinic_name,
      date: appt.appointment_date,
      start_time: appt.start_time,
      status: appt.status,
    })),
    activeMedications: medications.map((course) => ({
      medicine_name: course.medicine_name,
      dose: course.dose,
      times: course.times,
      end_date: course.end_date,
    })),
    allergies: history.filter((h) => h.record_type === "ALLERGY").map((h) => h.title),
    conditions: history.filter((h) => h.record_type === "CHRONIC_CONDITION").map((h) => h.title),
    upcomingFollowUps: followUps.upcoming.slice(0, 3).map((fu) => ({
      scheduled_date: fu.scheduled_date,
      reason: fu.reason,
      doctor_name: fu.doctor_name,
    })),
    queue: queueStatus
      ? {
          token_code: queueStatus.entry.token_code,
          status: queueStatus.entry.status,
          position: queueStatus.entry.status === "WAITING" ? queueStatus.position : null,
          people_ahead: queueStatus.peopleAhead,
        }
      : null,
  };
}

export interface AssistantReply {
  reply: string;
  intent: string;
  usedLlm: boolean;
}

/**
 * Handle one patient message: persist it, build the real-data context,
 * try the LLM (if configured), fall back to the deterministic engine,
 * and persist the assistant reply.
 */
export async function sendAssistantMessage(
  client: SupabaseClient,
  patientId: string,
  patientName: string,
  message: string
): Promise<AssistantReply> {
  const conversationId = await getOrCreateConversation(client, patientId);

  const { error: userError } = await client.from("ai_messages").insert({
    conversation_id: conversationId,
    role: "USER",
    content: message,
  });
  if (userError) throw userError;

  const context = await buildAssistantContext(client, patientId, patientName);
  const history = (await listMessages(client, conversationId))
    .filter((msg) => msg.id)
    .slice(-9, -1) // previous turns, excluding the just-inserted user message
    .map((msg) => ({ role: msg.role.toLowerCase() as "user" | "assistant", content: msg.content }));

  const { data: prefRow } = await client
    .from("user_preferences")
    .select("ai_assistant_enabled, ai_response_length")
    .eq("user_id", patientId)
    .maybeSingle();

  if (prefRow && prefRow.ai_assistant_enabled === false) {
    throw new Error("The AI health assistant is disabled in your preferences.");
  }

  const responseLength: "concise" | "detailed" =
    prefRow?.ai_response_length === "detailed" ? "detailed" : "concise";

  const llmReply = await generateLlmReply(history, message, context, responseLength);
  let reply: string;
  let intent: string;
  if (llmReply !== null) {
    reply = llmReply;
    intent = "llm";
  } else {
    const fallback = buildFallbackReply(message, context, responseLength);
    reply = fallback.reply;
    intent = fallback.intent;
  }

  const { error: assistantError } = await client.from("ai_messages").insert({
    conversation_id: conversationId,
    role: "ASSISTANT",
    content: reply,
    intent,
    used_llm: llmReply !== null,
  });
  if (assistantError) throw assistantError;

  return { reply, intent, usedLlm: llmReply !== null };
}
