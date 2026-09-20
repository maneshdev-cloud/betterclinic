/**
 * Static seed reference data — realistic Indian names, locations,
 * specializations, medicines, clinic names, and languages.
 *
 * All data is fictional but realistic, centered on Maharashtra (India).
 * Never uses real patient data.
 */

// ── Indian Names ──────────────────────────────────────────────────

export const MALE_FIRST_NAMES = [
  "Aarav","Aditya","Ajay","Akash","Amit","Amol","Anand","Anil","Aniket","Ankit",
  "Arjun","Ashish","Bharat","Chirag","Deepak","Dev","Dhruv","Dinesh","Ganesh","Gaurav",
  "Girish","Harish","Hemant","Hitesh","Ishaan","Jayesh","Karan","Kartik","Kiran","Krishna",
  "Kunal","Lalit","Manoj","Milind","Mohan","Mukesh","Nandish","Naveen","Nilesh","Nitin",
  "Om","Omkar","Pankaj","Paresh","Pradeep","Pranav","Prasad","Prathamesh","Rahul","Rajesh",
  "Rakesh","Ramesh","Ravi","Rohit","Roshan","Sachin","Sahil","Sagar","Sanjay","Saurabh",
  "Shashank","Shivam","Siddharth","Sunil","Suresh","Tanmay","Tejas","Tushar","Umesh","Varun",
  "Vijay","Vikas","Vikram","Vinay","Vinod","Vishal","Vivek","Yash","Yogesh","Zubin",
];

export const FEMALE_FIRST_NAMES = [
  "Aasha","Aditi","Ananya","Anjali","Ankita","Anusha","Arpita","Ashwini","Bhavna","Chitra",
  "Deepa","Devika","Diya","Gauri","Isha","Jaya","Jyoti","Kajal","Kavita","Kirti",
  "Komal","Kriti","Lakshmi","Madhuri","Manisha","Maya","Megha","Meera","Mira","Mona",
  "Namrata","Nandini","Neeta","Neha","Nikita","Nisha","Pallavi","Pooja","Prachi","Pragati",
  "Priya","Radhika","Rashmi","Rekha","Renu","Revati","Riddhi","Riya","Rohini","Rupal",
  "Sakshi","Sandhya","Sanika","Sapna","Sarika","Seema","Shilpa","Shraddha","Shreya","Shweta",
  "Siddhi","Sneha","Sonali","Sonal","Sudha","Sunita","Swati","Tanvi","Trupti","Usha",
  "Vaishali","Varsha","Vidya","Vrinda","Yamini","Yashika","Yogita","Zara","Zeel","Zoya",
];

export const LAST_NAMES = [
  "Jadhav","Patil","Deshmukh","Kulkarni","Joshi","Pawar","More","Deshpande","Bhosle","Chavan",
  "Gaekwad","Gaikwad","Shinde","Thorat","Kale","Mane","Salunkhe","Kadam","Ghate","Dange",
  "Rane","Sawant","Thakur","Naik","Shetty","Sharma","Verma","Gupta","Singh","Kumar",
  "Reddy","Nair","Menon","Iyer","Mukherjee","Chatterjee","Das","Banerjee","Bose","Sen",
  "Pillai","Patel","Shah","Mehta","Desai","Gandhi","Trivedi","Pandey","Mishra","Saxena",
  "Malhotra","Kapoor","Arora","Khanna","Bhat","Hegde","Acharya","Rao","Sinha","Tiwari",
];

// ── Locations ─────────────────────────────────────────────────────

export interface CityArea {
  city: string;
  areas: string[];
}

