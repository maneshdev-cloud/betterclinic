import type { Role } from "@/lib/constants";

export interface DemoAccount {
  id: string;
  email: string;
  fullName: string;
  role: Role;
  roles: Role[];
  phone: string;
  avatarUrl: string | null;
  qualification?: string;
  specialization?: string;
  clinicName?: string;
}

export const DEMO_ACCOUNTS: Record<string, DemoAccount> = {
  PATIENT: {
    id: "00000000-0000-0000-0000-000000000001",
    email: "patient.demo@betterclinic.app",
    fullName: "Ananya Sharma",
    role: "PATIENT",
    roles: ["PATIENT"],
    phone: "+919820011001",
    avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=256&q=80",
  },
  DOCTOR: {
    id: "00000000-0000-0000-0000-000000000002",
    email: "doctor.demo@betterclinic.app",
    fullName: "Dr. Aarav Deshmukh",
    role: "DOCTOR",
    roles: ["DOCTOR"],
    phone: "+919820011222",
    avatarUrl: "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=256&q=80",
    qualification: "MBBS, MD (General Medicine)",
    specialization: "General Medicine",
    clinicName: "City Central Health Clinic",
  },
  RECEPTIONIST: {
    id: "00000000-0000-0000-0000-000000000003",
    email: "receptionist.demo@betterclinic.app",
    fullName: "Sunita Patil",
    role: "RECEPTIONIST",
    roles: ["RECEPTIONIST"],
    phone: "+919820033444",
    avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=256&q=80",
    clinicName: "City Central Health Clinic",
  },
  CLINIC_ADMIN: {
    id: "00000000-0000-0000-0000-000000000004",
    email: "admin.demo@betterclinic.app",
    fullName: "Rajesh Joshi",
    role: "CLINIC_ADMIN",
    roles: ["CLINIC_ADMIN"],
    phone: "+919820055666",
    avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=256&q=80",
    clinicName: "City Central Health Clinic",
  },
};

export const MOCK_SPECIALIZATIONS = [
  { id: "3f062123-b03e-41c6-b5bf-84baa4fbae2f", name: "General Medicine" },
  { id: "333c7946-d872-4130-8e3c-dbb8824ae653", name: "Orthopedics" },
  { id: "751c5e4a-83a1-432c-98c7-be4a2526ab23", name: "Pediatrics" },
  { id: "9b15f7ae-e83f-4140-a095-3b0befb5de41", name: "Dermatology" },
  { id: "f41d4e14-64b1-46b5-96c1-44c208e81d32", name: "Neurology" },
  { id: "1f1b95cd-8630-4054-9161-1568c7edde9a", name: "Gynecology & Obstetrics" },
  { id: "6763ec01-e18f-4737-ba0e-a49cbb29a8e2", name: "Ophthalmology" },
  { id: "f5936a69-f20b-45e7-813c-a5a6819ca5d7", name: "Dentistry" },
  { id: "dd98735c-005b-41cb-8e19-7ecda93a5bf6", name: "Cardiology" },
  { id: "88a91bc2-4421-4f9e-a102-998877665544", name: "ENT (Ear, Nose, Throat)" },
];

export const MOCK_CLINICS = [
  {
    id: "adf43396-4670-4f1e-b8f6-3cf4032ddc68",
    name: "City Central Health Clinic",
    description: "Premier multi-speciality clinical center providing integrated outpatient care, diagnostic tests, and immediate priority queue appointments.",
    city: "Mumbai",
    area: "Bandra West",
    address_line: "Shop 12, Sunrise Complex, Linking Road, Bandra West",
    contact_phone: "+919820011000",
    contact_email: "contact@citycentralclinic.in",
    image_url: "https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=600&q=80",
    facilities: ["Wheelchair Accessible", "Diagnostic Lab", "In-house Pharmacy", "Emergency Care", "Wi-Fi"],
    avg_rating: 4.85,
    review_count: 142,
    is_active: true,
  },
  {
    id: "f5cdb9e4-4d2b-4e21-beea-6e812fa1fb90",
    name: "Metro Care Medical Centre",
    description: "Modern orthopedic, surgical and diagnostic outpatient wing equipped with high-precision imaging and digital health checkups.",
    city: "Pune",
    area: "Shivaji Nagar",
    address_line: "Plot 45, FC Road, Shivaji Nagar",
    contact_phone: "+919825031936",
    contact_email: "contact@metrocare-pune.in",
    image_url: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=600&q=80",
    facilities: ["X-Ray & Radiology", "Physiotherapy Wing", "Pharmacy", "Wheelchair Accessible"],
    avg_rating: 4.72,
    review_count: 98,
    is_active: true,
  },
  {
    id: "3edeb124-a986-426b-8e8e-f91fc1e4052a",
    name: "Apex Multispeciality Clinic",
    description: "Pediatric, cardiology, and general family medicine health facility with instant token check-in and child-friendly play area.",
    city: "Mumbai",
    area: "Andheri East",
    address_line: "Hub 4, Chakala Metro Station, Andheri East",
    contact_phone: "+919938407024",
    contact_email: "contact@apexclinic-andheri.in",
    image_url: "https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&w=600&q=80",
    facilities: ["Pediatric Care", "Vaccination Center", "Pathology Lab", "Wheelchair Accessible"],
    avg_rating: 4.65,
    review_count: 84,
    is_active: true,
  },
  {
    id: "f65fcf68-b380-4a03-ba2c-d560a35ea998",
    name: "LifeLine Community Healthcare",
    description: "Community health clinic focused on general practice, dermatology, preventive wellness, and rapid walk-in triage.",
    city: "Thane",
    area: "Naupada",
    address_line: "Gokhale Road, Naupada, Thane West",
    contact_phone: "+917743722754",
    contact_email: "contact@lifelinethane.in",
    image_url: "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=600&q=80",
    facilities: ["Dermatology Suite", "General Practice", "First Aid Triage", "Wheelchair Accessible"],
    avg_rating: 4.6,
    review_count: 67,
    is_active: true,
  },
];

