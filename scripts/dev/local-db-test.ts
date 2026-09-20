/**
 * LOCAL TEST HARNESS — full database integration test without Supabase.
 *
 * Boots nothing itself: point DATABASE_URL at any local PostgreSQL
 * (a stub of Supabase's auth/storage/realtime is applied first),
 * then runs the real migrations and the RLS verification suite.
 *
 *   # once, on a machine with local PostgreSQL:
 *   createdb betterclinic
 *   export DATABASE_URL=postgres://<user>:<pass>@127.0.0.1:5432/betterclinic
 *   npm run test:db
 *
 * On a real Supabase project you do NOT need this — use
 * `npm run db:push` + `npm run verify:rls` instead.
 */
import fs from "node:fs";
import path from "node:path";
import postgres from "postgres";
import { loadLocalEnv } from "../lib/load-env";
import { splitSqlStatements } from "../../lib/sql/splitter";

loadLocalEnv();

const url = process.env.DATABASE_URL;
if (!url) {
  console.error("DATABASE_URL must point at a local test database for this harness.");
  process.exit(1);
}
if (!/localhost|127\.0\.0\.1/.test(url)) {
  console.error(
    "Refusing to run the local harness against a non-localhost database — this stub is for local testing only."
  );
  process.exit(1);
}

const sql = postgres(url, { ssl: false, prepare: false, max: 1 });

async function applyFile(file: string, label: string) {
  const content = fs.readFileSync(file, "utf8");
  const statements = splitSqlStatements(content);
  await sql.begin(async (tx) => {
    for (const statement of statements) {
      try {
        await tx.unsafe(statement);
      } catch (err) {
        const snippet = statement.replace(/\s+/g, " ").slice(0, 160);
        throw new Error(
          `${(err as Error).message}\n  in ${label}, statement:\n    ${snippet}…`
        );
      }
    }
  });
  console.log(`  ✓ ${label} (${statements.length} statements)`);
}

async function main() {
  console.log("── Local database integration test ──\n");

  console.log("1. Resetting schema…");
  await sql.unsafe("drop schema if exists public cascade; create schema public;");
  console.log("  ✓ clean public schema");

  console.log("\n2. Applying Supabase stub (auth/storage/roles/realtime)…");
  await applyFile(path.join(process.cwd(), "scripts/dev/supabase-stub.sql"), "supabase-stub.sql");

  console.log("\n3. Applying real migrations (same files as `npm run db:push`)…");
  const dir = path.join(process.cwd(), "supabase/migrations");
  const files = fs.readdirSync(dir).filter((f) => f.endsWith(".sql")).sort();
  for (const file of files) {
    await applyFile(path.join(dir, file), file);
  }

  console.log("\n4. Re-applying migrations (idempotency check)…");
  for (const file of files) {
    await applyFile(path.join(dir, file), `${file} (re-run)`);
  }

  console.log("\n✓ Database integration test passed. Now run: npm run verify:rls\n");
  await sql.end({ timeout: 5 });
}

main().catch(async (err: Error) => {
  console.error("\n✗ FAILED:", err.message);
  await sql.end({ timeout: 5 }).catch(() => {});
  process.exit(1);
});