export const LOCATIONS: CityArea[] = [
  {
    city: "Mumbai",
    areas: ["Andheri","Bandra","Borivali","Dadar","Goregaon","Juhu","Kandivali",
            "Malad","Mulund","Powai","Thane Road","Vile Parle","Worli","Churchgate",
            "Lower Parel","Colaba","Kurla","Chembur","Sion","Wadala"],
  },
  {
    city: "Thane",
    areas: ["Ghodbunder Road","Majiwada","Kasarvadavali","Hiranandani Estate",
            "Pokhran Road","Wagle Estate","Naupada","Manpada","Balkum","Kolshet"],
  },
  {
    city: "Pune",
    areas: ["Koregaon Park","Viman Nagar","Hinjewadi","Baner","Kothrud",
            "Wakad","Deccan","Shivaji Nagar","Hadapsar","Kharadi","Aundh",
            "Pimpri","Chinchwad","Swargate","Camp"],
  },
  {
    city: "Nashik",
    areas: ["Gangapur Road","College Road","Panchavati","Indira Nagar",
            "Satpur","CIDCO","Trimbak Road","Mhasrul","Pathardi"],
  },
  {
    city: "Navi Mumbai",
    areas: ["Vashi","Nerul","Belapur","Kharghar","Panvel","Airoli",
            "Sanpada","Turbhe","Kopar Khairane","Ghansoli"],
  },
  {
    city: "Jalgaon",
    areas: ["MJ College Road","Ring Road","Nehru Nagar","Shirsoli Road",
            "Mehrun","Ajanta Road","Station Road"],
  },
];

// ── Specializations ───────────────────────────────────────────────

export const SPECIALIZATIONS = [
  "General Medicine","Cardiology","Dermatology","Pediatrics","Orthopedics",
  "ENT (Otolaryngology)","Ophthalmology","Gynecology & Obstetrics","Neurology",
  "Gastroenterology","Pulmonology","Urology","Endocrinology","Psychiatry",
  "General Surgery","Oncology","Nephrology","Rheumatology","Dentistry",
  "Physiotherapy","Radiology","Pathology","Anesthesiology","Plastic Surgery",
];

// ── Clinic Names ──────────────────────────────────────────────────

export const CLINIC_PREFIXES = [
  "HealthFirst","CarePoint","MediLife","Wellness","City Care",
  "Apollo","Fortis","Aarogya","Sanjeevani","LifeLine",
  "Shree","Sai","Galaxy","Star","Metro",
  "Prime","Elite","Royal","Heritage","Family",
  "Global","United","National","Advanced","Modern",
];

export const CLINIC_SUFFIXES = [
  "Hospital & Research Centre","Multispeciality Clinic","Medical Centre",
  "Polyclinic","Health Centre","Hospital","Nursing Home","Clinic",
  "Day Care Centre","Diagnostic Centre",
];

// ── Qualifications ────────────────────────────────────────────────

export const QUALIFICATIONS = [
  "MBBS","MBBS, MD","MBBS, MS","MBBS, MD (Medicine)","MBBS, MD (Pediatrics)",
  "MBBS, MD (Dermatology)","MBBS, MS (Orthopedics)","MBBS, MD (Cardiology)",
  "MBBS, MS (ENT)","MBBS, MS (Ophthalmology)","MBBS, MD (Gynecology)",
  "MBBS, DM (Neurology)","MBBS, MD (Gastroenterology)","MBBS, DM (Nephrology)",
  "MBBS, MD (Psychiatry)","MBBS, MS (General Surgery)","BDS","BDS, MDS",
  "BPT","BPT, MPT","MBBS, DNB","MBBS, FRCS","MBBS, MD, DM",
];

// ── Languages ─────────────────────────────────────────────────────

export const LANGUAGES = [
  "Hindi","English","Marathi","Gujarati","Tamil","Telugu","Kannada",
  "Malayalam","Bengali","Punjabi","Urdu","Konkani",
];

// ── Medicine Catalogue ────────────────────────────────────────────

export interface MedicineEntry {
  name: string;
  generic_name: string;
  form: "TABLET" | "CAPSULE" | "SYRUP" | "INJECTION" | "CREAM" | "DROPS" | "INHALER" | "OINTMENT" | "POWDER" | "SOLUTION";
  strength: string;
  category: string;
}

