/**
 * BETTER CLINIC — end-to-end workflow verification.
 *
 * Exercises the real database business logic (the same security-definer
 * RPCs the app calls) against a live database:
 *
 *   npm run verify:workflows
 *
 * Covered: slot generation → booking (+ double-booking protection) →
 * rescheduling → cancellation → check-in + deterministic tokens →
 * priority-ordered queue calling → consultation → prescription →
 * medication schedule generation → completion → no-show →
 * notifications and audit trail presence.
 *
 * Works against the local test harness (npm run test:db) or any
 * Supabase project — fixtures are created via the real signup trigger
 * and removed afterwards.
 */
import postgres from "postgres";
import { loadLocalEnv, requireEnv } from "./lib/load-env";

loadLocalEnv();

const dbUrl = requireEnv("DATABASE_URL");
const isLocal = /localhost|127\.0\.0\.1/.test(dbUrl);
const sql = postgres(dbUrl, {
  ssl: isLocal ? false : { rejectUnauthorized: false },
  prepare: false,
  max: 1,
});

const DOMAIN = "workflow-test.betterclinic.test";
const results: { name: string; pass: boolean; detail?: string }[] = [];

function record(name: string, pass: boolean, detail?: string) {
  results.push({ name, pass, detail });
  console.log(`  ${pass ? "✓" : "✗"} [${pass ? "PASS" : "FAIL"}] ${name}${!pass && detail ? ` — ${detail}` : ""}`);
}

function check(name: string, condition: boolean, detail?: string) {
  record(name, condition, detail ?? (condition ? undefined : "condition was false"));
}

async function asUser<T>(
  sub: string,
  fn: (tx: postgres.TransactionSql<{}>) => Promise<T>
): Promise<T> {
  const result = await sql.begin(async (tx) => {
    const claims = JSON.stringify({ sub, role: "authenticated" });
    await tx`select set_config('request.jwt.claims', ${claims}, true), set_config('role', 'authenticated', true)`;
    return fn(tx);
  });
  return result as T;
}

async function expectRpcError(name: string, sub: string, message: string, expectedToken: string) {
  try {
    await asUser(sub, (tx) => tx.unsafe(message));
    record(name, false, "RPC succeeded but should have raised an error");
  } catch (err) {
    const text = (err as Error).message;
    record(name, text.includes(`[${expectedToken}]`), `expected [${expectedToken}], got: ${text}`);
  }
}

async function createUser(email: string, metadata: Record<string, string>): Promise<string> {
  const rows = await sql`
    insert into auth.users (instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values ('00000000-0000-0000-0000-000000000000','authenticated','authenticated', ${email},
            'workflow-test-not-loginable', now(), now(), now(), '{}'::jsonb, ${sql.json(metadata)})
    returning id
  `;
  return rows[0].id as string;
}

