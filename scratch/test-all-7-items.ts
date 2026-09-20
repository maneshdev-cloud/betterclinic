import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://qkbgvbjbuirgxqbluegm.supabase.co";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrYmd2YmpidWlyZ3hxYmx1ZWdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NzQxOTcsImV4cCI6MjEwNTE1MDE5N30.Fs7M-cN9msvbZkx7uAaUsoB7CnVLW5HVgigqMgTlFdU";

const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function runTests() {
  console.log("=== Starting Automated Verification for All 7 Items ===");

  const naupadaClinicId = "274970a3-9522-4dbe-9d41-cc2e32b184ca";
  const validClaimCode = "ADM-A6EE81";
  const validDoctorCode = "510FAE";

  // 1. ITEM 1: Attempt to claim admin of existing clinic with NO code
  console.log("\n--- Item 1: Clinic Admin Claim Security ---");
  const randomSuffix = Math.floor(Math.random() * 100000);
  const testEmail1 = `admin_test_nocode_${randomSuffix}@testclinic.local`;
  const { data: res1, error: err1 } = await supabase.auth.signUp({
    email: testEmail1,
    password: "Password@123!",
    options: {
      data: {
        full_name: "Admin NoCode Tester",
        role: "CLINIC_ADMIN",
        clinic_id: naupadaClinicId,
        // No clinic_admin_claim_code provided!
      },
    },
  });

  if (err1) {
    console.log("✓ SUCCESS: Admin signup with no code rejected by database:", err1.message);
  } else {
    console.log("Admin signup with no code response:", res1);
  }

  // 2. ITEM 1: Attempt with invalid claim code
  const testEmail2 = `admin_test_badcode_${randomSuffix}@testclinic.local`;
  const { data: res2, error: err2 } = await supabase.auth.signUp({
    email: testEmail2,
    password: "Password@123!",
    options: {
      data: {
        full_name: "Admin BadCode Tester",
        role: "CLINIC_ADMIN",
        clinic_id: naupadaClinicId,
        clinic_admin_claim_code: "WRONG-CODE",
      },
    },
  });
  if (err2) {
    console.log("✓ SUCCESS: Admin signup with bad code rejected by database:", err2.message);
  } else {
    console.log("Admin signup with bad code response:", res2);
  }

  // 3. ITEM 1: Attempt with VALID claim code (should succeed and claim slot)
  const testEmail3 = `admin_test_valid_${randomSuffix}@testclinic.local`;
  const { data: res3, error: err3 } = await supabase.auth.signUp({
    email: testEmail3,
    password: "Password@123!",
    options: {
      data: {
        full_name: "Admin Valid Tester",
        role: "CLINIC_ADMIN",
        clinic_id: naupadaClinicId,
        clinic_admin_claim_code: " adm-a6ee81 ", // test trimming & case insensitivity
      },
    },
  });
  if (err3) {
    console.log("Admin signup error:", err3.message);
  } else if (res3.user) {
    console.log("✓ SUCCESS: Admin signup with valid trimmed/case-insensitive code accepted. User:", res3.user.id);
  }

  // 4. ITEM 1: Attempt a SECOND admin claim on the same clinic (must be rejected!)
  const testEmail4 = `admin_test_duplicate_${randomSuffix}@testclinic.local`;
  const { data: res4, error: err4 } = await supabase.auth.signUp({
    email: testEmail4,
    password: "Password@123!",
    options: {
      data: {
        full_name: "Admin Duplicate Tester",
        role: "CLINIC_ADMIN",
        clinic_id: naupadaClinicId,
        clinic_admin_claim_code: validClaimCode,
      },
    },
  });
  if (err4) {
    console.log("✓ SUCCESS: Second admin claim rejected with error:", err4.message);
  } else {
    console.log("Second admin attempt result:", res4);
  }

  // 5. ITEM 2: Doctor Invite Code Trim & Case Insensitivity
  console.log("\n--- Item 2: Doctor Invite Code Validation ---");
  const testDoctorEmail = `doctor_test_${randomSuffix}@testclinic.local`;
  const { data: docRes, error: docErr } = await supabase.auth.signUp({
    email: testDoctorEmail,
    password: "Password@123!",
    options: {
      data: {
        full_name: "Dr. Trim Test",
        role: "DOCTOR",
        clinic_id: naupadaClinicId,
        doctor_invite_code: "  510fae  ", // lowercase and padded with spaces
        registration_number: `REG${randomSuffix}`,
        qualification: "MBBS, MD",
        experience_years: "5",
        consultation_fee: "600",
      },
    },
  });
  if (docErr) {
    console.log("Doctor signup error:", docErr.message);
  } else {
    console.log("✓ SUCCESS: Doctor signup with lowercase/padded code succeeded:", docRes.user?.id);
  }

  // 6. ITEM 3: New Clinic Creation & Duplicate Check
  console.log("\n--- Item 3: New Clinic Duplicate Check & Creation ---");
  const queryName = "aarogya";
  const { data: dups } = await supabase
    .from("clinics")
    .select("id, name, city, area")
    .ilike("name", `%${queryName}%`)
    .limit(5);
  console.log(`✓ Duplicate check for "${queryName}" found ${dups?.length ?? 0} matches:`, dups?.map(d => `${d.name} (${d.city})`));

  // Test create_clinic_with_invite RPC
  const newClinicName = `Automated Test Clinic ${randomSuffix}`;
  const { data: clinicRpcRes, error: clinicRpcErr } = await supabase.rpc("create_clinic_with_invite", {
    p_name: newClinicName,
    p_city: "Pune",
    p_area: "Kothrud",
    p_address_line: "123 Tech Park",
  });

  if (clinicRpcErr) {
    console.error("✗ FAIL create_clinic_with_invite RPC error:", clinicRpcErr);
  } else {
    console.log("✓ SUCCESS: Created new clinic via RPC. Returned payload:", clinicRpcRes);
    const newClinicId = clinicRpcRes.id;
    console.log("New clinic admin claim code:", clinicRpcRes.admin_claim_code);

    // Founding admin signup for brand new clinic (Path A: is_new_clinic: "true", no code required)
    const foundingAdminEmail = `founding_admin_${randomSuffix}@testclinic.local`;
    const { data: foundRes, error: foundErr } = await supabase.auth.signUp({
      email: foundingAdminEmail,
      password: "Password@123!",
      options: {
        data: {
          full_name: "Founding Admin",
          role: "CLINIC_ADMIN",
          clinic_id: newClinicId,
          is_new_clinic: "true", // Path A!
        },
      },
    });
    if (foundErr) {
      console.error("✗ FAIL Founding admin signup error:", foundErr.message);
    } else {
      console.log("✓ SUCCESS: Founding admin created brand new clinic with no code required (Path A)!", foundRes.user?.id);
    }
  }

  // 7. ITEM 4: Avatar Storage Bucket
  console.log("\n--- Item 4: Avatars Storage Bucket Check ---");
  const sessionToken = res3?.session?.access_token;
  const user3 = res3?.user;
  if (sessionToken && user3) {
    const userClient = createClient(SUPABASE_URL, ANON_KEY, {
      global: { headers: { Authorization: `Bearer ${sessionToken}` } }
    });
    const testFile = Buffer.from("fake avatar png content");
    const testPath = `${user3.id}/test-avatar-${Date.now()}.png`;
    const { data: uploadData, error: uploadErr } = await userClient.storage
      .from("avatars")
      .upload(testPath, testFile, { contentType: "image/png", upsert: true });
    if (uploadErr) {
      console.log("Avatar upload error:", uploadErr.message);
    } else {
      console.log("✓ SUCCESS: Authenticated user uploaded avatar to avatars bucket successfully! Path:", uploadData.path);
      const { data: publicUrlData } = userClient.storage.from("avatars").getPublicUrl(testPath);
      console.log("✓ Public avatar URL:", publicUrlData.publicUrl);
    }
  }

  // 8. ITEM 7: User Preferences Privacy Flags
  console.log("\n--- Item 7: User Preferences Privacy Flags ---");
  if (user3) {
    // Check privacy flags RPC
    const { data: flags } = await supabase.rpc("get_user_privacy_flags", {
      p_user_ids: [user3.id],
    });
    console.log("✓ Privacy flags for user returned from security definer RPC:", flags);
  }

  console.log("\n=== Automated Verification Completed ===");
}

runTests().catch(console.error);
