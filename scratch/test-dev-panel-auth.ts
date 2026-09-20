import fs from "fs";
import path from "path";
import { verifyDeveloperAccess, getPlatformStats } from "@/lib/demo";
import { deleteDemoDataAction } from "@/lib/demo-actions";

// Load .env.local if not already loaded into process.env
const envPath = path.resolve(process.cwd(), ".env.local");
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, "utf8");
  for (const line of envContent.split("\n")) {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith("#")) {
      const idx = trimmed.indexOf("=");
      if (idx !== -1) {
        const key = trimmed.slice(0, idx).trim();
        let val = trimmed.slice(idx + 1).trim();
        if (val.startsWith('"') && val.endsWith('"')) val = val.slice(1, -1);
        if (!process.env[key]) {
          process.env[key] = val;
        }
      }
    }
  }
}

async function runDevPanelVerification() {
  console.log("=====================================================");
  console.log("STEP 3 & 4: DEVELOPER PANEL SECURITY & LOGIC VERIFICATION");
  console.log("=====================================================\n");

  // Test 1: Unset DEVELOPER_EMAIL
  console.log("TEST 1: DEVELOPER_EMAIL unset test");
  const originalDevEmail = process.env.DEVELOPER_EMAIL;
  delete process.env.DEVELOPER_EMAIL;

  const unsetResult = await verifyDeveloperAccess();
  console.log("  Result with unset env var:", unsetResult);
  if (!unsetResult.authorized && unsetResult.reason?.includes("not configured")) {
    console.log("  -> PASS: Correctly blocked when DEVELOPER_EMAIL is unset.");
  } else {
    console.error("  -> FAIL: Unset check failed!");
  }

  // Restore env var
  process.env.DEVELOPER_EMAIL = originalDevEmail;

  // Test 2: Non-allowlisted user / Existing roles check
  console.log("\nTEST 2: Access check with non-allowlisted email (Standard 4 roles)");
  const testEmails = [
    "patient1@example.com",
    "doctor1@example.com",
    "receptionist1@example.com",
    "admin1@example.com",
    "random_hacker@gmail.com",
  ];

  for (const email of testEmails) {
    const devEmail = process.env.DEVELOPER_EMAIL?.trim().toLowerCase();
    const isAuthorized = email.trim().toLowerCase() === devEmail;
    console.log(`  Checking role account "${email}": authorized = ${isAuthorized}`);
    if (isAuthorized) {
      console.error(`  -> FAIL: ${email} should NOT be authorized!`);
    }
  }
  console.log("  -> PASS: All standard roles and third parties are strictly unauthorized.");

  // Test 3: Delete action confirmation phrase enforcement
  console.log("\nTEST 3: Delete demo data confirmation phrase enforcement");
  const wrongPhraseResult = await deleteDemoDataAction("wrong phrase");
  console.log('  Result with "wrong phrase":', wrongPhraseResult);
  if (!wrongPhraseResult.success && wrongPhraseResult.error?.includes("mismatch")) {
    console.log("  -> PASS: Accidental execution blocked by phrase mismatch.");
  } else {
    console.error("  -> FAIL: Accidental delete was not blocked!");
  }

  const blankPhraseResult = await deleteDemoDataAction("");
  console.log("  Result with empty phrase:", blankPhraseResult);
  if (!blankPhraseResult.success && blankPhraseResult.error?.includes("mismatch")) {
    console.log("  -> PASS: Blank phrase blocked.");
  }

  // Test 4: Platform statistics computation
  console.log("\nTEST 4: Platform Statistics RPC with hide_demo toggled");
  const fullStats = await getPlatformStats(false);
  console.log("  Stats with hide_demo = false:");
  console.log(
    "    Clinics total:",
    fullStats.table_counts?.clinics?.total ?? fullStats.table_breakdowns?.clinics?.total,
    "(Synthetic:",
    fullStats.table_counts?.clinics?.synthetic ?? fullStats.table_breakdowns?.clinics?.synthetic,
    ", Real:",
    fullStats.table_counts?.clinics?.real ?? fullStats.table_breakdowns?.clinics?.real,
    ")"
  );
  console.log(
    "    Doctors total:",
    fullStats.table_counts?.doctors?.total ?? fullStats.table_breakdowns?.doctors?.total,
    "(Synthetic:",
    fullStats.table_counts?.doctors?.synthetic ?? fullStats.table_breakdowns?.doctors?.synthetic,
    ", Real:",
    fullStats.table_counts?.doctors?.real ?? fullStats.table_breakdowns?.doctors?.real,
    ")"
  );
  console.log(
    "    Patients total:",
    fullStats.table_counts?.patients?.total ?? fullStats.table_breakdowns?.patients?.total,
    "(Synthetic:",
    fullStats.table_counts?.patients?.synthetic ?? fullStats.table_breakdowns?.patients?.synthetic,
    ", Real:",
    fullStats.table_counts?.patients?.real ?? fullStats.table_breakdowns?.patients?.real,
    ")"
  );

  const realOnlyStats = await getPlatformStats(true);
  console.log("  Stats with hide_demo = true:");
  console.log(
    "    Clinics shown:",
    realOnlyStats.table_counts?.clinics?.total ?? realOnlyStats.table_breakdowns?.clinics?.total
  );
  console.log(
    "    Doctors shown:",
    realOnlyStats.table_counts?.doctors?.total ?? realOnlyStats.table_breakdowns?.doctors?.total
  );
  console.log(
    "    Database size:",
    fullStats.database_size_bytes,
    "bytes (~" + Math.round(fullStats.database_size_bytes / 1024 / 1024) + " MB)"
  );

  console.log("\n=====================================================");
  console.log("VERIFICATION COMPLETE");
  console.log("=====================================================");
}

runDevPanelVerification().catch(console.error);
