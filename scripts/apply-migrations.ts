/**
 * BETTER CLINIC — migration runner.
 *
 * Applies every file in supabase/migrations (sorted) against the
 * Supabase Postgres database via DATABASE_URL. The SQL is written to
 * be idempotent, so re-running is safe.
 *
 *   npm run db:push        apply all migrations
 *   npm run db:fresh       DROP the public schema and re-apply (dev only)
 *
 * No Supabase CLI or dashboard clicking required.
 */
import fs from "node:fs";
import path from "node:path";
import postgres from "postgres";
import { loadLocalEnv, requireEnv } from "./lib/load-env";
import { splitSqlStatements } from "../lib/sql/splitter";

loadLocalEnv();

const args = process.argv.slice(2);
const FRESH = args.includes("--fresh");

const dbUrl = requireEnv("DATABASE_URL");
const MIGRATIONS_DIR = path.join(process.cwd(), "supabase", "migrations");

const isLocal = /localhost|127\.0\.0\.1/.test(dbUrl);
const sql = postgres(dbUrl, {
  ssl: isLocal ? false : { rejectUnauthorized: false },
  prepare: false, // compatible with Supabase connection poolers
  max: 1,
});

async function main() {
  const files = fs
    .readdirSync(MIGRATIONS_DIR)
    .filter((f) => f.endsWith(".sql"))
    .sort();

  if (files.length === 0) {
    console.error(`No .sql files found in ${MIGRATIONS_DIR}`);
    process.exit(1);
  }

  // Serialize concurrent runs (e.g. two terminals).
  await sql`select pg_advisory_lock(hashtext('better-clinic-migrations'))`;

  try {
    if (FRESH) {
      if (process.env.NEXT_PUBLIC_APP_ENV === "production") {
        console.error(
          "Refusing --fresh: NEXT_PUBLIC_APP_ENV=production. Fresh resets are for development only."
        );
        process.exit(1);
      }
      console.log("⚠ Dropping and recreating the public schema (--fresh)…");
      await sql.unsafe(`
        drop schema if exists public cascade;
        create schema public;
        grant usage on schema public to postgres, anon, authenticated, service_role;
        grant usage on schema public to postgres, anon, authenticated, service_role;
      `);
      console.log("✓ Schema reset");
    }

    for (const file of files) {
      process.stdout.write(`▶ ${file} … `);
      const content = fs.readFileSync(path.join(MIGRATIONS_DIR, file), "utf8");
      const statements = splitSqlStatements(content);
      await sql.begin(async (tx) => {
        for (const statement of statements) {
          try {
            await tx.unsafe(statement);
          } catch (err) {
            const snippet = statement.replace(/\s+/g, " ").slice(0, 160);
            throw new Error(
              `${(err as Error).message}\n  in ${file}, statement:\n    ${snippet}…`
            );
          }
        }
      });
      console.log(`✓ (${statements.length} statements)`);
    }

    console.log("\nAll migrations applied successfully.");
  } finally {
    await sql`select pg_advisory_unlock(hashtext('better-clinic-migrations'))`;
    await sql.end({ timeout: 5 });
  }
}

main().catch((err: Error) => {
  console.error("\nMigration failed:");
  console.error(err.message);
  process.exit(1);
});
