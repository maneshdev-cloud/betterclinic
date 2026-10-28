import type { AssistantContext } from "@/lib/assistant/fallback";

// Emergency patterns for quick detection

export const EMERGENCY_PATTERNS: RegExp[] = [
  /\bchest pain\b/i,
  /\bheart attack\b/i,
  /\bcardiac arrest\b/i,
  /\bcan'?t breathe\b/i,
  /\bdifficulty breathing\b/i,
  /\bshortness of breath\b/i,
  /\btrouble breathing\b/i,
  /\bchoking\b/i,
  /\bunconscious\b/i,
  /\bloss of consciousness\b/i,
  /\bpassed out\b/i,
  /\bfainted\b/i,
  /\bsevere bleeding\b/i,
  /\bheavy bleeding\b/i,
  /\bbleeding badly\b/i,
  /\bbleeding profusely\b/i,
  /\bstroke\b/i,
  /\bface drooping\b/i,
  /\bslurred speech\b/i,
  /\bsuicid/i,
  /\bself.?harm\b/i,
  /\bkill myself\b/i,
  /\bend my life\b/i,
  /\boverdose\b/i,
  /\bpoison(ing|ed)?\b/i,
  /\banaphylax/i,
  /\bseizure\b/i,
  /\bconvulsion\b/i,
  /\bemergen(cy|t)\b/i,
  /\bambulance\b/i,
  /\b108\b/,
  /\b112\b/,
];

export function isEmergencyQuery(message: string): boolean {
  const text = message.trim();
  return EMERGENCY_PATTERNS.some((pattern) => pattern.test(text));
}

export const EMERGENCY_HARDCODED_REPLY =
  "EMERGENCY WARNING: If you are experiencing a medical emergency (such as chest pain, difficulty breathing, severe bleeding, or suspect a heart attack or stroke), please call 108 (Ambulance) or 112 immediately, or go to the nearest emergency room. You can also use the Emergency Call button in the top navigation bar. Do not wait for a chat reply — get immediate emergency medical care.";

export interface KnownContextEntities {
  medicines: Set<string>;
  doctors: Set<string>;
  dates: Set<string>;
}

// Collects recorded medications, doctors, and dates from patient context
export function extractContextEntities(context: AssistantContext): KnownContextEntities {
  const medicines = new Set<string>();
  const doctors = new Set<string>();
  const dates = new Set<string>();

  for (const med of context.activeMedications) {
    if (med.medicine_name) {
      medicines.add(med.medicine_name.trim().toLowerCase());
      // Also add individual tokens (e.g. "Telma" from "Telma 40")
      for (const token of med.medicine_name.split(/\s+/)) {
        if (token.length > 2 && !/^\d+$/.test(token)) {
          medicines.add(token.toLowerCase());
        }
      }
    }
    if (med.end_date) dates.add(med.end_date);
  }

  for (const appt of context.upcomingAppointments) {
    if (appt.doctor_name) {
      doctors.add(appt.doctor_name.trim().toLowerCase());
      const cleanName = appt.doctor_name.replace(/^(dr\.?|doctor)\s+/i, "").trim().toLowerCase();
      if (cleanName) doctors.add(cleanName);
    }
    if (appt.date) dates.add(appt.date);
  }

  for (const fu of context.upcomingFollowUps) {
    if (fu.doctor_name) {
      doctors.add(fu.doctor_name.trim().toLowerCase());
      const cleanName = fu.doctor_name.replace(/^(dr\.?|doctor)\s+/i, "").trim().toLowerCase();
      if (cleanName) doctors.add(cleanName);
    }
    if (fu.scheduled_date) dates.add(fu.scheduled_date);
  }

  return { medicines, doctors, dates };
}

// Common medications list to check for unauthorized recommendations
const COMMON_UNAPPROVED_MEDS = [
  "aspirin",
  "ibuprofen",
  "paracetamol",
  "acetaminophen",
  "amoxicillin",
  "ciprofloxacin",
  "azithromycin",
  "atorvastatin",
  "omeprazole",
  "pantoprazole",
  "losartan",
  "amlodipine",
  "metoprolol",
  "lisinopril",
  "gabapentin",
  "tramadol",
  "codeine",
  "morphine",
  "prednisone",
  "dexamethasone",
  "hydroxychloroquine",
  "ivermectin",
  "warfarin",
  "clopidogrel",
  "nitroglycerin",
  "nitrostat",
  "disprin",
  "combiflam",
  "crocin",
  "dolo",
  "calpol",
  "augmentin",
];

