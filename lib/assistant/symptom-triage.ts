import "server-only";
import { env, isAiConfigured } from "@/lib/env";
import { withRetry } from "@/lib/network/with-retry";
import { isEmergencyQuery, EMERGENCY_HARDCODED_REPLY } from "@/lib/assistant/safety";

export interface TriageResult {
  isEmergency: boolean;
  emergencyMessage?: string;
  recommendedSpecialization: string;
  alternativeSpecializations: string[];
  urgencyLevel: "ROUTINE" | "SAME_DAY" | "EMERGENCY";
  reasoning: string;
  questionsToPrepare: string[];
  usedLlm: boolean;
}

interface SpecialtyRule {
  specialty: string;
  keywords: RegExp[];
  reasoning: string;
  urgency: "ROUTINE" | "SAME_DAY";
  questions: string[];
}

const DETERMINISTIC_TRIAGE_RULES: SpecialtyRule[] = [
  {
    specialty: "General Medicine",
    keywords: [/\bfever\b/i, /\bcold\b/i, /\bcough\b/i, /\bflu\b/i, /\bbody ache\b/i, /\bweakness\b/i, /\bfatigue\b/i, /\bchills\b/i, /\bsore throat\b/i, /\bthroat pain\b/i, /\bgeneral\b/i, /\bcheckup\b/i, /\bdiabetes\b/i, /\bbp\b/i, /\bblood pressure\b/i],
    reasoning: "Your symptoms indicate a common acute systemic presentation (such as a viral infection, fever, or chronic metabolic management) best assessed first by a General Physician.",
    urgency: "SAME_DAY",
    questions: [
      "How many days have you had these symptoms?",
      "Have you recorded your temperature or blood pressure?",
      "Are you currently taking any fever or pain medications?",
    ],
  },
  {
    specialty: "Dermatology",
    keywords: [/\brash\b/i, /\bitching\b/i, /\bhives\b/i, /\bacne\b/i, /\beczema\b/i, /\bpsoriasis\b/i, /\bskin\b/i, /\bboil\b/i, /\bfungal\b/i, /\ballergy\b/i, /\bhair fall\b/i, /\bdandruff\b/i],
    reasoning: "These symptoms involve cutaneous or allergic dermatological manifestations which are best evaluated and diagnosed by a Dermatologist.",
    urgency: "ROUTINE",
    questions: [
      "Did this rash start after contact with any new food, soap, or medicine?",
      "Is the rash spreading or accompanied by itching or burning?",
      "Have you had similar skin episodes in the past?",
    ],
  },
  {
    specialty: "Orthopedics",
    keywords: [/\bjoint\b/i, /\bknee\b/i, /\bback pain\b/i, /\bspine\b/i, /\bfracture\b/i, /\bsprain\b/i, /\bbone\b/i, /\bswelling in joint\b/i, /\bstiffness\b/i, /\bshoulder\b/i, /\bneck pain\b/i, /\barthritis\b/i],
    reasoning: "Your symptoms point toward musculoskeletal, spinal, or joint involvement requiring orthopedic clinical examination and possible imaging.",
    urgency: "ROUTINE",
    questions: [
      "Was there any recent fall, twist, or sports trauma?",
      "Is the pain worse in the morning or after physical activity?",
      "Are you able to bear weight on the affected limb?",
    ],
  },
  {
    specialty: "Cardiology",
    keywords: [/\bpalpitation\b/i, /\bracing heart\b/i, /\birregular heartbeat\b/i, /\bheart check\b/i, /\bcholesterol\b/i, /\becg\b/i, /\bhigh bp\b/i],
    reasoning: "Cardiovascular evaluation is recommended to evaluate heart rhythm, lipid health, or persistent blood pressure regulation.",
    urgency: "SAME_DAY",
    questions: [
      "Do palpitations occur during rest or physical exertion?",
      "Do you have a family history of heart disease?",
      "Are you experiencing any lightheadedness or dizziness?",
    ],
  },
  {
    specialty: "Pediatrics",
    keywords: [/\bchild\b/i, /\bbaby\b/i, /\btoddler\b/i, /\binfant\b/i, /\bkid\b/i, /\bvaccination\b/i, /\bpediatric\b/i],
    reasoning: "Children have unique physiological and developmental requirements best evaluated by a Pediatrician.",
    urgency: "SAME_DAY",
    questions: [
      "What is the child's exact age and current weight?",
      "Is the child drinking fluids and staying active?",
      "Has any pediatric medication already been administered?",
    ],
  },
  {
    specialty: "ENT",
    keywords: [/\bear\b/i, /\bearache\b/i, /\bhearing\b/i, /\btinnitus\b/i, /\bsinus\b/i, /\bnose\b/i, /\bnosebleed\b/i, /\btonsil\b/i, /\bhoarseness\b/i, /\bvoice\b/i],
    reasoning: "Ear, nose, and throat symptoms are most effectively diagnosed with specialized ENT otoscopic and endoscopic examination.",
    urgency: "ROUTINE",
    questions: [
      "Is there any discharge or fluid coming from the ear?",
      "Do you have facial pressure or headaches around the eyes/forehead?",
      "How long has the change in voice or hearing persisted?",
    ],
  },
  {
    specialty: "Ophthalmology",
    keywords: [/\beye\b/i, /\bvision\b/i, /\bblurred vision\b/i, /\beye redness\b/i, /\beye strain\b/i, /\bwatery eye\b/i, /\bphotophobia\b/i],
    reasoning: "Visual or ocular complaints should be evaluated promptly by an Ophthalmologist with slit-lamp microscopy and visual acuity tests.",
    urgency: "ROUTINE",
    questions: [
      "Is there any sudden change in vision or flashes of light?",
      "Do you wear contact lenses or prescription glasses?",
      "Is the eye red, painful, or producing discharge?",
    ],
  },
];

