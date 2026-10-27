import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("server-only", () => ({}));

import {
  buildDeterministicPrescriptionExplanation,
  generatePrescriptionExplanation,
  type PrescriptionExplanationInput,
} from "@/lib/assistant/prescription-explainer";

vi.mock("@/lib/env", () => ({
  env: {
    ai: {
      provider: "groq",
      baseUrl: "https://api.groq.com/openai/v1",
      model: "openai/gpt-oss-120b",
      apiKey: "gsk_test_key_12345",
    },
  },
  isAiConfigured: vi.fn(() => true),
}));

describe("AI Prescription & Medication Timeline Explainer", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  const mockPrescription: PrescriptionExplanationInput = {
    doctor_name: "Dr. Aditya Verma",
    clinic_name: "City Central Health Clinic",
    notes: "Take warm saline gargles 3 times a day",
    items: [
      {
        medicine_name: "Pantoprazole",
        strength: "40mg",
        dose: "1 tablet",
        frequency: "OD",
        duration_days: 5,
        food_relation: "BEFORE_FOOD",
        instructions: "30 mins before breakfast",
      },
      {
        medicine_name: "Azithromycin",
        strength: "500mg",
        dose: "1 tablet",
        frequency: "OD",
        duration_days: 3,
        food_relation: "AFTER_FOOD",
        instructions: "After morning meal",
      },
      {
        medicine_name: "Dolo",
        strength: "650mg",
        dose: "1 tablet",
        frequency: "BD",
        duration_days: 3,
        food_relation: "AFTER_FOOD",
        instructions: "Morning and night if fever",
      },
    ],
  };

  describe("Deterministic Timeline Engine", () => {
    it("maps OD and BD frequencies to proper morning and bedtime slots", () => {
      const result = buildDeterministicPrescriptionExplanation(mockPrescription);

      expect(result.usedLlm).toBe(false);
      expect(result.timeline.length).toBeGreaterThanOrEqual(2);

      const morningSlot = result.timeline.find((s) => s.slotKey === "morning");
      expect(morningSlot).toBeDefined();
      expect(morningSlot?.medicines.some((m) => m.name.includes("Pantoprazole"))).toBe(true);
      expect(morningSlot?.medicines.some((m) => m.name.includes("Azithromycin"))).toBe(true);
      expect(morningSlot?.medicines.some((m) => m.name.includes("Dolo"))).toBe(true);

      const bedtimeSlot = result.timeline.find((s) => s.slotKey === "bedtime");
      expect(bedtimeSlot).toBeDefined();
      expect(bedtimeSlot?.medicines.some((m) => m.name.includes("Dolo"))).toBe(true);
      expect(bedtimeSlot?.medicines.some((m) => m.name.includes("Pantoprazole"))).toBe(false);
    });

    it("explains medicine purposes in plain English", () => {
      const result = buildDeterministicPrescriptionExplanation(mockPrescription);

      const panto = result.medicines.find((m) => m.name.includes("Pantoprazole"));
      expect(panto?.purpose.toLowerCase()).toContain("acid");

      const azithro = result.medicines.find((m) => m.name.includes("Azithromycin"));
      expect(azithro?.purpose.toLowerCase()).toContain("antibiotic");

      expect(result.missedDoseAdvice.toLowerCase()).toContain("never double up");
    });

    it("generates Hindi explanations when requested", () => {
      const result = buildDeterministicPrescriptionExplanation({
        ...mockPrescription,
        language: "hi",
      });

      expect(result.language).toBe("hi");
      const morningSlot = result.timeline.find((s) => s.slotKey === "morning");
      expect(morningSlot?.timeLabel).toContain("सुबह");
      expect(result.missedDoseAdvice).toContain("दोहरी खुराक न लें");
    });
  });

  describe("Groq LLM Prescription Explainer", () => {
    it("returns structured timeline and explanation when Groq returns valid JSON", async () => {
      const mockLlmResponse = {
        summary: "This prescription targets your acute throat infection and fever.",
        timeline: [
          {
            slotKey: "morning",
            timeLabel: "Morning (8:30 AM)",
            medicines: [{ name: "Pantoprazole 40mg", dose: "1 tab", foodAdvice: "Before breakfast" }],
          },
        ],
        medicines: [
          {
            name: "Pantoprazole 40mg",
            purpose: "Prevents gastric acidity caused by antibiotics",
            howToTake: "Empty stomach",
            duration: "5 days",
            precautions: "Do not chew",
          },
        ],
        safetyTips: ["Drink plenty of warm water"],
        missedDoseAdvice: "Take as soon as you remember, but do not double dose.",
      };

      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response(
          JSON.stringify({
            choices: [{ message: { content: JSON.stringify(mockLlmResponse) } }],
          }),
          { status: 200 }
        )
      );

      const result = await generatePrescriptionExplanation(mockPrescription);

      expect(result.usedLlm).toBe(true);
      expect(result.summary).toBe(mockLlmResponse.summary);
      expect(result.timeline[0]?.slotKey).toBe("morning");
      expect(result.safetyTips[0]).toBe("Drink plenty of warm water");
    });

    it("falls back gracefully when Groq returns an error", async () => {
      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response("Gateway Timeout", { status: 504, statusText: "Timeout" })
      );

      const result = await generatePrescriptionExplanation(mockPrescription);

      expect(result.usedLlm).toBe(false);
      expect(result.timeline.length).toBeGreaterThan(0);
      expect(result.medicines.length).toBe(3);
    });
  });
});
