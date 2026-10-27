import "server-only";
import { env, isAiConfigured } from "@/lib/env";
import { withRetry } from "@/lib/network/with-retry";

export interface PrescriptionItemInput {
  medicine_name: string;
  strength?: string | null;
  dose: string;
  frequency: string;
  duration_days: number;
  food_relation: string;
  instructions?: string | null;
}

export interface PrescriptionExplanationInput {
  doctor_name: string;
  clinic_name?: string;
  notes?: string | null;
  items: PrescriptionItemInput[];
  language?: "en" | "hi";
}

export interface TimelineSlot {
  slotKey: "morning" | "afternoon" | "evening" | "bedtime" | "as_needed";
  timeLabel: string;
  medicines: {
    name: string;
    dose: string;
    foodAdvice: string;
    instructions?: string;
  }[];
}

export interface MedicineExplanation {
  name: string;
  purpose: string;
  howToTake: string;
  duration: string;
  precautions: string;
}

export interface PrescriptionExplanation {
  summary: string;
  timeline: TimelineSlot[];
  medicines: MedicineExplanation[];
  safetyTips: string[];
  missedDoseAdvice: string;
  language: "en" | "hi";
  usedLlm: boolean;
}

/**
 * Common common-sense purpose dictionary for frequently prescribed outpatient medications
 */
const MEDICINE_PURPOSES: Record<string, { purposeEn: string; purposeHi: string; cautionEn: string }> = {
  paracetamol: {
    purposeEn: "Reduces fever, headache, body aches, and mild to moderate pain.",
    purposeHi: "बुखार और शरीर के दर्द को कम करने के लिए।",
    cautionEn: "Do not exceed recommended dose. Avoid combining with other paracetamol products.",
  },
  dolo: {
    purposeEn: "Paracetamol formulation used to bring down fever and relieve physical discomfort.",
    purposeHi: "बुखार और बदन दर्द कम करने के लिए।",
    cautionEn: "Take after meals with water. Do not exceed 3-4 doses in 24 hours.",
  },
  crocin: {
    purposeEn: "Fast-acting paracetamol for fever reduction and mild headache/pain relief.",
    purposeHi: "बुखार और हल्के सिरदर्द से राहत के लिए।",
    cautionEn: "Maintain at least 4-6 hours between doses.",
  },
  azithromycin: {
    purposeEn: "Antibiotic used to treat bacterial respiratory, throat, or chest infections.",
    purposeHi: "गले या छाती के बैक्टीरियल इन्फेक्शन को ठीक करने वाली एंटीबायोटिक।",
    cautionEn: "Complete the full course even if you start feeling better. Take at the same time daily.",
  },
  amoxicillin: {
    purposeEn: "Broad-spectrum penicillin antibiotic targeting bacterial infections.",
    purposeHi: "बैक्टीरिया से होने वाले संक्रमण के इलाज के लिए एंटीबायोटिक।",
    cautionEn: "Take with food to minimize stomach upset. Complete the entire course.",
  },
  augmentin: {
    purposeEn: "Antibiotic combining amoxicillin and clavulanate to combat resistant bacterial infections.",
    purposeHi: "संक्रमण को तेजी से ठीक करने वाली असरदार एंटीबायोटिक।",
    cautionEn: "Take at the start of a meal to prevent nausea and enhance absorption.",
  },
  pantoprazole: {
    purposeEn: "Proton pump inhibitor (PPI) that reduces excess stomach acid and prevents gastritis or heartburn.",
    purposeHi: "पेट में गैस और एसिडिटी को कम करने के लिए।",
    cautionEn: "Best taken first thing in the morning on an empty stomach, 30 minutes before breakfast.",
  },
  pan: {
    purposeEn: "Pantoprazole acid reducer to protect the stomach lining and prevent acid reflux.",
    purposeHi: "पेट में जलन और एसिडिटी से बचाव के लिए।",
    cautionEn: "Take 30 minutes before your morning meal with plain water.",
  },
  omeprazole: {
    purposeEn: "Antacid PPI that decreases stomach acid secretion and soothes acid indigestion.",
    purposeHi: "गैस और सीने में जलन से राहत देने के लिए।",
    cautionEn: "Swallow whole with water before breakfast; do not crush or chew.",
  },
  cetirizine: {
    purposeEn: "Antihistamine used to relieve runny nose, sneezing, itchy eyes, and allergic skin rashes.",
    purposeHi: "सर्दी, छींक, एलर्जी और खुजली से राहत के लिए।",
    cautionEn: "May cause mild drowsiness; preferable to take in the evening or bedtime.",
  },
  levocetirizine: {
    purposeEn: "Second-generation allergy medication for rhinitis, cold symptoms, and allergic itching.",
    purposeHi: "एलर्जी, बहती नाक और खुजली को ठीक करने के लिए।",
    cautionEn: "Take at night before sleeping as it can occasionally cause drowsiness.",
  },
  montelukast: {
    purposeEn: "Leukotriene receptor blocker used for asthma control and seasonal allergic rhinitis.",
    purposeHi: "सांस की नली की सूजन कम करने और एलर्जी रोकने के लिए।",
    cautionEn: "Take once daily in the evening with or without food.",
  },
  telmisartan: {
    purposeEn: "Angiotensin receptor blocker used to maintain normal blood pressure and protect heart/kidneys.",
    purposeHi: "ब्लड प्रेशर (BP) को नियंत्रित रखने के लिए।",
    cautionEn: "Take consistently at the same time every morning. Do not skip doses.",
  },
  telma: {
    purposeEn: "Brand of Telmisartan prescribed for daily blood pressure control.",
    purposeHi: "रोजाना ब्लड प्रेशर को नॉर्मल रखने के लिए।",
    cautionEn: "Take once daily in the morning. Regularly monitor your blood pressure.",
  },
  amlodipine: {
    purposeEn: "Calcium channel blocker that relaxes blood vessels to lower elevated blood pressure.",
    purposeHi: "रक्त वाहिकाओं को शिथिल कर ब्लड प्रेशर कम करने के लिए।",
    cautionEn: "Check with your doctor if you notice any ankle swelling.",
  },
  metformin: {
    purposeEn: "First-line oral diabetes medication that enhances insulin sensitivity and lowers blood sugar.",
    purposeHi: "शुगर (डायबिटीज) को कंट्रोल में रखने के लिए।",
    cautionEn: "Always take with or immediately after meals to avoid gastrointestinal upset.",
  },
  glycomet: {
    purposeEn: "Metformin formulation for glycemic control in type 2 diabetes.",
    purposeHi: "डायबिटीज में ब्लड शुगर नियंत्रित रखने के लिए।",
    cautionEn: "Take with meals as directed by your physician.",
  },
  ibuprofen: {
    purposeEn: "Anti-inflammatory pain reliever used for swelling, joint ache, or muscle soreness.",
    purposeHi: "दर्द और सूजन कम करने के लिए दर्द निवारक दवा।",
    cautionEn: "Always take after food or with milk to protect your stomach.",
  },
  combiflam: {
    purposeEn: "Combination of Ibuprofen and Paracetamol for acute pain relief and fever reduction.",
    purposeHi: "तेज दर्द और बुखार से तुरंत राहत के लिए।",
    cautionEn: "Never take on an empty stomach. Stay well hydrated.",
  },
  ors: {
    purposeEn: "Oral Rehydration Salts to restore essential electrolytes and fluids lost during diarrhea or dehydration.",
    purposeHi: "शरीर में पानी और नमक की कमी (डिहाइड्रेशन) दूर करने के लिए।",
    cautionEn: "Dissolve entire packet in clean drinking water as instructed on packet. Sip regularly.",
  },
};

