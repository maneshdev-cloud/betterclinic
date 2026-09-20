import { describe, expect, it } from "vitest";
import { buildFallbackReply, detectIntent, DISCLAIMER, type AssistantContext } from "@/lib/assistant/fallback";

/** Rich fixture mirroring what buildAssistantContext() fetches from the database. */
function fullContext(): AssistantContext {
  return {
    patientName: "Aarav Sharma",
    upcomingAppointments: [
      {
        doctor_name: "Dr. Meera Iyer",
        clinic_name: "Sunrise Family Clinic",
        date: "2026-09-18",
        start_time: "10:30",
        status: "CONFIRMED",
      },
      {
        doctor_name: "Dr. Raj Patil",
        clinic_name: "Pimpri Health Centre",
        date: "2026-09-25",
        start_time: "16:00",
        status: "PENDING",
      },
    ],
    activeMedications: [
      { medicine_name: "Metformin", dose: "500 mg", times: ["09:00", "21:00"], end_date: "2026-10-15" },
      { medicine_name: "Telma 40", dose: "40 mg", times: ["08:00"], end_date: "2026-10-01" },
    ],
    allergies: ["Penicillin", "Dust"],
    conditions: ["Type 2 Diabetes", "Hypertension"],
    upcomingFollowUps: [
      { scheduled_date: "2026-09-30", reason: "Sugar level review", doctor_name: "Dr. Meera Iyer" },
    ],
    queue: { token_code: "B-07", status: "WAITING", position: 3, people_ahead: 2 },
  };
}

function emptyContext(): AssistantContext {
  return {
    patientName: "Priya",
    upcomingAppointments: [],
    activeMedications: [],
    allergies: [],
    conditions: [],
    upcomingFollowUps: [],
    queue: null,
  };
}

describe("detectIntent", () => {
  it("detects emergencies first, before other keyword matches", () => {
    expect(detectIntent("I have chest pain and can't breathe")).toBe("emergency");
    expect(detectIntent("my father is unconscious after an accident")).toBe("emergency");
    expect(detectIntent("I think it's an overdose of my tablets")).toBe("emergency");
  });

  it("detects appointment questions", () => {
    expect(detectIntent("When is my next appointment?")).toBe("appointments");
    expect(detectIntent("do I have any bookings?")).toBe("appointments");
  });

  it("detects medication questions", () => {
    expect(detectIntent("What medications am I taking?")).toBe("medications");
    expect(detectIntent("what dose of my tablets should I take")).toBe("medications");
  });

  it("detects prescription questions", () => {
    expect(detectIntent("Show me my prescription")).toBe("prescriptions");
  });

  it("detects allergies and conditions separately", () => {
    expect(detectIntent("What are my allergies?")).toBe("allergies");
    expect(detectIntent("any chronic conditions on my file?")).toBe("conditions");
    expect(detectIntent("do I have diabetes or blood pressure recorded?")).toBe("conditions");
  });

  it("detects follow-up questions", () => {
    expect(detectIntent("When is my follow-up?")).toBe("follow_ups");
    expect(detectIntent("when should I come back to the clinic")).toBe("follow_ups");
  });

  it("detects queue questions", () => {
    expect(detectIntent("What is my queue token?")).toBe("queue");
    expect(detectIntent("how long until my turn?")).toBe("queue");
  });

  it("detects doctor search and small talk", () => {
    expect(detectIntent("I need a doctor near me")).toBe("find_doctor");
    expect(detectIntent("hello")).toBe("greeting");
    expect(detectIntent("what can you do?")).toBe("help");
    expect(detectIntent("thanks a lot")).toBe("thanks");
  });

  it("returns unknown for off-topic or medical-advice questions", () => {
    expect(detectIntent("What is the capital of France?")).toBe("unknown");
    expect(detectIntent("I have a weird rash, what disease is it?")).toBe("unknown");
  });
});

