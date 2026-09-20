import { createClient } from "@supabase/supabase-js";
import { loadLocalEnv, requireEnv } from "../scripts/lib/load-env";

loadLocalEnv();
const url = requireEnv("NEXT_PUBLIC_SUPABASE_URL");
const anonKey = requireEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY");

async function main() {
  const client = createClient(url, anonKey, { auth: { persistSession: false } });
  const devTestEmail = "test-verified-dev@betterclinic.app";
  const devPassword = "DevTestPassword123!";

  // 1. Sign up / sign in test developer account
  let { data, error } = await client.auth.signInWithPassword({
    email: devTestEmail,
    password: devPassword,
  });

  if (error) {
    const signupRes = await client.auth.signUp({
      email: devTestEmail,
      password: devPassword,
      options: { data: { full_name: "Verified Developer" } },
    });
    data = signupRes.data as any;
  }

  if (!data?.session) {
    const retry = await client.auth.signInWithPassword({
      email: devTestEmail,
      password: devPassword,
    });
    data = retry.data;
  }

  if (!data?.session) {
    console.error("Failed to obtain developer session");
    process.exit(1);
  }

  const projectRef = new URL(url).hostname.split(".")[0];
  const cookieHeader = `sb-${projectRef}-auth-token=${JSON.stringify([
    data.session.access_token,
    data.session.refresh_token,
    null,
    null,
    null,
  ])}`;

  console.log("Logged in with session for:", devTestEmail);

  // Test against DEVELOPER_EMAIL (should be 200 because DEVELOPER_EMAIL is test-verified-dev@betterclinic.app)
  const resAllowlisted = await fetch("http://localhost:3000/dev", {
    headers: { Cookie: cookieHeader },
  });
  console.log(`When ON allowlist -> /dev Status: ${resAllowlisted.status} (Expected: 200)`);
  if (resAllowlisted.status === 200) {
    console.log("   -> PASS: Allowlisted developer is granted access with HTTP 200 OK!");
  } else {
    console.error(`   -> FAIL: Expected 200, got ${resAllowlisted.status}`);
  }

  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
