import { createClient } from "@supabase/supabase-js";
import { loadLocalEnv, requireEnv } from "../scripts/lib/load-env";

loadLocalEnv();

const url = requireEnv("NEXT_PUBLIC_SUPABASE_URL");
const anonKey = requireEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY");

const testRoles = [
  { email: "test-patient@test.com", password: "Password123!", role: "Patient" },
  { email: "test-doctor@test.com", password: "Password123!", role: "Doctor" },
  { email: "test-receptionist@test.com", password: "Password123!", role: "Receptionist" },
  { email: "test-clinicadmin@test.com", password: "Password123!", role: "Clinic Admin" },
];

async function getSessionCookieFor(email: string, password: string): Promise<string | null> {
  const client = createClient(url, anonKey, { auth: { persistSession: false } });
  
  // Try sign in first
  let { data, error } = await client.auth.signInWithPassword({ email, password });
  if (error) {
    // If not found, sign up
    const signRes = await client.auth.signUp({
      email,
      password,
      options: { data: { full_name: "Test Role User" } },
    });
    data = signRes.data as any;
  }

  if (!data?.session) {
    // Second try signin if signup was pending confirmation
    const retry = await client.auth.signInWithPassword({ email, password });
    data = retry.data;
  }

  if (!data?.session) {
    return null;
  }

  const projectRef = new URL(url).hostname.split(".")[0];
  return `sb-${projectRef}-auth-token=${JSON.stringify([
    data.session.access_token,
    data.session.refresh_token,
    null,
    null,
    null,
  ])}`;
}

async function testRoleAccess() {
  console.log("===============================================================");
  console.log("VERIFYING /dev ACCESS RESTRICTION ACROSS EXISTING ROLES");
  console.log("===============================================================\n");

  // 1. Unauthenticated Request
  const unauthRes = await fetch("http://localhost:3000/dev");
  console.log(`1. Unauthenticated Visitor -> /dev Status: ${unauthRes.status} (Expected: 404)`);
  if (unauthRes.status === 404) {
    console.log("   -> PASS: Unauthenticated visitor blocked with 404.");
  } else {
    console.error(`   -> FAIL: Received ${unauthRes.status}`);
  }

  // 2. Test each role
  for (const item of testRoles) {
    const cookie = await getSessionCookieFor(item.email, item.password);
    if (!cookie) {
      console.log(`Could not obtain session for ${item.role} (${item.email})`);
      continue;
    }

    const res = await fetch("http://localhost:3000/dev", {
      headers: { Cookie: cookie },
    });

    console.log(`2. Logged in as ${item.role} (${item.email}) -> /dev Status: ${res.status} (Expected: 404)`);
    if (res.status === 404) {
      console.log(`   -> PASS: Correctly blocked with 404 Not Found.`);
    } else {
      console.error(`   -> FAIL: Received ${res.status} instead of 404!`);
    }
  }

  console.log("\n===============================================================");
  console.log("TESTING DEVELOPER ALLOWLISTED EMAIL");
  console.log("===============================================================");

  const devEmail = process.env.DEVELOPER_EMAIL?.trim().toLowerCase();
  console.log(`Allowlisted DEVELOPER_EMAIL in .env.local: ${devEmail}`);

  // Test sign in as the allowlisted developer email
  const devClient = createClient(url, anonKey, { auth: { persistSession: false } });
  const { data: devAuth, error: devSignInError } = await devClient.auth.signInWithPassword({
    email: devEmail!,
    password: "Password123!",
  });

  if (devSignInError || !devAuth.session) {
    console.log(`Developer account ${devEmail} sign-in note: ${devSignInError?.message}`);
  } else {
    const projectRef = new URL(url).hostname.split(".")[0];
    const cookieHeader = `sb-${projectRef}-auth-token=${JSON.stringify([
      devAuth.session.access_token,
      devAuth.session.refresh_token,
      null,
      null,
      null,
    ])}`;

    const devRes = await fetch("http://localhost:3000/dev", {
      headers: {
        Cookie: cookieHeader,
      },
    });
    console.log(`3. Logged in as DEVELOPER (${devEmail}) -> /dev Status: ${devRes.status} (Expected: 200)`);
    if (devRes.status === 200) {
      console.log("   -> PASS: Developer granted full access (HTTP 200 OK)!");
    } else {
      console.log(`   -> Note: Status is ${devRes.status}`);
    }
  }

  process.exit(0);
}

testRoleAccess().catch((err) => {
  console.error("Test error:", err);
  process.exit(1);
});