export const MOCK_DOCTORS = [
  {
    id: "00000000-0000-0000-0000-000000000002",
    registration_number: "MMC-2012-08-3419",
    qualification: "MBBS, MD (General Medicine)",
    experience_years: 14,
    consultation_fee: 600,
    about: "Senior General Physician with 14 years clinical experience in diagnosis and treatment of chronic and acute illnesses. Dedicated to evidence-based preventive care.",
    languages: ["English", "Hindi", "Marathi"],
    avg_rating: 4.88,
    review_count: 86,
    is_accepting_patients: true,
    is_fee_public: true,
    profile: {
      full_name: "Dr. Aarav Deshmukh",
      avatar_url: "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=256&q=80",
    },
    specializations: [{ id: "3f062123-b03e-41c6-b5bf-84baa4fbae2f", name: "General Medicine" }],
    clinics: [
      {
        id: "adf43396-4670-4f1e-b8f6-3cf4032ddc68",
        name: "City Central Health Clinic",
        city: "Mumbai",
        area: "Bandra West",
      },
      {
        id: "3edeb124-a986-426b-8e8e-f91fc1e4052a",
        name: "Apex Multispeciality Clinic",
        city: "Mumbai",
        area: "Andheri East",
      },
    ],
  },
  {
    id: "8c493931-d94c-45cb-8b93-ae5aedd08d23",
    registration_number: "MMC-2007-04-1822",
    qualification: "MBBS, MS (Orthopedics)",
    experience_years: 19,
    consultation_fee: 700,
    about: "Experienced Orthopedic surgeon specializing in joint replacement, sports injuries, and arthritis management.",
    languages: ["English", "Hindi"],
    avg_rating: 4.75,
    review_count: 64,
    is_accepting_patients: true,
    is_fee_public: true,
    profile: {
      full_name: "Dr. Divya Deshmukh",
      avatar_url: "https://images.unsplash.com/photo-1594824813587-1beec9e9b047?auto=format&fit=crop&w=256&q=80",
    },
    specializations: [{ id: "333c7946-d872-4130-8e3c-dbb8824ae653", name: "Orthopedics" }],
    clinics: [
      {
        id: "f5cdb9e4-4d2b-4e21-beea-6e812fa1fb90",
        name: "Metro Care Medical Centre",
        city: "Pune",
        area: "Shivaji Nagar",
      },
      {
        id: "adf43396-4670-4f1e-b8f6-3cf4032ddc68",
        name: "City Central Health Clinic",
        city: "Mumbai",
        area: "Bandra West",
      },
    ],
  },
  {
    id: "c3148d28-624a-4f4d-a54d-8e8536ce12e2",
    registration_number: "MMC-2014-06-2910",
    qualification: "MBBS, MD (Pediatrics)",
    experience_years: 12,
    consultation_fee: 500,
    about: "Compassionate Pediatrician dedicated to child health, growth monitoring, and preventative pediatric care.",
    languages: ["English", "Hindi", "Gujarati"],
    avg_rating: 4.92,
    review_count: 112,
    is_accepting_patients: true,
    is_fee_public: true,
    profile: {
      full_name: "Dr. Varun Malhotra",
      avatar_url: "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=256&q=80",
    },
    specializations: [{ id: "751c5e4a-83a1-432c-98c7-be4a2526ab23", name: "Pediatrics" }],
    clinics: [
      {
        id: "3edeb124-a986-426b-8e8e-f91fc1e4052a",
        name: "Apex Multispeciality Clinic",
        city: "Mumbai",
        area: "Andheri East",
      },
    ],
  },
  {
    id: "f754bb3a-d23f-4b02-8799-025535f3da65",
    registration_number: "MMC-2012-11-4820",
    qualification: "MBBS, MD (Dermatology)",
    experience_years: 14,
    consultation_fee: 650,
    about: "Expert Dermatologist specializing in clinical dermatology, skin health, and allergy treatment.",
    languages: ["English", "Hindi", "Malayalam"],
    avg_rating: 4.8,
    review_count: 73,
    is_accepting_patients: true,
    is_fee_public: true,
    profile: {
      full_name: "Dr. Aarav Pillai",
      avatar_url: "https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&w=256&q=80",
    },
    specializations: [{ id: "9b15f7ae-e83f-4140-a095-3b0befb5de41", name: "Dermatology" }],
    clinics: [
      {
        id: "f65fcf68-b380-4a03-ba2c-d560a35ea998",
        name: "LifeLine Community Healthcare",
        city: "Thane",
        area: "Naupada",
      },
    ],
  },
];

