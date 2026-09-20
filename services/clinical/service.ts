import type { SupabaseClient } from "@supabase/supabase-js";
import type {
  Consultation,
  Diagnosis,
  FollowUp,
  MedicalHistoryRecord,
  Prescription,
  PrescriptionItem,
  MedicationSchedule,
  Patient,
} from "@/lib/types/database";
import type { ConsultationNotesInput, PrescriptionInput } from "@/lib/validation/clinical";
import { pageRange, totalPages, todayClinicDate } from "@/lib/utils";
import type { SearchResult } from "@/services/doctors/service";

/* ── Shared shapes ─────────────────────────────────────────────── */

export interface DoctorBrief {
  id: string;
  name: string;
  qualification: string;
}

interface RawDoctorEmbed {
  qualification: string;
  profile: { full_name: string } | null;
}

function mapDoctorBrief(doctor: RawDoctorEmbed | null): DoctorBrief {
  return {
    id: "",
    name: doctor?.profile?.full_name ?? "Doctor",
    qualification: doctor?.qualification ?? "",
  };
}

/* ── Doctor: consultation list ─────────────────────────────────── */

export interface ConsultationListItem {
  id: string;
  status: Consultation["status"];
  chief_complaint: string | null;
  started_at: string;
  completed_at: string | null;
  patient_name: string;
  appointment_date: string;
  appointment_time: string;
  has_prescription: boolean;
}

const CONSULTATION_LIST_SELECT = `
  id, status, chief_complaint, started_at, completed_at,
  patient:patients!consultations_patient_id_fkey(profile:profiles!patients_id_fkey(full_name)),
  appointment:appointments(appointment_date, start_time),
  prescriptions(id)
`;

interface RawConsultationRow {
  id: string;
  status: Consultation["status"];
  chief_complaint: string | null;
  started_at: string;
  completed_at: string | null;
  patient: { profile: { full_name: string } | null } | null;
  appointment: { appointment_date: string; start_time: string } | null;
  prescriptions: { id: string }[] | null;
}

function mapConsultationRow(row: RawConsultationRow): ConsultationListItem {
  return {
    id: row.id,
    status: row.status,
    chief_complaint: row.chief_complaint,
    started_at: row.started_at,
    completed_at: row.completed_at,
    patient_name: row.patient?.profile?.full_name ?? "Patient",
    appointment_date: row.appointment?.appointment_date ?? "",
    appointment_time: row.appointment?.start_time ?? "",
    has_prescription: (row.prescriptions?.length ?? 0) > 0,
  };
}

export const CONSULTATION_PAGE_SIZE = 10;

export async function listDoctorConsultations(
  client: SupabaseClient,
  doctorId: string,
  status: "IN_PROGRESS" | "COMPLETED" | undefined,
  page = 1,
  patientSearch?: string
): Promise<SearchResult<ConsultationListItem>> {
  let query = client
    .from("consultations")
    .select(CONSULTATION_LIST_SELECT, { count: "exact" })
    .eq("doctor_id", doctorId);
  if (status) query = query.eq("status", status);
  // Patient-name search: resolve ids from profiles first (PostgREST cannot
  // filter a parent by a child embed), same pattern as the staff search.
  if (patientSearch && patientSearch.trim().length > 0) {
    const { data: profileRows, error: profileError } = await client
      .from("profiles")
      .select("id")
      .eq("role", "PATIENT")
      .ilike("full_name", `%${patientSearch.trim()}%`)
      .limit(100);
    if (profileError) throw profileError;
    const patientIds = ((profileRows ?? []) as { id: string }[]).map((row) => row.id);
    if (patientIds.length === 0) {
      return {
        items: [],
        total: 0,
        page,
        pageSize: CONSULTATION_PAGE_SIZE,
        totalPages: 1,
      };
    }
    query = query.in("patient_id", patientIds);
  }
  query = query.order("started_at", { ascending: false });

  const { from, to } = pageRange(page, CONSULTATION_PAGE_SIZE);
  const { data, error, count } = await query.range(from, to);
  if (error) throw error;

  const items = ((data ?? []) as unknown as RawConsultationRow[]).map(mapConsultationRow);
  const total = count ?? items.length;
  return { items, total, page, pageSize: CONSULTATION_PAGE_SIZE, totalPages: totalPages(total, CONSULTATION_PAGE_SIZE) };
}

