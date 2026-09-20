/**
 * Runs the daily medication-reminder generator against the database.
 *
 * Usage (DATABASE_URL from .env.local):
 *   npm run reminders
 *
 * Schedule it once a day (e.g. 08:00 IST) with pg_cron on Supabase:
 *   select cron.schedule('medication-reminders', '30 2 * * *',
 *     $$select public.create_medication_reminders();$$);
 * (02:30 UTC = 08:00 IST)
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

async function main() {
  const result = await sql`select public.create_medication_reminders() as created`;
  const created = Number((result[0] as { created: number } | undefined)?.created ?? 0);
  console.log(`Medication reminders created: ${created}`);
  await sql.end({ timeout: 5 });
}

main().catch(async (err: Error) => {
  console.error("Failed:", err.message);
  await sql.end({ timeout: 5 }).catch(() => {});
  process.exit(1);
});