export const MEDICINES: MedicineEntry[] = [
  // Analgesics & Anti-inflammatory
  { name: "Dolo 650", generic_name: "Paracetamol", form: "TABLET", strength: "650mg", category: "Analgesic" },
  { name: "Crocin", generic_name: "Paracetamol", form: "TABLET", strength: "500mg", category: "Analgesic" },
  { name: "Combiflam", generic_name: "Ibuprofen + Paracetamol", form: "TABLET", strength: "400mg + 325mg", category: "Anti-inflammatory" },
  { name: "Voveran SR", generic_name: "Diclofenac Sodium", form: "TABLET", strength: "100mg", category: "Anti-inflammatory" },
  { name: "Brufen", generic_name: "Ibuprofen", form: "TABLET", strength: "400mg", category: "Anti-inflammatory" },
  { name: "Flexon", generic_name: "Ibuprofen + Paracetamol", form: "TABLET", strength: "400mg + 325mg", category: "Anti-inflammatory" },

  // Antibiotics
  { name: "Augmentin 625", generic_name: "Amoxicillin + Clavulanate", form: "TABLET", strength: "625mg", category: "Antibiotic" },
  { name: "Azithral 500", generic_name: "Azithromycin", form: "TABLET", strength: "500mg", category: "Antibiotic" },
  { name: "Monocef", generic_name: "Cefixime", form: "TABLET", strength: "200mg", category: "Antibiotic" },
  { name: "Ciproflox 500", generic_name: "Ciprofloxacin", form: "TABLET", strength: "500mg", category: "Antibiotic" },
  { name: "Amoxyclav", generic_name: "Amoxicillin + Clavulanate", form: "TABLET", strength: "625mg", category: "Antibiotic" },
  { name: "Metrogyl 400", generic_name: "Metronidazole", form: "TABLET", strength: "400mg", category: "Antibiotic" },
  { name: "Oflox 200", generic_name: "Ofloxacin", form: "TABLET", strength: "200mg", category: "Antibiotic" },
  { name: "Doxycycline 100", generic_name: "Doxycycline", form: "CAPSULE", strength: "100mg", category: "Antibiotic" },

  // Gastrointestinal
  { name: "Pan 40", generic_name: "Pantoprazole", form: "TABLET", strength: "40mg", category: "Antacid" },
  { name: "Omez 20", generic_name: "Omeprazole", form: "CAPSULE", strength: "20mg", category: "Antacid" },
  { name: "Rantac 150", generic_name: "Ranitidine", form: "TABLET", strength: "150mg", category: "Antacid" },
  { name: "Gelusil MPS", generic_name: "Aluminium + Magnesium Hydroxide", form: "SYRUP", strength: "15ml", category: "Antacid" },
  { name: "Domperidone 10", generic_name: "Domperidone", form: "TABLET", strength: "10mg", category: "Antiemetic" },
  { name: "Ondem 4", generic_name: "Ondansetron", form: "TABLET", strength: "4mg", category: "Antiemetic" },
  { name: "Loperamide 2", generic_name: "Loperamide", form: "CAPSULE", strength: "2mg", category: "Anti-diarrheal" },
  { name: "Cremaffin", generic_name: "Liquid Paraffin + Milk of Magnesia", form: "SYRUP", strength: "15ml", category: "Laxative" },

  // Cardiac / Hypertension
  { name: "Ecosprin 75", generic_name: "Aspirin", form: "TABLET", strength: "75mg", category: "Antiplatelet" },
  { name: "Amlodipine 5", generic_name: "Amlodipine", form: "TABLET", strength: "5mg", category: "Antihypertensive" },
  { name: "Telmisartan 40", generic_name: "Telmisartan", form: "TABLET", strength: "40mg", category: "Antihypertensive" },
  { name: "Atenolol 50", generic_name: "Atenolol", form: "TABLET", strength: "50mg", category: "Beta Blocker" },
  { name: "Clopidogrel 75", generic_name: "Clopidogrel", form: "TABLET", strength: "75mg", category: "Antiplatelet" },
  { name: "Atorvastatin 10", generic_name: "Atorvastatin", form: "TABLET", strength: "10mg", category: "Statin" },
  { name: "Rosuvastatin 10", generic_name: "Rosuvastatin", form: "TABLET", strength: "10mg", category: "Statin" },

  // Diabetes
  { name: "Metformin 500", generic_name: "Metformin", form: "TABLET", strength: "500mg", category: "Antidiabetic" },
  { name: "Glimepiride 1", generic_name: "Glimepiride", form: "TABLET", strength: "1mg", category: "Antidiabetic" },
  { name: "Januvia 100", generic_name: "Sitagliptin", form: "TABLET", strength: "100mg", category: "Antidiabetic" },
  { name: "Human Mixtard", generic_name: "Insulin (70/30)", form: "INJECTION", strength: "100 IU/ml", category: "Insulin" },

  // Respiratory
  { name: "Ascoril D Plus", generic_name: "Dextromethorphan + Phenylephrine + Chlorpheniramine", form: "SYRUP", strength: "10ml", category: "Cough" },
  { name: "Benadryl", generic_name: "Diphenhydramine", form: "SYRUP", strength: "10ml", category: "Cough" },
  { name: "Levolin Inhaler", generic_name: "Levosalbutamol", form: "INHALER", strength: "50mcg", category: "Bronchodilator" },
  { name: "Budecort Inhaler", generic_name: "Budesonide", form: "INHALER", strength: "200mcg", category: "Corticosteroid" },
  { name: "Montelukast 10", generic_name: "Montelukast", form: "TABLET", strength: "10mg", category: "Antiasthmatic" },
  { name: "Ambroxol 30", generic_name: "Ambroxol", form: "TABLET", strength: "30mg", category: "Mucolytic" },

  // Antiallergic
  { name: "Cetirizine 10", generic_name: "Cetirizine", form: "TABLET", strength: "10mg", category: "Antihistamine" },
  { name: "Allegra 120", generic_name: "Fexofenadine", form: "TABLET", strength: "120mg", category: "Antihistamine" },
  { name: "Montair LC", generic_name: "Montelukast + Levocetirizine", form: "TABLET", strength: "10mg + 5mg", category: "Antihistamine" },

  // Dermatology
  { name: "Betnovate-N", generic_name: "Betamethasone + Neomycin", form: "CREAM", strength: "0.1%", category: "Topical Steroid" },
  { name: "Candid Cream", generic_name: "Clotrimazole", form: "CREAM", strength: "1%", category: "Antifungal" },
  { name: "Mupirocin Ointment", generic_name: "Mupirocin", form: "OINTMENT", strength: "2%", category: "Topical Antibiotic" },
  { name: "Clobetasol Cream", generic_name: "Clobetasol", form: "CREAM", strength: "0.05%", category: "Topical Steroid" },

  // Ophthalmology
  { name: "Moxifloxacin Eye Drops", generic_name: "Moxifloxacin", form: "DROPS", strength: "0.5%", category: "Ophthalmic" },
  { name: "Tears Plus", generic_name: "Carboxymethylcellulose", form: "DROPS", strength: "0.5%", category: "Lubricant" },

  // Vitamins & Supplements
  { name: "Becosules", generic_name: "B-Complex + Vitamin C", form: "CAPSULE", strength: "—", category: "Vitamin" },
  { name: "Shelcal 500", generic_name: "Calcium + Vitamin D3", form: "TABLET", strength: "500mg + 250IU", category: "Supplement" },
  { name: "Limcee", generic_name: "Vitamin C", form: "TABLET", strength: "500mg", category: "Vitamin" },
  { name: "Autrin", generic_name: "Ferrous Fumarate + Folic Acid + Zinc", form: "CAPSULE", strength: "—", category: "Iron Supplement" },
  { name: "Neurobion Forte", generic_name: "Vitamin B1 + B6 + B12", form: "TABLET", strength: "—", category: "Vitamin" },

  // ENT
  { name: "Otrivin Nasal Drops", generic_name: "Xylometazoline", form: "DROPS", strength: "0.1%", category: "Nasal Decongestant" },
  { name: "Candid Ear Drops", generic_name: "Clotrimazole", form: "DROPS", strength: "1%", category: "Antifungal" },

  // Musculoskeletal
  { name: "Flexura D", generic_name: "Diclofenac + Tizanidine", form: "TABLET", strength: "50mg + 2mg", category: "Muscle Relaxant" },
  { name: "Thiocolchicoside 4", generic_name: "Thiocolchicoside", form: "CAPSULE", strength: "4mg", category: "Muscle Relaxant" },
  { name: "Pregabalin 75", generic_name: "Pregabalin", form: "CAPSULE", strength: "75mg", category: "Neuropathic" },

  // Psychiatric / Neurology
  { name: "Escitalopram 10", generic_name: "Escitalopram", form: "TABLET", strength: "10mg", category: "Antidepressant" },
  { name: "Alprazolam 0.25", generic_name: "Alprazolam", form: "TABLET", strength: "0.25mg", category: "Anxiolytic" },
  { name: "Clonazepam 0.5", generic_name: "Clonazepam", form: "TABLET", strength: "0.5mg", category: "Anticonvulsant" },

  // Pediatrics
  { name: "Calpol", generic_name: "Paracetamol", form: "SYRUP", strength: "120mg/5ml", category: "Analgesic" },
  { name: "Zifi 100 DT", generic_name: "Cefixime", form: "TABLET", strength: "100mg", category: "Antibiotic" },
  { name: "Meftal-P", generic_name: "Mefenamic Acid", form: "SYRUP", strength: "50mg/5ml", category: "Analgesic" },
  { name: "Enterogermina", generic_name: "Bacillus clausii", form: "SYRUP", strength: "2 billion spores", category: "Probiotic" },

  // Thyroid
  { name: "Thyronorm 50", generic_name: "Levothyroxine", form: "TABLET", strength: "50mcg", category: "Thyroid" },
  { name: "Thyronorm 100", generic_name: "Levothyroxine", form: "TABLET", strength: "100mcg", category: "Thyroid" },

  // Miscellaneous
  { name: "ORS Powder", generic_name: "Oral Rehydration Salts", form: "POWDER", strength: "21.8g", category: "Rehydration" },
  { name: "Cyclopam", generic_name: "Dicyclomine + Paracetamol", form: "TABLET", strength: "20mg + 325mg", category: "Antispasmodic" },
  { name: "Norflox TZ", generic_name: "Norfloxacin + Tinidazole", form: "TABLET", strength: "400mg + 600mg", category: "Antibiotic" },
];