/* ── Doctor: consultation workspace ────────────────────────────── */

export interface PrescriptionItemView {
  id: string;
  medicine_name: string;
  generic_name: string | null;
  strength: string | null;
  dose: string;
  frequency: PrescriptionItem["frequency"];
  duration_days: number;
  instructions: string | null;
  food_relation: PrescriptionItem["food_relation"];
}

export interface PrescriptionView {
  id: string;
  notes: string | null;
  prescription_date: string;
  items: PrescriptionItemView[];
}

export interface FollowUpView {
  id: string;
  scheduled_date: string;
  reason: string;
  instructions: string | null;
  status: FollowUp["status"];
  doctor_name: string;
}

export interface DiagnosisView {
  id: string;
  name: string;
  description: string | null;
  code: string | null;
  is_primary: boolean;
}

export interface MedicalHistoryView {
  id: string;
  record_type: MedicalHistoryRecord["record_type"];
  title: string;
  description: string | null;
  is_active: boolean;
  recorded_at: string;
}

export interface ConsultationWorkspace {
  consultation: {
    id: string;
    status: Consultation["status"];
    chief_complaint: string | null;
    symptoms: string | null;
    clinical_notes: string | null;
    assessment: string | null;
    started_at: string;
    completed_at: string | null;
  };
  patient: {
    id: string;
    name: string;
    avatar_url: string | null;
    date_of_birth: string | null;
    sex: Patient["sex"];
    blood_group: string | null;
  };
  appointment: {
    id: string;
    date: string;
    start_time: string;
    status: string;
    visit_reason: string;
    type: "SCHEDULED" | "WALK_IN";
  };
  clinic_name: string;
  prescription: PrescriptionView | null;
  diagnoses: DiagnosisView[];
  followUps: FollowUpView[];
  medicalHistory: MedicalHistoryView[];
  pastConsultations: {
    id: string;
    started_at: string;
    chief_complaint: string | null;
    assessment: string | null;
    doctor_name: string;
    status: Consultation["status"];
  }[];
}

