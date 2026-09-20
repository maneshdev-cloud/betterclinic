import type { SupabaseClient } from "@supabase/supabase-js";
import type { EmergencyRequest } from "@/lib/types/database";

/**
 * Emergency module (prototype demo). Patients can raise an emergency
 * request and — only in demo mode — advance it through a simulated
 * status progression. The DB functions enforce everything; this service
 * only reads back the patient's own rows and emergency-card data.
 */

export interface EmergencyCard {
  bloodGroup: string | null;
  allergies: string[];
  conditions: string[];
  emergencyContactName: string | null;
  emergencyContactPhone: string | null;
}

export async function listPatientEmergencyRequests(
  client: SupabaseClient,
  patientId: string
): Promise<EmergencyRequest[]> {
  const { data, error } = await client
    .from("emergency_requests")
    .select("*")
    .eq("patient_id", patientId)
    .order("created_at", { ascending: false })
    .limit(20);
  if (error) throw error;
  return (data ?? []) as unknown as EmergencyRequest[];
}

/** The always-visible emergency card: vitals-relevant history + ICE contact. */
export async function getEmergencyCard(client: SupabaseClient, patientId: string): Promise<EmergencyCard> {
  const [patientRes, historyRes, privacyRes] = await Promise.all([
    client
      .from("patients")
      .select("blood_group, emergency_contact_name, emergency_contact_phone")
      .eq("id", patientId)
      .maybeSingle(),
    client
      .from("medical_history")
      .select("record_type, title")
      .eq("patient_id", patientId)
      .eq("is_active", true)
      .in("record_type", ["ALLERGY", "CHRONIC_CONDITION"])
      .limit(30),
    client.rpc("get_user_privacy_flags", { p_user_ids: [patientId] }),
  ]);
  if (patientRes.error) throw patientRes.error;
  if (historyRes.error) throw historyRes.error;

  const patient = patientRes.data as
    | { blood_group: string | null; emergency_contact_name: string | null; emergency_contact_phone: string | null }
    | null;
  const history = (historyRes.data ?? []) as unknown as { record_type: string; title: string }[];
  const privacy = (privacyRes.data ?? []) as { show_emergency_contact?: boolean }[];
  const showEmergency = privacy[0]?.show_emergency_contact ?? true;

  return {
    bloodGroup: patient?.blood_group ?? null,
    allergies: history.filter((h) => h.record_type === "ALLERGY").map((h) => h.title),
    conditions: history.filter((h) => h.record_type === "CHRONIC_CONDITION").map((h) => h.title),
    emergencyContactName: showEmergency ? patient?.emergency_contact_name ?? null : null,
    emergencyContactPhone: showEmergency ? patient?.emergency_contact_phone ?? null : null,
  };
}

/** "demo" | "production" — drives whether the simulated progression is offered. */
export async function getAppEnv(client: SupabaseClient): Promise<"demo" | "production"> {
  const { data } = await client.from("app_settings").select("value").eq("key", "app_env").maybeSingle();
  const value = (data as { value: string } | null)?.value;
  return value === "production" ? "production" : "demo";
}
