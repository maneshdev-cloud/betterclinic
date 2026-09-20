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
    // Postgres array literal format: '{"a","b"}'
    const inner = val.map(s => `"${String(s).replace(/"/g, '\\"')}"`).join(",");
    return `'{${inner}}'`;
  }
  return "'" + String(val).replace(/'/g, "''") + "'";
}

const FIRST_NAMES_MALE = [
  "Aarav", "Rohan", "Vikram", "Aditya", "Rahul", "Siddharth", "Arjun", "Karan",
  "Nikhil", "Pranav", "Varun", "Abhishek", "Sameer", "Gaurav", "Amit", "Kunal",
  "Manish", "Harsh", "Mayur", "Dev", "Alok", "Yash", "Omkar", "Sagar"
];
const FIRST_NAMES_FEMALE = [
  "Priya", "Ananya", "Sneha", "Pooja", "Neha", "Rhea", "Tanvi", "Isha",
  "Kavita", "Deepa", "Meera", "Swati", "Shreya", "Sunita", "Aarti", "Divya",
  "Pallavi", "Ritu", "Anjali", "Komal", "Vaishali", "Smita", "Gayatri", "Shilpa"
];
const LAST_NAMES = [
  "Sharma", "Patel", "Verma", "Joshi", "Deshmukh", "Kulkarni", "Mehta", "Shah",
  "Nair", "Pillai", "Reddy", "Rao", "Iyer", "Gupta", "Malhotra", "Kapoor",
  "Chavan", "Bhosale", "Shinde", "More", "Gaikwad", "Jadhav", "Patil", "Pawar"
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
  { id: "4dc27138-6db4-4320-a7aa-d4b1819d036e", name: "Dolo 650", generic: "Paracetamol", dosage: "650mg", form: "TABLET" },
  { id: "3d69b7ab-9a32-414d-a430-27077f2d6614", name: "Crocin", generic: "Paracetamol", dosage: "500mg", form: "TABLET" },
  { id: "2f482efd-0f24-4b84-9cba-f65ee6c87d84", name: "Combiflam", generic: "Ibuprofen + Paracetamol", dosage: "400mg + 325mg", form: "TABLET" },
  { id: "1514f65e-07b1-40a3-8b50-6766b0ccde25", name: "Augmentin 625", generic: "Amoxicillin + Clavulanate", dosage: "625mg", form: "TABLET" },
  { id: "f3f9872e-2df9-4eca-aa45-5666f5969f10", name: "Azithral 500", generic: "Azithromycin", dosage: "500mg", form: "TABLET" },
  { id: "ec4d1238-cfda-4d15-983c-1075cfc94bdd", name: "Ciproflox 500", generic: "Ciprofloxacin", dosage: "500mg", form: "TABLET" },
  { id: "c67fe46e-22d8-4123-bd9b-7637b0d55998", name: "Voveran SR", generic: "Diclofenac", dosage: "100mg", form: "TABLET" },
  { id: "71ecf204-ecce-46d1-a23a-e5cdc906d54a", name: "Brufen", generic: "Ibuprofen", dosage: "400mg", form: "TABLET" }
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

const outDir = path.join(process.cwd(), "scratch", "calibrated_batches");
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

function main() {
  console.log("Generating Calibrated Seed SQL (60 patients, 30 appointments)...");

  // 1. Clinics (~18 clinics)
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

  // Demo accounts
  const DEMO_PATIENT_ID = "00000000-0000-0000-0000-000000000001";
  const DEMO_DOCTOR_ID = "00000000-0000-0000-0000-000000000002";
  const DEMO_RECEPTIONIST_ID = "00000000-0000-0000-0000-000000000003";
  const DEMO_ADMIN_ID = "00000000-0000-0000-0000-000000000004";

  // Doctors (~20 doctors including demo doctor)
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

  // Clinic Staff (~6 staff including demo receptionist and demo admin)
  const staff: any[] = [
    {
      id: DEMO_RECEPTIONIST_ID,
      email: "demo-receptionist@betterclinic.app",
      name: "Sunita Patil",
      role: "RECEPTIONIST",
      clinicId: clinics[0].id
    },
    {
      id: DEMO_ADMIN_ID,
      email: "demo-admin@betterclinic.app",
      name: "Rajesh Joshi",
      role: "CLINIC_ADMIN",
      clinicId: clinics[0].id
    }
  ];

  for (let i = 1; i <= 6; i++) {
    const isMale = rng.chance(0.5);
    const fn = isMale ? rng.pick(FIRST_NAMES_MALE) : rng.pick(FIRST_NAMES_FEMALE);
    const ln = rng.pick(LAST_NAMES);
    const sId = rng.uuid();
    const role = i % 2 === 0 ? "CLINIC_ADMIN" : "RECEPTIONIST";
    staff.push({
      id: sId,
      email: `${role.toLowerCase()}.${fn.toLowerCase()}.${i}@betterclinic.app`,
      name: `${fn} ${ln}`,
      role,
      clinicId: clinics[i % clinics.length].id
    });
  }

  // Exactly 60 Patients (including demo patient)
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
    const pId = rng.uuid();
    const loc = rng.pick(CITIES);
    const area = rng.pick(loc.areas);
    const dob = rng.dateBetween(new Date(1960, 0, 1), new Date(2012, 0, 1));
    patients.push({
      id: pId,
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

  // Exactly 30 Appointments
  // Breakdown:
  // 16 COMPLETED (past) -> will generate consultations, diagnoses, prescriptions
  // 3 CANCELLED (past)
  // 1 NO_SHOW (past)
  // 4 TODAY (2 CHECKED_IN, 1 IN_CONSULTATION, 1 WAITING)
  // 6 FUTURE (4 BOOKED, 2 CONFIRMED)
  const appointments: any[] = [];
  const today = new Date();
  const todayStr = rng.dateString(today);

  const VISIT_REASONS = [
    "Routine health checkup", "Persistent headache and fever", "Joint pain and stiffness",
    "Skin rash and itching", "Seasonal cough and throat irritation", "Blood pressure follow-up",
    "Stomach pain and acidity", "Chest tightness on exertion", "Ear pain and blockage",
    "Diabetes consultation", "Eye checkup and blurry vision", "Childhood vaccination consultation"
  ];

  // 16 Completed
  for (let i = 0; i < 16; i++) {
    const pastDate = new Date(today);
    pastDate.setDate(today.getDate() - rng.int(1, 25));
    const dStr = rng.dateString(pastDate);
    const doc = doctors[i % doctors.length];
    const pat = patients[i % patients.length];
    appointments.push({
      id: rng.uuid(),
      slotId: rng.uuid(),
      patientId: pat.id,
      doctorId: doc.id,
      clinicId: doc.clinicId,
      date: dStr,
      startTime: "10:00:00",
      endTime: "10:30:00",
      status: "COMPLETED",
      reason: VISIT_REASONS[i % VISIT_REASONS.length],
      type: "SCHEDULED"
    });
  }

  // 3 Cancelled
  for (let i = 0; i < 3; i++) {
    const pastDate = new Date(today);
    pastDate.setDate(today.getDate() - rng.int(3, 20));
    const dStr = rng.dateString(pastDate);
    const doc = rng.pick(doctors);
    const pat = patients[16 + i];
    appointments.push({
      id: rng.uuid(),
      slotId: rng.uuid(),
      patientId: pat.id,
      doctorId: doc.id,
      clinicId: doc.clinicId,
      date: dStr,
      startTime: "11:00:00",
      endTime: "11:30:00",
      status: "CANCELLED",
      reason: "Patient requested cancellation due to travel",
      type: "SCHEDULED"
    });
  }

  // 1 No-show
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
      reason: "Routine consultation",
      type: "SCHEDULED"
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
      reason: VISIT_REASONS[(i + 4) % VISIT_REASONS.length],
      type: "SCHEDULED"
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
      reason: VISIT_REASONS[(i + 6) % VISIT_REASONS.length],
      type: "SCHEDULED"
    });
  }

  console.log(`Prepared ${clinics.length} clinics, ${doctors.length} doctors, ${staff.length} staff, ${patients.length} patients, ${appointments.length} appointments.`);

  // Write Batch 1: Clinics, Hours, Codes
  let sql1 = `-- Batch 1: Clinics\n`;
  for (const c of clinics) {
    sql1 += `insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values (${esc(c.id)}, ${esc(c.name)}, ${esc(c.city)}, ${esc(c.area)}, ${esc(c.pincode)}, ${esc(c.address)}, ${esc(c.phone)}, ${esc(c.email)}, ${c.rating}, ${c.reviews}, true, true)
on conflict (id) do nothing;\n`;

    sql1 += `insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values (${esc(c.id)}, ${esc(c.invite_code)}, ${esc('DOC-' + c.invite_code)}, ${esc(c.claim_code)}, true)
on conflict (clinic_id) do nothing;\n`;

    for (let day = 0; day <= 6; day++) {
      sql1 += `insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values (${esc(c.id)}, ${day}, '08:30:00', '20:30:00', ${day === 0}, true)
on conflict (clinic_id, day_of_week) do nothing;\n`;
    }
  }
  fs.writeFileSync(path.join(outDir, "01_clinics.sql"), sql1);

  // Write Batch 2: Auth Users, Profiles, Profile Roles for Doctors & Staff
  let sql2 = `-- Batch 2: Doctors & Staff Profiles\n`;
  for (const d of doctors) {
    sql2 += `insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values (${esc(d.id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(d.email)}, '${DEMO_PASSWORD_HASH}', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"${d.name}","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = ${esc(d.email)};\n`;

    sql2 += `insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values (${esc(d.id)}, ${esc(d.name)}, ${esc(d.email)}, ${esc(d.phone)}, 'DOCTOR', true)
on conflict (id) do update set full_name = ${esc(d.name)}, is_synthetic = true;\n`;

    sql2 += `insert into public.profile_roles (profile_id, role, is_synthetic)
values (${esc(d.id)}, 'DOCTOR', true)
on conflict (profile_id, role) do nothing;\n`;

    sql2 += `insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values (${esc(d.id)}, ${esc(d.qualification)}, ${esc(d.regNo)}, ${d.experience}, ${d.fee}, ${esc(d.about)}, ${esc(d.languages)}, ${d.rating}, ${d.reviews}, true, true)
on conflict (id) do nothing;\n`;

    sql2 += `insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values (${esc(d.id)}, ${esc(d.clinicId)}, true, true)
on conflict do nothing;\n`;

    sql2 += `insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values (${esc(d.id)}, ${esc(d.specId)}, true)
on conflict do nothing;\n`;

    for (let day = 1; day <= 6; day++) {
      sql2 += `insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values (${esc(d.id)}, ${esc(d.clinicId)}, ${day}, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;\n`;
    }
  }

  for (const s of staff) {
    sql2 += `insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values (${esc(s.id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(s.email)}, '${DEMO_PASSWORD_HASH}', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"${s.name}","role":"${s.role}"}'::jsonb)
on conflict (id) do update set email = ${esc(s.email)};\n`;

    sql2 += `insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values (${esc(s.id)}, ${esc(s.name)}, ${esc(s.email)}, ${esc(rng.phone())}, ${esc(s.role)}::public.user_role, true)
on conflict (id) do update set full_name = ${esc(s.name)}, is_synthetic = true;\n`;

    sql2 += `insert into public.profile_roles (profile_id, role, is_synthetic)
values (${esc(s.id)}, ${esc(s.role)}::public.user_role, true)
on conflict (profile_id, role) do nothing;\n`;

    sql2 += `insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values (${esc(s.id)}, ${esc(s.clinicId)}, ${esc(s.role)}::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;\n`;
  }
  fs.writeFileSync(path.join(outDir, "02_doctors_staff.sql"), sql2);

  // Write Batch 3: 60 Patients + Medical History
  let sql3 = `-- Batch 3: 60 Patients\n`;
  for (const p of patients) {
    sql3 += `insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values (${esc(p.id)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(p.email)}, '${DEMO_PASSWORD_HASH}', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"${p.name}","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = ${esc(p.email)};\n`;

    sql3 += `insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values (${esc(p.id)}, ${esc(p.name)}, ${esc(p.email)}, ${esc(p.phone)}, 'PATIENT', true)
on conflict (id) do update set full_name = ${esc(p.name)}, is_synthetic = true;\n`;

    sql3 += `insert into public.profile_roles (profile_id, role, is_synthetic)
values (${esc(p.id)}, 'PATIENT', true)
on conflict (profile_id, role) do nothing;\n`;

    sql3 += `insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values (${esc(p.id)}, ${esc(p.dob)}, ${esc(p.sex)}::public.sex, ${esc(p.blood)}, ${esc(p.address)}, ${esc(p.city)}, ${esc(p.area)}, ${esc(p.pincode)}, 'Family Member', ${esc(rng.phone())}, true)
on conflict (id) do nothing;\n`;

    if (rng.chance(0.35)) {
      sql3 += `insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values (${esc(p.id)}, 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);\n`;
    }
  }
  fs.writeFileSync(path.join(outDir, "03_patients.sql"), sql3);

  // Write Batch 4: 30 Appointments, Slots, Status History
  let sql4 = `-- Batch 4: 30 Appointments\n`;
  for (const a of appointments) {
    sql4 += `insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values (${esc(a.slotId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.date)}, ${esc(a.startTime)}, ${esc(a.endTime)}, 'BOOKED', true)
on conflict do nothing;\n`;

    sql4 += `insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values (${esc(a.id)}, ${esc(a.patientId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.slotId)}, 'SCHEDULED', ${esc(a.status)}::public.appointment_status, ${esc(a.date)}, ${esc(a.startTime)}, ${esc(a.endTime)}, ${esc(a.reason)}, now() - interval '2 days', true)
on conflict (id) do nothing;\n`;

    sql4 += `insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values (${esc(a.id)}, 'BOOKED', ${esc(a.status)}::public.appointment_status, true);\n`;

    // Today's appointments get check_ins and queue entries
    if (a.date === todayStr) {
      const qId = rng.uuid();
      sql4 += `insert into public.check_ins (appointment_id, patient_id, clinic_id, check_in_time, status, is_synthetic)
values (${esc(a.id)}, ${esc(a.patientId)}, ${esc(a.clinicId)}, now() - interval '30 minutes', 'COMPLETED', true)
on conflict do nothing;\n`;

      sql4 += `insert into public.queue_entries (id, clinic_id, doctor_id, appointment_id, patient_id, token_number, status, is_synthetic)
values (${esc(qId)}, ${esc(a.clinicId)}, ${esc(a.doctorId)}, ${esc(a.id)}, ${esc(a.patientId)}, ${rng.int(1, 15)}, ${esc(a.status)}::public.queue_status, true)
on conflict do nothing;\n`;

      sql4 += `insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, note, is_synthetic)
values (${esc(qId)}, 'CALLED'::public.queue_event_type, 'WAITING'::public.queue_status, 'CALLED'::public.queue_status, 'Patient called into examination room', true);\n`;
    }
  }
  fs.writeFileSync(path.join(outDir, "04_appointments.sql"), sql4);

  // Write Batch 5: Consultations, Diagnoses, Prescriptions, Follow-ups, Reviews
  let sql5 = `-- Batch 5: Clinical records, Prescriptions, Reviews\n`;
  const completedAppts = appointments.filter(a => a.status === "COMPLETED");

  for (let i = 0; i < completedAppts.length; i++) {
    const a = completedAppts[i];
    const consultId = rng.uuid();
    const rxId = rng.uuid();
    const med1 = MEDICINES[i % MEDICINES.length];
    const med2 = MEDICINES[(i + 3) % MEDICINES.length];

    sql5 += `insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values (${esc(consultId)}, ${esc(a.id)}, ${esc(a.patientId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.reason)}, 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;\n`;

    sql5 += `insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values (${esc(consultId)}, ${esc(a.patientId)}, 'Acute upper respiratory infection', 'J06.9', true, true);\n`;

    sql5 += `insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values (${esc(consultId)}, ${esc(a.patientId)}, 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);\n`;

    sql5 += `insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values (${esc(rxId)}, ${esc(consultId)}, ${esc(a.patientId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.date)}, 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;\n`;

    sql5 += `insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values (${esc(rxId)}, ${esc(med1.id)}, ${esc(med1.name)}, ${esc(med1.generic)}, ${esc(med1.dosage)}, '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       (${esc(rxId)}, ${esc(med2.id)}, ${esc(med2.name)}, ${esc(med2.generic)}, ${esc(med2.dosage)}, '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);\n`;

    sql5 += `insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values (${esc(rxId)}, ${esc(a.patientId)}, ${esc(med1.name)}, '1 tab', '08:00:00', ${esc(a.date)}, ${esc(a.date)}::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);\n`;

    if (i % 2 === 0) {
      sql5 += `insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values (${esc(consultId)}, ${esc(a.patientId)}, ${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.date)}::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);\n`;

      sql5 += `insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values (${esc(a.doctorId)}, ${esc(a.clinicId)}, ${esc(a.patientId)}, 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);\n`;
    }

    sql5 += `insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values (${esc(a.patientId)}, 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);\n`;
  }

  // Sample AI conversation
  const aiConvId = rng.uuid();
  sql5 += `insert into public.ai_conversations (id, patient_id, title, is_synthetic)
values (${esc(aiConvId)}, ${esc(DEMO_PATIENT_ID)}, 'Fever guidance inquiry', true);\n`;

  sql5 += `insert into public.ai_messages (conversation_id, sender, message, is_synthetic)
values (${esc(aiConvId)}, 'USER', 'What should I do if I have a 101F fever?', true),
       (${esc(aiConvId)}, 'ASSISTANT', 'Take plenty of fluids, rest, and consult a physician if fever persists over 48 hours or is accompanied by chills or breathing difficulty.', true);\n`;

  // Demo emergency request
  sql5 += `insert into public.emergency_requests (patient_id, emergency_type, status, location_address, is_demo, is_synthetic)
values (${esc(DEMO_PATIENT_ID)}, 'AMBULANCE', 'COMPLETED', 'Andheri West, Mumbai', true, true);\n`;

  fs.writeFileSync(path.join(outDir, "05_clinical.sql"), sql5);

  console.log("All 5 SQL batches generated successfully in scratch/calibrated_batches/!");
}

main();