export async function getConsultationWorkspace(
  client: SupabaseClient,
  consultationId: string
): Promise<ConsultationWorkspace | null> {
  const { data, error } = await client
    .from("consultations")
    .select(
      `
      id, status, chief_complaint, symptoms, clinical_notes, assessment,
      started_at, completed_at, patient_id, clinic_id,
      patient:patients!consultations_patient_id_fkey(date_of_birth, sex, blood_group, profile:profiles!patients_id_fkey(full_name, avatar_url)),
      appointment:appointments(id, appointment_date, start_time, status, visit_reason, appointment_type),
      clinic:clinics(name),
      prescriptions(id, notes, prescription_date, prescription_items(
        id, medicine_name, generic_name, strength, dose, frequency,
        duration_days, instructions, food_relation
      ))
      `
    )
    .eq("id", consultationId)
    .maybeSingle();
  if (error) throw error;
  if (!data) return null;

  const row = data as unknown as {
    id: string;
    status: Consultation["status"];
    chief_complaint: string | null;
    symptoms: string | null;
    clinical_notes: string | null;
    assessment: string | null;
    started_at: string;
    completed_at: string | null;
    patient_id: string;
    clinic_id: string;
    patient: {
      date_of_birth: string | null;
      sex: Patient["sex"];
      blood_group: string | null;
      profile: { full_name: string; avatar_url: string | null } | null;
    } | null;
    appointment: {
      id: string;
      appointment_date: string;
      start_time: string;
      status: string;
      visit_reason: string;
      appointment_type: "SCHEDULED" | "WALK_IN";
    } | null;
    clinic: { name: string } | null;
    prescriptions: {
      id: string;
      notes: string | null;
      prescription_date: string;
      prescription_items: PrescriptionItemView[] | null;
    }[] | null;
  };

  const [diagnosesResult, followUpsResult, historyResult, pastResult] = await Promise.all([
    client
      .from("diagnoses")
      .select("id, name, description, code, is_primary")
      .eq("consultation_id", consultationId)
      .order("is_primary", { ascending: false })
      .order("created_at")
      .limit(20),
    client
      .from("follow_ups")
      .select("id, scheduled_date, reason, instructions, status, doctor:doctors!follow_ups_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name))")
      .eq("consultation_id", consultationId)
      .order("scheduled_date")
      .limit(10),
    client
      .from("medical_history")
      .select("id, record_type, title, description, is_active, recorded_at")
      .eq("patient_id", row.patient_id)
      .order("recorded_at", { ascending: false })
      .limit(50),
    client
      .from("consultations")
      .select(
        `id, started_at, chief_complaint, assessment, status,
         doctor:doctors!consultations_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name))`
      )
      .eq("patient_id", row.patient_id)
      .neq("id", consultationId)
      .order("started_at", { ascending: false })
      .limit(10),
  ]);
  if (diagnosesResult.error) throw diagnosesResult.error;
  if (followUpsResult.error) throw followUpsResult.error;
  if (historyResult.error) throw historyResult.error;
  if (pastResult.error) throw pastResult.error;

  const followUpRows = (followUpsResult.data ?? []) as unknown as {
    id: string;
    scheduled_date: string;
    reason: string;
    instructions: string | null;
    status: FollowUp["status"];
    doctor: RawDoctorEmbed | null;
  }[];

  const pastRows = (pastResult.data ?? []) as unknown as {
    id: string;
    started_at: string;
    chief_complaint: string | null;
    assessment: string | null;
    status: Consultation["status"];
    doctor: RawDoctorEmbed | null;
  }[];

  return {
    consultation: {
      id: row.id,
      status: row.status,
      chief_complaint: row.chief_complaint,
      symptoms: row.symptoms,
      clinical_notes: row.clinical_notes,
      assessment: row.assessment,
      started_at: row.started_at,
      completed_at: row.completed_at,
    },
    patient: {
      id: row.patient_id,
      name: row.patient?.profile?.full_name ?? "Patient",
      avatar_url: row.patient?.profile?.avatar_url ?? null,
      date_of_birth: row.patient?.date_of_birth ?? null,
      sex: row.patient?.sex ?? null,
      blood_group: row.patient?.blood_group ?? null,
    },
    appointment: {
      id: row.appointment?.id ?? "",
      date: row.appointment?.appointment_date ?? "",
      start_time: row.appointment?.start_time ?? "",
      status: row.appointment?.status ?? "",
      visit_reason: row.appointment?.visit_reason ?? "",
      type: row.appointment?.appointment_type ?? "SCHEDULED",
    },
    clinic_name: row.clinic?.name ?? "Clinic",
    prescription: row.prescriptions?.[0]
      ? {
          id: row.prescriptions[0].id,
          notes: row.prescriptions[0].notes,
          prescription_date: row.prescriptions[0].prescription_date,
          items: row.prescriptions[0].prescription_items ?? [],
        }
      : null,
    diagnoses: (diagnosesResult.data ?? []) as unknown as DiagnosisView[],
    followUps: followUpRows.map((fu) => ({
      id: fu.id,
      scheduled_date: fu.scheduled_date,
      reason: fu.reason,
      instructions: fu.instructions,
      status: fu.status,
      doctor_name: mapDoctorBrief(fu.doctor).name,
    })),
    medicalHistory: (historyResult.data ?? []) as unknown as MedicalHistoryView[],
    pastConsultations: pastRows.map((past) => ({
      id: past.id,
      started_at: past.started_at,
      chief_complaint: past.chief_complaint,
      assessment: past.assessment,
      doctor_name: mapDoctorBrief(past.doctor).name,
      status: past.status,
    })),
  };
}

/** Doctor saves the four narrative fields (direct update, RLS-guarded). */
export async function updateConsultationNotes(
  client: SupabaseClient,
  consultationId: string,
  input: ConsultationNotesInput
): Promise<void> {
  const { error } = await client
    .from("consultations")
    .update({
      chief_complaint: input.chief_complaint || null,
      symptoms: input.symptoms || null,
      clinical_notes: input.clinical_notes || null,
      assessment: input.assessment || null,
    })
    .eq("id", consultationId);
  if (error) throw error;
}

