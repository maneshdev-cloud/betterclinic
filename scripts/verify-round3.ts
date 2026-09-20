import { createClient } from "@supabase/supabase-js";
import { loadLocalEnv } from "./lib/load-env";

loadLocalEnv();

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!supabaseUrl || !serviceRoleKey) {
  console.error("Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const adminClient = createClient(supabaseUrl, serviceRoleKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

async function main() {
  console.log("=== VERIFYING ROUND 3 FEATURES ===");

  // 1. Verify clinic_invite_codes has doctor_code
  console.log("\n1. Checking clinic_invite_codes table for staff and doctor codes...");
  const { data: inviteCodes, error: inviteErr } = await adminClient
    .from("clinic_invite_codes")
    .select("clinic_id, code, doctor_code");

  if (inviteErr) {
    throw new Error(`Failed to query clinic_invite_codes: ${inviteErr.message}`);
  }

  console.log(`Found ${inviteCodes?.length ?? 0} clinic invite codes.`);
  for (const c of inviteCodes ?? []) {
    if (!c.code || !c.doctor_code) {
      throw new Error(`Clinic ${c.clinic_id} missing code or doctor_code: ${JSON.stringify(c)}`);
    }
    console.log(`  Clinic ${c.clinic_id.slice(0, 8)}...: Staff Code=${c.code}, Doctor Code=${c.doctor_code}`);
  }
  console.log("✓ All clinics have valid staff and doctor invite codes.");

  // Pick first clinic
  const targetClinic = inviteCodes![0]!;
  const clinicId = targetClinic.clinic_id;
  const validDoctorCode = targetClinic.doctor_code;

  // Fetch a specialization
  const { data: spec } = await adminClient.from("specializations").select("id").limit(1).single();
  const specId = spec?.id;

  // 2. Test Multi-Role signup & activation
  console.log("\n2. Testing Multi-Role Identity Flow...");
  const testEmail = `test.multirole.${Date.now()}@example.com`;
  const testPassword = "TestPassword123!";

  console.log(`Creating initial PATIENT account: ${testEmail}`);
  const { data: authUser, error: authErr } = await adminClient.auth.admin.createUser({
    email: testEmail,
    password: testPassword,
    email_confirm: true,
    user_metadata: {
      role: "PATIENT",
      full_name: "Test MultiRole User",
      phone: "9876543210",
    },
  });

  if (authErr || !authUser.user) {
    throw new Error(`Failed to create test user: ${authErr?.message}`);
  }
  const userId = authUser.user.id;
  console.log(`Created user ${userId}`);

  // Check profile_roles table
  const { data: initialRoles, error: rolesErr } = await adminClient
    .from("profile_roles")
    .select("role")
    .eq("profile_id", userId);

  if (rolesErr) throw new Error(`profile_roles query failed: ${rolesErr.message}`);
  console.log(`Initial roles in profile_roles:`, initialRoles?.map((r) => r.role));
  if (!initialRoles?.some((r) => r.role === "PATIENT")) {
    throw new Error("Initial PATIENT role not recorded in profile_roles");
  }

  // 3. Test Doctor Invite Code Gatekeeping
  console.log("\n3. Testing Doctor Invite Code Gatekeeping...");
  console.log("Attempting to add DOCTOR role with INVALID doctor invite code...");
  const { error: invalidCodeErr } = await adminClient.rpc("add_profile_role", {
    p_user_id: userId,
    p_role: "DOCTOR",
    p_data: {
      qualification: "MBBS",
      registration_number: "TEST-12345",
      experience_years: "5",
      specialization_id: specId,
      clinic_id: clinicId,
      doctor_invite_code: "WRONG1",
    },
  });

  if (!invalidCodeErr) {
    throw new Error("Expected invalid doctor invite code to fail, but it succeeded!");
  }
  console.log(`✓ Correctly rejected with error: ${invalidCodeErr.message}`);

  console.log("Attempting to add DOCTOR role with VALID doctor invite code...");
  const { error: validCodeErr } = await adminClient.rpc("add_profile_role", {
    p_user_id: userId,
    p_role: "DOCTOR",
    p_data: {
      qualification: "MBBS",
      registration_number: "TEST-12345",
      experience_years: "5",
      specialization_id: specId,
      clinic_id: clinicId,
      doctor_invite_code: validDoctorCode,
    },
  });

  if (validCodeErr) {
    throw new Error(`Failed to add DOCTOR role with valid code: ${validCodeErr.message}`);
  }
  console.log("✓ Successfully added DOCTOR role with valid invite code!");

  // Verify both roles exist
  const { data: updatedRoles } = await adminClient
    .from("profile_roles")
    .select("role")
    .eq("profile_id", userId);

  const roleList = (updatedRoles ?? []).map((r) => r.role);
  console.log(`Updated roles in profile_roles:`, roleList);
  if (!roleList.includes("PATIENT") || !roleList.includes("DOCTOR")) {
    throw new Error(`Expected [PATIENT, DOCTOR], got: ${JSON.stringify(roleList)}`);
  }
  console.log("✓ Multi-role confirmed: Profile holds both PATIENT and DOCTOR roles!");

  // Verify doctors record exists
  const { data: doctorRow } = await adminClient.from("doctors").select("*").eq("id", userId).maybeSingle();
  if (!doctorRow) {
    throw new Error("Doctor record was not created in doctors table");
  }
  console.log(`✓ Doctor record confirmed: ${doctorRow.qualification}, reg: ${doctorRow.registration_number}`);

  // Verify patients record still exists
  const { data: patientRow } = await adminClient.from("patients").select("*").eq("id", userId).maybeSingle();
  if (!patientRow) {
    throw new Error("Patient record missing in patients table");
  }
  console.log(`✓ Patient record confirmed: ${patientRow.phone}`);

  // 4. Test duplicate role prevention
  console.log("\n4. Testing duplicate role prevention...");
  const { error: dupRoleErr } = await adminClient.rpc("add_profile_role", {
    p_user_id: userId,
    p_role: "DOCTOR",
    p_data: {
      qualification: "MBBS",
      registration_number: "TEST-12345",
      experience_years: "5",
    },
  });
  if (!dupRoleErr) {
    throw new Error("Expected duplicate role to fail, but it succeeded!");
  }
  console.log(`✓ Correctly rejected duplicate role: ${dupRoleErr.message}`);

  // 5. Clean up test user
  console.log("\n5. Cleaning up test user...");
  await adminClient.auth.admin.deleteUser(userId);
  console.log("✓ Cleaned up test user.");

  console.log("\n=== ALL ROUND 3 VERIFICATIONS PASSED ===");
}

main().catch((err) => {
  console.error("Verification failed:", err);
  process.exit(1);
});