// Common words ignored during medication extraction
const MED_CANDIDATE_STOPWORDS = new Set([
  "a", "an", "the", "this", "that", "these", "those", "your", "my", "our", "their", "his", "her",
  "it", "its", "them", "him", "you", "me", "us", "we", "they", "who", "whom", "which", "what",
  "and", "or", "but", "nor", "so", "for", "from", "to", "in", "on", "at", "by", "with", "without",
  "about", "into", "over", "after", "before", "between", "under", "above", "during", "through",
  "if", "when", "while", "as", "than", "then", "because", "since", "until", "unless",
  "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "not",
  "only", "own", "same", "too", "very", "can", "cannot", "will", "just", "should", "would",
  "could", "might", "must", "now", "well", "also", "properly", "regularly", "daily", "orally",
  "once", "twice", "thrice",
  "immediately", "directly", "further", "additional", "new", "old", "good", "bad", "safe",
  "care", "rest", "time", "times", "water", "fluid", "fluids", "food", "foods", "meal", "meals",
  "note", "notes", "breath", "breaths", "step", "steps", "action", "actions", "precaution", "precautions",
  "advice", "appointment", "appointments", "consultation", "consultations", "visit", "visits",
  "checkup", "checkups", "check-up", "check-ups", "doctor", "doctors", "physician", "physicians",
  "clinic", "clinics", "hospital", "hospitals", "test", "tests", "walk", "walks", "break", "breaks",
  "easy", "help", "relief", "symptom", "symptoms", "pain", "ache", "fever", "cough", "cold",
  "infection", "condition", "conditions", "disease", "health", "diet", "sleep", "exercise",
  "lifestyle", "routine", "schedule", "records", "record", "file", "files", "history", "profile",
  "log", "glucose", "sugar", "pressure", "blood", "morning", "evening", "night", "bedtime",
  "day", "days", "week", "weeks", "month", "months", "year", "years", "hour", "hours", "minute", "minutes",
  "hydration", "nutrition", "stretching", "counseling",
  "medication", "medications", "medicine", "medicines", "pill", "pills", "tablet", "tablets",
  "capsule", "capsules", "drug", "drugs", "prescription", "prescriptions", "dose", "doses",
  "dosage", "dosages", "treatment", "treatments", "therapy", "therapies", "remedy", "remedies",
  "drops", "syrup", "cream", "gel", "injection", "injections", "patch", "patches",
  "take", "takes", "took", "taking", "use", "uses", "used", "using", "give", "gives", "given", "giving",
  "get", "gets", "got", "getting", "have", "has", "had", "having", "contain", "contains", "contained",
  "include", "includes", "included", "including", "require", "requires", "required",
  "prescribe", "prescribes", "prescribed", "prescribing", "recommend", "recommends", "recommended", "recommending",
  "suggest", "suggests", "suggested", "suggesting", "start", "starts", "started", "starting",
  "stop", "stops", "stopped", "stopping", "try", "tries", "tried", "trying",
  "around", "approx", "approximately", "about", "almost", "nearly", "over", "under", "up", "down",
  "least", "most", "maximum", "minimum", "between", "another", "extra", "initial", "maintenance",
  "total", "single", "double", "regular", "oral",
  "consulting", "contacting", "calling", "visiting", "seeing", "speaking", "talking", "booking",
  "scheduling", "eating", "drinking", "sleeping", "resting", "walking", "exercising",
  "relaxing", "checking", "monitoring", "following", "asking"
]);

function isKnownMedicine(candidate: string, knownMedicines: Set<string>): boolean {
  const cand = candidate.trim().toLowerCase();
  if (!cand || cand.length < 3) return false;
  if (knownMedicines.has(cand)) return true;
  return Array.from(knownMedicines).some((km) => {
    if (km === cand) return true;
    if (km.length >= 3 && (km.includes(cand) || cand.includes(km))) {
      return true;
    }
    return false;
  });
}

export interface VerificationResult {
  valid: boolean;
  reason?: string;
}