function lookupMedicineInfo(name: string, isHindi: boolean) {
  const clean = name.toLowerCase().replace(/[^a-z0-9]/g, " ");
  for (const [key, data] of Object.entries(MEDICINE_PURPOSES)) {
    if (clean.includes(key)) {
      return {
        purpose: isHindi ? data.purposeHi : data.purposeEn,
        precautions: data.cautionEn,
      };
    }
  }
  return {
    purpose: isHindi
      ? "डॉक्टर द्वारा सुझाई गई विशिष्ट स्वास्थ्य समस्या के उपचार के लिए।"
      : "Prescribed by your doctor for your diagnosed clinical condition.",
    precautions: "Take exactly as prescribed with water. Complete course as directed.",
  };
}

function getFoodAdvice(relation: string, isHindi: boolean): string {
  switch (relation) {
    case "BEFORE_FOOD":
      return isHindi ? "खाली पेट (खाने से 30 मिनट पहले)" : "Before food / empty stomach (30 mins before meal)";
    case "AFTER_FOOD":
      return isHindi ? "खाने के बाद" : "After food / post-meal";
    case "WITH_FOOD":
      return isHindi ? "खाने के साथ" : "With meals";
    default:
      return isHindi ? "पानी के साथ" : "With water";
  }
}

/**
 * Deterministic explanation and timeline builder.
 */