/**
 * Create the consultation's prescription (one per consultation) and its
 * items, then notify the patient. Prescription and items are separate
 * statements so the items' RLS check sees the committed prescription.
 */
export async function savePrescription(
  client: SupabaseClient,
  doctorId: string,
  input: PrescriptionInput
): Promise<{ prescriptionId: string; items: number }> {
  const { data: consultation, error: consultError } = await client
    .from("consultations")
    .select("id, patient_id, clinic_id, prescriptions(id)")
    .eq("id", input.consultationId)
    .maybeSingle();
  if (consultError) throw consultError;
  if (!consultation) throw new Error("[NOT_FOUND] Consultation not found");

  const row = consultation as unknown as {
    id: string;
    patient_id: string;
    clinic_id: string;
    prescriptions: { id: string }[] | null;
  };

  let prescriptionId = row.prescriptions?.[0]?.id ?? null;

  if (!prescriptionId) {
    const { data: created, error: insertError } = await client
      .from("prescriptions")
      .insert({
        consultation_id: row.id,
        patient_id: row.patient_id,
        doctor_id: doctorId,
        clinic_id: row.clinic_id,
        notes: input.notes || null,
      })
      .select("id")
      .single();
    if (insertError) throw insertError;
    prescriptionId = (created as { id: string }).id;
  } else if (input.notes) {
    await client
      .from("prescriptions")
      .update({ notes: input.notes })
      .eq("id", prescriptionId);
  }

  const { error: itemsError } = await client.from("prescription_items").insert(
    input.items.map((item) => ({
      prescription_id: prescriptionId,
      medicine_name: item.medicine_name,
      generic_name: item.generic_name || null,
      strength: item.strength || null,
      dose: item.dose,
      frequency: item.frequency,
      duration_days: item.duration_days,
      instructions: item.instructions || null,
      food_relation: item.food_relation,
    }))
  );
  if (itemsError) throw itemsError;

  // Patient notification (the schedules were generated by the DB trigger).
  const { error: notifyError } = await client.rpc("notify_prescription_created", {
    p_prescription_id: prescriptionId,
  });
  if (notifyError) throw notifyError;

  return { prescriptionId, items: input.items.length };
}

export async function addDiagnosis(
  client: SupabaseClient,
  consultationId: string,
  patientId: string,
  input: { name: string; description?: string; code?: string; is_primary: boolean }
): Promise<DiagnosisView> {
  const { data, error } = await client
    .from("diagnoses")
    .insert({
      consultation_id: consultationId,
      patient_id: patientId,
      name: input.name,
      description: input.description || null,
      code: input.code || null,
      is_primary: input.is_primary,
    })
    .select("id, name, description, code, is_primary")
    .single();
  if (error) throw error;
  void patientId;
  return data as unknown as DiagnosisView;
}

export async function addMedicalHistory(
  client: SupabaseClient,
  doctorId: string,
  patientId: string,
  input: { record_type: string; title: string; description?: string }
): Promise<MedicalHistoryView> {
  const { data, error } = await client
    .from("medical_history")
    .insert({
      patient_id: patientId,
      record_type: input.record_type,
      title: input.title,
      description: input.description || null,
      recorded_by: doctorId,
    })
    .select("id, record_type, title, description, is_active, recorded_at")
    .single();
  if (error) throw error;
  return data as unknown as MedicalHistoryView;
}

export async function scheduleFollowUp(
  client: SupabaseClient,
  doctorId: string,
  consultationId: string,
  input: { scheduled_date: string; reason: string; instructions?: string }
): Promise<{ followUpId: string }> {
  const { data: consultation, error: consultError } = await client
    .from("consultations")
    .select("id, patient_id, clinic_id")
    .eq("id", consultationId)
    .maybeSingle();
  if (consultError) throw consultError;
  const row = consultation as unknown as { id: string; patient_id: string; clinic_id: string } | null;
  if (!row) throw new Error("[NOT_FOUND] Consultation not found");

  const { data, error } = await client
    .from("follow_ups")
    .insert({
      consultation_id: row.id,
      patient_id: row.patient_id,
      doctor_id: doctorId,
      clinic_id: row.clinic_id,
      scheduled_date: input.scheduled_date,
      reason: input.reason,
      instructions: input.instructions || null,
    })
    .select("id")
    .single();
  if (error) throw error;

  const followUpId = (data as { id: string }).id;
  const { error: notifyError } = await client.rpc("notify_follow_up_created", {
    p_follow_up_id: followUpId,
  });
  if (notifyError) throw notifyError;

  return { followUpId };
}