// ── Visit Reasons ─────────────────────────────────────────────────

export const VISIT_REASONS = [
  "Fever and body ache","Persistent cough","Headache and dizziness",
  "Routine health checkup","Follow-up visit","Skin rash",
  "Stomach pain","Back pain","Joint pain","Chest discomfort",
  "Breathing difficulty","Eye irritation","Ear pain","Sore throat",
  "High blood pressure follow-up","Diabetes management","Thyroid check",
  "Weight management consultation","Vaccination","Lab report review",
  "Dental pain","Dental cleaning","Child vaccination","Child growth check",
  "Pregnancy checkup","Menstrual irregularity","Urinary issues",
  "Anxiety and sleep issues","Allergy symptoms","Post-surgery follow-up",
];

// ── Chief Complaints ──────────────────────────────────────────────

export const CHIEF_COMPLAINTS = [
  "Patient presents with fever (101°F) for the last 3 days with body ache",
  "Persistent dry cough for over 2 weeks, no improvement with OTC medicines",
  "Recurring headache, mainly in the morning, associated with nausea",
  "Routine annual health check, no specific complaints",
  "Follow-up after recent surgery, wound healing assessment",
  "Itchy red rash on arms and chest for 5 days",
  "Epigastric pain after meals, occasional acid reflux",
  "Lower back pain radiating to left leg, worsening with activity",
  "Knee pain and swelling, difficulty climbing stairs",
  "Intermittent chest tightness, mild shortness of breath on exertion",
  "Wheezing and difficulty breathing at night",
  "Red, watery eyes with discharge for 3 days",
  "Right ear pain with reduced hearing for 1 week",
  "Sore throat with difficulty swallowing for 4 days",
  "Blood pressure readings elevated at home despite medication",
  "Fasting sugar levels above target, requesting medication review",
  "Fatigue and weight gain, requesting thyroid evaluation",
  "Progressive weight gain, requesting dietary and exercise guidance",
  "Child due for age-appropriate vaccination schedule",
  "Review of recent lab reports, no new symptoms",
];

