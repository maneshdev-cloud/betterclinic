/**
 * Canonical domain vocabulary — ONE term per concept, used by UI,
 * services and database alike (Phase 7 "Shared naming" rule).
 * The state machines defined here are mirrored in SQL triggers;
 * keep both in sync when changing transitions.
 */

export const ROLES = ["PATIENT", "DOCTOR", "RECEPTIONIST", "CLINIC_ADMIN"] as const;
export type Role = (typeof ROLES)[number];

export const ROLE_LABELS: Record<Role, string> = {
  PATIENT: "Patient",
  DOCTOR: "Doctor",
  RECEPTIONIST: "Receptionist",
  CLINIC_ADMIN: "Clinic Admin",
};

export function roleHomePath(role: Role): string {
  switch (role) {
    case "PATIENT":
      return "/patient";
    case "DOCTOR":
      return "/doctor";
    case "RECEPTIONIST":
      return "/staff";
    case "CLINIC_ADMIN":
      return "/admin";
  }
}

/* ── Appointments ──────────────────────────────────────────────── */

export const APPOINTMENT_STATUSES = [
  "BOOKED",
  "CONFIRMED",
  "CHECKED_IN",
  "WAITING",
  "CALLED",
  "IN_CONSULTATION",
  "COMPLETED",
  "CANCELLED",
  "NO_SHOW",
] as const;
export type AppointmentStatus = (typeof APPOINTMENT_STATUSES)[number];

export const APPOINTMENT_TYPES = ["SCHEDULED", "WALK_IN"] as const;
export type AppointmentType = (typeof APPOINTMENT_TYPES)[number];

/**
 * Valid appointment lifecycle transitions. Terminal states have no exits:
 * a COMPLETED appointment can never silently become BOOKED again, and a
 * CANCELLED one must go through a fresh booking workflow.
 */
export const APPOINTMENT_TRANSITIONS: Record<AppointmentStatus, AppointmentStatus[]> = {
  BOOKED: ["CONFIRMED", "CHECKED_IN", "CANCELLED", "NO_SHOW"],
  CONFIRMED: ["CHECKED_IN", "CANCELLED", "NO_SHOW"],
  CHECKED_IN: ["WAITING", "CANCELLED"],
  WAITING: ["CALLED", "CANCELLED", "NO_SHOW"],
  CALLED: ["IN_CONSULTATION", "WAITING", "NO_SHOW"],
  IN_CONSULTATION: ["COMPLETED"],
  COMPLETED: [],
  CANCELLED: [],
  NO_SHOW: [],
};

export const APPOINTMENT_STATUS_LABELS: Record<AppointmentStatus, string> = {
  BOOKED: "Booked",
  CONFIRMED: "Confirmed",
  CHECKED_IN: "Checked in",
  WAITING: "Waiting",
  CALLED: "Called",
  IN_CONSULTATION: "In consultation",
  COMPLETED: "Completed",
  CANCELLED: "Cancelled",
  NO_SHOW: "No-show",
};

/** Statuses that occupy a bookable slot. */
export const SLOT_OCCUPYING_STATUSES: AppointmentStatus[] = [
  "BOOKED",
  "CONFIRMED",
  "CHECKED_IN",
  "WAITING",
  "CALLED",
  "IN_CONSULTATION",
];

export function canTransition(from: AppointmentStatus, to: AppointmentStatus): boolean {
  return APPOINTMENT_TRANSITIONS[from]?.includes(to) ?? false;
}

/* ── Queue ─────────────────────────────────────────────────────── */

export const QUEUE_STATUSES = [
  "WAITING",
  "CALLED",
  "IN_CONSULTATION",
  "COMPLETED",
  "SKIPPED",
  "CANCELLED",
] as const;
export type QueueStatus = (typeof QUEUE_STATUSES)[number];

