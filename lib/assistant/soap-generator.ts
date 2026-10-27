import "server-only";
import { env, isAiConfigured } from "@/lib/env";
import { withRetry } from "@/lib/network/with-retry";

export interface PatientClinicalContext {
  patientName?: string;
  age?: number | string | null;
  gender?: string | null;
  sex?: string | null;
  visitReason?: string | null;
  allergies?: string[];
  conditions?: string[];
}

export interface SoapNote {
  chief_complaint: string;
  symptoms: string;
  clinical_notes: string;
  assessment: string;
  suggested_advice?: string;
  usedLlm: boolean;
}

const SYSTEM_PROMPT = `You are an expert Clinical Documentation AI Copilot for doctors in an outpatient clinic.
Your job is to transform raw, rough clinical notes, dictated observations, symptoms, and vitals into a clean, professional, and standardized SOAP note format.

Format Requirements:
1. "chief_complaint": A concise 1-sentence statement of the primary complaint and duration (e.g., "Acute sore throat with fever for 3 days").
2. "symptoms": Bulleted or structured list of reported and observed symptoms with onset, character, and severity.
3. "clinical_notes": Objective clinical findings (vital signs: BP, HR, Temp, SpO2, physical examination: chest, throat, abdomen, systemic review).
4. "assessment": Clinical assessment, differential or provisional diagnosis, and planned clinical pathway.
5. "suggested_advice": Clear, supportive patient instructions (e.g. hydration, warm saline gargles, red flags to watch for).

Return ONLY a valid JSON object with the exact keys:
{
  "chief_complaint": "...",
  "symptoms": "...",
  "clinical_notes": "...",
  "assessment": "...",
  "suggested_advice": "..."
}
Do not include markdown fences, preambles, or conversational text.`;

/**
 * Deterministic fallback parser for SOAP notes when Groq is unreachable, rate-limited,
 * or running offline in a test/demo environment without an active LLM key.
 */
