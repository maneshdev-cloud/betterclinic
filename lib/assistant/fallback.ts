import { formatDateString, formatTimeString } from "@/lib/assistant/format";

/**
 * Deterministic, database-grounded fallback for the health assistant.
 *
 * When no LLM key is configured (or the provider call fails), the
 * assistant answers from the patient's REAL records only: every fact in
 * a reply comes from the AssistantContext fetched from the database.
 * Questions it cannot answer from that context get an honest "I can't
 * answer that from your records" plus what it CAN do. No invented
 * medical advice, ever.
 */

export type AssistantIntent =
  | "emergency"
  | "appointments"
  | "medications"
  | "prescriptions"
  | "allergies"
  | "conditions"
  | "follow_ups"
  | "queue"
  | "find_doctor"
  | "greeting"
  | "help"
  | "thanks"
  | "unknown";

export interface AssistantContext {
  patientName: string;
  upcomingAppointments: {
    doctor_name: string;
    clinic_name: string;
    date: string;
    start_time: string;
    status: string;
  }[];
  activeMedications: {
    medicine_name: string;
    dose: string;
    times: string[];
    end_date: string;
  }[];
  allergies: string[];
  conditions: string[];
  upcomingFollowUps: {
    scheduled_date: string;
    reason: string;
    doctor_name: string;
  }[];
  queue: {
    token_code: string;
    status: string;
    position: number | null;
    people_ahead: number;
  } | null;
}