/**
 * Deterministic triage rule matcher.
 */
export function buildDeterministicTriage(
  symptoms: string,
  availableSpecializations: string[] = []
): TriageResult {
  // Layer 1: Emergency check
  if (isEmergencyQuery(symptoms)) {
    return {
      isEmergency: true,
      emergencyMessage: EMERGENCY_HARDCODED_REPLY,
      recommendedSpecialization: "Emergency Care / General Medicine",
      alternativeSpecializations: ["General Medicine"],
      urgencyLevel: "EMERGENCY",
      reasoning: "Your described symptoms may indicate an urgent or life-threatening situation requiring immediate hospital-based evaluation. Do not wait for a routine clinic appointment.",
      questionsToPrepare: ["Call 108 or 112 immediately", "Report exact time of symptom onset"],
      usedLlm: false,
    };
  }

  const text = symptoms.trim().toLowerCase();

  for (const rule of DETERMINISTIC_TRIAGE_RULES) {
    if (rule.keywords.some((kw) => kw.test(text))) {
      // Check if this specialty exists in the clinic's real specialties
      const matchedName =
        availableSpecializations.find(
          (s) => s.toLowerCase() === rule.specialty.toLowerCase()
        ) || rule.specialty;

      return {
        isEmergency: false,
        recommendedSpecialization: matchedName,
        alternativeSpecializations: ["General Medicine"].filter((s) => s !== matchedName),
        urgencyLevel: rule.urgency,
        reasoning: rule.reasoning,
        questionsToPrepare: rule.questions,
        usedLlm: false,
      };
    }
  }

  // Default fallback
  const fallbackSpecialty =
    availableSpecializations.find((s) => s.toLowerCase().includes("general")) ||
    availableSpecializations[0] ||
    "General Medicine";

  return {
    isEmergency: false,
    recommendedSpecialization: fallbackSpecialty,
    alternativeSpecializations: [],
    urgencyLevel: "ROUTINE",
    reasoning:
      "A General Physician is the best first step for comprehensive evaluation, initial clinical diagnosis, and coordination with sub-specialists if required.",
    questionsToPrepare: [
      "When did you first notice these symptoms?",
      "What makes the symptoms better or worse?",
      "Are you currently taking any prescription or over-the-counter medications?",
    ],
    usedLlm: false,
  };
}

/**
 * AI Symptom Triage using Groq LLM with safety grounding & deterministic fallback.
 */