// ── Diagnosis Names ───────────────────────────────────────────────

export const DIAGNOSES = [
  { name: "Viral Upper Respiratory Infection", code: "J06.9" },
  { name: "Acute Pharyngitis", code: "J02.9" },
  { name: "Essential Hypertension", code: "I10" },
  { name: "Type 2 Diabetes Mellitus", code: "E11.9" },
  { name: "Allergic Rhinitis", code: "J30.9" },
  { name: "Lumbar Spondylosis", code: "M47.816" },
  { name: "Gastroesophageal Reflux Disease", code: "K21.0" },
  { name: "Acute Gastritis", code: "K29.0" },
  { name: "Iron Deficiency Anemia", code: "D50.9" },
  { name: "Hypothyroidism", code: "E03.9" },
  { name: "Bronchial Asthma", code: "J45.909" },
  { name: "Tension Headache", code: "G44.209" },
  { name: "Contact Dermatitis", code: "L25.9" },
  { name: "Urinary Tract Infection", code: "N39.0" },
  { name: "Acute Otitis Media", code: "H66.90" },
  { name: "Conjunctivitis", code: "H10.9" },
  { name: "Osteoarthritis of Knee", code: "M17.9" },
  { name: "Generalized Anxiety Disorder", code: "F41.1" },
  { name: "Vitamin D Deficiency", code: "E55.9" },
  { name: "Dental Caries", code: "K02.9" },
  { name: "Acute Bronchitis", code: "J20.9" },
  { name: "Fungal Skin Infection", code: "B36.9" },
  { name: "Migraine without Aura", code: "G43.009" },
  { name: "Dyslipidemia", code: "E78.5" },
];

