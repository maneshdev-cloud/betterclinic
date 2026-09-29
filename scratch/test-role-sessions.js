const { createClient } = require("@supabase/supabase-js");

const SUPABASE_URL = "https://qkbgvbjbuirgxqbluegm.supabase.co";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrYmd2YmpidWlyZ3hxYmx1ZWdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NzQxOTcsImV4cCI6MjEwNTE1MDE5N30.Fs7M-cN9msvbZkx7uAaUsoB7CnVLW5HVgigqMgTlFdU";

const ROLES_TO_TEST = [
  {
    role: "PATIENT",
    email: "demo-patient@betterclinic.app",
    password: "password123",
    routes: [
      "/patient",
      "/patient/doctors",
      "/patient/clinics",
      "/patient/appointments",
      "/patient/queue",
      "/patient/prescriptions",
      "/patient/assistant",
      "/patient/settings",
    ],
  },
  {
    role: "DOCTOR",
    email: "demo-doctor@betterclinic.app",
    password: "password123",
    routes: [
      "/doctor",
      "/doctor/queue",
      "/doctor/consultations",
      "/doctor/patients",
      "/doctor/availability",
      "/doctor/settings",
    ],
  },
  {
    role: "RECEPTIONIST",
    email: "demo-receptionist@betterclinic.app",
    password: "password123",
    routes: [
      "/staff",
      "/staff/queue",
      "/staff/appointments",
      "/staff/settings",
    ],
  },
  {
    role: "CLINIC_ADMIN",
    email: "demo-admin@betterclinic.app",
    password: "password123",
    routes: [
      "/admin",
      "/admin/doctors",
      "/admin/staff",
      "/admin/analytics",
      "/admin/audit",
      "/admin/settings",
    ],
  },
];

async function run() {
  console.log("═══════════════════════════════════════════════════════════════════════");
  console.log("🔐 TESTING AUTHENTICATED SESSIONS ACROSS ALL 4 ROLES ON PRODUCTION BUILD");
  console.log("═══════════════════════════════════════════════════════════════════════\n");

  for (const item of ROLES_TO_TEST) {
    console.log(`▶ Testing Role: ${item.role} (${item.email})`);
    const supabase = createClient(SUPABASE_URL, ANON_KEY, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    const { data: authData, error: authErr } = await supabase.auth.signInWithPassword({
      email: item.email,
      password: item.password,
    });

    if (authErr || !authData.session) {
      console.log(`  ❌ Login failed: ${authErr?.message}`);
      continue;
    }

    console.log(`  ✓ Authenticated with Supabase (Session Token received)`);

    // Format Supabase SSR cookies for localhost:3000
    // Supabase SSR uses sb-<project-ref>-auth-token
    const projectRef = "qkbgvbjbuirgxqbluegm";
    const sessionStr = JSON.stringify(authData.session);
    // In @supabase/ssr, the cookie is base64 encoded or JSON encoded
    const cookieHeader = `sb-${projectRef}-auth-token=${encodeURIComponent(sessionStr)}; sb-${projectRef}-auth-token.0=${encodeURIComponent(sessionStr)}`;

    // Test protected routes
    for (const route of item.routes) {
      try {
        const res = await fetch("http://localhost:3000" + route, {
          headers: {
            Cookie: cookieHeader,
          },
          redirect: "manual",
        });

        const status = res.status;
        const loc = res.headers.get("location") || "";
        const body = await res.text();
        const hasConnectivityBanner = body.includes("offline") && body.includes("banner");
        
        console.log(`    ${route.padEnd(26)} -> Status: ${status} ${loc ? `(Redirect: ${loc})` : "OK"} [HTML Size: ${body.length} bytes]`);
      } catch (e) {
        console.log(`    ${route.padEnd(26)} -> Error: ${e.message}`);
      }
    }
    console.log();
  }
}

run();