/* ── Doctor: patient directory ─────────────────────────────────── */

export interface DoctorPatientItem {
  id: string;
  name: string;
  avatar_url: string | null;
  date_of_birth: string | null;
  sex: Patient["sex"];
  visits: number;
  last_visit: string | null;
  upcoming: number;
}

const PATIENT_FETCH_CAP = 500;

export async function listDoctorPatients(
  client: SupabaseClient,
  doctorId: string,
  query: string,
  page: number
): Promise<SearchResult<DoctorPatientItem>> {
  const [apptResult, consultResult] = await Promise.all([
    client
      .from("appointments")
      .select("patient_id, appointment_date, status")
      .eq("doctor_id", doctorId)
      .limit(1000),
    client
      .from("consultations")
      .select("patient_id")
      .eq("doctor_id", doctorId)
      .limit(1000),
  ]);
  if (apptResult.error) throw apptResult.error;
  if (consultResult.error) throw consultResult.error;

  const apptRows = (apptResult.data ?? []) as unknown as { patient_id: string; appointment_date: string; status: string }[];
  const consultIds = ((consultResult.data ?? []) as { patient_id: string }[]).map((r) => r.patient_id);
  const patientIds = Array.from(new Set([...apptRows.map((r) => r.patient_id), ...consultIds]));
  if (patientIds.length === 0) {
    return { items: [], total: 0, page, pageSize: 20, totalPages: 1 };
  }

  // Stats per patient from the appointment rows we already fetched.
  const stats = new Map<string, { visits: number; last_visit: string | null; upcoming: number }>();
  for (const appt of apptRows) {
    const stat = stats.get(appt.patient_id) ?? { visits: 0, last_visit: null, upcoming: 0 };
    if (["COMPLETED"].includes(appt.status)) {
      stat.visits += 1;
      if (!stat.last_visit || appt.appointment_date > stat.last_visit) stat.last_visit = appt.appointment_date;
    } else if (["BOOKED", "CONFIRMED", "CHECKED_IN", "WAITING", "CALLED", "IN_CONSULTATION"].includes(appt.status)) {
      stat.upcoming += 1;
    }
    stats.set(appt.patient_id, stat);
  }

  let patientsQuery = client
    .from("patients")
    .select("id, date_of_birth, sex, profile:profiles!patients_id_fkey(full_name, avatar_url)")
    .in("id", patientIds.slice(0, PATIENT_FETCH_CAP));
  if (query) {
    patientsQuery = patientsQuery.ilike("profile.full_name", `%${query}%`);
  }

  const { data, error } = await patientsQuery.limit(PATIENT_FETCH_CAP);
  if (error) throw error;

  const rows = (data ?? []) as unknown as {
    id: string;
    date_of_birth: string | null;
    sex: Patient["sex"];
    profile: { full_name: string; avatar_url: string | null } | null;
  }[];

  const items: DoctorPatientItem[] = rows
    .map((row) => ({
      id: row.id,
      name: row.profile?.full_name ?? "Patient",
      avatar_url: row.profile?.avatar_url ?? null,
      date_of_birth: row.date_of_birth,
      sex: row.sex,
      visits: stats.get(row.id)?.visits ?? 0,
      last_visit: stats.get(row.id)?.last_visit ?? null,
      upcoming: stats.get(row.id)?.upcoming ?? 0,
    }))
    .sort((a, b) => a.name.localeCompare(b.name));

  const { from, to } = pageRange(page, 20);
  return {
    items: items.slice(from, to + 1),
    total: items.length,
    page,
    pageSize: 20,
    totalPages: totalPages(items.length, 20),
  };
}