// ── Follow-up Reasons ─────────────────────────────────────────────

export const FOLLOWUP_REASONS = [
  "Lab report review","Blood pressure monitoring","Sugar level check",
  "Wound assessment","Medication efficacy review","Symptom reassessment",
  "Post-procedure checkup","Prescription renewal","Growth monitoring",
  "Therapy progress review","Vaccination schedule","Diet plan follow-up",
];

// ── Notification Templates ────────────────────────────────────────

export const NOTIFICATION_TITLES: Record<string, string> = {
  APPOINTMENT_BOOKED: "Appointment Booked",
  APPOINTMENT_CONFIRMED: "Appointment Confirmed",
  APPOINTMENT_CANCELLED: "Appointment Cancelled",
  APPOINTMENT_RESCHEDULED: "Appointment Rescheduled",
  CHECK_IN_SUCCESS: "Check-in Successful",
  QUEUE_UPDATED: "Queue Updated",
  YOU_ARE_NEXT: "You Are Next!",
  DOCTOR_DELAY: "Doctor Running Late",
  CONSULTATION_COMPLETED: "Consultation Completed",
  PRESCRIPTION_CREATED: "New Prescription",
  MEDICATION_REMINDER: "Medication Reminder",
  FOLLOW_UP_REMINDER: "Follow-up Reminder",
  EMERGENCY_UPDATE: "Emergency Update",
};

// ── Blood Groups ──────────────────────────────────────────────────

export const BLOOD_GROUPS = ["A+","A-","B+","B-","O+","O-","AB+","AB-"];

// ── Clinic Facilities ─────────────────────────────────────────────

export const FACILITIES = [
  "Pharmacy","Lab","X-Ray","ECG","Ultrasound","Parking","Wheelchair Access",
  "WiFi","AC Waiting Area","Emergency Room","ICU","NICU","Blood Bank",
  "Cafeteria","Ambulance","MRI","CT Scan","Physiotherapy Room",
];