export const QUEUE_TRANSITIONS: Record<QueueStatus, QueueStatus[]> = {
  WAITING: ["CALLED", "SKIPPED", "CANCELLED"],
  CALLED: ["IN_CONSULTATION", "WAITING", "CANCELLED"],
  IN_CONSULTATION: ["COMPLETED", "CANCELLED"],
  SKIPPED: ["WAITING", "CANCELLED"],
  COMPLETED: [],
  CANCELLED: [],
};

export const QUEUE_STATUS_LABELS: Record<QueueStatus, string> = {
  WAITING: "Waiting",
  CALLED: "Called",
  IN_CONSULTATION: "In consultation",
  COMPLETED: "Completed",
  SKIPPED: "Skipped",
  CANCELLED: "Cancelled",
};

export const PRIORITIES = ["NORMAL", "HIGH", "URGENT"] as const;
export type Priority = (typeof PRIORITIES)[number];
export const PRIORITY_LABELS: Record<Priority, string> = {
  NORMAL: "Normal",
  HIGH: "High",
  URGENT: "Urgent",
};
/** Lower number = seen first. */
export const PRIORITY_ORDER: Record<Priority, number> = { URGENT: 0, HIGH: 1, NORMAL: 2 };

export const QUEUE_EVENT_TYPES = [
  "CREATED",
  "CALLED",
  "RECALLED",
  "SKIPPED",
  "RESUMED",
  "STARTED",
  "COMPLETED",
  "CANCELLED",
  "PRIORITY_CHANGED",
] as const;
export type QueueEventType = (typeof QUEUE_EVENT_TYPES)[number];

/* ── Clinical ──────────────────────────────────────────────────── */

export const CONSULTATION_STATUSES = ["DRAFT", "IN_PROGRESS", "COMPLETED"] as const;
export type ConsultationStatus = (typeof CONSULTATION_STATUSES)[number];

export const FOLLOW_UP_STATUSES = ["SCHEDULED", "COMPLETED", "CANCELLED", "MISSED"] as const;
export type FollowUpStatus = (typeof FOLLOW_UP_STATUSES)[number];

export const PRESCRIPTION_STATUSES = ["ACTIVE", "COMPLETED", "CANCELLED"] as const;
export type PrescriptionStatus = (typeof PRESCRIPTION_STATUSES)[number];

export const MEDICATION_SCHEDULE_STATUSES = ["ACTIVE", "COMPLETED", "CANCELLED"] as const;
export type MedicationScheduleStatus = (typeof MEDICATION_SCHEDULE_STATUSES)[number];

export const MEDICINE_FORMS = [
  "TABLET",
  "CAPSULE",
  "SYRUP",
  "INJECTION",
  "CREAM",
  "OINTMENT",
  "DROPS",
  "INHALER",
  "POWDER",
] as const;
export type MedicineForm = (typeof MEDICINE_FORMS)[number];

export const FOOD_RELATIONS = [
  "BEFORE_FOOD",
  "AFTER_FOOD",
  "WITH_FOOD",
  "EMPTY_STOMACH",
  "NOT_SPECIFIED",
] as const;
export type FoodRelation = (typeof FOOD_RELATIONS)[number];
export const FOOD_RELATION_LABELS: Record<FoodRelation, string> = {
  BEFORE_FOOD: "Before food",
  AFTER_FOOD: "After food",
  WITH_FOOD: "With food",
  EMPTY_STOMACH: "Empty stomach",
  NOT_SPECIFIED: "Not specified",
};

/**
 * Dose frequencies. The times-of-day mapping below mirrors the SQL
 * function `generate_medication_schedules` — keep both in sync.
 * SOS ("as needed") and STAT (single immediate dose) do not produce
 * daily schedule rows.
 */
export const PRESCRIPTION_FREQUENCIES = ["OD", "BD", "TDS", "QID", "HS", "SOS", "STAT"] as const;
export type PrescriptionFrequency = (typeof PRESCRIPTION_FREQUENCIES)[number];