/* ── Patient views ─────────────────────────────────────────────── */

export interface PatientPrescription {
  id: string;
  prescription_date: string;
  status: Prescription["status"];
  notes: string | null;
  doctor_name: string;
  doctor_qualification: string;
  clinic_name: string;
  items: PrescriptionItemView[];
}

const PATIENT_RX_SELECT = `
  id, prescription_date, status, notes,
  doctor:doctors!prescriptions_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name)),
  clinic:clinics(name),
  prescription_items(id, medicine_name, generic_name, strength, dose, frequency,
                     duration_days, instructions, food_relation)
`;

interface RawPatientRxRow {
  id: string;
  prescription_date: string;
  status: Prescription["status"];
  notes: string | null;
  doctor: RawDoctorEmbed | null;
  clinic: { name: string } | null;
  prescription_items: PrescriptionItemView[] | null;
}

function mapPatientRx(row: RawPatientRxRow): PatientPrescription {
  return {
    id: row.id,
    prescription_date: row.prescription_date,
    status: row.status,
    notes: row.notes,
    doctor_name: mapDoctorBrief(row.doctor).name,
    doctor_qualification: mapDoctorBrief(row.doctor).qualification,
    clinic_name: row.clinic?.name ?? "Clinic",
    items: row.prescription_items ?? [],
  };
}

export const RX_PAGE_SIZE = 10;

export async function listPatientPrescriptions(
  client: SupabaseClient,
  patientId: string,
  page = 1
): Promise<SearchResult<PatientPrescription>> {
  const { from, to } = pageRange(page, RX_PAGE_SIZE);
  const { data, error, count } = await client
    .from("prescriptions")
    .select(PATIENT_RX_SELECT, { count: "exact" })
    .eq("patient_id", patientId)
    .order("prescription_date", { ascending: false })
    .order("created_at", { ascending: false })
    .range(from, to);
  if (error) throw error;
  const items = ((data ?? []) as unknown as RawPatientRxRow[]).map(mapPatientRx);
  const total = count ?? items.length;
  return { items, total, page, pageSize: RX_PAGE_SIZE, totalPages: totalPages(total, RX_PAGE_SIZE) };
}

export interface MedicationCourse {
  itemId: string;
  prescriptionId: string;
  medicine_name: string;
  dose: string;
  instructions: string | null;
  food_relation: PrescriptionItem["food_relation"];
  start_date: string;
  end_date: string;
  times: string[];
}

/** Active medication courses (grouped from the schedule rows the DB generates). */
export async function listActiveMedications(
  client: SupabaseClient,
  patientId: string
): Promise<MedicationCourse[]> {
  const today = todayClinicDate();
  const { data, error } = await client
    .from("medication_schedules")
    .select(
      `id, prescription_item_id, prescription_id, medicine_name, dose, time_of_day,
       start_date, end_date, instructions, food_relation, status`
    )
    .eq("patient_id", patientId)
    .eq("status", "ACTIVE")
    .gte("end_date", today)
    .order("time_of_day")
    .limit(300);
  if (error) throw error;

  const rows = (data ?? []) as unknown as {
    id: string;
    prescription_item_id: string;
    prescription_id: string;
    medicine_name: string;
    dose: string;
    time_of_day: string;
    start_date: string;
    end_date: string;
    instructions: string | null;
    food_relation: PrescriptionItem["food_relation"];
    status: MedicationSchedule["status"];
  }[];

  const byItem = new Map<string, MedicationCourse>();
  for (const row of rows) {
    const course = byItem.get(row.prescription_item_id);
    if (course) {
      course.times.push(row.time_of_day);
    } else {
      byItem.set(row.prescription_item_id, {
        itemId: row.prescription_item_id,
        prescriptionId: row.prescription_id,
        medicine_name: row.medicine_name,
        dose: row.dose,
        instructions: row.instructions,
        food_relation: row.food_relation,
        start_date: row.start_date,
        end_date: row.end_date,
        times: [row.time_of_day],
      });
    }
  }
  return Array.from(byItem.values());
}

