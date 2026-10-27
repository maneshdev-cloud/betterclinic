import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("server-only", () => ({}));

import {
  buildDeterministicSoapNote,
  generateSoapNote,
  type PatientClinicalContext,
} from "@/lib/assistant/soap-generator";

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

describe("AI Clinical Copilot & SOAP Note Generator", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  const mockContext: PatientClinicalContext = {
    patientName: "Rohan Mehta",
    age: 28,
    gender: "MALE",
    visitReason: "Fever and body pain since 2 days",
    allergies: ["Penicillin"],
    conditions: ["Asthma"],
  };

  describe("Deterministic Clinical SOAP Engine (Fallback)", () => {
    it("extracts chief complaint, symptoms, vitals and assessment from raw notes", () => {
      const rawNotes =
        "c/o severe sore throat and fever 101 F for 3 days. BP 120/80, HR 84 bpm, SpO2 98%. On throat exam: bilateral tonsillar erythema. Diagnosis: Acute Pharyngitis.";

      const result = buildDeterministicSoapNote(rawNotes, mockContext);

      expect(result.usedLlm).toBe(false);
      expect(result.chief_complaint.toLowerCase()).toContain("sore throat and fever");
      expect(result.symptoms).toContain("Fever");
      expect(result.symptoms).toContain("Sore throat");
      expect(result.clinical_notes).toContain("Blood Pressure: 120/80");
      expect(result.clinical_notes).toContain("Heart Rate: 84 bpm");
      expect(result.clinical_notes).toContain("Temperature: 101 F");
      expect(result.clinical_notes).toContain("SpO2: 98%");
      expect(result.assessment).toContain("Acute Pharyngitis");
      expect(result.suggested_advice).toBeDefined();
    });

    it("falls back to visitReason if chief complaint is not explicitly tagged in notes", () => {
      const rawNotes = "Patient looks fatigued, vitals BP 130/85 mmHg, advice rest.";
      const result = buildDeterministicSoapNote(rawNotes, mockContext);

      expect(result.chief_complaint).toBe("Fever and body pain since 2 days");
      expect(result.clinical_notes).toContain("Blood Pressure: 130/85");
    });

    it("handles minimal input safely without crashing", () => {
      const result = buildDeterministicSoapNote("headache", undefined);

      expect(result.chief_complaint).toBeDefined();
      expect(result.symptoms).toContain("Headache");
      expect(result.clinical_notes).toBeDefined();
      expect(result.assessment).toBeDefined();
    });
  });

  describe("Groq LLM SOAP Generation", () => {
    it("returns structured SOAP note when Groq responds with valid JSON", async () => {
      const mockSoap = {
        chief_complaint: "Acute severe pharyngitis with fever for 3 days",
        symptoms: "• Severe odynophagia\n• High grade fever\n• Chills",
        clinical_notes: "Vitals: BP 120/80 mmHg, HR 88 bpm, Temp 101.2°F\nThroat: Marked tonsillar exudate, uvula midline",
        assessment: "Provisional Diagnosis: Acute Bacterial Pharyngitis\nPlan: Oral antibiotics, antipyretics, review in 3 days",
        suggested_advice: "Warm saline gargles 4 times daily, adequate fluid intake",
      };

      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response(
          JSON.stringify({
            choices: [{ message: { content: JSON.stringify(mockSoap) } }],
          }),
          { status: 200 }
        )
      );

      const result = await generateSoapNote("severe throat pain and fever 101F, bp 120/80", mockContext);

      expect(result.usedLlm).toBe(true);
      expect(result.chief_complaint).toBe(mockSoap.chief_complaint);
      expect(result.symptoms).toBe(mockSoap.symptoms);
      expect(result.clinical_notes).toBe(mockSoap.clinical_notes);
      expect(result.assessment).toBe(mockSoap.assessment);
      expect(result.suggested_advice).toBe(mockSoap.suggested_advice);
    });

    it("falls back gracefully to deterministic parser when Groq returns 500 error", async () => {
      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response("Internal Server Error", { status: 500, statusText: "Internal Error" })
      );

      const result = await generateSoapNote("fever and cough for 2 days, BP 118/76", mockContext);

      expect(result.usedLlm).toBe(false);
      expect(result.chief_complaint).toBeDefined();
      expect(result.clinical_notes).toContain("118/76");
    });

    it("falls back gracefully when Groq returns non-JSON conversational text", async () => {
      vi.spyOn(global, "fetch").mockResolvedValueOnce(
        new Response(
          JSON.stringify({
            choices: [{ message: { content: "Here is your note: patient has a cough." } }],
          }),
          { status: 200 }
        )
      );

      const result = await generateSoapNote("Patient has persistent cough and cold", mockContext);

      expect(result.usedLlm).toBe(false);
      expect(result.symptoms).toContain("Cough");
    });
  });
});