// Validates response against known patient records to prevent inaccurate claims
export function verifyResponseEntities(
  response: string,
  context: AssistantContext
): VerificationResult {
  const text = response.toLowerCase();
  const known = extractContextEntities(context);

  for (const med of COMMON_UNAPPROVED_MEDS) {
    if (isKnownMedicine(med, known.medicines)) continue;

    const medRegex = new RegExp(`\\b${med}\\b`, "i");
    if (medRegex.test(text)) {
      return {
        valid: false,
        reason: `Response mentioned unrecorded medication: ${med}`,
      };
    }
  }

  const nonMedContext = new Set<string>();
  if (context.patientName) {
    for (const t of context.patientName.toLowerCase().split(/\s+/)) {
      if (t.length >= 3) nonMedContext.add(t);
    }
  }
  for (const appt of context.upcomingAppointments) {
    if (appt.clinic_name) {
      for (const t of appt.clinic_name.toLowerCase().split(/\s+/)) {
        if (t.length >= 3) nonMedContext.add(t);
      }
    }
  }

  const candidatePatterns: RegExp[] = [
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s*\(?\s*(?:\d+(?:\.\d+)?\s*(?:mg|ml|mcg|g|iu)\b|tablets?|capsules?|pills?|drops?|syrup)\)?/gi,
    /\b(?:\d+(?:\.\d+)?\s*(?:mg|ml|mcg|g|iu)|\d+\s*(?:tablets?|capsules?|pills?|drops?))\s+of\s+([A-Za-z][A-Za-z0-9-]{2,})\b/gi,
    /\b(?:take|taking|prescribe|prescribed|prescribing|recommend|recommended|recommending|suggest|suggested|suggesting|start|started|starting|use|using|try|trying|consider|considering)\s+(?:a\s+|an\s+|some\s+|the\s+)?(?:dose\s+of\s+|daily\s+|new\s+|oral\s+|regular\s+)?([A-Za-z][A-Za-z0-9-]{2,})\b/gi,
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s+(?:is|was|can\s+be|could\s+be|should\s+be|may\s+be|might\s+be)\s+(?:prescribed|recommended|taken|started|used|suggested|helpful|effective|beneficial)\b/gi,
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s+is\s+(?:an?\s+)?(?:option|alternative|medication|drug|treatment|remedy)\b/gi,
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s+(?:once|twice|\d+\s+times)\s+(?:a|per)?\s*(?:day|daily)\b/gi,
    /\b(?:dose|dosage|course)\s+of\s+([A-Za-z][A-Za-z0-9-]{2,})\b/gi,
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s+dose\b/gi,
  ];

  for (const pattern of candidatePatterns) {
    let candidateMatch: RegExpExecArray | null;
    while ((candidateMatch = pattern.exec(response)) !== null) {
      const rawCandidate = candidateMatch[1];
      if (!rawCandidate) continue;
      const cand = rawCandidate.trim().toLowerCase();

      if (cand.length <= 2 || MED_CANDIDATE_STOPWORDS.has(cand)) continue;

      const isDoctor =
        known.doctors.has(cand) ||
        Array.from(known.doctors).some((d) => d.includes(cand) || cand.includes(d));
      if (isDoctor) continue;

      if (nonMedContext.has(cand)) continue;

      if (!isKnownMedicine(cand, known.medicines)) {
        return {
          valid: false,
          reason: `Response mentioned unrecorded medication: ${cand}`,
        };
      }
    }
  }

  // Check for doctor names
  const doctorRegex = /\b(?:Dr\.?|Doctor)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)\b/g;
  let match: RegExpExecArray | null;
  while ((match = doctorRegex.exec(response)) !== null) {
    const rawDoctor = match[0].toLowerCase();
    const cleanDoctor = match[1].toLowerCase();

    const isKnown =
      known.doctors.has(rawDoctor) ||
      known.doctors.has(cleanDoctor) ||
      Array.from(known.doctors).some((d) => d.includes(cleanDoctor) || cleanDoctor.includes(d));

    if (cleanDoctor === "your" || cleanDoctor === "a" || cleanDoctor === "the") {
      continue;
    }

    if (!isKnown) {
      return {
        valid: false,
        reason: `Response mentioned unknown doctor: ${match[0]}`,
      };
    }
  }

  // Check for dosage alteration phrases
  const dosageChangePatterns = [
    /\b(increase|decrease|double|reduce|raise|lower)\s+(your\s+)?(dose|dosage|medication)\b/i,
    /\btake\s+\d+\s*(mg|ml|tablets?|pills?|capsules?)\s+(more|extra|instead)\b/i,
    /\b(you\s+should\s+take|i\s+prescribe|start\s+taking)\s+\b/i,
  ];

  for (const pattern of dosageChangePatterns) {
    if (pattern.test(text)) {
      return {
        valid: false,
        reason: "Response attempted direct dosage change or prescription instruction",
      };
    }
  }

  return { valid: true };
}

export const FALLBACK_GRACEFUL_NOTE =
  "\n\nI can show you what's on file, but I can't add a written explanation right now — please try again shortly.";
