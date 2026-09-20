import fs from "fs";
import path from "path";
import postgres from "postgres";
import { loadLocalEnv, requireEnv } from "../scripts/lib/load-env";

loadLocalEnv();
const dbUrl = requireEnv("DATABASE_URL");
const isLocal = /localhost|127\.0\.0\.1/.test(dbUrl);
const sql = postgres(dbUrl, {
  ssl: isLocal ? false : { rejectUnauthorized: false },
  prepare: false,
  max: 1,
});

async function main() {
  const chunks = [
    "chunk_1_clinics.sql",
    "chunk_2_doctors_staff.sql",
    "chunk_3_patients.sql",
    "chunk_4_appointments.sql",
    "chunk_5_clinical.sql"
  ];

  for (const chunkFile of chunks) {
    const fullPath = path.join(process.cwd(), "scratch", "compact_chunks", chunkFile);
    console.log(`Executing ${chunkFile}...`);
    const content = fs.readFileSync(fullPath, "utf-8");
    await sql.unsafe(content);
    console.log(`✓ ${chunkFile} executed successfully`);
  }

  await sql.end();
  console.log("All chunks applied successfully!");
}

main().catch(err => {
  console.error("Error executing chunks:", err);
  process.exit(1);
});