const todayStr = new Date().toISOString().slice(0, 10);
const tomorrowStr = new Date(Date.now() + 86400000).toISOString().slice(0, 10);
const pastStr = new Date(Date.now() - 86400000 * 5).toISOString().slice(0, 10);

export const MOCK_APPOINTMENTS = [
  {
    id: "a1111111-1111-1111-1111-111111111111",
    patient_id: "00000000-0000-0000-0000-000000000001",
    doctor_id: "00000000-0000-0000-0000-000000000002",
    clinic_id: "adf43396-4670-4f1e-b8f6-3cf4032ddc68",
    appointment_number: "APT-2026-0042",
    appointment_date: todayStr,
    start_time: "11:00:00",
    end_time: "11:30:00",
    status: "CONFIRMED",
    appointment_type: "SCHEDULED",
    type: "IN_PERSON",
    consultation_fee: 600,
    visit_reason: "Routine quarterly health checkup and blood pressure review",
    notes: null,
    cancellation_reason: null,
    doctor: {
      qualification: "MBBS, MD (General Medicine)",
      profile: { full_name: "Dr. Aarav Deshmukh" },
    },
    clinic: {
      name: "City Central Health Clinic",
      city: "Mumbai",
      area: "Bandra West",
    },
  },
  {
    id: "a2222222-2222-2222-2222-222222222222",
    patient_id: "00000000-0000-0000-0000-000000000001",
    doctor_id: "8c493931-d94c-45cb-8b93-ae5aedd08d23",
    clinic_id: "f5cdb9e4-4d2b-4e21-beea-6e812fa1fb90",
    appointment_number: "APT-2026-0048",
    appointment_date: tomorrowStr,
    start_time: "14:00:00",
    end_time: "14:30:00",
    status: "BOOKED",
    appointment_type: "SCHEDULED",
    type: "IN_PERSON",
    consultation_fee: 700,
    visit_reason: "Knee joint stiffness and consultation for orthopedic physiotherapy",
    notes: null,
    cancellation_reason: null,
    doctor: {
      qualification: "MBBS, MS (Orthopedics)",
      profile: { full_name: "Dr. Divya Deshmukh" },
    },
    clinic: {
      name: "Metro Care Medical Centre",
      city: "Pune",
      area: "Shivaji Nagar",
    },
  },
  {
    id: "a3333333-3333-3333-3333-333333333333",
    patient_id: "00000000-0000-0000-0000-000000000001",
    doctor_id: "00000000-0000-0000-0000-000000000002",
    clinic_id: "adf43396-4670-4f1e-b8f6-3cf4032ddc68",
    appointment_number: "APT-2026-0038",
    appointment_date: pastStr,
    start_time: "15:00:00",
    end_time: "15:30:00",
    status: "COMPLETED",
    appointment_type: "SCHEDULED",
    type: "IN_PERSON",
    consultation_fee: 600,
    visit_reason: "Mild seasonal cough and allergy consultation",
    notes: "Prescribed anti-allergic medication and steam inhalation.",
    cancellation_reason: null,
    doctor: {
      qualification: "MBBS, MD (General Medicine)",
      profile: { full_name: "Dr. Aarav Deshmukh" },
    },
    clinic: {
      name: "City Central Health Clinic",
      city: "Mumbai",
      area: "Bandra West",
    },
  },
];