async function main() {
  console.log("BETTER CLINIC — workflow verification\n");

  /* ── fixtures ── */
  const clinic = (
    await sql`insert into public.clinics (name, address_line, city, area) values ('Workflow Test Clinic','S1','Pune','Area') returning id`
  )[0].id as string;
  await sql`insert into public.clinic_invite_codes (clinic_id, code) values (${clinic}, 'WFTEST-CODE')`;
  const spec = (
    await sql`insert into public.specializations (name, slug) values ('Workflow Test Spec','workflow-test-spec') returning id`
  )[0].id as string;

  const doctor = await createUser(`doctor@${DOMAIN}`, {
    role: "DOCTOR", full_name: "Dr Workflow", phone: "9800000001",
    qualification: "MBBS, MD", registration_number: "WF-1", experience_years: "8",
    specialization_id: spec, clinic_id: clinic, consultation_fee: "600",
  });
  const patient1 = await createUser(`p1@${DOMAIN}`, { role: "PATIENT", full_name: "WF Patient One", phone: "9800000002" });
  const patient2 = await createUser(`p2@${DOMAIN}`, { role: "PATIENT", full_name: "WF Patient Two", phone: "9800000003" });
  const patient3 = await createUser(`p3@${DOMAIN}`, { role: "PATIENT", full_name: "WF Patient Three", phone: "9800000004" });
  const receptionist = await createUser(`recep@${DOMAIN}`, {
    role: "RECEPTIONIST", full_name: "WF Reception", phone: "9800000005",
    clinic_id: clinic, staff_invite_code: "WFTEST-CODE",
  });

  // Availability: every day 09:00–17:00 with a 12:00-13:00 break, 15-min slots.
  await sql`
    insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes)
    select ${doctor}, ${clinic}, d, '09:00', '17:00', '12:00', '13:00', 15
    from generate_series(0, 6) d
  `;

  const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString().slice(0, 10);

  /* ── 1. slot generation ── */
  console.log("── Slot generation ──");
  const slots = await asUser(patient1, (tx) =>
    tx`select * from public.ensure_slots(${doctor}, ${clinic}, ${tomorrow}::date) order by start_time`
  );
  check("ensure_slots generates the day's slots", slots.length === 28, `expected 28 slots (9-12 & 13-17), got ${slots.length}`);
  const breakSlots = slots.filter((s) => s.start_time >= "12:00" && s.start_time < "13:00");
  check("slots overlapping the break are excluded", breakSlots.length === 0, `${breakSlots.length} break slots generated`);
  check("generated slots start FREE", slots.every((s) => s.status === "FREE"));

  const slotA = slots[2]!.id as string; // 09:30
  const slotB = slots[3]!.id as string; // 09:45
  const slotC = slots[4]!.id as string; // 10:00

  /* ── 2. booking ── */
  console.log("\n── Booking ──");
  const appointment = await asUser(patient1, (tx) =>
    tx`select * from public.book_appointment(p_slot_id := ${slotA}, p_visit_reason := 'Persistent headache')`
  );
  check("booking returns a BOOKED appointment", appointment[0]?.status === "BOOKED", `status=${appointment[0]?.status}`);
  const appointmentId = appointment[0].id as string;

  const slotAfter = await sql`select status from public.appointment_slots where id = ${slotA}`;
  check("slot flips to BOOKED", slotAfter[0].status === "BOOKED");

  const notif = await asUser(patient1, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient1} and type = 'APPOINTMENT_BOOKED'`
  );
  check("patient receives a booking notification", Number(notif[0].count) === 1, `count=${notif[0].count}`);

  await expectRpcError(
    "double-booking the same slot is rejected",
    patient2,
    `select * from public.book_appointment(p_slot_id := '${slotA}', p_visit_reason := 'Should fail')`,
    "SLOT_TAKEN"
  );

  // slotB (09:45-10:00) is back-to-back with slotA (09:30-09:45) — adjacent, not overlapping.
  const slotBAppt = await asUser(patient1, (tx) =>
    tx`select * from public.book_appointment(p_slot_id := ${slotB}, p_visit_reason := 'Second opinion visit')`
  );
  check("booking an adjacent (back-to-back, non-overlapping) slot is allowed", !!slotBAppt[0]?.id);
  const slotBApptId = slotBAppt[0].id as string;

  // A truly overlapping fixture: 09:50-10:10 tomorrow overlaps slotC (10:00-10:15).
  await sql`
    insert into public.appointments (patient_id, doctor_id, clinic_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    values (${patient1}, ${doctor}, ${clinic}, 'WALK_IN', 'BOOKED', ${tomorrow}::date, '09:50', '10:10', 'Manual overlap fixture')
  `;
  const overlap = await asUser(patient1, (tx) =>
    tx`select * from public.book_appointment(p_slot_id := ${slotC}, p_visit_reason := 'Should overlap')`
  ).then(() => "ok").catch((e: Error) => e.message);
  check(
    "patient cannot book a slot overlapping an existing appointment",
    /DOUBLE_BOOKING/.test(overlap),
    overlap
  );
  // The overlap fixture has served its purpose — retire it so later
  // rescheduling isn't blocked by a genuinely overlapping appointment.
  await sql`update public.appointments set status = 'CANCELLED', cancellation_reason = 'Test fixture retired' where patient_id = ${patient1} and visit_reason = 'Manual overlap fixture' and status = 'BOOKED'`;

  /* ── 2b. staff confirmation ── */
  console.log("\n── Staff confirmation ──");
  const confirmed = await asUser(receptionist, (tx) =>
    tx`select * from public.confirm_appointment(p_appointment_id := ${slotBApptId})`
  );
  check("receptionist confirms a BOOKED appointment", confirmed[0]?.status === "CONFIRMED", `status=${confirmed[0]?.status}`);
  check("confirmed_at is stamped", !!confirmed[0]?.confirmed_at);

  const confirmNotif = await asUser(patient1, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient1} and type = 'APPOINTMENT_CONFIRMED'`
  );
  check("patient receives a confirmation notification", Number(confirmNotif[0].count) >= 1, `count=${confirmNotif[0].count}`);

  await expectRpcError(
    "patients cannot confirm appointments",
    patient1,
    `select * from public.confirm_appointment(p_appointment_id := '${slotBApptId}')`,
    "FORBIDDEN"
  );
  await expectRpcError(
    "confirming an already-confirmed appointment is rejected",
    receptionist,
    `select * from public.confirm_appointment(p_appointment_id := '${slotBApptId}')`,
    "INVALID_TRANSITION"
  );

  /* ── 3. rescheduling ── */
  console.log("\n── Rescheduling ──");
  const rescheduled = await asUser(patient1, (tx) =>
    tx`select * from public.reschedule_appointment(p_appointment_id := ${appointmentId}, p_new_slot_id := ${slotC}, p_reason := 'Schedule conflict')`
  );
  check("reschedule moves the appointment to the new slot", rescheduled[0]?.slot_id === slotC);

  const oldSlot = await sql`select status from public.appointment_slots where id = ${slotA}`;
  const newSlot = await sql`select status from public.appointment_slots where id = ${slotC}`;
  check("old slot is released (FREE)", oldSlot[0].status === "FREE");
  check("new slot is occupied (BOOKED)", newSlot[0].status === "BOOKED");

  const history = await asUser(patient1, (tx) =>
    tx`select reason from public.appointment_status_history where appointment_id = ${appointmentId} order by created_at`
  );
  check(
    "reschedule is preserved in history",
    history.some((h) => /Rescheduled from/.test(String(h.reason))),
    "no reschedule history row found"
  );

  /* ── 4. cancellation ── */
  console.log("\n── Cancellation ──");
  const cancelled = await asUser(patient1, (tx) =>
    tx`select * from public.cancel_appointment(p_appointment_id := ${appointmentId}, p_reason := 'Feeling better')`
  );
  check("appointment is CANCELLED", cancelled[0]?.status === "CANCELLED");
  const slotAfterCancel = await sql`select status from public.appointment_slots where id = ${slotC}`;
  check("cancelled appointment releases its slot", slotAfterCancel[0].status === "FREE");

  /* ── 5. check-in + tokens ── */
  console.log("\n── Check-in, walk-ins and tokens ──");
  // Book a fresh appointment (slotD = 10:15, still free) and move it to today for the queue tests.
  // End time 23:59:59.999999 keeps the appointment "not yet passed" at any hour IST
  // (check-in rejects end times already passed; a 23:30 end made the suite flaky
  // between 23:30 and midnight IST).
  const slotD = slots[6]!.id as string;
  const todayAppt = await asUser(patient1, (tx) =>
    tx`select * from public.book_appointment(p_slot_id := ${slotD}, p_visit_reason := 'Follow-up visit')`
  );
  const todayApptId = todayAppt[0].id as string;
  await sql`update public.appointments set appointment_date = current_date, start_time = '23:00', end_time = '23:59:59.999999' where id = ${todayApptId}`;

  const entry1 = await asUser(patient1, (tx) =>
    tx`select * from public.check_in_appointment(p_appointment_id := ${todayApptId}, p_method := 'APP')`
  );
  check("check-in assigns token T001", entry1[0]?.token_code === "T001", `token=${entry1[0]?.token_code}`);
  check("queue entry is WAITING", entry1[0]?.status === "WAITING");

  const apptStatus = await sql`select status from public.appointments where id = ${todayApptId}`;
  check("appointment moved to WAITING", apptStatus[0].status === "WAITING");

  await expectRpcError(
    "duplicate check-in is rejected",
    patient1,
    `select * from public.check_in_appointment(p_appointment_id := '${todayApptId}')`,
    "DUPLICATE_CHECK_IN"
  );

  // Walk-in (urgent) → T002
  const entry2 = await asUser(receptionist, (tx) =>
    tx`select * from public.create_walk_in(p_clinic_id := ${clinic}, p_doctor_id := ${doctor}, p_patient_id := ${patient2}, p_visit_reason := 'High fever since morning', p_priority := 'URGENT')`
  );
  check("urgent walk-in gets T002", entry2[0]?.token_code === "T002", `token=${entry2[0]?.token_code}`);
  check("walk-in token is URGENT priority", entry2[0]?.priority === "URGENT");

  // Another walk-in (normal) → T003
  const entry3 = await asUser(receptionist, (tx) =>
    tx`select * from public.create_walk_in(p_clinic_id := ${clinic}, p_doctor_id := ${doctor}, p_patient_id := ${patient3}, p_visit_reason := 'Routine check-up')`
  );
  check("normal walk-in gets T003", entry3[0]?.token_code === "T003", `token=${entry3[0]?.token_code}`);

  /* ── 6. queue calling honours priority ── */
  console.log("\n── Queue operations (priority-ordered) ──");
  const called1 = await asUser(doctor, (tx) =>
    tx`select * from public.queue_call_next(p_clinic_id := ${clinic}, p_doctor_id := ${doctor})`
  );
  check("urgent T002 is called first (priority over token order)", called1[0]?.token_code === "T002", `called=${called1[0]?.token_code}`);

  const called1Notif = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient2} and type = 'QUEUE_CALLED'`
  );
  check("called patient is notified", Number(called1Notif[0].count) >= 1);

  const nextUpNotif = await asUser(patient1, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient1} and type = 'QUEUE_UPDATED' and title = 'You are next'`
  );
  check("next-in-line patient gets a 'you are next' notification", Number(nextUpNotif[0].count) >= 1);

  /* ── 6b. queue management (call specific, skip, resume, priority) ── */
  console.log("\n── Queue management ──");
  const calledSpecific = await asUser(doctor, (tx) =>
    tx`select * from public.queue_call_specific(p_queue_entry_id := ${entry3[0].id})`
  );
  check("doctor can call a specific waiting token", calledSpecific[0]?.token_code === "T003", `token=${calledSpecific[0]?.token_code}`);

  const returned = await asUser(receptionist, (tx) =>
    tx`select * from public.queue_return_to_waiting(p_queue_entry_id := ${entry3[0].id})`
  );
  check("called-but-absent token returns to WAITING", returned[0]?.status === "WAITING");

  const prioritised = await asUser(receptionist, (tx) =>
    tx`select * from public.queue_set_priority(p_queue_entry_id := ${entry3[0].id}, p_priority := 'HIGH')`
  );
  check("staff raises a token's priority to HIGH", prioritised[0]?.priority === "HIGH");

  const skipped = await asUser(doctor, (tx) =>
    tx`select * from public.queue_skip(p_queue_entry_id := ${entry3[0].id})`
  );
  check("waiting token can be skipped", skipped[0]?.status === "SKIPPED");

  const resumed = await asUser(receptionist, (tx) =>
    tx`select * from public.queue_resume(p_queue_entry_id := ${entry3[0].id})`
  );
  check("skipped token can be resumed to WAITING", resumed[0]?.status === "WAITING");

  const recalled = await asUser(doctor, (tx) =>
    tx`select * from public.queue_recall(p_queue_entry_id := ${entry2[0].id})`
  );
  check("a CALLED token can be re-called (notification re-sent)", recalled[0]?.status === "CALLED");

  await expectRpcError(
    "patients cannot manage the queue",
    patient3,
    `select * from public.queue_call_specific(p_queue_entry_id := '${entry3[0].id}')`,
    "FORBIDDEN"
  );
  await expectRpcError(
    "resuming a waiting (not skipped) token is rejected",
    receptionist,
    `select * from public.queue_resume(p_queue_entry_id := '${entry3[0].id}')`,
    "INVALID_TRANSITION"
  );

  /* ── 7. consultation, prescription, completion ── */
  console.log("\n── Consultation & prescription ──");
  const appt2 = await sql`select id from public.appointments where id = ${entry2[0].appointment_id}`;
  const consultation2 = await asUser(doctor, (tx) =>
    tx`select * from public.start_consultation(p_appointment_id := ${appt2[0].id})`
  );
  check("consultation starts IN_PROGRESS", consultation2[0]?.status === "IN_PROGRESS");

  const entry2Status = await sql`select status from public.queue_entries where id = ${entry2[0].id}`;
  check("queue entry moves to IN_CONSULTATION", entry2Status[0].status === "IN_CONSULTATION");

  // Fill in clinical notes (RLS allows the consulting doctor).
  await asUser(doctor, (tx) =>
    tx`update public.consultations set chief_complaint = 'High fever', symptoms = 'Fever 102F, body ache', clinical_notes = 'Viral fever. Paracetamol advised, hydrate.', assessment = 'Acute viral fever' where id = ${consultation2[0].id}`
  );

  // Prescription with structured items — BD for 5 days and OD for 3 days.
  // (Two statements: the items' RLS check must see the committed prescription.)
  const prescription = await asUser(doctor, (tx) => tx`
    insert into public.prescriptions (consultation_id, patient_id, doctor_id, clinic_id, notes)
    values (${consultation2[0].id}, ${patient2}, ${doctor}, ${clinic}, 'Take with water')
    returning id
  `);
  const items = await asUser(doctor, (tx) => tx`
    insert into public.prescription_items (prescription_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation)
    values
      (${prescription[0].id}, 'Paracetamol', 'Paracetamol', '500mg', '1 tablet', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation),
      (${prescription[0].id}, 'Cetirizine', 'Cetirizine', '10mg', '1 tablet', 'OD'::public.prescription_frequency, 3, 'At night', 'AFTER_FOOD'::public.food_relation)
    returning id
  `);
  check("prescription created with 2 structured items", items.length === 2);

  const rxId = prescription[0].id as string;
  await asUser(doctor, (tx) => tx`select public.notify_prescription_created(${rxId})`);

  const schedules = await asUser(patient2, (tx) =>
    tx`select * from public.medication_schedules where prescription_id = ${rxId} order by time_of_day`
  );
  check("medication schedules generated (BD→2 + OD→1 = 3 rows)", schedules.length === 3, `got ${schedules.length}`);
  const expectedEnd = new Date(Date.now() + 4 * 86400000).toISOString().slice(0, 10);
  const actualEnd = new Date(schedules[0].end_date as string).toISOString().slice(0, 10);
  check(
    "schedule dates span the prescribed duration",
    schedules.length === 3 && actualEnd === expectedEnd,
    `first end_date=${actualEnd}, expected ${expectedEnd} (BD 5 days → +4)`
  );

  const completed = await asUser(doctor, (tx) =>
    tx`select * from public.complete_consultation(p_consultation_id := ${consultation2[0].id})`
  );
  check("consultation completes", completed[0]?.status === "COMPLETED");

  const appt2Final = await sql`select status from public.appointments where id = ${appt2[0].id}`;
  const entry2Final = await sql`select status from public.queue_entries where id = ${entry2[0].id}`;
  check("appointment COMPLETED after consultation", appt2Final[0].status === "COMPLETED");
  check("queue entry COMPLETED after consultation", entry2Final[0].status === "COMPLETED");

  /* ── 7b. clinical records for the workspace ── */
  console.log("\n── Clinical records ──");
  const diagnosis = await asUser(doctor, (tx) => tx`
    insert into public.diagnoses (consultation_id, patient_id, name, code, description, is_primary)
    values (${consultation2[0].id}, ${patient2}, 'Acute viral fever', 'B34.9', 'Symptomatic treatment advised', true)
    returning id
  `);
  check("doctor records a diagnosis", diagnosis.length === 1);

  const patientDiagnoses = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.diagnoses where patient_id = ${patient2}`
  );
  check("patient can read their diagnosis", Number(patientDiagnoses[0].count) >= 1);

  const historyEntry = await asUser(doctor, (tx) => tx`
    insert into public.medical_history (patient_id, record_type, title, description, recorded_by)
    values (${patient2}, 'ALLERGY', 'Penicillin', 'Rash observed in 2024', ${doctor})
    returning id
  `);
  check("doctor records a medical history entry", historyEntry.length === 1);

  const patientHistory = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.medical_history where patient_id = ${patient2} and record_type = 'ALLERGY'`
  );
  check("patient can read their history entry", Number(patientHistory[0].count) >= 1);

  const patientHistoryWrite = await asUser(patient2, (tx) =>
    tx`insert into public.medical_history (patient_id, record_type, title, recorded_by) values (${patient2}, 'NOTE', 'Self entry', ${doctor})`
  ).then(() => "ok").catch((e: Error) => e.message);
  check(
    "patients cannot write medical history",
    /row-level security/.test(patientHistoryWrite),
    patientHistoryWrite
  );

  const patientMeds = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.medication_schedules where patient_id = ${patient2} and status = 'ACTIVE'`
  );
  check("patient sees their active medication schedule", Number(patientMeds[0].count) === 3, `count=${patientMeds[0].count}`);

  /* ── 7c. daily medication reminders ── */
  console.log("\n── Medication reminders ──");
  // Run as the admin/superuser connection (mirrors the service role that
  // pg_cron or `npm run reminders` would use).
  const reminderRun1 = await sql`select public.create_medication_reminders() as created`;
  const reminders1 = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient2} and type = 'MEDICATION_REMINDER' and created_at >= current_date`
  );
  check(
    "reminder generator creates one notification for the medicated patient",
    Number(reminderRun1[0].created) === 1 && Number(reminders1[0].count) === 1,
    `created=${reminderRun1[0].created}, notifications=${reminders1[0].count}`
  );

  const reminderBody = await asUser(patient2, (tx) =>
    tx`select body from public.notifications where user_id = ${patient2} and type = 'MEDICATION_REMINDER' and created_at >= current_date limit 1`
  );
  const bodyText = String(reminderBody[0]?.body ?? "");
  check(
    "reminder body lists the patient's actual medicines",
    bodyText.includes("Paracetamol") && bodyText.includes("Cetirizine"),
    bodyText
  );

  const reminderRun2 = await sql`select public.create_medication_reminders() as created`;
  const reminders2 = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient2} and type = 'MEDICATION_REMINDER' and created_at >= current_date`
  );
  check(
    "reminder generator is idempotent within the day",
    Number(reminderRun2[0].created) === 0 && Number(reminders2[0].count) === 1,
    `second run created=${reminderRun2[0].created}, notifications=${reminders2[0].count}`
  );

  const patientReminderRun = await asUser(patient2, (tx) => tx`select public.create_medication_reminders()`)
    .then(() => "ok")
    .catch((e: Error) => e.message);
  check(
    "patients cannot execute the reminder generator",
    /permission denied/.test(patientReminderRun),
    patientReminderRun
  );

  /* ── 7d. emergency demo module ── */
  console.log("\n── Emergency demo ──");
  const emergency = await asUser(patient1, (tx) =>
    tx`select * from public.create_emergency_request(
      p_description := 'Prototype demo — chest pain roleplay',
      p_location_text := 'Test street 1, Pune'
    )`
  );
  check(
    "patient creates an emergency request (CREATED, demo-flagged)",
    emergency[0]?.status === "CREATED" && emergency[0]?.is_demo === true,
    `status=${emergency[0]?.status} is_demo=${emergency[0]?.is_demo}`
  );

  const emergencyId = emergency[0].id as string;
  const received = await asUser(patient1, (tx) =>
    tx`select * from public.emergency_advance_demo(p_request_id := ${emergencyId})`
  );
  check(
    "demo advance moves CREATED → RECEIVED and stamps received_at",
    received[0]?.status === "RECEIVED" && Boolean(received[0]?.received_at),
    `status=${received[0]?.status}`
  );

  const closed = await asUser(patient1, async (tx) => {
    const ack = await tx`select * from public.emergency_advance_demo(p_request_id := ${emergencyId})`;
    return ack[0]?.status === "ACKNOWLEDGED"
      ? tx`select * from public.emergency_advance_demo(p_request_id := ${emergencyId})`
      : [{ status: "NOT_ACK", closed_at: null }];
  });
  check(
    "demo advance reaches CLOSED with closed_at stamped",
    closed[0]?.status === "CLOSED" && Boolean(closed[0]?.closed_at),
    `status=${closed[0]?.status}`
  );

  await expectRpcError(
    "advancing a closed request is rejected",
    patient1,
    `select * from public.emergency_advance_demo(p_request_id := '${emergencyId}')`,
    "INVALID_TRANSITION"
  );

  // Ownership check (fresh, still-open request from another patient)
  const emergency2 = await asUser(patient2, (tx) =>
    tx`select * from public.create_emergency_request(
      p_description := 'Second demo request',
      p_location_text := 'Test street 2, Pune'
    )`
  );
  await expectRpcError(
    "advancing another patient's request is forbidden",
    patient1,
    `select * from public.emergency_advance_demo(p_request_id := '${emergency2[0].id}')`,
    "FORBIDDEN"
  );

  // Production mode must disable the simulation entirely (and be restored after).
  await sql`insert into public.app_settings (key, value) values ('app_env', 'production')
            on conflict (key) do update set value = 'production'`;
  try {
    await expectRpcError(
      "demo simulation is disabled in production mode",
      patient2,
      `select * from public.emergency_advance_demo(p_request_id := '${emergency2[0].id}')`,
      "FORBIDDEN"
    );
  } finally {
    await sql`delete from public.app_settings where key = 'app_env'`;
  }

  // Emergency events are audited with clinic_id null (not clinic-scoped),
  // so they are intentionally NOT part of the clinic audit viewer below.
  const emergencyAudit = await sql`
    select count(*) as count from public.audit_logs
    where entity_type = 'EMERGENCY' and action in ('EMERGENCY_CREATED', 'EMERGENCY_DEMO_ADVANCED')
  `;
  check(
    "emergency events are audited (globally, not clinic-scoped)",
    Number(emergencyAudit[0].count) >= 2,
    `count=${emergencyAudit[0].count}`
  );

  /* ── 8. follow-up + no-show ── */
  console.log("\n── Follow-up & no-show ──");
  const followUp = await asUser(doctor, (tx) => tx`
    insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions)
    values (${consultation2[0].id}, ${patient2}, ${doctor}, ${clinic}, current_date + 5, 'Review fever', 'Bring temperature log')
    returning id
  `);
  check("follow-up created", followUp.length === 1);
  await asUser(doctor, (tx) => tx`select public.notify_follow_up_created(${followUp[0].id})`);
  const fuNotif = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.notifications where user_id = ${patient2} and type = 'FOLLOW_UP_SCHEDULED'`
  );
  check("follow-up notification sent", Number(fuNotif[0].count) === 1);

  const patientFollowUps = await asUser(patient2, (tx) =>
    tx`select count(*) as count from public.follow_ups where patient_id = ${patient2} and status = 'SCHEDULED'`
  );
  check("patient sees their scheduled follow-up", Number(patientFollowUps[0].count) >= 1);

  // No-show the remaining waiting patient (T001, patient1)
  await expectRpcError(
    "patient cannot call the queue",
    patient1,
    `select * from public.queue_call_next(p_clinic_id := '${clinic}', p_doctor_id := '${doctor}')`,
    "FORBIDDEN"
  );
  await expectRpcError(
    "receptionist cannot start a consultation",
    receptionist,
    `select * from public.start_consultation(p_appointment_id := '${todayApptId}')`,
    "FORBIDDEN"
  );

  const noShow = await asUser(receptionist, (tx) =>
    tx`select * from public.mark_no_show(p_appointment_id := ${todayApptId})`
  );
  check("no-show marks the appointment", noShow[0]?.status === "NO_SHOW");
  const entry1Final = await sql`select status from public.queue_entries where id = ${entry1[0].id}`;
  check("no-show removes the patient from the active queue (CANCELLED)", entry1Final[0].status === "CANCELLED");

  /* ── 9. state machine protection ── */
  console.log("\n── State machine protection ──");
  await expectRpcError(
    "rescheduling a COMPLETED appointment is rejected",
    doctor,
    `select * from public.reschedule_appointment(p_appointment_id := '${appt2[0].id}', p_new_slot_id := '${slotA}')`,
    "INVALID_TRANSITION"
  );
  await expectRpcError(
    "cancelling a CANCELLED appointment is rejected",
    patient1,
    `select * from public.cancel_appointment(p_appointment_id := '${appointmentId}')`,
    "INVALID_TRANSITION"
  );
  // patient3 books tomorrow, then tries to check in today → wrong-day check-in.
  const slotE = slots[8]!.id as string;
  const p3Tomorrow = await asUser(patient3, (tx) =>
    tx`select * from public.book_appointment(p_slot_id := ${slotE}, p_visit_reason := 'Tomorrow visit')`
  );
  await expectRpcError(
    "check-in for a different day is rejected",
    patient3,
    `select * from public.check_in_appointment(p_appointment_id := '${p3Tomorrow[0].id}')`,
    "PAST_DATE"
  );
  await expectRpcError(
    "patient cannot book on behalf of another patient",
    patient1,
    `select * from public.book_appointment(p_slot_id := '${slotA}', p_visit_reason := 'For a friend', p_patient_id := '${patient3}')`,
    "FORBIDDEN"
  );

  /* ── 4b. availability refresh ── */
  console.log("\n── Availability refresh ──");
  const dayAfter = new Date(Date.now() + 48 * 60 * 60 * 1000).toISOString().slice(0, 10);
  const dayAfterSlots = await asUser(patient2, (tx) =>
    tx`select * from public.ensure_slots(${doctor}, ${clinic}, ${dayAfter}::date) order by start_time`
  );
  check("slots exist for the day after tomorrow", dayAfterSlots.length === 28, `got ${dayAfterSlots.length}`);
  const keepSlot = dayAfterSlots[1]!.id as string;
  const keptAppt = await asUser(patient2, (tx) =>
    tx`select * from public.book_appointment(p_slot_id := ${keepSlot}, p_visit_reason := 'Refresh fixture')`
  );
  check("fixture booking on the day after tomorrow", keptAppt[0]?.status === "BOOKED");

  await asUser(doctor, (tx) => tx`select * from public.refresh_future_slots(${doctor}, ${clinic})`);

  const afterRefresh = (await sql`select status, count(*) as count from public.appointment_slots where doctor_id = ${doctor} and clinic_id = ${clinic} and slot_date = ${dayAfter}::date group by status`) as unknown as { status: string; count: string }[];
  const bookedRow = afterRefresh.find((r) => r.status === "BOOKED");
  const freeRow = afterRefresh.find((r) => r.status === "FREE");
  check("BOOKED slots survive an availability refresh", Number(bookedRow?.count ?? 0) === 1, `BOOKED=${bookedRow?.count ?? 0}`);
  check("FREE future slots are dropped by the refresh", !freeRow, `FREE=${freeRow?.count}`);

  const regenerated = await asUser(patient2, (tx) =>
    tx`select * from public.ensure_slots(${doctor}, ${clinic}, ${dayAfter}::date) order by start_time`
  );
  const regenFree = ((regenerated as unknown as { status: string }[])).filter((s) => s.status === "FREE").length;
  check("ensure_slots regenerates the freed slots", regenFree === 27, `FREE after regen=${regenFree}`);

  // Retire the fixture appointment so it cannot interfere with later sections.
  await asUser(patient2, (tx) =>
    tx`select * from public.cancel_appointment(p_appointment_id := ${keptAppt[0].id}, p_reason := 'Refresh fixture retired')`
  );

  /* ── audit trail ── */
  const audit = await sql`select distinct action from public.audit_logs where clinic_id = ${clinic} order by action`;
  const auditActions = audit.map((a) => a.action);
  for (const expected of ["APPOINTMENT_BOOKED", "APPOINTMENT_RESCHEDULED", "APPOINTMENT_CANCELLED", "CHECK_IN", "WALK_IN_CREATED", "QUEUE_CALLED", "CONSULTATION_STARTED", "CONSULTATION_COMPLETED", "APPOINTMENT_NO_SHOW"]) {
    check(`audit log captured ${expected}`, auditActions.includes(expected));
  }

  /* ── analytics fixture sanity (same aggregates the admin page uses) ── */
  console.log("\n── Analytics fixtures ──");
  const walkInCount = await sql`
    select count(*) as count from public.appointments
    where clinic_id = ${clinic} and appointment_type = 'WALK_IN'
  `;
  check("analytics: walk-ins are recorded for the clinic", Number(walkInCount[0].count) >= 2, `count=${walkInCount[0].count}`);

  const completedCount = await sql`
    select count(*) as count from public.appointments
    where clinic_id = ${clinic} and status = 'COMPLETED'
  `;
  check("analytics: completed appointments exist", Number(completedCount[0].count) >= 1, `count=${completedCount[0].count}`);

  const calledEntries = await sql`
    select count(*) as count from public.queue_entries
    where clinic_id = ${clinic} and called_at is not null
  `;
  check("analytics: queue wait timestamps exist for called tokens", Number(calledEntries[0].count) >= 1, `count=${calledEntries[0].count}`);

  const durationSamples = await sql`
    select count(*) as count from public.queue_entries
    where clinic_id = ${clinic} and started_at is not null and completed_at is not null
  `;
  check("analytics: consultation duration samples exist", Number(durationSamples[0].count) >= 1, `count=${durationSamples[0].count}`);

  /* ── cleanup ── */
  console.log("\n── Cleaning up ──");
  await sql`delete from auth.users where email like ${"%@" + DOMAIN}`;
  await sql`delete from public.specializations where slug = 'workflow-test-spec'`;
  await sql`delete from public.clinics where name = 'Workflow Test Clinic'`;
  console.log("  cleanup done");

  const passed = results.filter((r) => r.pass).length;
  const failed = results.length - passed;
  console.log(`\n${"─".repeat(50)}`);
  console.log(`Workflow verification: ${passed}/${results.length} checks passed${failed ? `, ${failed} FAILED` : ""}`);
  console.log(`${"─".repeat(50)}\n`);

  await sql.end({ timeout: 5 });
  process.exit(failed > 0 ? 1 : 0);
}

main().catch(async (err: Error) => {
  console.error("Fatal:", err.message);
  await sql`delete from auth.users where email like ${"%@" + DOMAIN}`.catch(() => {});
  await sql`delete from public.specializations where slug = 'workflow-test-spec'`.catch(() => {});
  await sql`delete from public.clinics where name = 'Workflow Test Clinic'`.catch(() => {});
  await sql.end({ timeout: 5 }).catch(() => {});
  process.exit(1);
});
