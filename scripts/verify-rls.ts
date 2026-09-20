/**
 * BETTER CLINIC — RLS verification suite.
 *
 * Runs against your live Supabase database (DATABASE_URL) and proves
 * that Row Level Security blocks cross-role / cross-patient access.
 *
 *   npm run verify:rls
 *
 * How it works: fixtures (a clinic, two doctors, two patients, one
 * receptionist, one admin) are created through the REAL signup trigger
 * (handle_new_user), including invite-code validation for staff. Test
 * appointments, a consultation and an audit row are added. Queries are
 * then executed while impersonating each user by setting
 * request.jwt.claims + role, exactly like PostgREST does. Every check
 * prints PASS/FAIL and the script exits non-zero on any failure.
 * All fixture data is removed afterwards.
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

const TEST_EMAIL_DOMAIN = "rls-test.betterclinic.test";
const results: { name: string; pass: boolean; detail?: string }[] = [];

function record(name: string, pass: boolean, detail?: string) {
  results.push({ name, pass, detail });
  const mark = pass ? "PASS" : "FAIL";
  console.log(`  ${pass ? "✓" : "✗"} [${mark}] ${name}${detail && !pass ? ` — ${detail}` : ""}`);
}

/** Run queries as a specific user (or 'anon') inside a transaction. */
async function asUser(
  user: { sub: string } | "anon",
  fn: (tx: postgres.TransactionSql<{}>) => Promise<unknown>
): Promise<unknown> {
  const result = await sql.begin(async (tx) => {
    if (user === "anon") {
      await tx`select set_config('role', 'anon', true)`;
    } else {
      const claims = JSON.stringify({ sub: user.sub, role: "authenticated" });
      await tx`select set_config('request.jwt.claims', ${claims}, true), set_config('role', 'authenticated', true)`;
    }
    return fn(tx);
  });
  return result;
}

async function expectRows(
  name: string,
  user: { sub: string } | "anon",
  query: (tx: postgres.TransactionSql<{}>) => Promise<{ count: number }[]>,
  expected: number
) {
  try {
    const rows = (await asUser(user, query)) as { count: number }[];
    const count = Number(rows[0]?.count ?? 0);
    record(name, count === expected, `expected ${expected} row(s), saw ${count}`);
  } catch (err) {
    record(name, false, `query errored: ${(err as Error).message}`);
  }
}

async function expectDenied(
  name: string,
  user: { sub: string } | "anon",
  fn: (tx: postgres.TransactionSql<{}>) => Promise<unknown>
) {
  try {
    await asUser(user, fn);
    record(name, false, "statement was ALLOWED but should have been denied");
  } catch (err) {
    const message = (err as Error).message;
    const denied = /row-level security|permission denied/i.test(message);
    record(name, denied, denied ? undefined : `unexpected error: ${message}`);
  }
}

/**
 * UPDATE on a table with no update policy silently affects 0 rows
 * (default-deny). Verify the exact denial: zero rows touched AND the
 * data provably unchanged afterwards.
 */
async function expectUpdateBlocked(
  name: string,
  user: { sub: string } | "anon",
  update: (tx: postgres.TransactionSql<{}>) => Promise<unknown>,
  verifyUnchanged: () => Promise<boolean>
) {
  try {
    const result = (await asUser(user, update)) as { count: number };
    const touched = result?.count ?? -1;
    if (touched !== 0) {
      record(name, false, `UPDATE touched ${touched} row(s) — should have been blocked`);
      return;
    }
    const unchanged = await verifyUnchanged();
    record(name, unchanged, "UPDATE affected 0 rows but the data changed anyway");
  } catch (err) {
    // An explicit RLS error is also a valid denial.
    const message = (err as Error).message;
    const denied = /row-level security|permission denied/i.test(message);
    record(name, denied, denied ? undefined : `unexpected error: ${message}`);
  }
}

interface Fixture {
  clinicId: string;
  doctor1: string;
  doctor2: string;
  patient1: string;
  patient2: string;
  receptionist: string;
  admin: string;
  appointment1: string;
  appointment2: string;
}

async function createUser(tx: postgres.TransactionSql<{}>, email: string, metadata: Record<string, string>): Promise<string> {
  // Fixture users are never logged into via the auth API, so the password
  // hash is a placeholder (also avoids a pgcrypto dependency here).
  // NOTE: tx.json() — passing a JSON string with ::jsonb would be
  // double-encoded by postgres.js into a scalar JSON string.
  const rows = await tx`
    insert into auth.users (instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values ('00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${email},
            'rls-test-not-loginable', now(), now(), now(), '{}'::jsonb, ${tx.json(metadata)})
    returning id
  `;
  return rows[0].id as string;
}

