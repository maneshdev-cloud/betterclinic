import fs from "fs";
import path from "path";

import crypto from "crypto";

// Deterministic Pseudo-Random Number Generator (LCG)
class PRNG {
  private seed: number;
  constructor(seed: number = 42) {
    this.seed = seed;
  }
  next(): number {
    this.seed = (this.seed * 1664525 + 1013904223) % 4294967296;
    return this.seed / 4294967296;
  }
  int(min: number, max: number): number {
    return Math.floor(this.next() * (max - min + 1)) + min;
  }
  pick<T>(array: readonly T[] | T[]): T {
    return array[this.int(0, array.length - 1)];
  }
  uuid(): string {
    return crypto.randomUUID();
  }
  phone(): string {
    return `+91${this.pick(["98", "99", "97", "96", "95", "93", "91", "88", "87", "86", "84", "77", "75"])}${this.int(10000000, 99999999)}`;
  }
  dateBetween(start: Date, end: Date): Date {
    return new Date(start.getTime() + this.next() * (end.getTime() - start.getTime()));
  }
  dateString(d: Date): string {
    return d.toISOString().slice(0, 10);
  }
}

const rng = new PRNG(12345);

const outDir = path.join(process.cwd(), "scratch", "sql_chunks");
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

function escapeSql(val: any): string {
  if (val === null || val === undefined) return "NULL";
  if (typeof val === "boolean") return val ? "true" : "false";
  if (typeof val === "number") return String(val);
  return "'" + String(val).replace(/'/g, "''") + "'";
}

function slugify(s: string): string {
  return s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
}

const FIRST_NAMES_MALE = [
  "Aarav", "Rohan", "Vikram", "Aditya", "Rahul", "Siddharth", "Arjun", "Karan",
  "Nikhil", "Pranav", "Varun", "Abhishek", "Sameer", "Gaurav", "Amit", "Kunal"
];
const FIRST_NAMES_FEMALE = [
  "Priya", "Ananya", "Sneha", "Pooja", "Neha", "Rhea", "Tanvi", "Isha",
  "Kavita", "Deepa", "Meera", "Swati", "Shreya", "Sunita", "Aarti", "Divya"
];
const LAST_NAMES = [
  "Sharma", "Patel", "Verma", "Joshi", "Deshmukh", "Kulkarni", "Mehta", "Shah",
  "Nair", "Pillai", "Reddy", "Rao", "Iyer", "Gupta", "Malhotra", "Kapoor"
];
const BLOOD_GROUPS = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

function randomPerson(r: PRNG) {
  const isMale = r.next() > 0.5;
  const firstName = isMale ? r.pick(FIRST_NAMES_MALE) : r.pick(FIRST_NAMES_FEMALE);
  const lastName = r.pick(LAST_NAMES);
  return {
    firstName,
    lastName,
    fullName: `${firstName} ${lastName}`,
    sex: isMale ? "MALE" : "FEMALE",
  };
}

const EXISTING_CLINICS = [
  {"id":"9defe45b-25a6-4d52-adc3-8082c8a8f56f","name":"Aarogya Diagnostic Centre (Kandivali)","city":"Mumbai","area":"Kandivali","invite_code":"AARO238"},
  {"id":"274970a3-9522-4dbe-9d41-cc2e32b184ca","name":"Aarogya Health Centre (Naupada)","city":"Thane","area":"Naupada","invite_code":"AARO935"},
  {"id":"88e85be0-2235-4bf6-a389-0ae62ceabb8d","name":"Aarogya Nursing Home (Sion)","city":"Mumbai","area":"Sion","invite_code":"AARO612"},
  {"id":"b9c5ff36-4ef4-441e-b442-775663d8652a","name":"Aarogya Polyclinic (Vile Parle)","city":"Mumbai","area":"Vile Parle","invite_code":"AARO293"},
  {"id":"b75a94a9-eb46-4308-a3ee-2276bf0ae432","name":"Advanced Day Care Centre (Pokhran Road)","city":"Thane","area":"Pokhran Road","invite_code":"ADVA611"},
  {"id":"e36436e7-563f-4696-a061-c137ca91a8e0","name":"Apollo Day Care Centre (Wadala)","city":"Mumbai","area":"Wadala","invite_code":"APOL103"},
  {"id":"ec931301-ad5c-4e14-9c3e-ea0332475701","name":"Apollo Hospital (Wagle Estate)","city":"Thane","area":"Wagle Estate","invite_code":"APOL435"},
  {"id":"a312e21a-1f7c-46df-a593-15baf99a85d8","name":"Apollo Polyclinic (Colaba)","city":"Mumbai","area":"Colaba","invite_code":"APOL495"},
  {"id":"163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09","name":"CarePoint Diagnostic Centre (Worli)","city":"Mumbai","area":"Worli","invite_code":"CARE386"},
  {"id":"06165788-d672-4bcc-a5bb-2bb81f8889bf","name":"CarePoint Hospital (Juhu)","city":"Mumbai","area":"Juhu","invite_code":"CARE252"},
  {"id":"d9b6df45-8fb6-4147-adef-b2f7f354e8e8","name":"CarePoint Medical Centre (Churchgate)","city":"Mumbai","area":"Churchgate","invite_code":"CARE223"},
  {"id":"bbb1f407-cf97-4d6c-9e96-1ae68e61d620","name":"CarePoint Multispeciality Clinic (Thane Road)","city":"Mumbai","area":"Thane Road","invite_code":"CARE759"},
  {"id":"177234ab-513d-4eeb-846f-84f768cc3f21","name":"City Care Polyclinic (Goregaon)","city":"Mumbai","area":"Goregaon","invite_code":"CITY480"},
  {"id":"50f2fd47-2f9d-4c97-acc9-af5021fe2279","name":"Elite Nursing Home (Bandra)","city":"Mumbai","area":"Bandra","invite_code":"ELIT310"},
  {"id":"b02f15c5-8dff-435c-a749-30f268deec03","name":"Family Medical Centre (Chembur)","city":"Mumbai","area":"Chembur","invite_code":"FAMI739"},
  {"id":"6bcb5f55-5297-4dcb-9066-58c174d45013","name":"Galaxy Hospital & Research Centre (Powai)","city":"Mumbai","area":"Powai","invite_code":"GALA450"},
  {"id":"93fb326b-2edc-4ee6-9608-64409c5babda","name":"Global Multispeciality Clinic (Kasarvadavali)","city":"Thane","area":"Kasarvadavali","invite_code":"GLOB118"},
  {"id":"edab5373-01f2-4df1-825e-14099f589ae8","name":"LifeLine Polyclinic (Dadar)","city":"Mumbai","area":"Dadar","invite_code":"LIFE211"},
  {"id":"8111f72e-b4ea-4362-9cf5-ef69a793fd73","name":"MediLife Hospital (Hiranandani Estate)","city":"Thane","area":"Hiranandani Estate","invite_code":"MEDI183"},
  {"id":"bd5f1196-97fe-4f16-bb6d-d32f3d3503ad","name":"MediLife Multispeciality Clinic (Manpada)","city":"Thane","area":"Manpada","invite_code":"MEDI309"},
  {"id":"0edfc0fe-7703-4de8-817f-d35bd39e082a","name":"Metro Hospital (Borivali)","city":"Mumbai","area":"Borivali","invite_code":"METR152"},
  {"id":"80798686-5ecd-47e3-8dfa-334fac68fbe8","name":"Metro Multispeciality Clinic (Ghodbunder Road)","city":"Thane","area":"Ghodbunder Road","invite_code":"METR128"},
  {"id":"52cf3065-6234-4b0d-ba6b-cf33ea26639b","name":"Modern Nursing Home (Lower Parel)","city":"Mumbai","area":"Lower Parel","invite_code":"MODE314"},
  {"id":"a04ba937-d27c-47e1-aab1-b2140fa4bf4c","name":"National Hospital (Balkum)","city":"Thane","area":"Balkum","invite_code":"NATI460"},
  {"id":"9c795e23-a828-476e-8c4b-9d855cd3e8bf","name":"Prime Nursing Home (Majiwada)","city":"Thane","area":"Majiwada","invite_code":"PRIM194"},
  {"id":"b71cbebd-b233-42ae-9986-0e6666386a26","name":"Sai Day Care Centre (Mulund)","city":"Mumbai","area":"Mulund","invite_code":"SAI664"},
  {"id":"a923ac40-1961-4256-b903-4cffc4464ad4","name":"Sai Polyclinic (Andheri)","city":"Mumbai","area":"Andheri","invite_code":"SAI970"},
  {"id":"16181d96-9229-48ed-96e4-5673a5118844","name":"Star Medical Centre (Malad)","city":"Mumbai","area":"Malad","invite_code":"STAR197"},
  {"id":"135684f5-efca-43a9-8468-b8e1c5ad7fe7","name":"United Hospital (Kolshet)","city":"Thane","area":"Kolshet","invite_code":"UNIT294"},
  {"id":"acf4854e-b4fd-43b1-9c4e-15d2c3003880","name":"United Medical Centre (Kurla)","city":"Mumbai","area":"Kurla","invite_code":"UNIT682"}
];

const SPECIALIZATION_IDS: Record<string, string> = {
  "anesthesiology": "7a123665-00e9-49c1-a880-008ac2a45f8c",
  "cardiology": "d901feca-d88c-4dcc-9ff9-8716c0265f7f",
  "dentistry": "f5936a69-f20b-45e7-813c-a5a6819ca5d7",
  "dermatology": "9b15f7ae-e83f-4140-a095-3b0befb5de41",
  "endocrinology": "dd98735c-005b-41cb-8e19-7ecda93a5bf6",
  "ent-otolaryngology": "87012fa8-f937-4373-9bf2-ce7a255c5ad6",
  "gastroenterology": "7130c038-22bc-4b7a-b004-c606b8d2b491",
  "general-medicine": "3f062123-b03e-41c6-b5bf-84baa4fbae2f",
  "general-surgery": "02ca475b-b9b4-4880-ac6c-6e0fcae3dd5a",
  "gynecology-obstetrics": "1f1b95cd-8630-4054-9161-1568c7edde9a",
  "nephrology": "262dee60-afca-4f8b-9608-02c581656962",
  "neurology": "f41d4e14-64b1-46b5-96c1-44c208e81d32",
  "oncology": "eac38caf-2f90-4a74-8a0a-50d4e45f99e2",
  "ophthalmology": "6763ec01-e18f-4737-ba0e-a49cbb29a8e2",
  "orthopedics": "333c7946-d872-4130-8e3c-dbb8824ae653",
  "pathology": "3e71cddb-7e0d-47af-bd53-53525dce2539",
  "pediatrics": "751c5e4a-83a1-432c-98c7-be4a2526ab23",
  "physiotherapy": "f6f84b76-c192-4927-aa97-4974520a5e98",
  "plastic-surgery": "1618e866-4583-455e-9559-dff3230272fe",
  "psychiatry": "0d3080e9-dc75-444c-8ccd-565ed4fc4464",
  "pulmonology": "236d5e70-ea34-4a34-ad88-8b0bccc2a485",
  "radiology": "204c18a2-29f1-4409-a815-4541e94c9aec",
  "rheumatology": "292023bd-6c1f-4215-b023-91dce1a9403a",
  "urology": "9006b369-7e7e-492c-a98a-eb1b5e2d1e8e",
};

const DEMO_PASSWORD_HASH = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy"; // Demo@123456

function createAuthUserSql(
  id: string,
  email: string,
  role: string,
  fullName: string,
  phone: string,
  extraMeta: Record<string, any> = {}
) {
  const meta = {
    full_name: fullName,
    email,
    role,
    phone,
    ...extraMeta,
  };
  const appMeta = {
    provider: "email",
    providers: ["email"],
    role,
  };
  return `
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      ${escapeSql(id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      ${escapeSql(email)}, ${escapeSql(DEMO_PASSWORD_HASH)}, now(), now(), now(),
      ${escapeSql(JSON.stringify(appMeta))}::jsonb,
      ${escapeSql(JSON.stringify(meta))}::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = ${escapeSql(email)}, 
      raw_app_meta_data = ${escapeSql(JSON.stringify(appMeta))}::jsonb,
      raw_user_meta_data = ${escapeSql(JSON.stringify(meta))}::jsonb;
  `;
}

// ── 4. 25 Doctors across Specializations & Clinics ────────────────
console.log("Generating 04a_doctors.sql and 04b_doctors.sql...");
const doctorsSqlA: string[] = [];
const doctorsSqlB: string[] = [];

const DEMO_DOCTOR_ID = "00000000-0000-0000-0000-000000000002";
const doctorList: { id: string; name: string; clinicId: string; fee: number }[] = [
  { id: DEMO_DOCTOR_ID, name: "Dr. Aarav Deshmukh", clinicId: "a923ac40-1961-4256-b903-4cffc4464ad4", fee: 600 }
];

const SPECIALIZATION_MAP: Record<string, string[]> = {
  "general-medicine": ["MBBS, MD (General Medicine)", "MBBS, DNB (Internal Medicine)"],
  "cardiology": ["MBBS, MD, DM (Cardiology)", "MBBS, DNB (Cardiology)"],
  "dermatology": ["MBBS, MD (Dermatology, Venereology & Leprosy)", "MBBS, DVD"],
  "pediatrics": ["MBBS, MD (Pediatrics)", "MBBS, DCH"],
  "orthopedics": ["MBBS, MS (Orthopedics)", "MBBS, DNB (Ortho)"],
  "gynecology-obstetrics": ["MBBS, MS (OBGYN)", "MBBS, DGO"],
  "ent-otolaryngology": ["MBBS, MS (ENT)", "MBBS, DLO"],
  "ophthalmology": ["MBBS, MS (Ophthalmology)", "MBBS, DOMS"],
  "neurology": ["MBBS, MD, DM (Neurology)"],
  "gastroenterology": ["MBBS, MD, DM (Gastroenterology)"],
};

const specKeys = Object.keys(SPECIALIZATION_MAP);

for (let i = 0; i < 25; i++) {
  const docId = rng.uuid();
  const person = randomPerson(rng);
  const name = `Dr. ${person.fullName}`;
  const specKey = specKeys[i % specKeys.length];
  const specId = SPECIALIZATION_IDS[specKey];
  const qualification = rng.pick(SPECIALIZATION_MAP[specKey]);
  const clinic = EXISTING_CLINICS[i % EXISTING_CLINICS.length];
  const fee = rng.pick([400, 500, 600, 700, 800, 1000]);
  const experience = rng.int(5, 28);
  const rating = Number((4.2 + rng.next() * 0.75).toFixed(2));
  const reviewCount = rng.int(10, 95);
  const regNumber = `MMC-${rng.int(2000, 2020)}-${rng.int(10000, 99999)}`;
  const email = `dr.${slugify(person.firstName)}.${slugify(person.lastName)}@betterclinic.app`;
  const phone = rng.phone();
  const about = `Compassionate healthcare provider specializing in ${specKey.replace(/-/g, " ")}. Dedicated to patient-centric treatment with proven clinical outcomes.`;

  doctorList.push({ id: docId, name, clinicId: clinic.id, fee });

  const targetDocSql = i < 12 ? doctorsSqlA : doctorsSqlB;

  // Insert Auth User with full doctor metadata for handle_new_user() trigger
  targetDocSql.push(
    createAuthUserSql(docId, email, "DOCTOR", name, phone, {
      qualification,
      registration_number: regNumber,
      experience_years: String(experience),
      consultation_fee: String(fee),
      about,
      specialization_id: specId,
      clinic_id: clinic.id,
    })
  );

  // Update doctor rating and languages
  targetDocSql.push(`
    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = ${rating},
      review_count = ${reviewCount},
      is_accepting_patients = true
    WHERE id = ${escapeSql(docId)};

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES (${escapeSql(docId)}, ${escapeSql(specId)})
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES (${escapeSql(docId)}, ${escapeSql(clinic.id)}, true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  `);

  // Availability for each doctor (Mon-Sat 09:00 - 18:00)
  for (let dow = 1; dow <= 6; dow++) {
    targetDocSql.push(`
      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES (${escapeSql(docId)}, ${escapeSql(clinic.id)}, ${dow}, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    `);
  }
}

fs.writeFileSync(path.join(outDir, "04a_doctors.sql"), doctorsSqlA.join("\n"));
fs.writeFileSync(path.join(outDir, "04b_doctors.sql"), doctorsSqlB.join("\n"));

// ── 5. Patients & Active Logged In User Links ─────────────────────
console.log("Generating 05_patients.sql...");
const patientsSql: string[] = [];
const patientIds: string[] = [];

// Ensure logged-in user (Manesh Jadhav) is in patientIds
const LOGGED_IN_USER_ID = "361dd8a5-1392-44a6-b682-4306ebbf5836";
patientIds.push(LOGGED_IN_USER_ID);

for (let i = 0; i < 30; i++) {
  const pId = rng.uuid();
  const person = randomPerson(rng);
  const email = `${slugify(person.firstName)}.${slugify(person.lastName)}${rng.int(10, 99)}@example.com`;
  const phone = rng.phone();
  const dob = rng.dateString(rng.dateBetween(new Date(1960, 0, 1), new Date(2005, 0, 1)));
  const bg = rng.pick(BLOOD_GROUPS);
  const clinic = rng.pick(EXISTING_CLINICS);

  patientIds.push(pId);
  patientsSql.push(
    createAuthUserSql(pId, email, "PATIENT", person.fullName, phone, {
      date_of_birth: dob,
      sex: person.sex,
      city: clinic.city,
    })
  );
  patientsSql.push(`
    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES (${escapeSql(pId)}, ${escapeSql(dob)}, ${escapeSql(person.sex)}::public.sex, ${escapeSql(bg)}, ${escapeSql(`Flat ${rng.int(101, 1204)}, Building ${rng.int(1, 15)}, ${clinic.area}`)}, ${escapeSql(clinic.city)}, ${escapeSql(clinic.area)}, ${escapeSql(String(rng.int(400001, 425001)))}, ${escapeSql(`Family Contact`)}, ${escapeSql(rng.phone())})
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  `);
}

fs.writeFileSync(path.join(outDir, "05_patients.sql"), patientsSql.join("\n"));

// ── 6. Slots, Appointments, Queue & Consultations ─────────────────
console.log("Generating 06_appointments_and_queue.sql...");
const apptSql: string[] = [];

const today = new Date().toISOString().slice(0, 10);
const primaryClinicId = "a923ac40-1961-4256-b903-4cffc4464ad4";

// Generate slots and appointments for today for Demo Doctor
const times = [
  "09:00:00", "09:15:00", "09:30:00", "09:45:00",
  "10:00:00", "10:15:00", "10:30:00", "10:45:00",
  "11:00:00", "11:15:00", "11:30:00", "11:45:00",
  "14:00:00", "14:15:00", "14:30:00", "14:45:00",
  "15:00:00", "15:15:00", "15:30:00", "15:45:00",
];

const VISIT_REASONS = [
  "Persistent headache and mild fever for two days",
  "Annual general health checkup and lipid screening",
  "Follow-up for chronic hypertension and blood pressure review",
  "Seasonal allergies, sneezing, and sore throat",
  "Joint pain and stiffness in the morning",
  "Mild chest discomfort during exertion — preliminary evaluation",
  "Follow-up for routine diabetes and fasting glucose review",
  "Skin rash and dry skin itchiness",
];

// Give the logged-in user an appointment with Demo Doctor today!
const myApptId = rng.uuid();
const mySlotId = rng.uuid();

apptSql.push(`
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES (${escapeSql(mySlotId)}, ${escapeSql(DEMO_DOCTOR_ID)}, ${escapeSql(primaryClinicId)}, ${escapeSql(today)}, '11:00:00', '11:15:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES (${escapeSql(myApptId)}, ${escapeSql(LOGGED_IN_USER_ID)}, ${escapeSql(DEMO_DOCTOR_ID)}, ${escapeSql(primaryClinicId)}, ${escapeSql(mySlotId)}, 'SCHEDULED', 'CONFIRMED', ${escapeSql(today)}, '11:00:00', '11:15:00', 'Routine general health checkup and seasonal flu consultation')
  ON CONFLICT (id) DO NOTHING;
`);

// Add today slots for doctors across clinics
for (let d = 0; d < Math.min(doctorList.length, 8); d++) {
  const doc = doctorList[d];
  for (let t = 0; t < times.length; t++) {
    const slotId = rng.uuid();
    const startTime = times[t];
    const [h, m] = startTime.split(":").map(Number);
    const endMinutes = m + 15;
    const endTime = `${String(endMinutes >= 60 ? h + 1 : h).padStart(2, "0")}:${String(endMinutes % 60).padStart(2, "0")}:00`;
    const isBooked = t < 2; // First 2 slots booked

    if (isBooked) {
      const patientId = patientIds[(d * 2 + t) % patientIds.length];
      const apptId = rng.uuid();
      const status = t === 0 ? "IN_CONSULTATION" : "WAITING";

      apptSql.push(`
        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES (${escapeSql(slotId)}, ${escapeSql(doc.id)}, ${escapeSql(doc.clinicId)}, ${escapeSql(today)}, ${escapeSql(startTime)}, ${escapeSql(endTime)}, 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES (${escapeSql(apptId)}, ${escapeSql(patientId)}, ${escapeSql(doc.id)}, ${escapeSql(doc.clinicId)}, ${escapeSql(slotId)}, 'SCHEDULED', ${escapeSql(status)}::public.appointment_status, ${escapeSql(today)}, ${escapeSql(startTime)}, ${escapeSql(endTime)}, ${escapeSql(rng.pick(VISIT_REASONS))})
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES (${escapeSql(apptId)}, ${escapeSql(patientId)}, ${escapeSql(doc.clinicId)}, 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES (${escapeSql(doc.clinicId)}, ${escapeSql(doc.id)}, ${escapeSql(patientId)}, ${escapeSql(apptId)}, ${escapeSql(today)}, ${t + 1}, ${escapeSql(`T00${t + 1}`)}, 'NORMAL', ${escapeSql(status)}::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      `);
    } else {
      apptSql.push(`
        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES (${escapeSql(slotId)}, ${escapeSql(doc.id)}, ${escapeSql(doc.clinicId)}, ${escapeSql(today)}, ${escapeSql(startTime)}, ${escapeSql(endTime)}, 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      `);
    }
  }
}

fs.writeFileSync(path.join(outDir, "06_appointments_and_queue.sql"), apptSql.join("\n"));

console.log("All seed SQL chunks successfully written to scratch/sql_chunks/");
