import type { AssistantContext } from "@/lib/assistant/fallback";

/**
 * Multi-layer safety hardening for the Better Clinic Health Assistant.
 *
 * Layer 1: Keyword-triggered emergency override (pre-LLM, deterministic).
 * Layer 2: Post-response scoped entity verification (detects hallucinated meds/doctors).
 * Layer 3: Technical inability to mutate data (read-only queries, no tools/mutations).
 */

// ── 1. Emergency keyword override (Pre-LLM) ──────────────────────

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

// ── 2. Scoped Entity Extraction and Verification ─────────────────

export interface KnownContextEntities {
  medicines: Set<string>;
  doctors: Set<string>;
  dates: Set<string>;
}

/**
 * Extract authorized entities strictly from the patient's fetched records.
 */
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

/**
 * Common common-sense list of medication names or drug recommendation patterns
 * to prevent the model from diagnosing/prescribing drugs outside patient context.
 */
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

/**
 * Common non-medication stop words and context terms to ignore during medication extraction.
 */
const MED_CANDIDATE_STOPWORDS = new Set([
  // Articles, pronouns, prepositions, conjunctions
  "a", "an", "the", "this", "that", "these", "those", "your", "my", "our", "their", "his", "her",
  "it", "its", "them", "him", "you", "me", "us", "we", "they", "who", "whom", "which", "what",
  "and", "or", "but", "nor", "so", "for", "from", "to", "in", "on", "at", "by", "with", "without",
  "about", "into", "over", "after", "before", "between", "under", "above", "during", "through",
  "if", "when", "while", "as", "than", "then", "because", "since", "until", "unless",
  // Common adverbs, adjectives, auxiliaries
  "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "not",
  "only", "own", "same", "too", "very", "can", "cannot", "will", "just", "should", "would",
  "could", "might", "must", "now", "well", "also", "properly", "regularly", "daily", "orally",
  "once", "twice", "thrice",
  "immediately", "directly", "further", "additional", "new", "old", "good", "bad", "safe",
  // Conversational & medical context words
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
  // Generic medicine/prescription terms
  "medication", "medications", "medicine", "medicines", "pill", "pills", "tablet", "tablets",
  "capsule", "capsules", "drug", "drugs", "prescription", "prescriptions", "dose", "doses",
  "dosage", "dosages", "treatment", "treatments", "therapy", "therapies", "remedy", "remedies",
  "drops", "syrup", "cream", "gel", "injection", "injections", "patch", "patches",
  // Common verbs and modifiers that precede dosage or appear near clinical actions
  "take", "takes", "took", "taking", "use", "uses", "used", "using", "give", "gives", "given", "giving",
  "get", "gets", "got", "getting", "have", "has", "had", "having", "contain", "contains", "contained",
  "include", "includes", "included", "including", "require", "requires", "required",
  "prescribe", "prescribes", "prescribed", "prescribing", "recommend", "recommends", "recommended", "recommending",
  "suggest", "suggests", "suggested", "suggesting", "start", "starts", "started", "starting",
  "stop", "stops", "stopped", "stopping", "try", "tries", "tried", "trying",
  "around", "approx", "approximately", "about", "almost", "nearly", "over", "under", "up", "down",
  "least", "most", "maximum", "minimum", "between", "another", "extra", "initial", "maintenance",
  "total", "single", "double", "regular", "oral",
  // Common verbs in participle or noun forms that might follow "recommend" / "start"
  "consulting", "contacting", "calling", "visiting", "seeing", "speaking", "talking", "booking",
  "scheduling", "eating", "drinking", "sleeping", "resting", "walking", "exercising",
  "relaxing", "checking", "monitoring", "following", "asking"
]);

/**
 * Helper to check if a candidate medication name matches patient's known records.
 */
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

/**
 * Verify that Groq's response does not hallucinate doctor names, medication names,
 * or direct dosage change recommendations outside the patient's records.
 */