async function setup(): Promise<Fixture> {
  console.log("\n── Creating fixtures (via the real signup trigger) ──");

  const clinicRows = await sql`
    insert into public.clinics (name, address_line, city, area)
    values ('RLS Test Clinic', 'Test Street 1', 'Pune', 'Test Area')
    returning id
  `;
  const clinicId = clinicRows[0].id as string;

  const inviteRows = await sql`
    insert into public.clinic_invite_codes (clinic_id, code)
    values (${clinicId}, 'RLSTEST-' || upper(substr(md5(random()::text), 1, 6)))
    returning code
  `;
  const inviteCode = inviteRows[0].code as string;

  const specRows = await sql`
    insert into public.specializations (name, slug, description)
    values ('RLS Test Medicine', 'rls-test-medicine', 'Temporary specialization for RLS tests')
    returning id
  `;
  const specId = specRows[0].id as string;

  const doctorMeta = (name: string) => ({
    role: "DOCTOR",
    full_name: name,
    phone: "9800000001",
    qualification: "MBBS",
    registration_number: "RLS-TEST-1",
    experience_years: "5",
    specialization_id: specId,
    clinic_id: clinicId,
  });

  const [doctor1, doctor2, patient1, patient2, receptionist, admin] = await sql.begin(async (tx) => {
    const d1 = await createUser(tx, `d1@${TEST_EMAIL_DOMAIN}`, doctorMeta("Dr Rls One"));
    const d2 = await createUser(tx, `d2@${TEST_EMAIL_DOMAIN}`, doctorMeta("Dr Rls Two"));
    const p1 = await createUser(tx, `p1@${TEST_EMAIL_DOMAIN}`, { role: "PATIENT", full_name: "Rls Patient One", phone: "9800000002" });
    const p2 = await createUser(tx, `p2@${TEST_EMAIL_DOMAIN}`, { role: "PATIENT", full_name: "Rls Patient Two", phone: "9800000003" });
    const r = await createUser(tx, `r@${TEST_EMAIL_DOMAIN}`, { role: "RECEPTIONIST", full_name: "Rls Receptionist", phone: "9800000004", clinic_id: clinicId, staff_invite_code: inviteCode });
    const a = await createUser(tx, `a@${TEST_EMAIL_DOMAIN}`, { role: "CLINIC_ADMIN", full_name: "Rls Admin", phone: "9800000005", clinic_id: clinicId, staff_invite_code: inviteCode });
    return [d1, d2, p1, p2, r, a];
  });

  // Appointments: A1 = patient1 ↔ doctor1, A2 = patient2 ↔ doctor2 (same clinic).
  const appointmentRows = await sql`
    insert into public.appointments (patient_id, doctor_id, clinic_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    values
      (${patient1}, ${doctor1}, ${clinicId}, 'SCHEDULED', 'BOOKED', current_date, '10:00', '10:30', 'RLS test visit one'),
      (${patient2}, ${doctor2}, ${clinicId}, 'SCHEDULED', 'BOOKED', current_date, '11:00', '11:30', 'RLS test visit two')
    returning id
  `;
  const appointment1 = appointmentRows[0].id as string;
  const appointment2 = appointmentRows[1].id as string;

  // A consultation for patient1 with doctor1, plus a prescription-free record set.
  await sql`
    insert into public.consultations (appointment_id, patient_id, doctor_id, clinic_id, status, chief_complaint, clinical_notes)
    values (${appointment1}, ${patient1}, ${doctor1}, ${clinicId}, 'COMPLETED', 'Test complaint', 'Test notes')
  `;
  await sql`select public.log_audit('RLS_TEST_EVENT', 'TEST', null, ${clinicId}, null, '{}'::jsonb)`;

  console.log("  fixtures ready");
  return { clinicId, doctor1, doctor2, patient1, patient2, receptionist, admin, appointment1, appointment2 };
}