export function buildDeterministicPrescriptionExplanation(
  input: PrescriptionExplanationInput
): PrescriptionExplanation {
  const isHindi = input.language === "hi";

  // Build daily timeline slots
  const morningMeds: TimelineSlot["medicines"] = [];
  const afternoonMeds: TimelineSlot["medicines"] = [];
  const eveningMeds: TimelineSlot["medicines"] = [];
  const bedtimeMeds: TimelineSlot["medicines"] = [];
  const asNeededMeds: TimelineSlot["medicines"] = [];

  const medicineExplanations: MedicineExplanation[] = [];

  for (const item of input.items) {
    const fullName = `${item.medicine_name}${item.strength ? ` (${item.strength})` : ""}`;
    const info = lookupMedicineInfo(item.medicine_name, isHindi);
    const foodAdvice = getFoodAdvice(item.food_relation, isHindi);

    const medEntry = {
      name: fullName,
      dose: item.dose,
      foodAdvice,
      instructions: item.instructions || undefined,
    };

    const freq = (item.frequency || "").toUpperCase();
    if (freq === "OD") {
      morningMeds.push(medEntry);
    } else if (freq === "BD") {
      morningMeds.push(medEntry);
      bedtimeMeds.push(medEntry);
    } else if (freq === "TDS") {
      morningMeds.push(medEntry);
      afternoonMeds.push(medEntry);
      bedtimeMeds.push(medEntry);
    } else if (freq === "QID") {
      morningMeds.push(medEntry);
      afternoonMeds.push(medEntry);
      eveningMeds.push(medEntry);
      bedtimeMeds.push(medEntry);
    } else if (freq === "HS") {
      bedtimeMeds.push(medEntry);
    } else {
      asNeededMeds.push(medEntry);
    }

    medicineExplanations.push({
      name: fullName,
      purpose: info.purpose,
      howToTake: `${item.dose} · ${foodAdvice}`,
      duration: `${item.duration_days} day${item.duration_days === 1 ? "" : "s"}`,
      precautions: info.precautions,
    });
  }

  const timeline: TimelineSlot[] = [];
  if (morningMeds.length > 0) {
    timeline.push({
      slotKey: "morning",
      timeLabel: isHindi ? "सुबह (नाश्ते के आसपास · 8:00 - 9:00 AM)" : "Morning (around breakfast · 8:00 - 9:00 AM)",
      medicines: morningMeds,
    });
  }
  if (afternoonMeds.length > 0) {
    timeline.push({
      slotKey: "afternoon",
      timeLabel: isHindi ? "दोपहर (दोपहर के भोजन के बाद · 1:00 - 2:00 PM)" : "Afternoon (after lunch · 1:00 - 2:00 PM)",
      medicines: afternoonMeds,
    });
  }
  if (eveningMeds.length > 0) {
    timeline.push({
      slotKey: "evening",
      timeLabel: isHindi ? "शाम (चाय / स्नैक्स के समय · 5:00 - 6:00 PM)" : "Evening (around 5:00 - 6:00 PM)",
      medicines: eveningMeds,
    });
  }
  if (bedtimeMeds.length > 0) {
    timeline.push({
      slotKey: "bedtime",
      timeLabel: isHindi ? "रात / सोने से पहले (डिनर के बाद · 9:00 - 10:00 PM)" : "Night / Bedtime (after dinner · 9:00 - 10:00 PM)",
      medicines: bedtimeMeds,
    });
  }
  if (asNeededMeds.length > 0) {
    timeline.push({
      slotKey: "as_needed",
      timeLabel: isHindi ? "जरूरत पड़ने पर (SOS)" : "As Needed (SOS / when symptoms arise)",
      medicines: asNeededMeds,
    });
  }

  const summary = isHindi
    ? `डॉ. ${input.doctor_name} द्वारा लिखी गई दवाएं। दिनचर्या के अनुसार समय पर दवाएं लें ताकि जल्दी स्वास्थ्य लाभ मिल सके।`
    : `Prescribed by Dr. ${input.doctor_name}. Follow this daily schedule to maximize recovery and prevent missed doses.`;

  const safetyTips = isHindi
    ? [
        "दवाएं हमेशा पर्याप्त पानी के साथ लें।",
        "एंटीबायोटिक्स का पूरा कोर्स खत्म करें, भले ही आप पहले ही ठीक महसूस करने लगें।",
        "किसी भी नई दवा को शुरू करने या रोकने से पहले अपने डॉक्टर से परामर्श करें।",
        "दवाओं को धूप और नमी से दूर ठंडी व सूखी जगह पर रखें।",
      ]
    : [
        "Take medicines with a full glass of water unless instructed otherwise.",
        "Complete the full antibiotic course even if your symptoms improve early.",
        "Do not stop chronic blood pressure or diabetes medications without consulting your doctor.",
        "Store in a cool, dry place away from direct sunlight.",
      ];

  const missedDoseAdvice = isHindi
    ? "यदि कोई खुराक छूट जाए, तो याद आते ही ले लें। यदि अगली खुराक का समय हो चुका हो, तो छूटी हुई खुराक छोड़ दें — कभी भी दोहरी खुराक न लें।"
    : "If you miss a dose, take it as soon as you remember. If it is almost time for your next scheduled dose, skip the missed dose and resume your regular schedule. Never double up.";

  return {
    summary,
    timeline,
    medicines: medicineExplanations,
    safetyTips,
    missedDoseAdvice,
    language: input.language || "en",
    usedLlm: false,
  };
}