export function buildDeterministicSoapNote(
  rawNotes: string,
  context?: PatientClinicalContext
): SoapNote {
  const text = rawNotes.trim();
  const lines = text.split(/\r?\n/).map((l) => l.trim()).filter(Boolean);

  // 1. Chief complaint detection
  let chiefComplaint = "";
  const ccMatch = text.match(/(?:c\/o|chief complaint|complains? of|presents? with|reason)(?::\s*|\s+)([^.\n]+)/i);
  if (ccMatch && ccMatch[1]) {
    chiefComplaint = ccMatch[1].trim();
  } else if (context?.visitReason) {
    chiefComplaint = context.visitReason;
  } else if (lines.length > 0) {
    chiefComplaint = lines[0].replace(/^(patient|c\/o|reports?)\s*/i, "");
    if (chiefComplaint.length > 80) {
      chiefComplaint = chiefComplaint.slice(0, 80) + "...";
    }
  }
  if (!chiefComplaint) {
    chiefComplaint = "Outpatient general medical consultation";
  }

  // 2. Vitals & Objective extraction
  const vitalsFound: string[] = [];
  const bpMatch = text.match(/\b(?:bp|blood pressure)[:\s]*(\d{2,3}\s*\/\s*\d{2,3}(?:\s*mmHg)?)\b/i);
  if (bpMatch) vitalsFound.push(`Blood Pressure: ${bpMatch[1].trim()}`);

  const hrMatch = text.match(/\b(?:hr|pulse|heart rate)[:\s]*(\d{2,3}(?:\s*bpm)?)\b/i);
  if (hrMatch) vitalsFound.push(`Heart Rate: ${hrMatch[1].trim()}`);

  const tempMatch = text.match(/\b(?:temp|temperature|fever)[:\s]*(\d{2,3}(?:\.\d)?\s*°?[FC])\b/i);
  if (tempMatch) vitalsFound.push(`Temperature: ${tempMatch[1].trim()}`);

  const spo2Match = text.match(/\b(?:spo2|oxygen|saturation)[:\s]*(\d{2,3}%?)\b/i);
  if (spo2Match) {
    const rawSpo2 = spo2Match[1].trim();
    vitalsFound.push(`SpO2: ${rawSpo2.endsWith("%") ? rawSpo2 : `${rawSpo2}%`}`);
  }

  const examNotes: string[] = [];
  if (vitalsFound.length > 0) {
    examNotes.push(`Vitals: ${vitalsFound.join(", ")}`);
  }

  // Look for physical exam phrases (e.g. "On throat exam: bilateral tonsillar erythema" or "Chest: clear")
  const examKeywords = [
    { pattern: /(?:on\s+)?(?:chest|lungs?|auscultation)(?:\s+exam)?[:\s]+([^,\n.]+)/i, label: "Respiratory" },
    { pattern: /(?:on\s+)?(?:throat|pharynx|tonsils?)(?:\s+exam)?[:\s]+([^,\n.]+)/i, label: "ENT" },
    { pattern: /(?:on\s+)?(?:abdomen|p\/a|palpation)(?:\s+exam)?[:\s]+([^,\n.]+)/i, label: "Abdominal" },
    { pattern: /(?:on\s+)?(?:cvs|heart sounds?)(?:\s+exam)?[:\s]+([^,\n.]+)/i, label: "Cardiovascular" },
  ];
  for (const ek of examKeywords) {
    const m = text.match(ek.pattern);
    if (m && m[1]) {
      examNotes.push(`${ek.label}: ${m[1].trim()}`);
    }
  }

  const clinicalNotes = examNotes.length > 0
    ? examNotes.join("\n")
    : (text.length > 0 ? `Physical Examination & Findings:\n• General condition: Stable, oriented.\n• Observed details: ${text.slice(0, 200)}` : "Physical examination unremarkable. Patient hemodynamically stable.");

  // 3. Symptoms extraction
  const symptomKeywords = [
    "fever", "cough", "cold", "headache", "throat pain", "sore throat", "pain",
    "nausea", "vomiting", "diarrhea", "body ache", "fatigue", "chills", "breathlessness",
    "dizziness", "rash", "burning micturition", "stiffness", "weakness"
  ];
  const detectedSymptoms = symptomKeywords.filter((sk) =>
    new RegExp(`\\b${sk}\\b`, "i").test(text)
  );

  let symptomsText = "";
  if (detectedSymptoms.length > 0) {
    symptomsText = detectedSymptoms.map((s) => `• ${s.charAt(0).toUpperCase() + s.slice(1)} reported`).join("\n");
  } else {
    symptomsText = lines.slice(0, 3).map((l) => `• ${l}`).join("\n") || "• Symptoms as reported in chief complaint";
  }

  // 4. Assessment extraction
  const dxMatch = text.match(/(?:diagnosis|dx|assessment|impression|provisional)[:\s]*([^.\n]+)/i);
  let assessmentText = "";
  if (dxMatch && dxMatch[1]) {
    assessmentText = `Provisional Diagnosis: ${dxMatch[1].trim()}\nPlan: Symptomatic medical management and conservative monitoring.`;
  } else if (detectedSymptoms.length > 0) {
    assessmentText = `Clinical Impression: Acute symptomatic presentation (${detectedSymptoms.slice(0, 2).join(", ")}).\nPlan: Initiate conservative outpatient pharmacotherapy, monitor recovery, and review if red flags develop.`;
  } else {
    assessmentText = "Clinical Impression: Acute uncomplicated outpatient presentation.\nPlan: Symptomatic relief and clinical observation.";
  }

  // 5. Advice
  const suggestedAdvice = "Adequate hydration, balanced diet, rest. Review immediately if high fever, worsening pain, or breathing difficulty develops.";

  return {
    chief_complaint: chiefComplaint,
    symptoms: symptomsText,
    clinical_notes: clinicalNotes,
    assessment: assessmentText,
    suggested_advice: suggestedAdvice,
    usedLlm: false,
  };
}