async function runChecks(f: Fixture) {
  console.log("\n── Cross-patient isolation ──");
  await expectRows(
    "Patient 1 cannot see Patient 2's appointments",
    { sub: f.patient1 },
    (tx) => tx`select count(*) as count from public.appointments where patient_id = ${f.patient2}`,
    0
  );
  await expectRows(
    "Patient 1 cannot see Patient 2's consultations",
    { sub: f.patient1 },
    (tx) => tx`select count(*) as count from public.consultations where patient_id = ${f.patient2}`,
    0
  );
  await expectRows(
    "Patient 1 cannot see Patient 2's prescriptions",
    { sub: f.patient1 },
    (tx) => tx`select count(*) as count from public.prescriptions where patient_id = ${f.patient2}`,
    0
  );
  await expectRows(
    "Patient 1 sees their own appointment",
    { sub: f.patient1 },
    (tx) => tx`select count(*) as count from public.appointments where id = ${f.appointment1}`,
    1
  );

  console.log("\n── Doctor scoping ──");
  await expectRows(
    "Doctor 1 sees only their own appointments (not Doctor 2's)",
    { sub: f.doctor1 },
    (tx) => tx`select count(*) as count from public.appointments where clinic_id = ${f.clinicId}`,
    1
  );
  await expectRows(
    "Doctor 1 sees Patient 1 (direct care relationship)",
    { sub: f.doctor1 },
    (tx) => tx`select count(*) as count from public.patients where id = ${f.patient1}`,
    1
  );
  await expectRows(
    "Doctor 1 CANNOT see Patient 2 (same clinic, no relationship)",
    { sub: f.doctor1 },
    (tx) => tx`select count(*) as count from public.patients where id = ${f.patient2}`,
    0
  );
  await expectRows(
    "Doctor 2 cannot read Doctor 1's consultation for Patient 1",
    { sub: f.doctor2 },
    (tx) => tx`select count(*) as count from public.consultations where patient_id = ${f.patient1}`,
    0
  );

  console.log("\n── Receptionist: operational yes, clinical no ──");
  await expectRows(
    "Receptionist sees today's appointments at their clinic",
    { sub: f.receptionist },
    (tx) => tx`select count(*) as count from public.appointments where clinic_id = ${f.clinicId}`,
    2
  );
  await expectRows(
    "Receptionist sees patient identities for their clinic's appointments",
    { sub: f.receptionist },
    (tx) => tx`select count(*) as count from public.patients p where p.id in (${f.patient1}, ${f.patient2})`,
    2
  );
  await expectRows(
    "Receptionist CANNOT read clinical consultations",
    { sub: f.receptionist },
    (tx) => tx`select count(*) as count from public.consultations`,
    0
  );
  await expectRows(
    "Receptionist CANNOT read prescriptions",
    { sub: f.receptionist },
    (tx) => tx`select count(*) as count from public.prescriptions`,
    0
  );

  console.log("\n── Write protection (mutations only via RPCs) ──");
  await expectUpdateBlocked(
    "Patient cannot directly modify an appointment (RLS default-deny)",
    { sub: f.patient1 },
    (tx) => tx`update public.appointments set visit_reason = 'hacked' where id = ${f.appointment1}`,
    async () => {
      const rows = await sql`select visit_reason from public.appointments where id = ${f.appointment1}`;
      return rows[0]?.visit_reason === "RLS test visit one";
    }
  );
  await expectDenied(
    "Patient cannot directly INSERT a queue entry",
    { sub: f.patient1 },
    (tx) => tx`insert into public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, status)
               values (${f.clinicId}, ${f.doctor1}, ${f.patient1}, ${f.appointment1}, current_date, 'WAITING')`
  );
  await expectUpdateBlocked(
    "Patient cannot flip a slot's status directly (RLS default-deny)",
    { sub: f.patient1 },
    (tx) => tx`update public.appointment_slots set status = 'BLOCKED' where doctor_id = ${f.doctor1}`,
    async () => {
      const rows = await sql`select status from public.appointment_slots where doctor_id = ${f.doctor1}`;
      return rows.every((r) => String(r.status) === "FREE");
    }
  );
  await expectDenied(
    "Patient cannot write audit logs",
    { sub: f.patient1 },
    (tx) => tx`insert into public.audit_logs (action, entity_type) values ('HACK', 'TEST')`
  );

  console.log("\n── Audit logs & admin scope ──");
  await expectRows(
    "Patient cannot read audit logs",
    { sub: f.patient1 },
    (tx) => tx`select count(*) as count from public.audit_logs`,
    0
  );
  await expectRows(
    "Clinic admin reads their clinic's audit logs",
    { sub: f.admin },
    (tx) => tx`select count(*) as count from public.audit_logs where clinic_id = ${f.clinicId} and action = 'RLS_TEST_EVENT'`,
    1
  );
  await expectRows(
    "Clinic admin sees staff/doctor signup audit rows for their clinic",
    { sub: f.admin },
    (tx) => tx`select count(*) as count from public.audit_logs where clinic_id = ${f.clinicId} and action = 'AUTH_SIGNUP'`,
    4 // doctor1, doctor2, receptionist, admin (patients have no clinic on signup)
  );
  await expectRows(
    "Clinic admin sees their clinic's appointments",
    { sub: f.admin },
    (tx) => tx`select count(*) as count from public.appointments where clinic_id = ${f.clinicId}`,
    2
  );

  console.log("\n── Anonymous (signed out) access ──");
  await expectRows(
    "Anonymous can read doctors (public discovery)",
    "anon",
    (tx) => tx`select count(*) as count from public.doctors where id in (${f.doctor1}, ${f.doctor2})`,
    2
  );
  await expectRows(
    "Anonymous can read specializations (public discovery)",
    "anon",
    (tx) => tx`select count(*) as count from public.specializations where id in (
      select specialization_id from public.doctor_specializations where doctor_id = ${f.doctor1})`,
    1
  );
  await expectRows(
    "Anonymous cannot read appointments",
    "anon",
    (tx) => tx`select count(*) as count from public.appointments`,
    0
  );
  await expectRows(
    "Anonymous cannot read clinic invite codes",
    "anon",
    (tx) => tx`select count(*) as count from public.clinic_invite_codes`,
    0
  );

  console.log("\n── Invite-code enforcement (signup trigger) ──");
  try {
    await sql.begin(async (tx) => {
      await createUser(tx, `impostor@${TEST_EMAIL_DOMAIN}`, {
        role: "RECEPTIONIST",
        full_name: "Impostor",
        phone: "9800000099",
        clinic_id: f.clinicId,
        staff_invite_code: "WRONG-CODE",
      });
    });
    record("Signup with a wrong invite code is rejected", false, "impostor staff account was created");
  } catch (err) {
    const message = (err as Error).message;
    record(
      "Signup with a wrong invite code is rejected",
      /INVITE_CODE_INVALID/.test(message),
      message
    );
  }
}

