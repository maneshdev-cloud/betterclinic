/**
 * Switches the DATABASE to production mode (app_settings.app_env =
 * 'production'). This disables every demo simulation at the database
 * level (e.g. emergency demo progression raises an error).
 *
 * Remember to also set NEXT_PUBLIC_APP_ENV=production in .env.local /
 * your hosting environment, and re-deploy so the client picks it up.
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
  await sql`insert into public.app_settings (key, value) values ('app_env', 'production')
            on conflict (key) do update set value = 'production', updated_at = now()`;
  const [{ env }] = await sql`select value as env from public.app_settings where key = 'app_env'`;
  console.log(`✓ Database app_env = ${env}`);
  console.log("Next: set NEXT_PUBLIC_APP_ENV=production in your environment and re-deploy.");
  await sql.end({ timeout: 5 });
}

main().catch((err: Error) => {
  console.error("Failed:", err.message);
  process.exit(1);
});
