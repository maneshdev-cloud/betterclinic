/**
 * BETTER CLINIC — Calibrated Realistic Synthetic Seed System.
 *
 * Seeds a calibrated dataset at the targeted scale:
 *   - 18 clinics across Maharashtra
 *   - 20 doctors + 8 staff (receptionists & clinic admins)
 *   - 60 patients with complete demographics and medical histories
 *   - 30 appointments (past completed, today active queue, cancelled, no-show, upcoming)
 *   - All derived relational records (consultations, diagnoses, treatment plans, prescriptions,
 *     medication schedules, follow-ups, reviews, notifications, AI messages, emergency demo)
 *   - All tagged with is_synthetic = true
 *
 * Usage:
 *   npm run seed          # Insert calibrated seed dataset
 *   npm run seed:reset    # Scoped delete of synthetic data via purge_synthetic_data() and re-seed
 */

import fs from "fs";
import path from "path";
import postgres from "postgres";
import { loadLocalEnv, requireEnv } from "./lib/load-env";

loadLocalEnv();

// Production guard
if (process.env.NEXT_PUBLIC_APP_ENV === "production") {
  console.error("⛔ Refusing to seed: NEXT_PUBLIC_APP_ENV=production. Seeding is disabled in production.");
  process.exit(1);
}

const dbUrl = requireEnv("DATABASE_URL");
const isLocal = /localhost|127\.0\.0\.1/.test(dbUrl);
const sql = postgres(dbUrl, {
  ssl: isLocal ? false : { rejectUnauthorized: false },
  prepare: false,
  max: 1,
});

const args = process.argv.slice(2);
const RESET = args.includes("--reset") || args.includes("-r");

async function wipeData() {
  console.log("🧹 Resetting synthetic data via public.purge_synthetic_data()...");
  await sql.unsafe(`select public.purge_synthetic_data();`);
  console.log("✓ Scoped synthetic data wipe complete (real users and real data preserved).\n");
}

async function main() {
  console.log("═══════════════════════════════════════════════════════════════");
  console.log("🏥 BETTER CLINIC — Calibrated Synthetic Seed System");
  console.log("   Target: 18 Clinics | 20 Doctors | 60 Patients | 30 Appointments");
  console.log("═══════════════════════════════════════════════════════════════\n");

  if (RESET) {
    await wipeData();
  }

  const chunksDir = path.join(__dirname, "seed_chunks");
  const chunkFiles = [
    "chunk_1_clinics.sql",
    "chunk_2_doctors_staff.sql",
    "chunk_3_patients.sql",
    "chunk_4_appointments.sql",
    "chunk_5_clinical.sql",
  ];

  for (let i = 0; i < chunkFiles.length; i++) {
    const file = chunkFiles[i];
    const filePath = path.join(chunksDir, file);
    if (!fs.existsSync(filePath)) {
      console.error(`❌ Missing seed chunk file: ${filePath}`);
      process.exit(1);
    }
    console.log(`📦 Executing [${i + 1}/${chunkFiles.length}] ${file}...`);
    const content = fs.readFileSync(filePath, "utf-8");
    await sql.unsafe(content);
    console.log(`   ✓ Completed ${file}`);
  }

  console.log("\n📊 Fetching updated platform statistics...");
  const statsRes = await sql.unsafe<{ get_platform_stats: any }[]>(`select public.get_platform_stats(false);`);
  const stats = statsRes[0]?.get_platform_stats;

  if (stats) {
    console.log("\n──────────────── Platform Summary ────────────────");
    console.log(`Database Size: ${stats.database_size_pretty}`);
    console.log(`Signups Total: ${stats.signups_by_role?.total} (Patients: ${stats.signups_by_role?.patient}, Doctors: ${stats.signups_by_role?.doctor}, Admins: ${stats.signups_by_role?.clinic_admin}, Receptionists: ${stats.signups_by_role?.receptionist})`);
    console.log(`Appointments:  ${stats.appointments_summary?.total} (Completed: ${stats.appointments_summary?.completed}, Active: ${stats.appointments_summary?.active}, Cancelled: ${stats.appointments_summary?.cancelled}, No-Show: ${stats.appointments_summary?.no_show})`);
    console.log("──────────────────────────────────────────────────\n");
  }

  console.log("✅ Seeding completed successfully!");
  await sql.end();
}

main().catch(async (err) => {
  console.error("❌ Seeding failed:", err);
  await sql.end();
  process.exit(1);
});
