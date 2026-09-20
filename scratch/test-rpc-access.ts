import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://qkbgvbjbuirgxqbluegm.supabase.co";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrYmd2YmpidWlyZ3hxYmx1ZWdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NzQxOTcsImV4cCI6MjEwNTE1MDE5N30.Fs7M-cN9msvbZkx7uAaUsoB7CnVLW5HVgigqMgTlFdU";

async function main() {
  console.log("=== Testing Direct RPC Access (Before Migration 00026) ===");
  
  // 1. Sign in as Patient
  const client = createClient(SUPABASE_URL, ANON_KEY);
  const { data: authData, error: authError } = await client.auth.signInWithPassword({
    email: "test-patient@test.com",
    password: "Password123!",
  });

  if (authError || !authData.session) {
    console.error("Failed to sign in as test-patient:", authError?.message);
    return;
  }

  console.log("Successfully signed in as Patient:", authData.user.email);
  const patientClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: {
      headers: {
        Authorization: `Bearer ${authData.session.access_token}`,
      },
    },
  });

  console.log("\n1. Patient calling get_platform_stats(p_hide_demo: false):");
  const statsRes = await patientClient.rpc("get_platform_stats", { p_hide_demo: false });
  if (statsRes.error) {
    console.log("-> Rejected with error:", statsRes.error);
  } else {
    console.log("-> VULNERABILITY CONFIRMED: Succeeded! Total database size:", statsRes.data?.database_size_pretty);
  }

  console.log("\n2. Patient calling purge_synthetic_data():");
  // Let's check permissions or test with direct fetch
  const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/purge_synthetic_data`, {
    method: "POST",
    headers: {
      "apikey": ANON_KEY,
      "Authorization": `Bearer ${authData.session.access_token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({}),
  });
  console.log("-> Status code:", res.status, res.statusText);
  const body = await res.text();
  console.log("-> Response body:", body.slice(0, 300));
}

main().catch(console.error);
