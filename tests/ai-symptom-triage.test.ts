import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("server-only", () => ({}));

import {
  buildDeterministicTriage,
  triageSymptoms,
} from "@/lib/assistant/symptom-triage";

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

describe("AI Symptom Triage & Specialty Doctor Finder", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  const availableSpecialties = [
    "General Medicine",
    "Cardiology",
    "Dermatology",
    "Orthopedics",
    "Pediatrics",
    "ENT",
    "Ophthalmology",
  ];

  describe("Emergency Red Flag Triage (Pre-LLM)", () => {
    it("immediately flags acute chest pain and breathing issues as emergencies", () => {
      const result = buildDeterministicTriage(
        "I have severe crushing chest pain and trouble breathing",
        availableSpecialties
      );

      expect(result.isEmergency).toBe(true);
      expect(result.urgencyLevel).toBe("EMERGENCY");
      expect(result.emergencyMessage).toContain("108");
      expect(result.emergencyMessage).toContain("112");
    });

    it("pre-LLM emergency check prevents Groq API call entirely", async () => {
      const fetchSpy = vi.spyOn(global, "fetch");

      const result = await triageSymptoms(
        "suspected stroke face drooping slurred speech",
        availableSpecialties
      );

      expect(result.isEmergency).toBe(true);
      expect(result.urgencyLevel).toBe("EMERGENCY");
      expect(fetchSpy).not.toHaveBeenCalled();
    });
  });

  describe("Deterministic Specialty Rule Engine", () => {
    it("triages fever and sore throat to General Medicine", () => {
      const result = buildDeterministicTriage(
        "Fever 101F, body ache, sore throat for 3 days",
        availableSpecialties
      );

      expect(result.isEmergency).toBe(false);
      expect(result.recommendedSpecialization).toBe("General Medicine");
      expect(result.questionsToPrepare.length).toBeGreaterThan(0);
    });

    it("triages rash and itching to Dermatology", () => {
      const result = buildDeterministicTriage(
        "Red itchy rash and hives spreading on arms",
        availableSpecialties
      );

      expect(result.isEmergency).toBe(false);
      expect(result.recommendedSpecialization).toBe("Dermatology");
    });

    it("triages knee pain and joint stiffness to Orthopedics", () => {
      const result = buildDeterministicTriage(
        "Severe knee pain and stiffness while climbing stairs",
        availableSpecialties
      );

      expect(result.isEmergency).toBe(false);
      expect(result.recommendedSpecialization).toBe("Orthopedics");
    });

    it("triages eye redness and blurred vision to Ophthalmology", () => {
      const result = buildDeterministicTriage(
        "Eye redness and blurred vision after dust exposure",
        availableSpecialties
      );

      expect(result.isEmergency).toBe(false);
      expect(result.recommendedSpecialization).toBe("Ophthalmology");
    });

    it("defaults safely to General Medicine when symptoms are non-specific", () => {
      const result = buildDeterministicTriage("Feeling unwell and tired", availableSpecialties);

      expect(result.isEmergency).toBe(false);
      expect(result.recommendedSpecialization).toBe("General Medicine");
    });
  });

  describe("Groq LLM Symptom Triage", () => {
    it("returns structured specialty recommendation from Groq JSON response", async () => {
      const mockTriage = {
        isEmergency: false,
        recommendedSpecialization: "Dermatology",
        alternativeSpecializations: ["General Medicine"],
        urgencyLevel: "ROUTINE",
        reasoning: "Skin manifestations with itching indicate acute contact or allergic dermatitis.",
        questionsToPrepare: ["When did the rash first appear?", "Any new cosmetics or soaps?"],
      };

      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response(
          JSON.stringify({
            choices: [{ message: { content: JSON.stringify(mockTriage) } }],
          }),
          { status: 200 }
        )
      );

      const result = await triageSymptoms(
        "Red itchy bumps all over my hands after cleaning",
        availableSpecialties
      );

      expect(result.usedLlm).toBe(true);
      expect(result.recommendedSpecialization).toBe("Dermatology");
      expect(result.reasoning).toBe(mockTriage.reasoning);
      expect(result.questionsToPrepare).toEqual(mockTriage.questionsToPrepare);
    });

    it("falls back gracefully when Groq fails with an HTTP error", async () => {
      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response("Bad Gateway", { status: 502, statusText: "Bad Gateway" })
      );

      const result = await triageSymptoms(
        "Severe knee joint pain and swelling",
        availableSpecialties
      );

      expect(result.usedLlm).toBe(false);
      expect(result.recommendedSpecialization).toBe("Orthopedics");
    });
  });
});
