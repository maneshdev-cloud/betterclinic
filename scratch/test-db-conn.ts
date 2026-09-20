import postgres from "postgres";

const connStr = "postgresql://postgres.qkbgvbjbuirgxqbluegm:BetterClinic2026!@aws-0-ap-south-1.pooler.supabase.com:6543/postgres";

async function main() {
  const sql = postgres(connStr, {
    ssl: { rejectUnauthorized: false },
    prepare: false,
  });

  const res = await sql`select 1 as test, current_database() as db`;
  console.log("Success:", res);
  await sql.end();
}

main().catch(err => {
  console.error("Connection failed:", err.message);
});