/**
 * Generate a structured SOAP note from rough notes and patient clinical context.
 * Calls Groq LLM when available; falls back gracefully to deterministic clinical parser.
 */
export async function generateSoapNote(
  rawNotes: string,
  context?: PatientClinicalContext
): Promise<SoapNote> {
  const fallback = buildDeterministicSoapNote(rawNotes, context);

  if (!isAiConfigured() || rawNotes.trim().length < 3) {
    return fallback;
  }

  const patientContextStr = [
    context?.patientName ? `Patient: ${context.patientName}` : null,
    context?.age ? `Age: ${context.age} years` : null,
    context?.gender ? `Gender: ${context.gender}` : null,
    context?.visitReason ? `Stated Visit Reason: ${context.visitReason}` : null,
    context?.allergies && context.allergies.length > 0 ? `Known Allergies: ${context.allergies.join(", ")}` : "Known Allergies: None recorded",
    context?.conditions && context.conditions.length > 0 ? `Chronic Conditions: ${context.conditions.join(", ")}` : null,
  ].filter(Boolean).join(" | ");

  const userPrompt = `PATIENT CONTEXT:\n${patientContextStr || "Outpatient Consultation"}\n\nDOCTOR'S ROUGH NOTES / DICTATION:\n${rawNotes}\n\nPlease generate a clean, structured SOAP clinical note in the required JSON format.`;

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 12000);

  try {
    const response = await withRetry(
      () =>
        fetch(`${env.ai.baseUrl.replace(/\/$/, "")}/chat/completions`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${env.ai.apiKey}`,
          },
          body: JSON.stringify({
            model: env.ai.model,
            temperature: 0.15,
            max_tokens: 1500,
            messages: [
              { role: "system", content: SYSTEM_PROMPT },
              { role: "user", content: userPrompt },
            ],
          }),
          signal: controller.signal,
        }),
      { retries: 1, backoffs: [400] }
    );

    if (!response.ok) {
      console.warn(`[SOAP AI] AI provider returned ${response.status}: ${response.statusText}`);
      return fallback;
    }

    const payload = (await response.json()) as {
      choices?: { message?: { content?: string } }[];
    };
    const rawContent = payload.choices?.[0]?.message?.content?.trim();
    if (!rawContent) return fallback;

    // Parse JSON safely
    const cleaned = rawContent
      .replace(/^```json\s*/i, "")
      .replace(/^```\s*/, "")
      .replace(/\s*```$/, "")
      .trim();

    let parsed: any;
    try {
      parsed = JSON.parse(cleaned);
    } catch {
      const match = rawContent.match(/\{[\s\S]*\}/);
      if (match) {
        parsed = JSON.parse(match[0]);
      }
    }

    const formatField = (val: any, fallbackVal: string): string => {
      if (typeof val === "string") return val.trim();
      if (Array.isArray(val)) {
        return val.map((item) => `• ${String(item).replace(/^[•\s-]+/, "")}`).join("\n");
      }
      if (val && typeof val === "object") {
        return Object.entries(val).map(([k, v]) => `• ${k}: ${String(v)}`).join("\n");
      }
      return fallbackVal;
    };

    if (
      parsed &&
      typeof parsed === "object" &&
      (typeof parsed.chief_complaint === "string" || Array.isArray(parsed.chief_complaint))
    ) {
      return {
        chief_complaint: formatField(parsed.chief_complaint, fallback.chief_complaint),
        symptoms: formatField(parsed.symptoms, fallback.symptoms),
        clinical_notes: formatField(parsed.clinical_notes, fallback.clinical_notes),
        assessment: formatField(parsed.assessment, fallback.assessment),
        suggested_advice: formatField(parsed.suggested_advice, fallback.suggested_advice || ""),
        usedLlm: true,
      };
    }

    return fallback;
  } catch (err) {
    console.warn("[SOAP AI] Error generating SOAP note via LLM:", err);
    return fallback;
  } finally {
    clearTimeout(timeout);
  }
}
