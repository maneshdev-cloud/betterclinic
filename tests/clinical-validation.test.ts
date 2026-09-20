import { describe, expect, it } from "vitest";
import {
  consultationNotesSchema,
  prescriptionItemSchema,
  prescriptionSchema,
  diagnosisSchema,
  medicalHistorySchema,
  followUpSchema,
} from "@/lib/validation/clinical";

const UUID = "22222222-2222-2222-2222-222222222222";

describe("consultationNotesSchema", () => {
  it("accepts partial notes", () => {
    expect(consultationNotesSchema.safeParse({ chief_complaint: "Fever" }).success).toBe(true);
    expect(consultationNotesSchema.safeParse({}).success).toBe(true);
  });

  it("rejects over-long fields", () => {
    expect(consultationNotesSchema.safeParse({ clinical_notes: "x".repeat(4001) }).success).toBe(false);
  });
});

describe("prescriptionItemSchema", () => {
  const valid = {
    medicine_name: "Paracetamol",
    dose: "1 tablet",
    frequency: "BD",
    duration_days: "5",
    food_relation: "AFTER_FOOD",
  };

  it("accepts a valid item and coerces duration", () => {
    const parsed = prescriptionItemSchema.parse(valid);
    expect(parsed.duration_days).toBe(5);
    expect(parsed.frequency).toBe("BD");
  });

  it("requires a medicine name and dose", () => {
    expect(prescriptionItemSchema.safeParse({ ...valid, medicine_name: "P" }).success).toBe(false);
    expect(prescriptionItemSchema.safeParse({ ...valid, dose: "" }).success).toBe(false);
  });

  it("rejects invalid frequency, food relation and duration bounds", () => {
    expect(prescriptionItemSchema.safeParse({ ...valid, frequency: "DAILY" }).success).toBe(false);
    expect(prescriptionItemSchema.safeParse({ ...valid, food_relation: "WITH_MEAL" }).success).toBe(false);
    expect(prescriptionItemSchema.safeParse({ ...valid, duration_days: "0" }).success).toBe(false);
    expect(prescriptionItemSchema.safeParse({ ...valid, duration_days: "366" }).success).toBe(false);
    expect(prescriptionItemSchema.safeParse({ ...valid, duration_days: "2.5" }).success).toBe(false);
  });
});

describe("prescriptionSchema", () => {
  it("needs at least one item and a valid consultation", () => {
    expect(prescriptionSchema.safeParse({ consultationId: UUID, items: [] }).success).toBe(false);
    expect(prescriptionSchema.safeParse({ consultationId: "nope", items: [{}] }).success).toBe(false);
  });

  it("caps the number of items", () => {
    const item = {
      medicine_name: "Medicine X",
      dose: "1",
      frequency: "OD",
      duration_days: 1,
    };
    expect(
      prescriptionSchema.safeParse({ consultationId: UUID, items: Array(16).fill(item) }).success
    ).toBe(false);
    expect(
      prescriptionSchema.safeParse({ consultationId: UUID, items: Array(15).fill(item) }).success
    ).toBe(true);
  });
});

describe("diagnosisSchema", () => {
  it("requires a name", () => {
    expect(diagnosisSchema.safeParse({ consultationId: UUID, name: "Influenza" }).success).toBe(true);
    expect(diagnosisSchema.safeParse({ consultationId: UUID, name: "I" }).success).toBe(false);
  });
});

describe("medicalHistorySchema", () => {
  it("requires patient, type and title", () => {
    expect(
      medicalHistorySchema.safeParse({ patientId: UUID, record_type: "ALLERGY", title: "Penicillin" }).success
    ).toBe(true);
    expect(
      medicalHistorySchema.safeParse({ patientId: UUID, record_type: "NOT_A_TYPE", title: "X" }).success
    ).toBe(false);
  });
});

describe("followUpSchema", () => {
  it("requires a real date and a reason", () => {
    expect(
      followUpSchema.safeParse({ consultationId: UUID, scheduled_date: "2026-10-01", reason: "Review" }).success
    ).toBe(true);
    expect(
      followUpSchema.safeParse({ consultationId: UUID, scheduled_date: "01-10-2026", reason: "Review" }).success
    ).toBe(false);
    expect(
      followUpSchema.safeParse({ consultationId: UUID, scheduled_date: "2026-10-01", reason: "ok" }).success
    ).toBe(false);
  });
});