async function cleanup() {
  console.log("\n── Cleaning up fixtures ──");
  await sql`delete from auth.users where email like ${"@" + TEST_EMAIL_DOMAIN} or email like ${"%@" + TEST_EMAIL_DOMAIN}`;
  await sql`delete from public.specializations where slug = 'rls-test-medicine'`;
  await sql`delete from public.clinics where name = 'RLS Test Clinic'`;
  console.log("  cleanup done");
}

async function main() {
  console.log("BETTER CLINIC — RLS verification");
  console.log(`Target: ${dbUrl.replace(/\/\/[^@]*@/, "//***@")}`);

  const tables: string[] = [];
  const rels = await sql`select tablename from pg_tables where schemaname = 'public'`;
  if (rels.length === 0) {
    console.error("\nNo tables found in the public schema. Run `npm run db:push` first.");
    process.exit(1);
  }
  tables.push(...rels.map((r) => r.tablename as string));
  const expectedTables = ["profiles", "appointments", "queue_entries", "prescriptions", "audit_logs"];
  const missing = expectedTables.filter((t) => !tables.includes(t));
  if (missing.length > 0) {
    console.error(`\nSchema looks incomplete (missing: ${missing.join(", ")}). Run \`npm run db:push\` first.`);
    process.exit(1);
  }

  let fixture: Fixture;
  try {
    fixture = await setup();
  } catch (err) {
    console.error("\nFixture setup failed:", (err as Error).message);
    console.error("Have you run `npm run db:push`?");
    await cleanup().catch(() => {});
    process.exit(1);
  }

  try {
    await runChecks(fixture);
  } finally {
    await cleanup().catch(() => {});
  }

  const passed = results.filter((r) => r.pass).length;
  const failed = results.length - passed;
  console.log(`\n${"─".repeat(50)}`);
  console.log(`RLS verification: ${passed}/${results.length} checks passed${failed ? `, ${failed} FAILED` : ""}`);
  console.log(`${"─".repeat(50)}\n`);

  await sql.end({ timeout: 5 });
  process.exit(failed > 0 ? 1 : 0);
}

main().catch(async (err: Error) => {
  console.error("Fatal:", err.message);
  await sql.end({ timeout: 5 }).catch(() => {});
  process.exit(1);
});
