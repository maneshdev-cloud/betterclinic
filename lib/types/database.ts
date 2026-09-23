/**
 * Hand-written TypeScript mirror of the PostgreSQL schema
 * (supabase/migrations/00001_schema.sql). Keep in sync when the
 * schema changes.
 */

export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

/* ── Row types (snake_case, matching PostgREST responses) ───────── */

export interface Profile {
  id: string;
  full_name: string;
  email: string;
  phone: string | null;
  role: "PATIENT" | "DOCTOR" | "RECEPTIONIST" | "CLINIC_ADMIN";
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface Location {
  id: string;
  city: string;
  area: string;
  created_at: string;
}

export interface Specialization {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  created_at: string;
}

export interface Clinic {
  id: string;
  name: string;
  description: string | null;
  address_line: string;
  city: string;
  area: string;
  pincode: string | null;
  contact_phone: string | null;
  contact_email: string | null;
  image_url: string | null;
  facilities: string[];
  avg_rating: number;
  review_count: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Patient {
  id: string;
  date_of_birth: string | null;
  sex: "MALE" | "FEMALE" | "OTHER" | null;
  blood_group: string | null;
  address_line: string | null;
  city: string | null;
  area: string | null;
  pincode: string | null;
  emergency_contact_name: string | null;
  emergency_contact_phone: string | null;
  created_at: string;
  updated_at: string;
}

export interface Doctor {
  id: string;
  qualification: string;
  registration_number: string;
  experience_years: number;
  consultation_fee: number;
  about: string | null;
  languages: string[];
  avg_rating: number;
  review_count: number;
  is_accepting_patients: boolean;
  created_at: string;
  updated_at: string;
}

export interface DoctorSpecialization {
  doctor_id: string;
  specialization_id: string;
  created_at: string;
}

export interface DoctorClinic {
  id: string;
  doctor_id: string;
  clinic_id: string;
  is_primary: boolean;
  created_at: string;
}

export interface ClinicStaff {
  id: string;
  user_id: string;
  clinic_id: string;
  role: "RECEPTIONIST" | "CLINIC_ADMIN";
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface ClinicHours {
  id: string;
  clinic_id: string;
  day_of_week: number;
  opens_at: string;
  closes_at: string;
  is_closed: boolean;
  created_at: string;
  updated_at: string;
}

export interface DoctorAvailability {
  id: string;
  doctor_id: string;
  clinic_id: string;
  day_of_week: number;
  start_time: string;
  end_time: string;
  break_start: string | null;
  break_end: string | null;
  slot_duration_minutes: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface AppointmentSlot {
  id: string;
  doctor_id: string;
  clinic_id: string;
  slot_date: string;
  start_time: string;
  end_time: string;
  status: "FREE" | "BOOKED" | "BLOCKED";
  appointment_id: string | null;
  created_at: string;
}

export interface Appointment {
  id: string;
  patient_id: string;
  doctor_id: string;
  clinic_id: string;
  slot_id: string | null;
  appointment_type: "SCHEDULED" | "WALK_IN";
  status:
    | "BOOKED"
    | "CONFIRMED"
    | "CHECKED_IN"
    | "WAITING"
    | "CALLED"
    | "IN_CONSULTATION"
    | "COMPLETED"
    | "CANCELLED"
    | "NO_SHOW";
  appointment_date: string;
  start_time: string;
  end_time: string;
  visit_reason: string;
  notes: string | null;
  booked_at: string;
  confirmed_at: string | null;
  checked_in_at: string | null;
  cancelled_at: string | null;
  cancellation_reason: string | null;
  completed_at: string | null;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface AppointmentStatusHistory {
  id: string;
  appointment_id: string;
  from_status: Appointment["status"] | null;
  to_status: Appointment["status"];
  changed_by: string | null;
  reason: string | null;
  created_at: string;
}

export interface CheckIn {
  id: string;
  appointment_id: string;
  patient_id: string;
  clinic_id: string;
  method: "APP" | "RECEPTIONIST";
  checked_in_by: string | null;
  created_at: string;
}

export interface QueueEntry {
  id: string;
  clinic_id: string;
  doctor_id: string;
  patient_id: string;
  appointment_id: string;
  queue_date: string;
  token_number: number;
  token_code: string;
  priority: "NORMAL" | "HIGH" | "URGENT";
  status: "WAITING" | "CALLED" | "IN_CONSULTATION" | "COMPLETED" | "SKIPPED" | "CANCELLED";
  created_at: string;
  called_at: string | null;
  started_at: string | null;
  completed_at: string | null;
}

export interface QueueEvent {
  id: string;
  queue_entry_id: string;
  event_type:
    | "CREATED"
    | "CALLED"
    | "RECALLED"
    | "SKIPPED"
    | "RESUMED"
    | "STARTED"
    | "COMPLETED"
    | "CANCELLED"
    | "PRIORITY_CHANGED";
  from_status: QueueEntry["status"] | null;
  to_status: QueueEntry["status"] | null;
  changed_by: string | null;
  note: string | null;
  created_at: string;
}

export interface Notification {
  id: string;
  user_id: string;
  type: string;
  title: string;
  body: string;
  entity_type: string | null;
  entity_id: string | null;
  is_read: boolean;
  read_at: string | null;
  created_at: string;
}

export interface Consultation {
  id: string;
  appointment_id: string;
  patient_id: string;
  doctor_id: string;
  clinic_id: string;
  status: "DRAFT" | "IN_PROGRESS" | "COMPLETED";
  chief_complaint: string | null;
  symptoms: string | null;
  clinical_notes: string | null;
  assessment: string | null;
  started_at: string;
  completed_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface Diagnosis {
  id: string;
  consultation_id: string;
  patient_id: string;
  name: string;
  description: string | null;
  code: string | null;
  is_primary: boolean;
  created_at: string;
}

export interface TreatmentPlan {
  id: string;
  consultation_id: string;
  patient_id: string;
  title: string;
  description: string | null;
  instructions: string | null;
  duration_days: number | null;
  created_at: string;
  updated_at: string;
}

export interface MedicalHistoryRecord {
  id: string;
  patient_id: string;
  record_type:
    | "ALLERGY"
    | "CHRONIC_CONDITION"
    | "SURGERY"
    | "INJURY"
    | "FAMILY_HISTORY"
    | "LIFESTYLE"
    | "IMMUNIZATION"
    | "NOTE";
  title: string;
  description: string | null;
  recorded_by: string | null;
  is_active: boolean;
  recorded_at: string;
  updated_at: string;
}

export interface Medicine {
  id: string;
  name: string;
  generic_name: string;
  form: "TABLET" | "CAPSULE" | "SYRUP" | "INJECTION" | "CREAM" | "OINTMENT" | "DROPS" | "INHALER" | "POWDER";
  strength: string | null;
  category: string;
  is_common: boolean;
  created_at: string;
}

export interface Prescription {
  id: string;
  consultation_id: string;
  patient_id: string;
  doctor_id: string;
  clinic_id: string;
  prescription_date: string;
  status: "ACTIVE" | "COMPLETED" | "CANCELLED";
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface PrescriptionItem {
  id: string;
  prescription_id: string;
  medicine_id: string | null;
  medicine_name: string;
  generic_name: string | null;
  strength: string | null;
  dose: string;
  frequency: "OD" | "BD" | "TDS" | "QID" | "HS" | "SOS" | "STAT";
  duration_days: number;
  instructions: string | null;
  food_relation: "BEFORE_FOOD" | "AFTER_FOOD" | "WITH_FOOD" | "EMPTY_STOMACH" | "NOT_SPECIFIED";
  created_at: string;
}

export interface MedicationSchedule {
  id: string;
  prescription_item_id: string;
  prescription_id: string;
  patient_id: string;
  medicine_name: string;
  dose: string;
  time_of_day: string;
  start_date: string;
  end_date: string;
  instructions: string | null;
  food_relation: PrescriptionItem["food_relation"];
  status: "ACTIVE" | "COMPLETED" | "CANCELLED";
  created_at: string;
  updated_at: string;
}

export interface FollowUp {
  id: string;
  consultation_id: string;
  patient_id: string;
  doctor_id: string;
  clinic_id: string;
  scheduled_date: string;
  reason: string;
  instructions: string | null;
  status: "SCHEDULED" | "COMPLETED" | "CANCELLED" | "MISSED";
  completed_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface Review {
  id: string;
  doctor_id: string | null;
  clinic_id: string | null;
  patient_id: string;
  rating: number;
  title: string | null;
  comment: string | null;
  is_approved: boolean;
  created_at: string;
  updated_at: string;
}

export interface EmergencyRequest {
  id: string;
  patient_id: string;
  description: string;
  location_text: string;
  latitude: number | null;
  longitude: number | null;
  status: "CREATED" | "RECEIVED" | "ACKNOWLEDGED" | "CLOSED";
  is_demo: boolean;
  created_at: string;
  received_at: string | null;
  acknowledged_at: string | null;
  closed_at: string | null;
  updated_at: string;
}

export interface AuditLog {
  id: string;
  actor_id: string | null;
  actor_role: Profile["role"] | null;
  action: string;
  entity_type: string;
  entity_id: string | null;
  clinic_id: string | null;
  patient_id: string | null;
  metadata: Json;
  created_at: string;
}

export interface AiConversation {
  id: string;
  patient_id: string;
  created_at: string;
  updated_at: string;
}

export interface AiMessage {
  id: string;
  conversation_id: string;
  role: "USER" | "ASSISTANT";
  content: string;
  intent: string | null;
  used_llm: boolean;
  is_emergency_override?: boolean;
  created_at: string;
}

/* ── supabase-js Database generic ───────────────────────────────── */

type TableDef<Row> = {
  Row: Row;
  Insert: Partial<Row>;
  Update: Partial<Row>;
  Relationships: unknown[];
};

export type Database = {
  public: {
    Tables: {
      profiles: TableDef<Profile>;
      locations: TableDef<Location>;
      specializations: TableDef<Specialization>;
      clinics: TableDef<Clinic>;
      clinic_invite_codes: TableDef<{ clinic_id: string; code: string; created_at: string }>;
      patients: TableDef<Patient>;
      doctors: TableDef<Doctor>;
      doctor_specializations: TableDef<DoctorSpecialization>;
      doctor_clinics: TableDef<DoctorClinic>;
      clinic_staff: TableDef<ClinicStaff>;
      clinic_hours: TableDef<ClinicHours>;
      doctor_availability: TableDef<DoctorAvailability>;
      appointment_slots: TableDef<AppointmentSlot>;
      appointments: TableDef<Appointment>;
      appointment_status_history: TableDef<AppointmentStatusHistory>;
      check_ins: TableDef<CheckIn>;
      queue_token_counters: TableDef<{
        clinic_id: string;
        doctor_id: string;
        counter_date: string;
        last_number: number;
      }>;
      queue_entries: TableDef<QueueEntry>;
      queue_events: TableDef<QueueEvent>;
      notifications: TableDef<Notification>;
      consultations: TableDef<Consultation>;
      diagnoses: TableDef<Diagnosis>;
      treatment_plans: TableDef<TreatmentPlan>;
      medical_history: TableDef<MedicalHistoryRecord>;
      medicines: TableDef<Medicine>;
      prescriptions: TableDef<Prescription>;
      prescription_items: TableDef<PrescriptionItem>;
      medication_schedules: TableDef<MedicationSchedule>;
      follow_ups: TableDef<FollowUp>;
      reviews: TableDef<Review>;
      emergency_requests: TableDef<EmergencyRequest>;
      audit_logs: TableDef<AuditLog>;
      app_settings: TableDef<{ key: string; value: string; updated_at: string }>;
      ai_conversations: TableDef<AiConversation>;
      ai_messages: TableDef<AiMessage>;
    };
    Views: Record<string, never>;
    Functions: {
      ensure_slots: {
        Args: { p_doctor: string; p_clinic: string; p_date: string };
        Returns: AppointmentSlot[];
      };
      refresh_future_slots: { Args: { p_doctor: string; p_clinic: string }; Returns: undefined };
      book_appointment: {
        Args: { p_slot_id: string; p_visit_reason: string; p_patient_id?: string };
        Returns: Appointment;
      };
      reschedule_appointment: {
        Args: { p_appointment_id: string; p_new_slot_id: string; p_reason?: string };
        Returns: Appointment;
      };
      cancel_appointment: {
        Args: { p_appointment_id: string; p_reason?: string };
        Returns: Appointment;
      };
      confirm_appointment: { Args: { p_appointment_id: string }; Returns: Appointment };
      check_in_appointment: {
        Args: { p_appointment_id: string; p_method?: "APP" | "RECEPTIONIST" };
        Returns: QueueEntry;
      };
      create_walk_in: {
        Args: {
          p_clinic_id: string;
          p_doctor_id: string;
          p_patient_id: string;
          p_visit_reason: string;
          p_priority?: "NORMAL" | "HIGH" | "URGENT";
        };
        Returns: QueueEntry;
      };
      queue_call_next: { Args: { p_clinic_id: string; p_doctor_id: string }; Returns: QueueEntry };
      queue_call_specific: { Args: { p_queue_entry_id: string }; Returns: QueueEntry };
      queue_recall: { Args: { p_queue_entry_id: string }; Returns: QueueEntry };
      queue_return_to_waiting: { Args: { p_queue_entry_id: string }; Returns: QueueEntry };
      queue_skip: { Args: { p_queue_entry_id: string }; Returns: QueueEntry };
      queue_resume: { Args: { p_queue_entry_id: string }; Returns: QueueEntry };
      queue_set_priority: {
        Args: { p_queue_entry_id: string; p_priority: "NORMAL" | "HIGH" | "URGENT" };
        Returns: QueueEntry;
      };
      mark_no_show: { Args: { p_appointment_id: string }; Returns: Appointment };
      start_consultation: { Args: { p_appointment_id: string }; Returns: Consultation };
      complete_consultation: { Args: { p_consultation_id: string }; Returns: Consultation };
      notify_prescription_created: { Args: { p_prescription_id: string }; Returns: undefined };
      notify_follow_up_created: { Args: { p_follow_up_id: string }; Returns: undefined };
      ensure_medication_reminders: { Args: Record<string, never>; Returns: number };
      create_emergency_request: {
        Args: { p_description: string; p_location_text: string; p_latitude?: number | null; p_longitude?: number | null };
        Returns: EmergencyRequest;
      };
      emergency_advance_demo: { Args: { p_request_id: string }; Returns: EmergencyRequest };
    };
    Enums: {
      user_role: Profile["role"];
      appointment_status: Appointment["status"];
      queue_status: QueueEntry["status"];
      priority: QueueEntry["priority"];
      prescription_frequency: PrescriptionItem["frequency"];
    };
    CompositeTypes: Record<string, never>;
  };
};

/* ── Frequently used joined shapes ──────────────────────────────── */

export interface AppointmentWithRelations extends Appointment {
  appointments?: undefined;
  doctor?: { profiles?: { full_name: string } | null } & Doctor;
  patient?: { profiles?: { full_name: string } | null } & Patient;
  clinic?: Clinic;
}