export async function triageSymptoms(
  symptoms: string,
  availableSpecializations: string[] = []
): Promise<TriageResult> {
  // Layer 1: Pre-LLM Emergency keyword check (always takes absolute precedence)
  if (isEmergencyQuery(symptoms)) {
    return buildDeterministicTriage(symptoms, availableSpecializations);
  }

  const fallback = buildDeterministicTriage(symptoms, availableSpecializations);

  if (!isAiConfigured() || symptoms.trim().length < 4) {
    return fallback;
  }

  const availableListStr =
    availableSpecializations.length > 0
      ? `Available Specialties in Clinic: ${availableSpecializations.join(", ")}`
      : "Available Specialties: General Medicine, Cardiology, Dermatology, Pediatrics, Orthopedics, ENT, Ophthalmology, Neurology";

  const systemPrompt = `You are a clinical triage intake AI assistant for an outpatient clinic portal.
Your job is to analyze a patient's natural language symptom description and recommend the single most appropriate medical specialty to consult.

CRITICAL SAFETY & TRIAGE RULES:
1. If the symptoms indicate a potential emergency (such as acute chest pain, trouble breathing, signs of stroke, heavy bleeding, suicidal thoughts), you MUST flag "isEmergency": true and "urgencyLevel": "EMERGENCY".
2. Match "recommendedSpecialization" to one of the provided clinic specialties whenever possible. If in doubt, recommend "General Medicine".
3. Return ONLY a valid JSON object matching this schema:
{
  "isEmergency": boolean,
  "recommendedSpecialization": "string",
  "alternativeSpecializations": ["string"],
  "urgencyLevel": "ROUTINE" | "SAME_DAY" | "EMERGENCY",
  "reasoning": "Brief, reassuring 1-2 sentence explanation of why this specialist is appropriate.",
  "questionsToPrepare": ["2-3 practical questions the patient should prepare for the doctor"]
}
Do NOT include markdown formatting or extra text.`;

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
            max_tokens: 1200,
            messages: [
              { role: "system", content: systemPrompt },
              {
                role: "user",
                content: `${availableListStr}\n\nPATIENT REPORTED SYMPTOMS:\n"${symptoms.trim()}"`,
              },
            ],
          }),
          signal: controller.signal,
        }),
      { retries: 1, backoffs: [400] }
    );

    if (!response.ok) {
      console.warn(`[Triage AI] Provider returned ${response.status}`);
      return fallback;
    }

    const payload = (await response.json()) as {
      choices?: { message?: { content?: string } }[];
    };
    const rawContent = payload.choices?.[0]?.message?.content?.trim();
    if (!rawContent) return fallback;

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
      if (match) parsed = JSON.parse(match[0]);
    }

    if (
      parsed &&
      typeof parsed === "object" &&
      typeof parsed.recommendedSpecialization === "string" &&
      typeof parsed.reasoning === "string"
    ) {
      // Find case-insensitive match in available list if present
      const matched =
        availableSpecializations.find(
          (s) => s.toLowerCase() === parsed.recommendedSpecialization.toLowerCase()
        ) || parsed.recommendedSpecialization;

      return {
        isEmergency: Boolean(parsed.isEmergency),
        emergencyMessage: parsed.isEmergency ? EMERGENCY_HARDCODED_REPLY : undefined,
        recommendedSpecialization: matched,
        alternativeSpecializations: Array.isArray(parsed.alternativeSpecializations)
          ? parsed.alternativeSpecializations
          : fallback.alternativeSpecializations,
        urgencyLevel: ["ROUTINE", "SAME_DAY", "EMERGENCY"].includes(parsed.urgencyLevel)
          ? parsed.urgencyLevel
          : fallback.urgencyLevel,
        reasoning: parsed.reasoning.trim(),
        questionsToPrepare: Array.isArray(parsed.questionsToPrepare) && parsed.questionsToPrepare.length > 0
          ? parsed.questionsToPrepare
          : fallback.questionsToPrepare,
        usedLlm: true,
      };
    }

    return fallback;
  } catch (err) {
    console.warn("[Triage AI] AI call failed:", err);
    return fallback;
  } finally {
    clearTimeout(timeout);
  }
}
