import { createClient } from "@supabase/supabase-js";
import { loadLocalEnv, requireEnv } from "../scripts/lib/load-env";

loadLocalEnv();
const url = requireEnv("NEXT_PUBLIC_SUPABASE_URL");
const key = requireEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY");

async function main() {
  const client = createClient(url, key, { auth: { persistSession: false } });
  console.log("Signing up fresh user...");
  const signUpRes = await client.auth.signUp({
    email: "test-patient-role@example.com",
    password: "Password123!",
    options: {
      data: {
        full_name: "Test Patient",
        role: "PATIENT",
      },
    },
  });
  console.log("SignUp response:", JSON.stringify(signUpRes, null, 2));

  console.log("Signing in with new user...");
  const res = await client.auth.signInWithPassword({
    email: "test-patient-role@example.com",
    password: "Password123!",
  });
  console.log("SignIn response:", JSON.stringify(res, null, 2));
  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