const INTENT_KEYWORDS: { intent: AssistantIntent; patterns: RegExp[] }[] = [
  {
    intent: "emergency",
    patterns: [/emergen/, /ambulance/, /chest pain/i, /can'?t breathe/i, /unconscious/i, /bleeding badly/i, /accident/i, /suicid/i, /overdose/i],
  },
  {
    intent: "appointments",
    patterns: [/appointments?/, /booking/, /booked/, /visit/, /when is my (next|upcoming)/, /schedule(?!d follow)/],
  },
  {
    intent: "medications",
    patterns: [/medicines?/, /medications?/, /meds\b/i, /tablets?/, /pills?/, /doses?/, /what (should|do) i take/i, /taking anything/i],
  },
  {
    intent: "prescriptions",
    patterns: [/prescriptions?/, /\brx\b/i, /what did the doctor (give|prescribe)/i],
  },
  {
    intent: "allergies",
    patterns: [/allerg(y|ies|ic)/i],
  },
  {
    intent: "conditions",
    patterns: [/conditions?/, /chronic/, /medical history/, /diabet|bp\b|blood pressure|asthma|thyroid/i],
  },
  {
    intent: "follow_ups",
    patterns: [/follow.?ups?/, /follow.?up visit/i, /when (should|do) i come back/i, /next check.?in/i],
  },
  {
    intent: "queue",
    patterns: [/queue/, /token/, /my turn/i, /how long.*(wait|turn)/i, /waiting/],
  },
  {
    intent: "find_doctor",
    patterns: [/find (a|me a) doctor/i, /book (a|an) (new )?appointment/i, /which doctor/i, /search doctor/i, /need a doctor/i],
  },
  {
    intent: "greeting",
    patterns: [/^(hi|hello|hey|namaste|good (morning|afternoon|evening))\b/i],
  },
  {
    intent: "help",
    patterns: [/^(help|what can you do|how do you work|options|commands)\b/i, /what.*can (you|i) ask/i],
  },
  {
    intent: "thanks",
    patterns: [/thank/i, /^thanks\b/i, /great, thanks/i],
  },
];

export function detectIntent(message: string): AssistantIntent {
  const text = message.toLowerCase().trim();
  for (const { intent, patterns } of INTENT_KEYWORDS) {
    if (patterns.some((pattern) => pattern.test(text))) return intent;
  }
  return "unknown";
}

const DISCLAIMER = "This assistant shows information from your clinic records. It is not a doctor and cannot diagnose — for medical questions, consult your doctor.";

export interface FallbackReply {
  reply: string;
  intent: AssistantIntent;
}

/** Compose a deterministic answer from the patient's real records. */
export function buildFallbackReply(
  message: string,
  context: AssistantContext,
  responseLength: "concise" | "detailed" = "concise"
): FallbackReply {
  const intent = detectIntent(message);
  const name = context.patientName.split(" ")[0] || "there";
  const isDetailed = responseLength === "detailed";

  switch (intent) {
    case "emergency":
      return {
        intent,
        reply:
          "If this is a medical emergency, call 108 (ambulance) or 112 (all-in-one emergency) right now — do not wait for a reply here. If it is safe to do so, go to the nearest emergency room. This assistant cannot help in emergencies.",
      };

    case "appointments": {
      if (context.upcomingAppointments.length === 0) {
        return {
          intent,
          reply: `You have no upcoming appointments on record, ${name}. You can browse doctors and book a real slot from Find doctors — I can't book for you, but the booking page only takes a minute.`,
        };
      }
      const lines = context.upcomingAppointments.map(
        (appt) =>
          `• ${formatDateString(appt.date)} at ${formatTimeString(appt.start_time)} with ${appt.doctor_name} at ${appt.clinic_name} (${appt.status.toLowerCase()})`
      );
      return {
        intent,
        reply: `Your upcoming appointment${context.upcomingAppointments.length === 1 ? "" : "s"}:\n${lines.join("\n")}\n\nYou can check in from My appointments or the Live queue page on the day of the visit.`,
      };
    }

    case "medications": {
      if (context.activeMedications.length === 0) {
        return {
          intent,
          reply: "You have no active medication courses right now — nothing is prescribed to you with an ongoing schedule.",
        };
      }
      const lines = context.activeMedications.map(
        (med) =>
          `• ${med.medicine_name} — ${med.dose}, at ${med.times.map((t) => formatTimeString(t)).join(" and ")}, until ${formatDateString(med.end_date)}`
      );
      return {
        intent,
        reply: `Your active medications (from your prescriptions):\n${lines.join("\n")}\n\nThe Medications page shows today's dose times and course progress.`,
      };
    }

    case "prescriptions": {
      if (context.activeMedications.length === 0) {
        return {
          intent,
          reply: "You have no active prescriptions on record. Past prescriptions are on the Prescriptions page.",
        };
      }
      const names = Array.from(new Set(context.activeMedications.map((m) => m.medicine_name)));
      return {
        intent,
        reply: `Your doctor has currently prescribed: ${names.join(", ")}. Full dosing details (dose, frequency, food relation) are on the Prescriptions page.`,
      };
    }

    case "allergies": {
      if (context.allergies.length === 0) {
        return {
          intent,
          reply: "No allergies are recorded on your file. If you know of one, tell your doctor at your next visit so they can add it to your record.",
        };
      }
      return {
        intent,
        reply: `Recorded allergies on your file: ${context.allergies.join(", ")}. This comes from your medical history — only your doctors can update it.`,
      };
    }

    case "conditions": {
      if (context.conditions.length === 0) {
        return {
          intent,
          reply: "No chronic conditions are recorded on your file. Your full medical timeline is on the Medical records page.",
        };
      }
      return {
        intent,
        reply: `Chronic conditions recorded on your file: ${context.conditions.join(", ")}. Your consultation history and prescriptions are on the Medical records page.`,
      };
    }

    case "follow_ups": {
      if (context.upcomingFollowUps.length === 0) {
        return {
          intent,
          reply: "You have no follow-up visits scheduled. When a doctor asks you to return, it appears on the Follow-ups page with their instructions.",
        };
      }
      const lines = context.upcomingFollowUps.map(
        (fu) => `• ${formatDateString(fu.scheduled_date)} — ${fu.reason} (with ${fu.doctor_name})`
      );
      return {
        intent,
        reply: `Your upcoming follow-up${context.upcomingFollowUps.length === 1 ? "" : "s"}:\n${lines.join("\n")}`,
      };
    }

    case "queue": {
      if (!context.queue) {
        return {
          intent,
          reply: "You are not in a queue right now. Once you check in for today's appointment (My queue page), I can show your token and position.",
        };
      }
      const position =
        context.queue.status === "WAITING"
          ? `You are number ${context.queue.position} in the queue with ${context.queue.people_ahead} patient${context.queue.people_ahead === 1 ? "" : "s"} ahead of you.`
          : `Your token ${context.queue.token_code} has been called — status: ${context.queue.status.replace("_", " ").toLowerCase()}.`;
      return {
        intent,
        reply: `Your token is ${context.queue.token_code}. ${position}\n\nThe Live queue page updates in real time when your token is called.`,
      };
    }

    case "find_doctor":
      return {
        intent,
        reply:
          "I can't search or book for you, but the Find doctors page lets you filter by specialization, city, fee and same-day availability, and book a real slot in a few taps.",
      };

    case "greeting":
      return {
        intent,
        reply: `Hello ${name}! I'm your clinic assistant. I can answer questions about your appointments, medications, prescriptions, allergies, follow-ups and queue token — using only your real records. Ask me something like \"what medications am I taking?\"`,
      };

    case "help":
      return {
        intent,
        reply:
          "I can answer from your clinic records:\n• \"When is my next appointment?\"\n• \"What medications am I taking?\"\n• \"What are my allergies?\"\n• \"When is my follow-up?\"\n• \"What's my queue token / position?\"\n\nI cannot book, cancel, diagnose or prescribe. For anything urgent: call 108.",
      };

    case "thanks":
      return {
        intent,
        reply: "You're welcome! Ask anytime — I'm here with your records. Wishing you good health.",
      };

    case "unknown":
    default:
      return {
        intent: "unknown",
        reply: `I can only answer using your clinic records, and I couldn't match that to anything I have. Try asking about:\n• your appointments\n• your medications or prescriptions\n• your allergies or conditions\n• your follow-ups\n• your queue token\n\nIf it's urgent, call 108. ${DISCLAIMER}`,
      };
  }
}

export { DISCLAIMER };
