import { createClient } from "@supabase/supabase-js";
import { loadLocalEnv, requireEnv } from "../scripts/lib/load-env";

loadLocalEnv();

const url = requireEnv("NEXT_PUBLIC_SUPABASE_URL");
const key = requireEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY");

const TABLES_WITH_SYNTHETIC = new Set([
  "profiles", "patients", "doctors", "clinics", "clinic_staff",
  "appointments", "appointment_slots", "consultations", "prescriptions",
  "prescription_items", "medication_schedules", "follow_ups", "diagnoses",
  "treatment_plans", "medical_history", "reviews", "notifications",
  "queue_entries", "queue_events", "check_ins", "ai_conversations",
  "ai_messages", "emergency_requests", "audit_logs", "doctor_availability",
  "clinic_hours", "doctor_clinics", "doctor_specializations",
  "clinic_invite_codes", "appointment_status_history"
]);

function wrapClient(client: any, hideDemo: boolean) {
  if (!hideDemo) return client;
  const originalFrom = client.from.bind(client);
  client.from = (table: string) => {
    const qb = originalFrom(table);
    if (!TABLES_WITH_SYNTHETIC.has(table)) {
      return qb;
    }
    const originalSelect = qb.select.bind(qb);
    qb.select = (...args: any[]) => {
      const fb = originalSelect(...args);
      return fb.eq("is_synthetic", false);
    };
    return qb;
  };
  return client;
}

async function run() {
  const normalClient = createClient(url, key);
  const { data: allClinics } = await normalClient.from("clinics").select("id, name, is_synthetic");
  console.log(`Normal client clinics count: ${allClinics?.length} (synthetic: ${allClinics?.filter(c => c.is_synthetic).length}, real: ${allClinics?.filter(c => !c.is_synthetic).length})`);

  const wrappedClient = wrapClient(createClient(url, key), true);
  const { data: realClinics } = await wrappedClient.from("clinics").select("id, name, is_synthetic");
  console.log(`Wrapped client (hideDemo=true) clinics count: ${realClinics?.length} (synthetic: ${realClinics?.filter((c: any) => c.is_synthetic).length}, real: ${realClinics?.filter((c: any) => !c.is_synthetic).length})`);

  const { data: allDoctors } = await normalClient.from("doctors").select("id, is_synthetic");
  console.log(`Normal client doctors count: ${allDoctors?.length}`);

  const { data: realDoctors } = await wrappedClient.from("doctors").select("id, is_synthetic");
  console.log(`Wrapped client (hideDemo=true) doctors count: ${realDoctors?.length}`);
}

run();
