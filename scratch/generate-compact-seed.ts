import fs from "fs";
import path from "path";
import crypto from "crypto";

class PRNG {
  private seed: number;
  constructor(seed: number = 2026) {
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
  sample<T>(array: readonly T[] | T[], count: number): T[] {
    const copy = [...array];
    const res: T[] = [];
    for (let i = 0; i < count && copy.length > 0; i++) {
      const idx = this.int(0, copy.length - 1);
      res.push(copy.splice(idx, 1)[0]);
    }
    return res;
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
  chance(prob: number): boolean {
    return this.next() < prob;
  }
}

const rng = new PRNG(2026);

function esc(val: any): string {
  if (val === null || val === undefined) return "NULL";
  if (typeof val === "boolean") return val ? "true" : "false";
  if (typeof val === "number") return String(val);
  if (Array.isArray(val)) {
    const inner = val.map(s => `"${String(s).replace(/"/g, '\\"')}"`).join(",");
    return `'{${inner}}'`;
  }
  return "'" + String(val).replace(/'/g, "''") + "'";
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

const CITIES = [
  { city: "Mumbai", areas: ["Andheri", "Bandra", "Borivali", "Chembur", "Dadar", "Goregaon", "Juhu", "Kandivali", "Malad", "Powai"] },
  { city: "Thane", areas: ["Naupada", "Ghodbunder Road", "Majiwada", "Kasarvadavali", "Vartak Nagar", "Manpada"] },
  { city: "Navi Mumbai", areas: ["Vashi", "Nerul", "Kharghar", "Belapur", "Panvel"] },
  { city: "Pune", areas: ["Kothrud", "Baner", "Viman Nagar", "Hinjewadi", "Aundh"] }
];

const SPECIALIZATIONS = [
  { id: "3f062123-b03e-41c6-b5bf-84baa4fbae2f", name: "General Medicine" },
  { id: "d901feca-d88c-4dcc-9ff9-8716c0265f7f", name: "Cardiology" },
  { id: "9b15f7ae-e83f-4140-a095-3b0befb5de41", name: "Dermatology" },
  { id: "751c5e4a-83a1-432c-98c7-be4a2526ab23", name: "Pediatrics" },
  { id: "333c7946-d872-4130-8e3c-dbb8824ae653", name: "Orthopedics" },
  { id: "1f1b95cd-8630-4054-9161-1568c7edde9a", name: "Gynecology & Obstetrics" },
  { id: "87012fa8-f937-4373-9bf2-ce7a255c5ad6", name: "ENT (Otolaryngology)" },
  { id: "6763ec01-e18f-4737-ba0e-a49cbb29a8e2", name: "Ophthalmology" },
  { id: "f5936a69-f20b-45e7-813c-a5a6819ca5d7", name: "Dentistry" },
  { id: "dd98735c-005b-41cb-8e19-7ecda93a5bf6", name: "Endocrinology" },
  { id: "f41d4e14-64b1-46b5-96c1-44c208e81d32", name: "Neurology" },
  { id: "0d3080e9-dc75-444c-8ccd-565ed4fc4464", name: "Psychiatry" }
];

const MEDICINES = [
  { id: "4dc27138-6db4-4320-a7aa-d4b1819d036e", name: "Dolo 650", generic: "Paracetamol", dosage: "650mg" },
  { id: "3d69b7ab-9a32-414d-a430-27077f2d6614", name: "Crocin", generic: "Paracetamol", dosage: "500mg" },
  { id: "2f482efd-0f24-4b84-9cba-f65ee6c87d84", name: "Combiflam", generic: "Ibuprofen + Paracetamol", dosage: "400mg + 325mg" },
  { id: "1514f65e-07b1-40a3-8b50-6766b0ccde25", name: "Augmentin 625", generic: "Amoxicillin + Clavulanate", dosage: "625mg" },
  { id: "f3f9872e-2df9-4eca-aa45-5666f5969f10", name: "Azithral 500", generic: "Azithromycin", dosage: "500mg" },
  { id: "ec4d1238-cfda-4d15-983c-1075cfc94bdd", name: "Ciproflox 500", generic: "Ciprofloxacin", dosage: "500mg" },
  { id: "c67fe46e-22d8-4123-bd9b-7637b0d55998", name: "Voveran SR", generic: "Diclofenac", dosage: "100mg" },
  { id: "71ecf204-ecce-46d1-a23a-e5cdc906d54a", name: "Brufen", generic: "Ibuprofen", dosage: "400mg" }
];

const QUALIFICATIONS = [
  "MBBS, MD (General Medicine)",
  "MBBS, MS (Orthopedics)",
  "MBBS, MD (Pediatrics)",
  "MBBS, DNB (Cardiology)",
  "MBBS, MD (Dermatology)",
  "MBBS, MS (ENT)",
  "BDS, MDS (Oral Surgery)",
  "MBBS, DGO (Obstetrics & Gynecology)"
];

const DEMO_PASSWORD_HASH = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy"; // Demo@123456

const DEMO_PATIENT_ID = "00000000-0000-0000-0000-000000000001";
const DEMO_DOCTOR_ID = "00000000-0000-0000-0000-000000000002";
const DEMO_RECEPTIONIST_ID = "00000000-0000-0000-0000-000000000003";
const DEMO_ADMIN_ID = "00000000-0000-0000-0000-000000000004";

// 1. Clinics (18)
const clinics: any[] = [];
const clinicNames = [
  "Sai Care Polyclinic", "Aarogya Health Hub", "Metro Multispeciality Clinic",
  "LifeLine Family Clinic", "Apex Diagnostic & Medical Centre", "City Health Clinic",
  "Prana Wellness Clinic", "Apollo Day Care", "CarePoint Polyclinic",
  "National Health Clinic", "Sanjeevani Care Clinic", "Shree Multispeciality Clinic",
  "Noble Diagnostic Centre", "Pinnacle Health Clinic", "Spandana Polyclinic",
  "Suraksha Medical Clinic", "MedLife Health Care", "Dhanvantari Clinic"
];

let cIndex = 0;
for (const cName of clinicNames) {
  const loc = CITIES[cIndex % CITIES.length];
  const area = loc.areas[cIndex % loc.areas.length];
  const cId = rng.uuid();
  const prefix = cName.split(" ")[0].slice(0, 4).toUpperCase();
  const code = `${prefix}${rng.int(100, 999)}`;
  clinics.push({
    id: cId,
    name: `${cName} (${area})`,
    city: loc.city,
    area: area,
    pincode: String(rng.int(400001, 411050)),
    address: `Shop No. ${rng.int(1, 25)}, Galaxy Complex, ${area} Main Road`,
    phone: rng.phone(),
    email: `contact@${cName.toLowerCase().replace(/[^a-z0-9]/g, "")}-${area.toLowerCase().replace(/[^a-z0-9]/g, "")}.in`,
    rating: Number((4.1 + rng.next() * 0.8).toFixed(2)),
    reviews: rng.int(12, 95),
    invite_code: code,
    claim_code: `ADM-${code}`
  });
  cIndex++;
}

// 2. Doctors (20)
const doctors: any[] = [];
doctors.push({
  id: DEMO_DOCTOR_ID,
  email: "demo-doctor@betterclinic.app",
  name: "Dr. Aarav Deshmukh",
  phone: "+919820011223",
  qualification: "MBBS, MD (General Medicine)",
  regNo: "MMC-2010-48291",
  experience: 14,
  fee: 600,
  about: "Senior General Physician with 14 years clinical experience in diagnosis and treatment of chronic and acute illnesses.",
  languages: ["English", "Hindi", "Marathi"],
  rating: 4.88,
  reviews: 86,
  clinicId: clinics[0].id,
  specId: SPECIALIZATIONS[0].id
});

for (let i = 1; i < 20; i++) {
  const isMale = rng.chance(0.5);
  const fn = isMale ? rng.pick(FIRST_NAMES_MALE) : rng.pick(FIRST_NAMES_FEMALE);
  const ln = rng.pick(LAST_NAMES);
  const dId = rng.uuid();
  const spec = rng.pick(SPECIALIZATIONS);
  const clinic = rng.pick(clinics);
  doctors.push({
    id: dId,
    email: `dr.${fn.toLowerCase()}.${ln.toLowerCase()}${i}@betterclinic.app`,
    name: `Dr. ${fn} ${ln}`,
    phone: rng.phone(),
    qualification: rng.pick(QUALIFICATIONS),
    regNo: `MMC-${rng.int(2005, 2022)}-${rng.int(10000, 99999)}`,
    experience: rng.int(4, 25),
    fee: rng.pick([400, 500, 600, 750, 900]),
    about: `Experienced ${spec.name} specialist committed to evidence-based, empathetic patient care.`,
    languages: rng.sample(["English", "Hindi", "Marathi", "Gujarati"], rng.int(2, 3)),
    rating: Number((4.2 + rng.next() * 0.7).toFixed(2)),
    reviews: rng.int(10, 70),
    clinicId: clinic.id,
    specId: spec.id
  });
}

// 3. Staff (8)
const staff: any[] = [
  { id: DEMO_RECEPTIONIST_ID, email: "demo-receptionist@betterclinic.app", name: "Sunita Patil", role: "RECEPTIONIST", clinicId: clinics[0].id },
  { id: DEMO_ADMIN_ID, email: "demo-admin@betterclinic.app", name: "Rajesh Joshi", role: "CLINIC_ADMIN", clinicId: clinics[0].id }
];
for (let i = 1; i <= 6; i++) {
  const isMale = rng.chance(0.5);
  const fn = isMale ? rng.pick(FIRST_NAMES_MALE) : rng.pick(FIRST_NAMES_FEMALE);
  const ln = rng.pick(LAST_NAMES);
  const role = i % 2 === 0 ? "CLINIC_ADMIN" : "RECEPTIONIST";
  staff.push({
    id: rng.uuid(),
    email: `${role.toLowerCase()}.${fn.toLowerCase()}.${i}@betterclinic.app`,
    name: `${fn} ${ln}`,
    role,
    clinicId: clinics[i % clinics.length].id
  });
}

// 4. Exactly 60 Patients
const patients: any[] = [
  {
    id: DEMO_PATIENT_ID,
    email: "demo-patient@betterclinic.app",
    name: "Aarav Sharma",
    phone: "+919819922334",
    dob: "1994-08-14",
    sex: "MALE",
    blood: "O+",
    city: "Mumbai",
    area: "Andheri",
    pincode: "400053",
    address: "Flat 402, Lotus Heights, Andheri West"
  }
];
for (let i = 1; i < 60; i++) {
  const isMale = rng.chance(0.5);
  const fn = isMale ? rng.pick(FIRST_NAMES_MALE) : rng.pick(FIRST_NAMES_FEMALE);
  const ln = rng.pick(LAST_NAMES);
  const loc = rng.pick(CITIES);
  const area = rng.pick(loc.areas);
  const dob = rng.dateBetween(new Date(1960, 0, 1), new Date(2012, 0, 1));
  patients.push({
    id: rng.uuid(),
    email: `patient.${fn.toLowerCase()}.${ln.toLowerCase()}${i}@betterclinic.app`,
    name: `${fn} ${ln}`,
    phone: rng.phone(),
    dob: rng.dateString(dob),
    sex: isMale ? "MALE" : "FEMALE",
    blood: rng.pick(BLOOD_GROUPS),
    city: loc.city,
    area: area,
    pincode: String(rng.int(400001, 411050)),
    address: `Flat ${rng.int(101, 1204)}, Tower ${rng.pick(["A", "B", "C"])}, ${area}`
  });
}

// 5. Exactly 30 Appointments
const appointments: any[] = [];
const today = new Date();
const todayStr = rng.dateString(today);

const VISIT_REASONS = [
  "Routine health checkup", "Persistent headache and fever", "Joint pain and stiffness",
  "Skin rash and itching", "Seasonal cough and throat irritation", "Blood pressure follow-up",
  "Stomach pain and acidity", "Chest tightness on exertion", "Ear pain and blockage",
  "Diabetes consultation", "Eye checkup and blurry vision", "Childhood vaccination consultation"
];

// 16 Completed (past)
for (let i = 0; i < 16; i++) {
  const pastDate = new Date(today);
  pastDate.setDate(today.getDate() - rng.int(1, 25));
  const doc = doctors[i % doctors.length];
  const pat = patients[i % patients.length];
  appointments.push({
    id: rng.uuid(),
    slotId: rng.uuid(),
    patientId: pat.id,
    doctorId: doc.id,
    clinicId: doc.clinicId,
    date: rng.dateString(pastDate),
    startTime: "10:00:00",
    endTime: "10:30:00",
    status: "COMPLETED",
    reason: VISIT_REASONS[i % VISIT_REASONS.length]
  });
}

// 3 Cancelled (past)
for (let i = 0; i < 3; i++) {
  const pastDate = new Date(today);
  pastDate.setDate(today.getDate() - rng.int(3, 20));
  const doc = rng.pick(doctors);
  const pat = patients[16 + i];
  appointments.push({
    id: rng.uuid(),
    slotId: rng.uuid(),
    patientId: pat.id,
    doctorId: doc.id,
    clinicId: doc.clinicId,
    date: rng.dateString(pastDate),
    startTime: "11:00:00",
    endTime: "11:30:00",
    status: "CANCELLED",
    reason: "Patient requested cancellation due to travel"
  });
}

// 1 No-show (past)
{
  const pastDate = new Date(today);
  pastDate.setDate(today.getDate() - 4);
  const doc = doctors[0];
  const pat = patients[19];
  appointments.push({
    id: rng.uuid(),
    slotId: rng.uuid(),
    patientId: pat.id,
    doctorId: doc.id,
    clinicId: doc.clinicId,
    date: rng.dateString(pastDate),
    startTime: "14:00:00",
    endTime: "14:30:00",
    status: "NO_SHOW",
    reason: "Routine consultation"
  });
}

// 4 Today
const todayStatuses = ["CHECKED_IN", "IN_CONSULTATION", "WAITING", "CHECKED_IN"];
for (let i = 0; i < 4; i++) {
  const doc = doctors[i % doctors.length];
  const pat = patients[20 + i];
  appointments.push({
    id: rng.uuid(),
    slotId: rng.uuid(),
    patientId: pat.id,
    doctorId: doc.id,
    clinicId: doc.clinicId,
    date: todayStr,
    startTime: `1${1 + i}:00:00`,
    endTime: `1${1 + i}:30:00`,
    status: todayStatuses[i],
    reason: VISIT_REASONS[(i + 4) % VISIT_REASONS.length]
  });
}

// 6 Future
const futureStatuses = ["BOOKED", "CONFIRMED", "BOOKED", "CONFIRMED", "BOOKED", "BOOKED"];
for (let i = 0; i < 6; i++) {
  const futureDate = new Date(today);
  futureDate.setDate(today.getDate() + rng.int(1, 10));
  const doc = doctors[(i + 5) % doctors.length];
  const pat = patients[24 + i];
  appointments.push({
    id: rng.uuid(),
    slotId: rng.uuid(),
    patientId: pat.id,
    doctorId: doc.id,
    clinicId: doc.clinicId,
    date: rng.dateString(futureDate),
    startTime: "15:00:00",
    endTime: "15:30:00",
    status: futureStatuses[i],
    reason: VISIT_REASONS[(i + 6) % VISIT_REASONS.length]
  });
}

// Assemble multi-row statements into chunk files
const outDir = path.join(process.cwd(), "scratch", "compact_chunks");
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

// Chunk 1: Clinics, Codes, Hours
let c1 = `insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic) values\n` +
  clinics.map(c => `(${esc(c.id)}, ${esc(c.name)}, ${esc(c.city)}, ${esc(c.area)}, ${esc(c.pincode)}, ${esc(c.address)}, ${esc(c.phone)}, ${esc(c.email)}, ${c.rating}, ${c.reviews}, true, true)`).join(",\n") +
  `\non conflict (id) do nothing;\n\n`;

c1 += `insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic) values\n` +
  clinics.map(c => `(${esc(c.id)}, ${esc(c.invite_code)}, ${esc('DOC-' + c.invite_code)}, ${esc(c.claim_code)}, true)`).join(",\n") +
  `\non conflict (clinic_id) do nothing;\n\n`;

const hoursRows: string[] = [];
for (const c of clinics) {
  for (let day = 0; day <= 6; day++) {
    hoursRows.push(`(${esc(c.id)}, ${day}, '08:30:00', '20:30:00', ${day === 0}, true)`);
  }
}
c1 += `insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic) values\n` +
  hoursRows.join(",\n") +
  `\non conflict (clinic_id, day_of_week) do nothing;\n`;
fs.writeFileSync(path.join(outDir, "chunk_1_clinics.sql"), c1);

// Chunk 2: Auth Users, Profiles, Profile Roles for Doctors & Staff
const doctorAuthRows = doctors.map(d => {
  const meta = JSON.stringify({
    full_name: d.name,
    role: "DOCTOR",
    registration_number: d.regNo,
    qualification: d.qualification,
    experience_years: String(d.experience),
    consultation_fee: String(d.fee),
    about: d.about,
    clinic_id: d.clinicId,
    specialization_id: d.specId,
    is_new_clinic: "true"
  });
  return `(${esc(d.id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(d.email)}, '${DEMO_PASSWORD_HASH}', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, ${esc(meta)}::jsonb)`;
});

const staffAuthRows = staff.map(s => {
  const c = clinics.find(cl => cl.id === s.clinicId)!;
  const meta = s.role === "CLINIC_ADMIN"
    ? JSON.stringify({
        full_name: s.name,
        role: "CLINIC_ADMIN",
        clinic_id: s.clinicId,
        is_new_clinic: "true"
      })
    : JSON.stringify({
        full_name: s.name,
        role: "RECEPTIONIST",
        clinic_id: s.clinicId,
        staff_invite_code: c.invite_code
      });
  return `(${esc(s.id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(s.email)}, '${DEMO_PASSWORD_HASH}', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, ${esc(meta)}::jsonb)`;
});

const allStaffDocIds = [...doctors.map(d => d.id), ...staff.map(s => s.id)];
let c2 = `insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data) values\n` +
  [...doctorAuthRows, ...staffAuthRows].join(",\n") +
  `\non conflict (id) do update set email = excluded.email;\n\n`;

c2 += `update public.profiles set is_synthetic = true where id in (${allStaffDocIds.map(esc).join(",")});\n`;
c2 += `update public.profile_roles set is_synthetic = true where profile_id in (${allStaffDocIds.map(esc).join(",")});\n\n`;

for (const d of doctors) {
  c2 += `update public.doctors set
  qualification = ${esc(d.qualification)},
  registration_number = ${esc(d.regNo)},
  experience_years = ${d.experience},
  consultation_fee = ${d.fee},
  about = ${esc(d.about)},
  languages = ${esc(d.languages)},
  avg_rating = ${d.rating},
  review_count = ${d.reviews},
  is_accepting_patients = true,
  is_synthetic = true
where id = ${esc(d.id)};\n`;
}
c2 += `\n`;

c2 += `update public.clinic_staff set is_synthetic = true where user_id in (${staff.map(s => esc(s.id)).join(",")});\n\n`;

c2 += `insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic) values\n` +
  doctors.map(d => `(${esc(d.id)}, ${esc(d.clinicId)}, true, true)`).join(",\n") +
  `\non conflict do nothing;\n\n`;
c2 += `update public.doctor_clinics set is_synthetic = true where doctor_id in (${doctors.map(d => esc(d.id)).join(",")});\n\n`;

c2 += `insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic) values\n` +
  doctors.map(d => `(${esc(d.id)}, ${esc(d.specId)}, true)`).join(",\n") +
  `\non conflict do nothing;\n\n`;
c2 += `update public.doctor_specializations set is_synthetic = true where doctor_id in (${doctors.map(d => esc(d.id)).join(",")});\n\n`;

const availRows: string[] = [];
for (const d of doctors) {
  for (let day = 1; day <= 6; day++) {
    availRows.push(`(${esc(d.id)}, ${esc(d.clinicId)}, ${day}, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)`);
  }
}
c2 += `insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic) values\n` +
  availRows.join(",\n") +
  `\non conflict do nothing;\n`;
fs.writeFileSync(path.join(outDir, "chunk_2_doctors_staff.sql"), c2);

// Chunk 3: 60 Patients
const patientAuthRows = patients.map(p => {
  const meta = JSON.stringify({
    full_name: p.name,
    role: "PATIENT",
    date_of_birth: p.dob,
    sex: p.sex,
    city: p.city
  });
  return `(${esc(p.id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(p.email)}, '${DEMO_PASSWORD_HASH}', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, ${esc(meta)}::jsonb)`;
});

let c3 = `insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data) values\n` +
  patientAuthRows.join(",\n") +
  `\non conflict (id) do update set email = excluded.email;\n\n`;

c3 += `update public.profiles set is_synthetic = true where id in (${patients.map(p => esc(p.id)).join(",")});\n`;
c3 += `update public.profile_roles set is_synthetic = true where profile_id in (${patients.map(p => esc(p.id)).join(",")});\n\n`;

for (const p of patients) {
  c3 += `insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values (${esc(p.id)}, ${esc(p.dob)}, ${esc(p.sex)}::public.sex, ${esc(p.blood)}, ${esc(p.address)}, ${esc(p.city)}, ${esc(p.area)}, ${esc(p.pincode)}, 'Family Member', ${esc(rng.phone())}, true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;\n`;
}
c3 += `\n`;

const medHistRows: string[] = [];
for (const p of patients) {
  if (rng.chance(0.35)) {
    medHistRows.push(`(${esc(p.id)}, 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true)`);
  }
}
if (medHistRows.length > 0) {
  c3 += `insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic) values\n` +
    medHistRows.join(",\n") + `;\n`;
}
fs.writeFileSync(path.join(outDir, "chunk_3_patients.sql"), c3);

// Chunk 4: 30 Appointments, Slots, Check-ins, Queue
let c4 = `insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic) values\n` +
  appointments.map(a => `(${esc(a.slotId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.date)}, ${esc(a.startTime)}, ${esc(a.endTime)}, 'BOOKED', true)`).join(",\n") +
  `\non conflict do nothing;\n\n`;

c4 += `insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic) values\n` +
  appointments.map(a => `(${esc(a.id)}, ${esc(a.patientId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.slotId)}, 'SCHEDULED', ${esc(a.status)}::public.appointment_status, ${esc(a.date)}, ${esc(a.startTime)}, ${esc(a.endTime)}, ${esc(a.reason)}, now() - interval '2 days', true)`).join(",\n") +
  `\non conflict (id) do nothing;\n\n`;

c4 += `insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic) values\n` +
  appointments.map(a => `(${esc(a.id)}, 'BOOKED', ${esc(a.status)}::public.appointment_status, true)`).join(",\n") +
  `;\n\n`;

const todayAppts = appointments.filter(a => a.date === todayStr);
if (todayAppts.length > 0) {
  c4 += `insert into public.check_ins (appointment_id, patient_id, clinic_id, method, is_synthetic) values\n` +
    todayAppts.map(a => `(${esc(a.id)}, ${esc(a.patientId)}, ${esc(a.clinicId)}, 'APP', true)`).join(",\n") +
    `\non conflict do nothing;\n\n`;

  const qEntries = todayAppts.map((a, idx) => ({
    qId: rng.uuid(),
    appt: a,
    tokenNum: idx + 1,
    tokenCode: `T${String(idx + 1).padStart(3, "0")}`
  }));

  c4 += `insert into public.queue_entries (id, clinic_id, doctor_id, appointment_id, patient_id, queue_date, token_number, token_code, priority, status, is_synthetic) values\n` +
    qEntries.map(e => `(${esc(e.qId)}, ${esc(e.appt.clinicId)}, ${esc(e.appt.doctorId)}, ${esc(e.appt.id)}, ${esc(e.appt.patientId)}, ${esc(todayStr)}, ${e.tokenNum}, ${esc(e.tokenCode)}, 'NORMAL', ${esc(e.appt.status)}::public.queue_status, true)`).join(",\n") +
    `\non conflict do nothing;\n\n`;

  c4 += `insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, note, is_synthetic) values\n` +
    qEntries.map(e => `(${esc(e.qId)}, 'CALLED'::public.queue_event_type, 'WAITING'::public.queue_status, 'CALLED'::public.queue_status, 'Patient called to examination room', true)`).join(",\n") +
    `;\n`;
}
fs.writeFileSync(path.join(outDir, "chunk_4_appointments.sql"), c4);

// Chunk 5: Clinical records, Prescriptions, Reviews, Notifications
const completedAppts = appointments.filter(a => a.status === "COMPLETED");
const clinicalData = completedAppts.map((a, idx) => {
  const consultId = rng.uuid();
  const rxId = rng.uuid();
  const rxItemId1 = rng.uuid();
  const rxItemId2 = rng.uuid();
  const med1 = MEDICINES[idx % MEDICINES.length];
  const med2 = MEDICINES[(idx + 3) % MEDICINES.length];
  return { a, consultId, rxId, rxItemId1, rxItemId2, med1, med2, idx };
});

let c5 = `insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic) values\n` +
  clinicalData.map(c => `(${esc(c.consultId)}, ${esc(c.a.id)}, ${esc(c.a.patientId)}, ${esc(c.a.doctorId)}, ${esc(c.a.clinicId)}, ${esc(c.a.reason)}, 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)`).join(",\n") +
  `\non conflict (id) do nothing;\n\n`;

c5 += `insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic) values\n` +
  clinicalData.map(c => `(${esc(c.consultId)}, ${esc(c.a.patientId)}, 'Acute upper respiratory infection', 'J06.9', true, true)`).join(",\n") +
  `;\n\n`;

c5 += `insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic) values\n` +
  clinicalData.map(c => `(${esc(c.consultId)}, ${esc(c.a.patientId)}, 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true)`).join(",\n") +
  `;\n\n`;

c5 += `insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic) values\n` +
  clinicalData.map(c => `(${esc(c.rxId)}, ${esc(c.consultId)}, ${esc(c.a.patientId)}, ${esc(c.a.doctorId)}, ${esc(c.a.clinicId)}, ${esc(c.a.date)}, 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)`).join(",\n") +
  `\non conflict (id) do nothing;\n\n`;

const rxItems: string[] = [];
for (const c of clinicalData) {
  rxItems.push(`(${esc(c.rxItemId1)}, ${esc(c.rxId)}, ${esc(c.med1.id)}, ${esc(c.med1.name)}, ${esc(c.med1.generic)}, ${esc(c.med1.dosage)}, '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true)`);
  rxItems.push(`(${esc(c.rxItemId2)}, ${esc(c.rxId)}, ${esc(c.med2.id)}, ${esc(c.med2.name)}, ${esc(c.med2.generic)}, ${esc(c.med2.dosage)}, '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true)`);
}
c5 += `insert into public.prescription_items (id, prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic) values\n` +
  rxItems.join(",\n") + `;\n\n`;

c5 += `insert into public.medication_schedules (prescription_item_id, prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic) values\n` +
  clinicalData.map(c => `(${esc(c.rxItemId1)}, ${esc(c.rxId)}, ${esc(c.a.patientId)}, ${esc(c.med1.name)}, '1 tab', '08:00:00', ${esc(c.a.date)}, ${esc(c.a.date)}::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true)`).join(",\n") +
  `;\n\n`;

const followUps = clinicalData.filter(c => c.idx % 2 === 0);
c5 += `insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic) values\n` +
  followUps.map(c => `(${esc(c.consultId)}, ${esc(c.a.patientId)}, ${esc(c.a.doctorId)}, ${esc(c.a.clinicId)}, ${esc(c.a.date)}::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true)`).join(",\n") +
  `;\n\n`;

// doctor reviews (clinic_id null) and clinic reviews (doctor_id null)
const docReviews = followUps.slice(0, 4);
const clinicReviews = followUps.slice(4);

c5 += `insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic) values\n` +
  [
    ...docReviews.map(c => `(${esc(c.a.doctorId)}, NULL, ${esc(c.a.patientId)}, 5, 'Excellent experience', 'Very courteous doctor and thorough diagnosis. Highly recommended!', true, true)`),
    ...clinicReviews.map(c => `(NULL, ${esc(c.a.clinicId)}, ${esc(c.a.patientId)}, 5, 'Clean and efficient clinic', 'Minimal wait time and spotless consultation rooms.', true, true)`)
  ].join(",\n") +
  `;\n\n`;

c5 += `insert into public.notifications (user_id, type, title, body, is_read, is_synthetic) values\n` +
  clinicalData.map(c => `(${esc(c.a.patientId)}, 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true)`).join(",\n") +
  `;\n\n`;

// AI and Emergency
const aiConvId = rng.uuid();
c5 += `insert into public.ai_conversations (id, patient_id, title, is_synthetic) values (${esc(aiConvId)}, ${esc(DEMO_PATIENT_ID)}, 'Fever guidance inquiry', true);\n` +
  `insert into public.ai_messages (conversation_id, sender, message, is_synthetic) values\n` +
  `(${esc(aiConvId)}, 'USER', 'What should I do if I have a 101F fever?', true),\n` +
  `(${esc(aiConvId)}, 'ASSISTANT', 'Take plenty of fluids, rest, and consult a physician if fever persists over 48 hours or is accompanied by chills or breathing difficulty.', true);\n\n` +
  `insert into public.emergency_requests (patient_id, description, location_text, status, is_demo, is_synthetic) values (${esc(DEMO_PATIENT_ID)}, 'Chest discomfort and shortness of breath', 'Andheri West, Mumbai', 'CLOSED', true, true);\n`;

fs.writeFileSync(path.join(outDir, "chunk_5_clinical.sql"), c5);

console.log("Compact SQL chunks successfully generated in scratch/compact_chunks/!");