/**
 * Generate AI-enhanced prescription explanation using Groq LLM with fallback
 */
export async function generatePrescriptionExplanation(
  input: PrescriptionExplanationInput
): Promise<PrescriptionExplanation> {
  const fallback = buildDeterministicPrescriptionExplanation(input);

  if (!isAiConfigured() || input.items.length === 0) {
    return fallback;
  }

  const isHindi = input.language === "hi";

  const systemPrompt = `You are a warm, reassuring, and expert Clinical Pharmacist AI Assistant.
Your task is to take a doctor's prescription and explain it in clear, friendly plain language (${isHindi ? "Hindi" : "English"}) so the patient understands:
1. When to take each medicine (Daily Routine: Morning, Afternoon, Evening, Night/Bedtime, As Needed).
2. Why each medicine is prescribed (clinical purpose in simple layman terms).
3. Practical food and lifestyle precautions.
4. What to do if a dose is missed.

STRICT MEDICAL SAFETY RULES:
- Ground every medicine strictly in the provided prescription list. Never invent or suggest unprescribed drugs.
- Do not alter prescribed doses or durations.
- Output ONLY a valid JSON object matching this schema:
{
  "summary": "...",
  "timeline": [
    {
      "slotKey": "morning" | "afternoon" | "evening" | "bedtime" | "as_needed",
      "timeLabel": "...",
      "medicines": [{ "name": "...", "dose": "...", "foodAdvice": "..." }]
    }
  ],
  "medicines": [
    {
      "name": "...",
      "purpose": "...",
      "howToTake": "...",
      "duration": "...",
      "precautions": "..."
    }
  ],
  "safetyTips": ["...", "..."],
  "missedDoseAdvice": "..."
}
Do not include any conversational preamble or markdown code blocks.`;

  const userPrompt = `PRESCRIPTION DETAILS:
Doctor: ${input.doctor_name}
Clinic: ${input.clinic_name || "Better Clinic"}
Doctor's Notes: ${input.notes || "None"}

MEDICATIONS:
${input.items
  .map(
    (item, i) =>
      `${i + 1}. ${item.medicine_name} ${item.strength || ""} — Dose: ${item.dose}, Frequency: ${item.frequency}, Duration: ${item.duration_days} days, Meal Relation: ${item.food_relation}, Instructions: ${item.instructions || "None"}`
  )
  .join("\n")}

Language: ${isHindi ? "Hindi (हिंदी)" : "English"}`;

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
              { role: "system", content: systemPrompt },
              { role: "user", content: userPrompt },
            ],
          }),
          signal: controller.signal,
        }),
      { retries: 1, backoffs: [400] }
    );

    if (!response.ok) {
      console.warn(`[Prescription AI] Provider returned ${response.status}`);
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
      Array.isArray(parsed.timeline) &&
      Array.isArray(parsed.medicines)
    ) {
      return {
        summary: typeof parsed.summary === "string" ? parsed.summary : fallback.summary,
        timeline: parsed.timeline,
        medicines: parsed.medicines,
        safetyTips: Array.isArray(parsed.safetyTips) ? parsed.safetyTips : fallback.safetyTips,
        missedDoseAdvice: typeof parsed.missedDoseAdvice === "string" ? parsed.missedDoseAdvice : fallback.missedDoseAdvice,
        language: input.language || "en",
        usedLlm: true,
      };
    }

    return fallback;
  } catch (e) {
    console.warn("[Prescription AI] Failed LLM call:", e);
    return fallback;
  } finally {
    clearTimeout(timeout);
  }
}