export interface PatientFollowUpItem {
  id: string;
  scheduled_date: string;
  reason: string;
  instructions: string | null;
  status: FollowUp["status"];
  doctor_name: string;
}

export async function listPatientFollowUps(
  client: SupabaseClient,
  patientId: string
): Promise<{ upcoming: PatientFollowUpItem[]; past: PatientFollowUpItem[] }> {
  const { data, error } = await client
    .from("follow_ups")
    .select(
      `id, scheduled_date, reason, instructions, status,
       doctor:doctors!follow_ups_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name))`
    )
    .eq("patient_id", patientId)
    .order("scheduled_date", { ascending: false })
    .limit(200);
  if (error) throw error;

  const today = todayClinicDate();
  const rows = (data ?? []) as unknown as {
    id: string;
    scheduled_date: string;
    reason: string;
    instructions: string | null;
    status: FollowUp["status"];
    doctor: RawDoctorEmbed | null;
  }[];

  const mapped: PatientFollowUpItem[] = rows.map((row) => ({
    id: row.id,
    scheduled_date: row.scheduled_date,
    reason: row.reason,
    instructions: row.instructions,
    status: row.status,
    doctor_name: mapDoctorBrief(row.doctor).name,
  }));

  return {
    upcoming: mapped.filter((fu) => fu.status === "SCHEDULED" && fu.scheduled_date >= today).reverse(),
    past: mapped.filter((fu) => !(fu.status === "SCHEDULED" && fu.scheduled_date >= today)),
  };
}

export interface TimelineEntry {
  kind: "HISTORY" | "CONSULTATION" | "PRESCRIPTION";
  date: string;
  title: string;
  description: string | null;
  meta: string;
  id: string;
}

/** Merged medical timeline for the patient records page. */
export async function getPatientTimeline(
  client: SupabaseClient,
  patientId: string
): Promise<{ entries: TimelineEntry[]; allergies: string[]; conditions: string[] }> {
  const [historyResult, consultResult, rxResult] = await Promise.all([
    client
      .from("medical_history")
      .select("id, record_type, title, description, is_active, recorded_at")
      .eq("patient_id", patientId)
      .order("recorded_at", { ascending: false })
      .limit(100),
    client
      .from("consultations")
      .select(
        `id, started_at, chief_complaint, assessment, status,
         doctor:doctors!consultations_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name)),
         diagnoses(id)`
      )
      .eq("patient_id", patientId)
      .order("started_at", { ascending: false })
      .limit(50),
    client
      .from("prescriptions")
      .select(
        `id, prescription_date, notes,
         doctor:doctors!prescriptions_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name)),
         prescription_items(id)`
      )
      .eq("patient_id", patientId)
      .order("prescription_date", { ascending: false })
      .limit(50),
  ]);
  if (historyResult.error) throw historyResult.error;
  if (consultResult.error) throw consultResult.error;
  if (rxResult.error) throw rxResult.error;

  const historyRows = (historyResult.data ?? []) as unknown as MedicalHistoryView[];
  const consultRows = (consultResult.data ?? []) as unknown as {
    id: string;
    started_at: string;
    chief_complaint: string | null;
    assessment: string | null;
    status: Consultation["status"];
    doctor: RawDoctorEmbed | null;
    diagnoses: { id: string }[] | null;
  }[];
  const rxRows = (rxResult.data ?? []) as unknown as {
    id: string;
    prescription_date: string;
    notes: string | null;
    doctor: RawDoctorEmbed | null;
    prescription_items: { id: string }[] | null;
  }[];

  const entries: TimelineEntry[] = [
    ...historyRows.map((row): TimelineEntry => ({
      kind: "HISTORY",
      id: row.id,
      date: row.recorded_at.slice(0, 10),
      title: row.title,
      description: row.description,
      meta: row.record_type,
    })),
    ...consultRows.map((row): TimelineEntry => ({
      kind: "CONSULTATION",
      id: row.id,
      date: row.started_at.slice(0, 10),
      title: row.chief_complaint || "Consultation",
      description: row.assessment,
      meta: mapDoctorBrief(row.doctor).name,
    })),
    ...rxRows.map((row): TimelineEntry => ({
      kind: "PRESCRIPTION",
      id: row.id,
      date: row.prescription_date,
      title: `Prescription — ${row.prescription_items?.length ?? 0} medicine${(row.prescription_items?.length ?? 0) === 1 ? "" : "s"}`,
      description: row.notes,
      meta: mapDoctorBrief(row.doctor).name,
    })),
  ].sort((a, b) => b.date.localeCompare(a.date));

  return {
    entries,
    allergies: historyRows
      .filter((row) => row.record_type === "ALLERGY" && row.is_active)
      .map((row) => row.title),
    conditions: historyRows
      .filter((row) => row.record_type === "CHRONIC_CONDITION" && row.is_active)
      .map((row) => row.title),
  };
}