describe("buildFallbackReply — grounded answers", () => {
  it("emergency replies with 108/112 and no medical content", () => {
    const { reply, intent } = buildFallbackReply("chest pain", fullContext());
    expect(intent).toBe("emergency");
    expect(reply).toContain("108");
    expect(reply).toContain("112");
    expect(reply).not.toContain("Metformin");
  });

  it("appointment answers list only real appointments with formatted dates", () => {
    const { reply } = buildFallbackReply("When is my next appointment?", fullContext());
    expect(reply).toContain("18 Sep 2026");
    expect(reply).toContain("10:30 AM");
    expect(reply).toContain("Dr. Meera Iyer");
    expect(reply).toContain("25 Sep 2026");
    expect(reply).toContain("confirmed");
  });

  it("appointment answer is honest when nothing is booked", () => {
    const { reply } = buildFallbackReply("when is my appointment?", emptyContext());
    expect(reply).toContain("no upcoming appointments");
  });

  it("medication answers come from the active courses", () => {
    const { reply } = buildFallbackReply("What medications am I taking?", fullContext());
    expect(reply).toContain("Metformin");
    expect(reply).toContain("500 mg");
    expect(reply).toContain("9:00 AM and 9:00 PM");
    expect(reply).toContain("15 Oct 2026");
    expect(reply).toContain("Telma 40");
  });

  it("medication answer admits when no courses are active", () => {
    const { reply } = buildFallbackReply("what meds am I on?", emptyContext());
    expect(reply).toContain("no active medication courses");
  });

  it("prescription answers name the prescribed medicines", () => {
    const { reply } = buildFallbackReply("What did the doctor give me?", fullContext());
    expect(reply).toContain("Metformin");
    expect(reply).toContain("Telma 40");
  });

  it("allergy and condition answers come from recorded history", () => {
    expect(buildFallbackReply("What are my allergies?", fullContext()).reply).toContain("Penicillin, Dust");
    expect(buildFallbackReply("what conditions do I have?", fullContext()).reply).toContain("Type 2 Diabetes, Hypertension");
    expect(buildFallbackReply("allergies?", emptyContext()).reply).toContain("No allergies");
    expect(buildFallbackReply("conditions?", emptyContext()).reply).toContain("No chronic conditions");
  });

  it("follow-up answers use the scheduled date", () => {
    const { reply } = buildFallbackReply("When is my follow-up?", fullContext());
    expect(reply).toContain("30 Sep 2026");
    expect(reply).toContain("Sugar level review");
  });

  it("queue answers show token, position and people ahead", () => {
    const { reply } = buildFallbackReply("What is my queue status?", fullContext());
    expect(reply).toContain("B-07");
    expect(reply).toContain("number 3");
    expect(reply).toContain("2 patients ahead");
  });

  it("queue answer handles a called (non-waiting) token", () => {
    const ctx = fullContext();
    ctx.queue = { token_code: "B-07", status: "IN_CONSULTATION", position: null, people_ahead: 0 };
    const { reply } = buildFallbackReply("is it my turn?", ctx);
    expect(reply).toContain("B-07");
    expect(reply).toContain("in consultation");
    expect(reply).not.toContain("number 3");
  });

  it("queue answer admits when not in a queue", () => {
    expect(buildFallbackReply("my token?", emptyContext()).reply).toContain("not in a queue");
  });

  it("find_doctor points at the real page instead of booking itself", () => {
    const { reply } = buildFallbackReply("I want to find a doctor", fullContext());
    expect(reply).toContain("Find doctors");
    expect(reply).toContain("can't search or book for you");
  });

  it("greeting uses the patient's first name", () => {
    const { reply } = buildFallbackReply("Hi there", fullContext());
    expect(reply).toContain("Hello Aarav");
  });

  it("unknown questions get an honest menu, never invented advice", () => {
    const { reply, intent } = buildFallbackReply("What is the capital of France?", fullContext());
    expect(intent).toBe("unknown");
    expect(reply).toContain("couldn't match");
    expect(reply).toContain("appointments");
    expect(reply).toContain(DISCLAIMER);
    // Never leaks records into an unrelated answer:
    expect(reply).not.toContain("Metformin");
    expect(reply).not.toContain("B-07");
  });

  it("never fabricates data in empty contexts", () => {
    for (const question of [
      "when is my next appointment",
      "what medications am I taking",
      "my allergies",
      "my conditions",
      "when is my follow up",
      "what is my token",
      "what is the meaning of life",
    ]) {
      const reply = buildFallbackReply(question, emptyContext()).reply;
      expect(reply, `question: ${question}`).toMatch(
        /no |not in a queue|couldn't match|Find doctors/i
      );
    }
  });
});