export const FREQUENCY_LABELS: Record<PrescriptionFrequency, string> = {
  OD: "Once a day (OD)",
  BD: "Twice a day (BD)",
  TDS: "Three times a day (TDS)",
  QID: "Four times a day (QID)",
  HS: "At bedtime (HS)",
  SOS: "As needed (SOS)",
  STAT: "Immediately (STAT)",
};

export const FREQUENCY_TIMES: Record<
  Exclude<PrescriptionFrequency, "SOS" | "STAT">,
  string[]
> = {
  OD: ["09:00"],
  BD: ["09:00", "21:00"],
  TDS: ["08:00", "14:00", "20:00"],
  QID: ["08:00", "14:00", "20:00", "02:00"],
  HS: ["22:00"],
};

export const FREQUENCY_PER_DAY: Record<PrescriptionFrequency, number> = {
  OD: 1,
  BD: 2,
  TDS: 3,
  QID: 4,
  HS: 1,
  SOS: 0,
  STAT: 0,
};

/* ── Notifications ─────────────────────────────────────────────── */

export const NOTIFICATION_TYPES = [
  "APPOINTMENT_BOOKED",
  "APPOINTMENT_CONFIRMED",
  "APPOINTMENT_CANCELLED",
  "APPOINTMENT_RESCHEDULED",
  "CHECK_IN_CONFIRMED",
  "QUEUE_UPDATED",
  "QUEUE_CALLED",
  "QUEUE_COMPLETED",
  "CONSULTATION_COMPLETED",
  "PRESCRIPTION_CREATED",
  "FOLLOW_UP_SCHEDULED",
  "MEDICATION_REMINDER",
  "EMERGENCY_UPDATE",
  "SYSTEM",
] as const;
export type NotificationType = (typeof NOTIFICATION_TYPES)[number];

/* ── Emergency Care ───────────────────────────────────────────── */

export const EMERGENCY_STATUSES = ["CREATED", "RECEIVED", "ACKNOWLEDGED", "CLOSED"] as const;
export type EmergencyStatus = (typeof EMERGENCY_STATUSES)[number];
export const EMERGENCY_TRANSITIONS: Record<EmergencyStatus, EmergencyStatus[]> = {
  CREATED: ["RECEIVED"],
  RECEIVED: ["ACKNOWLEDGED"],
  ACKNOWLEDGED: ["CLOSED"],
  CLOSED: [],
};

/* ── Misc ──────────────────────────────────────────────────────── */

export const DAYS_OF_WEEK = [
  { value: 0, label: "Sunday" },
  { value: 1, label: "Monday" },
  { value: 2, label: "Tuesday" },
  { value: 3, label: "Wednesday" },
  { value: 4, label: "Thursday" },
  { value: 5, label: "Friday" },
  { value: 6, label: "Saturday" },
];

export const SEXES = ["MALE", "FEMALE", "OTHER"] as const;
export const SEX_LABELS: Record<(typeof SEXES)[number], string> = {
  MALE: "Male",
  FEMALE: "Female",
  OTHER: "Other",
};

export const MEDICAL_HISTORY_TYPES = [
  "ALLERGY",
  "CHRONIC_CONDITION",
  "SURGERY",
  "INJURY",
  "FAMILY_HISTORY",
  "LIFESTYLE",
  "IMMUNIZATION",
  "NOTE",
] as const;
export type MedicalHistoryType = (typeof MEDICAL_HISTORY_TYPES)[number];
export const MEDICAL_HISTORY_LABELS: Record<MedicalHistoryType, string> = {
  ALLERGY: "Allergy",
  CHRONIC_CONDITION: "Chronic condition",
  SURGERY: "Surgery",
  INJURY: "Injury",
  FAMILY_HISTORY: "Family history",
  LIFESTYLE: "Lifestyle",
  IMMUNIZATION: "Immunization",
  NOTE: "Note",
};

/** Default consultation length used until real history exists (minutes). */
export const DEFAULT_CONSULTATION_MINUTES = 15;
/** How far ahead patients may book. */
export const BOOKING_HORIZON_DAYS = 30;