/** Doctor-facing patient overview (records the doctor is allowed to see). */
export async function getPatientOverview(
  client: SupabaseClient,
  patientId: string
): Promise<{
  patient: ConsultationWorkspace["patient"];
  medicalHistory: MedicalHistoryView[];
  consultations: ConsultationListItem[];
  prescriptions: PatientPrescription[];
  followUps: PatientFollowUpItem[];
} | null> {
  const { data: patientRow, error: patientError } = await client
    .from("patients")
    .select("id, date_of_birth, sex, blood_group, profile:profiles!patients_id_fkey(full_name, avatar_url)")
    .eq("id", patientId)
    .maybeSingle();
  if (patientError) throw patientError;
  if (!patientRow) return null;
  const row = patientRow as unknown as {
    id: string;
    date_of_birth: string | null;
    sex: Patient["sex"];
    blood_group: string | null;
    profile: { full_name: string; avatar_url: string | null } | null;
  };

  const [historyResult, consultResult, rxResult, fuResult] = await Promise.all([
    client
      .from("medical_history")
      .select("id, record_type, title, description, is_active, recorded_at")
      .eq("patient_id", patientId)
      .order("recorded_at", { ascending: false })
      .limit(50),
    client
      .from("consultations")
      .select(CONSULTATION_LIST_SELECT)
      .eq("patient_id", patientId)
      .order("started_at", { ascending: false })
      .limit(20),
    client
      .from("prescriptions")
      .select(PATIENT_RX_SELECT)
      .eq("patient_id", patientId)
      .order("prescription_date", { ascending: false })
      .limit(20),
    client
      .from("follow_ups")
      .select(
        `id, scheduled_date, reason, instructions, status,
         doctor:doctors!follow_ups_doctor_id_fkey(qualification, profile:profiles!doctors_id_fkey(full_name))`
      )
      .eq("patient_id", patientId)
      .order("scheduled_date", { ascending: false })
      .limit(20),
  ]);
  if (historyResult.error) throw historyResult.error;
  if (consultResult.error) throw consultResult.error;
  if (rxResult.error) throw rxResult.error;
  if (fuResult.error) throw fuResult.error;

  const fuRows = (fuResult.data ?? []) as unknown as {
    id: string;
    scheduled_date: string;
    reason: string;
    instructions: string | null;
    status: FollowUp["status"];
    doctor: RawDoctorEmbed | null;
  }[];

  return {
    patient: {
      id: row.id,
      name: row.profile?.full_name ?? "Patient",
      avatar_url: row.profile?.avatar_url ?? null,
      date_of_birth: row.date_of_birth,
      sex: row.sex,
      blood_group: row.blood_group,
    },
    medicalHistory: (historyResult.data ?? []) as unknown as MedicalHistoryView[],
    consultations: ((consultResult.data ?? []) as unknown as RawConsultationRow[]).map(mapConsultationRow),
    prescriptions: ((rxResult.data ?? []) as unknown as RawPatientRxRow[]).map(mapPatientRx),
    followUps: fuRows.map((fu) => ({
      id: fu.id,
      scheduled_date: fu.scheduled_date,
      reason: fu.reason,
      instructions: fu.instructions,
      status: fu.status,
      doctor_name: mapDoctorBrief(fu.doctor).name,
    })),
  };
}

export type { Diagnosis, FollowUp, MedicalHistoryRecord as MedicalHistory };
