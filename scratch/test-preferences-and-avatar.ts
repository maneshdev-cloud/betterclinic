import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://qkbgvbjbuirgxqbluegm.supabase.co";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrYmd2YmpidWlyZ3hxYmx1ZWdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NzQxOTcsImV4cCI6MjEwNTE1MDE5N30.Fs7M-cN9msvbZkx7uAaUsoB7CnVLW5HVgigqMgTlFdU";

const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function run() {
  console.log("=== Testing Avatar Storage and User Preferences ===");

  const random = Math.floor(Math.random() * 100000);
  const email = `patient_pref_test_${random}@patient.local`;
  const { data: authData, error: authErr } = await supabase.auth.signUp({
    email,
    password: "Password@123!",
    options: {
      data: {
        full_name: "Pref Tester",
        role: "PATIENT",
      }
    }
  });

  if (authErr || !authData.user) {
    console.error("Sign up error:", authErr);
    return;
  }

  const userId = authData.user.id;
  const token = authData.session?.access_token;
  console.log("Signed in test patient:", userId);

  const authClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: token ? { Authorization: `Bearer ${token}` } : {} }
  });

  // 1. Test Avatar Upload
  console.log("\n--- Testing Avatar Upload ---");
  const avatarBytes = Buffer.from("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==");
  const avatarPath = `${userId}/avatar-${Date.now()}.png`;
  const { data: uploadData, error: uploadErr } = await authClient.storage
    .from("avatars")
    .upload(avatarPath, avatarBytes, { contentType: "image/png", upsert: true });

  if (uploadErr) {
    console.error("✗ Avatar upload failed:", uploadErr);
  } else {
    console.log("✓ SUCCESS: Avatar uploaded:", uploadData.path);
    const { data: urlData } = authClient.storage.from("avatars").getPublicUrl(avatarPath);
    console.log("✓ Public avatar URL:", urlData.publicUrl);
  }

  // 2. Test User Preferences Insert & Query
  console.log("\n--- Testing User Preferences ---");
  const { data: prefData, error: prefErr } = await authClient
    .from("user_preferences")
    .upsert({
      user_id: userId,
      theme: "dark",
      sound_enabled: true,
      notify_appointments: false, // Turned off
      notify_queue: true,
      notify_prescriptions: false,
      anonymous_reviews: true,
      public_fee: false,
      show_emergency_contact: false,
      ai_assistant_enabled: false,
      ai_response_length: "detailed",
    })
    .select()
    .single();

  if (prefErr) {
    console.error("✗ User preferences upsert failed:", prefErr);
  } else {
    console.log("✓ SUCCESS: Preferences stored in DB:", prefData);
  }

  // 3. Test Privacy Flags Security Definer RPC
  console.log("\n--- Testing get_user_privacy_flags RPC ---");
  const { data: privacyFlags, error: privacyErr } = await supabase.rpc("get_user_privacy_flags", {
    p_user_ids: [userId],
  });
  if (privacyErr) {
    console.error("✗ get_user_privacy_flags failed:", privacyErr);
  } else {
    console.log("✓ SUCCESS: Privacy flags returned:", privacyFlags);
  }

  // 4. Test create_notification RPC gating
  console.log("\n--- Testing Notification Preference Gating ---");
  // Test 1: Send APPOINTMENT_BOOKED (should be suppressed because notify_appointments is false)
  const { error: notifErr1 } = await supabase.rpc("create_notification", {
    p_user: userId,
    p_type: "APPOINTMENT_BOOKED",
    p_title: "Appointment Booked",
    p_body: "This should be muted by user preferences",
  });
  console.log("RPC call 1 (Appointment Booked - muted) error:", notifErr1);

  // Test 2: Send QUEUE_CALLED (should succeed because notify_queue is true)
  const { error: notifErr2 } = await supabase.rpc("create_notification", {
    p_user: userId,
    p_type: "QUEUE_CALLED",
    p_title: "You are being called!",
    p_body: "Please proceed to consultation room 2",
  });
  console.log("RPC call 2 (Queue Called - allowed) error:", notifErr2);

  // Query notifications for user
  const { data: notifs, error: listNotifErr } = await authClient
    .from("notifications")
    .select("type, title")
    .eq("user_id", userId);

  console.log("Actual notifications stored in DB for user:", notifs);
  const hasAppt = notifs?.some(n => n.type === "APPOINTMENT_BOOKED");
  const hasQueue = notifs?.some(n => n.type === "QUEUE_CALLED");

  if (!hasAppt && hasQueue) {
    console.log("✓ SUCCESS: Muted category (APPOINTMENT_BOOKED) was completely suppressed, and active category (QUEUE_CALLED) was generated!");
  } else {
    console.error("✗ Notification gating check failed: hasAppt=", hasAppt, "hasQueue=", hasQueue);
  }

  console.log("\n=== Preferences and Avatar Tests Complete ===");
}

run().catch(console.error);
