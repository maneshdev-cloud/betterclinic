import type { SupabaseClient } from "@supabase/supabase-js";
import type { AiMessage } from "@/lib/types/database";
import { buildFallbackReply, type AssistantContext } from "@/lib/assistant/fallback";
import { generateLlmReply } from "@/lib/assistant/llm";
import {
  isEmergencyQuery,
  EMERGENCY_HARDCODED_REPLY,
  verifyResponseEntities,
  FALLBACK_GRACEFUL_NOTE,
} from "@/lib/assistant/safety";
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
  isEmergencyOverride?: boolean;
  createdAt: string;
}

// Fetch or create conversation for patient
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
    .select("id, role, content, intent, used_llm, is_emergency_override, created_at")
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
    is_emergency_override?: boolean;
    created_at: string;
  }[];
  return rows.map((row) => ({
    id: row.id,
    role: row.role,
    content: row.content,
    intent: row.intent,
    usedLlm: row.used_llm,
    isEmergencyOverride: row.is_emergency_override ?? false,
    createdAt: row.created_at,
  }));
}

// Builds context from patient records
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
  isEmergencyOverride?: boolean;
}

// Handles patient messages with safety checks, database lookup, and fallback
export async function sendAssistantMessage(
  client: SupabaseClient,
  patientId: string,
  patientName: string,
  message: string,
  injectedContext?: AssistantContext
): Promise<AssistantReply> {
  const conversationId = await getOrCreateConversation(client, patientId);

  const { error: userError } = await client.from("ai_messages").insert({
    conversation_id: conversationId,
    role: "USER",
    content: message,
  });
  if (userError) throw userError;

  // Fetch patient medical records for context
  const context = injectedContext ?? (await buildAssistantContext(client, patientId, patientName));

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

  // Emergency keyword check
  if (isEmergencyQuery(message)) {
    const reply = EMERGENCY_HARDCODED_REPLY;
    const intent = "emergency_override";

    await client.from("ai_messages").insert({
      conversation_id: conversationId,
      role: "ASSISTANT",
      content: reply,
      intent,
      used_llm: false,
      is_emergency_override: true,
    });

    return { reply, intent, usedLlm: false, isEmergencyOverride: true };
  }

  // Check if query matches known database records directly
  const fallback = buildFallbackReply(message, context, responseLength);
  if (fallback.intent !== "unknown") {
    await client.from("ai_messages").insert({
      conversation_id: conversationId,
      role: "ASSISTANT",
      content: fallback.reply,
      intent: fallback.intent,
      used_llm: false,
      is_emergency_override: false,
    });

    return { reply: fallback.reply, intent: fallback.intent, usedLlm: false, isEmergencyOverride: false };
  }

  const history = (await listMessages(client, conversationId))
    .filter((msg) => msg.id)
    .slice(-9, -1) // up to 4 exchanges (excluding the just-inserted message)
    .map((msg) => ({ role: msg.role.toLowerCase() as "user" | "assistant", content: msg.content }));

  let reply: string;
  let intent: string = "llm";
  let usedLlm = false;

  const llmReply = await generateLlmReply(history, message, context, responseLength);
  if (llmReply !== null) {
    const verification = verifyResponseEntities(llmReply, context);
    if (verification.valid) {
      reply = llmReply;
      usedLlm = true;
    } else {
      console.warn(`[Clinical AI] Response discarded due to entity verification: ${verification.reason}`);
      reply = fallback.reply + FALLBACK_GRACEFUL_NOTE;
      intent = "fallback_entity_mismatch";
    }
  } else {
    reply = fallback.reply + FALLBACK_GRACEFUL_NOTE;
    intent = "fallback_llm_failed";
  }

  const { error: assistantError } = await client.from("ai_messages").insert({
    conversation_id: conversationId,
    role: "ASSISTANT",
    content: reply,
    intent,
    used_llm: usedLlm,
    is_emergency_override: false,
  });
  if (assistantError) throw assistantError;

  return { reply, intent, usedLlm, isEmergencyOverride: false };
}
