import fs from "fs";
import path from "path";
import crypto from "crypto";

const outDir = path.join(process.cwd(), "scratch", "sql_chunks");
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

function escapeSql(val: any): string {
  if (val === null || val === undefined) return "NULL";
  if (typeof val === "boolean") return val ? "true" : "false";
  if (typeof val === "number") return String(val);
  return "'" + String(val).replace(/'/g, "''") + "'";
}

const LOGGED_IN_USER_ID = "361dd8a5-1392-44a6-b682-4306ebbf5836";

const DOCTORS = [
  {"doctor_id":"00000000-0000-0000-0000-000000000002","clinic_id":"a923ac40-1961-4256-b903-4cffc4464ad4","full_name":"Dr. Aarav Deshmukh"},
  {"doctor_id":"040d22e0-4981-4b50-a339-696906276686","clinic_id":"9defe45b-25a6-4d52-adc3-8082c8a8f56f","full_name":"Dr. Priya Nair"},
  {"doctor_id":"438d6569-0c7a-40ae-909c-53c46e69827d","clinic_id":"274970a3-9522-4dbe-9d41-cc2e32b184ca","full_name":"Dr. Rohan Rao"},
  {"doctor_id":"cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7","clinic_id":"88e85be0-2235-4bf6-a389-0ae62ceabb8d","full_name":"Dr. Tanvi Reddy"},
  {"doctor_id":"f5a975b1-b727-49a1-afc8-a306cc87ded8","clinic_id":"b9c5ff36-4ef4-441e-b442-775663d8652a","full_name":"Dr. Shreya Deshmukh"},
  {"doctor_id":"7c77a23d-3109-4106-84ab-779310e1b5b3","clinic_id":"b75a94a9-eb46-4308-a3ee-2276bf0ae432","full_name":"Dr. Swati Kulkarni"},
  {"doctor_id":"5b7a2255-1585-403a-8189-35edf717d208","clinic_id":"e36436e7-563f-4696-a061-c137ca91a8e0","full_name":"Dr. Aarti Rao"},
  {"doctor_id":"1f8756fd-2a09-4bc7-992f-155f6901693c","clinic_id":"ec931301-ad5c-4e14-9c3e-ea0332475701","full_name":"Dr. Abhishek Nair"}
];

const PATIENTS = [
  "088b9e7b-5c17-4e89-b37f-d709bd9c053b",
  "16cc854d-827c-4a36-8653-e5237772f046",
  "a575786b-e181-4935-8d89-06a5ad722adb",
  "53bfa8d9-f36c-4207-8092-d833c7ccf6df",
  "6a86b9e5-56db-44c1-b67e-8dd92fd0cc56",
  "711cde25-d481-4812-bc2b-6770e6881b1d",
  "6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7",
  "40133434-eb9d-4e89-9fac-130d00f8bd99",
  "387eb9a0-71c4-4846-a8b9-e3b30c7b1a90",
  "651f1079-3801-4852-8b03-d9e272b42ffc",
  "dca33f00-00a3-46cd-ae8b-69f3f612d5ee",
  "7ff9b795-eb07-40c2-9cc9-568c14f652ec"
];

const times = [
  "09:00:00", "09:15:00", "09:30:00", "09:45:00",
  "10:00:00", "10:15:00", "10:30:00", "10:45:00",
  "11:00:00", "11:15:00", "11:30:00", "11:45:00",
  "14:00:00", "14:15:00", "14:30:00", "14:45:00",
  "15:00:00", "15:15:00", "15:30:00", "15:45:00",
];

const today = "2026-09-17";

const stmtsPart1: string[] = [];
const stmtsPart2: string[] = [];

// 1. Demo Doctor at Sai Polyclinic:
const demoDoc = DOCTORS[0];

// Patient 1 - In Consultation (Token T001)
const slot1Id = crypto.randomUUID();
const appt1Id = crypto.randomUUID();
stmtsPart1.push(`
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('${slot1Id}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${today}', '09:00:00', '09:15:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('${appt1Id}', '${PATIENTS[0]}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${slot1Id}', 'SCHEDULED', 'IN_CONSULTATION', '${today}', '09:00:00', '09:15:00', 'Chronic hypertension and monthly blood pressure follow-up')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
  VALUES ('${appt1Id}', '${PATIENTS[0]}', '${demoDoc.clinic_id}', 'APP')
  ON CONFLICT (appointment_id) DO NOTHING;

  INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
  VALUES ('${demoDoc.clinic_id}', '${demoDoc.doctor_id}', '${PATIENTS[0]}', '${appt1Id}', '${today}', 1, 'T001', 'NORMAL', 'IN_CONSULTATION')
  ON CONFLICT (appointment_id) DO NOTHING;
`);

// Patient 2 - Waiting (Token T002)
const slot2Id = crypto.randomUUID();
const appt2Id = crypto.randomUUID();
stmtsPart1.push(`
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('${slot2Id}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${today}', '09:15:00', '09:30:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('${appt2Id}', '${PATIENTS[1]}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${slot2Id}', 'SCHEDULED', 'WAITING', '${today}', '09:15:00', '09:30:00', 'Skin rash and allergic dry dermatitis')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
  VALUES ('${appt2Id}', '${PATIENTS[1]}', '${demoDoc.clinic_id}', 'APP')
  ON CONFLICT (appointment_id) DO NOTHING;

  INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
  VALUES ('${demoDoc.clinic_id}', '${demoDoc.doctor_id}', '${PATIENTS[1]}', '${appt2Id}', '${today}', 2, 'T002', 'NORMAL', 'WAITING')
  ON CONFLICT (appointment_id) DO NOTHING;
`);

// Logged In User - Waiting (Token T003)
const slot3Id = crypto.randomUUID();
const appt3Id = crypto.randomUUID();
stmtsPart1.push(`
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('${slot3Id}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${today}', '09:30:00', '09:45:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('${appt3Id}', '${LOGGED_IN_USER_ID}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${slot3Id}', 'SCHEDULED', 'WAITING', '${today}', '09:30:00', '09:45:00', 'Routine general health checkup and seasonal flu consultation')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
  VALUES ('${appt3Id}', '${LOGGED_IN_USER_ID}', '${demoDoc.clinic_id}', 'APP')
  ON CONFLICT (appointment_id) DO NOTHING;

  INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
  VALUES ('${demoDoc.clinic_id}', '${demoDoc.doctor_id}', '${LOGGED_IN_USER_ID}', '${appt3Id}', '${today}', 3, 'T003', 'NORMAL', 'WAITING')
  ON CONFLICT (appointment_id) DO NOTHING;
`);

// Free slots for Demo Doctor today
for (let t = 3; t < times.length; t++) {
  const sId = crypto.randomUUID();
  const startTime = times[t];
  const [h, m] = startTime.split(":").map(Number);
  const endMinutes = m + 15;
  const endTime = `${String(endMinutes >= 60 ? h + 1 : h).padStart(2, "0")}:${String(endMinutes % 60).padStart(2, "0")}:00`;

  stmtsPart1.push(`
    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('${sId}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${today}', '${startTime}', '${endTime}', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  `);
}

// 2. Slots and Queues for other doctors (Doctor 1 to 3) in Part 1
for (let d = 1; d <= 3; d++) {
  const doc = DOCTORS[d];
  const p1 = PATIENTS[d * 2];
  const p2 = PATIENTS[d * 2 + 1];

  const s1 = crypto.randomUUID();
  const a1 = crypto.randomUUID();
  stmtsPart1.push(`
    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('${s1}', '${doc.doctor_id}', '${doc.clinic_id}', '${today}', '09:00:00', '09:15:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('${a1}', '${p1}', '${doc.doctor_id}', '${doc.clinic_id}', '${s1}', 'SCHEDULED', 'IN_CONSULTATION', '${today}', '09:00:00', '09:15:00', 'Routine checkup and consultation')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('${a1}', '${p1}', '${doc.clinic_id}', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('${doc.clinic_id}', '${doc.doctor_id}', '${p1}', '${a1}', '${today}', 1, 'T001', 'NORMAL', 'IN_CONSULTATION')
    ON CONFLICT (appointment_id) DO NOTHING;
  `);

  const s2 = crypto.randomUUID();
  const a2 = crypto.randomUUID();
  stmtsPart1.push(`
    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('${s2}', '${doc.doctor_id}', '${doc.clinic_id}', '${today}', '09:15:00', '09:30:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('${a2}', '${p2}', '${doc.doctor_id}', '${doc.clinic_id}', '${s2}', 'SCHEDULED', 'WAITING', '${today}', '09:15:00', '09:30:00', 'Evaluation and prescription renewal')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('${a2}', '${p2}', '${doc.clinic_id}', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('${doc.clinic_id}', '${doc.doctor_id}', '${p2}', '${a2}', '${today}', 2, 'T002', 'NORMAL', 'WAITING')
    ON CONFLICT (appointment_id) DO NOTHING;
  `);

  // Free slots
  for (let t = 2; t < 10; t++) {
    const sId = crypto.randomUUID();
    const startTime = times[t];
    const [h, m] = startTime.split(":").map(Number);
    const endMinutes = m + 15;
    const endTime = `${String(endMinutes >= 60 ? h + 1 : h).padStart(2, "0")}:${String(endMinutes % 60).padStart(2, "0")}:00`;

    stmtsPart1.push(`
      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('${sId}', '${doc.doctor_id}', '${doc.clinic_id}', '${today}', '${startTime}', '${endTime}', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    `);
  }
}

// 3. Past Consultation, Prescription & Medical Records for Logged-In User in Part 2
const pastSlotId = crypto.randomUUID();
const pastApptId = crypto.randomUUID();
const pastConsultId = crypto.randomUUID();
const pastPrescriptionId = crypto.randomUUID();

stmtsPart2.push(`
  -- Past Appointment
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('${pastSlotId}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '2026-09-10', '10:00:00', '10:15:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, notes)
  VALUES ('${pastApptId}', '${LOGGED_IN_USER_ID}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '${pastSlotId}', 'SCHEDULED', 'COMPLETED', '2026-09-10', '10:00:00', '10:15:00', 'Persistent dry cough and mild fever', 'Patient advised to complete 5-day course and rest.')
  ON CONFLICT (id) DO NOTHING;

  -- Past Consultation
  INSERT INTO public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, consultation_date, chief_complaint, symptoms, examination_findings, diagnosis, treatment_plan, follow_up_date, vitals)
  VALUES (
    '${pastConsultId}', '${pastApptId}', '${LOGGED_IN_USER_ID}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}', '2026-09-10',
    'Dry cough for 3 days, low-grade fever, sore throat',
    'Throat irritation, dry cough aggravated at night, mild fatigue',
    'Pharyngeal erythema present. Lungs clear to auscultation bilaterally. No lymphadenopathy.',
    'Acute viral pharyngitis with mild upper respiratory tract infection',
    'Hydration, steam inhalation twice daily, oral antipyretic SOS, warm saline gargles.',
    '2026-09-17',
    '{"bp_systolic": 120, "bp_diastolic": 80, "heart_rate": 74, "temperature": 99.1, "spo2": 98, "weight_kg": 70}'::jsonb
  ) ON CONFLICT (id) DO NOTHING;

  -- Past Prescription
  INSERT INTO public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, notes)
  VALUES (
    '${pastPrescriptionId}', '${pastConsultId}', '${LOGGED_IN_USER_ID}', '${demoDoc.doctor_id}', '${demoDoc.clinic_id}',
    'Take medications after meals with plenty of water. Avoid cold beverages.'
  ) ON CONFLICT (id) DO NOTHING;

  -- Prescription Items (referencing valid medicines from 01_reference.sql)
  INSERT INTO public.prescription_items (prescription_id, medicine_id, custom_medicine_name, dosage, frequency, duration, instructions)
  SELECT 
    '${pastPrescriptionId}',
    id,
    null,
    '500mg',
    '1-0-1',
    '5 days',
    'Take after meals'
  FROM public.medicines
  WHERE name ILIKE '%Paracetamol%' OR name ILIKE '%Crocin%'
  LIMIT 1
  ON CONFLICT DO NOTHING;

  INSERT INTO public.prescription_items (prescription_id, medicine_id, custom_medicine_name, dosage, frequency, duration, instructions)
  SELECT 
    '${pastPrescriptionId}',
    id,
    null,
    '10mg',
    '0-0-1',
    '5 days',
    'Take before sleep'
  FROM public.medicines
  WHERE name ILIKE '%Cetirizine%' OR name ILIKE '%Montair%'
  LIMIT 1
  ON CONFLICT DO NOTHING;
`);

fs.writeFileSync(path.join(outDir, "chunk_06_real_1.sql"), stmtsPart1.join("\n"));
fs.writeFileSync(path.join(outDir, "chunk_06_real_2.sql"), stmtsPart2.join("\n"));

console.log("Successfully generated real appointment SQL files!");