export function verifyResponseEntities(
  response: string,
  context: AssistantContext
): VerificationResult {
  const text = response.toLowerCase();
  const known = extractContextEntities(context);

  // 1a. Fast first-pass check against common unapproved medication list
  for (const med of COMMON_UNAPPROVED_MEDS) {
    // If the medicine is in the patient's real records, it is permitted
    if (isKnownMedicine(med, known.medicines)) continue;

    // Check if the response mentions this unapproved medication
    const medRegex = new RegExp(`\\b${med}\\b`, "i");
    if (medRegex.test(text)) {
      return {
        valid: false,
        reason: `Response mentioned unrecorded medication: ${med}`,
      };
    }
  }

  // 1b. General extraction-and-verify check for any medication mentions
  // Extract non-med context (patient name, clinic names) to avoid false positives
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
    // Candidate immediately preceding dosage unit or form (e.g. "Rosuvastatin 20mg", "Clonazepam 0.5 mg", "Montelukast tablets", "Aspirin (500mg)")
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s*\(?\s*(?:\d+(?:\.\d+)?\s*(?:mg|ml|mcg|g|iu)\b|tablets?|capsules?|pills?|drops?|syrup)\)?/gi,

    // Dosage amount / unit preceding candidate (e.g. "500mg of Rosuvastatin", "2 tablets of Montelukast")
    /\b(?:\d+(?:\.\d+)?\s*(?:mg|ml|mcg|g|iu)|\d+\s*(?:tablets?|capsules?|pills?|drops?))\s+of\s+([A-Za-z][A-Za-z0-9-]{2,})\b/gi,

    // Clinical action verbs preceding candidate (e.g. "take Rosuvastatin", "prescribing Clonazepam", "start Montelukast", "recommend taking Rosuvastatin")
    /\b(?:take|taking|prescribe|prescribed|prescribing|recommend|recommended|recommending|suggest|suggested|suggesting|start|started|starting|use|using|try|trying|consider|considering)\s+(?:a\s+|an\s+|some\s+|the\s+)?(?:dose\s+of\s+|daily\s+|new\s+|oral\s+|regular\s+)?([A-Za-z][A-Za-z0-9-]{2,})\b/gi,

    // Candidate followed by passive clinical verbs or recommendations (e.g. "Montelukast is recommended", "Rosuvastatin can be taken", "Clonazepam was prescribed")
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s+(?:is|was|can\s+be|could\s+be|should\s+be|may\s+be|might\s+be)\s+(?:prescribed|recommended|taken|started|used|suggested|helpful|effective|beneficial)\b/gi,

    // Candidate described as treatment/option
    /\b([A-Za-z][A-Za-z0-9-]{2,})\s+is\s+(?:an?\s+)?(?:option|alternative|medication|drug|treatment|remedy)\b/gi,

    // Frequency or schedule near candidate (e.g. "Rosuvastatin once daily", "Clonazepam twice a day", "dose of Montelukast", "Rosuvastatin dose")
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

      // Skip very short tokens or generic stop words
      if (cand.length <= 2 || MED_CANDIDATE_STOPWORDS.has(cand)) continue;

      // Skip if matched doctor name (handled by doctor check)
      const isDoctor =
        known.doctors.has(cand) ||
        Array.from(known.doctors).some((d) => d.includes(cand) || cand.includes(d));
      if (isDoctor) continue;

      // Skip non-med context (patient name, clinic names)
      if (nonMedContext.has(cand)) continue;

      // Check if recognized in known patient medicines
      if (!isKnownMedicine(cand, known.medicines)) {
        return {
          valid: false,
          reason: `Response mentioned unrecorded medication: ${cand}`,
        };
      }
    }
  }

  // 2. Check for doctor mentions not present in patient context
  // e.g. "Dr. Smith", "Dr. Gupta"
  const doctorRegex = /\b(?:Dr\.?|Doctor)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)\b/g;
  let match: RegExpExecArray | null;
  while ((match = doctorRegex.exec(response)) !== null) {
    const rawDoctor = match[0].toLowerCase();
    const cleanDoctor = match[1].toLowerCase();

    // Check if recognized in known context
    const isKnown =
      known.doctors.has(rawDoctor) ||
      known.doctors.has(cleanDoctor) ||
      Array.from(known.doctors).some((d) => d.includes(cleanDoctor) || cleanDoctor.includes(d));

    // Allow generic phrase "your doctor" or "a doctor"
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

  // 3. Check for direct prescription/dosage alteration commands
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
