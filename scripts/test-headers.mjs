const routes = [
  "/",
  "/login",
  "/signup",
  "/choose-role",
  "/patient",
  "/patient/records",
  "/patient/follow-ups",
  "/doctor",
  "/doctor/queue",
  "/staff",
  "/admin",
  "/admin/doctors"
];

async function check() {
  for (const r of routes) {
    try {
      const res = await fetch("http://localhost:3000" + r, { redirect: "manual" });
      console.log(`${r.padEnd(25)} Status: ${res.status} | Cache-Control: ${res.headers.get("cache-control")} | Location: ${res.headers.get("location") || "none"}`);
    } catch (e) {
      console.error(`${r.padEnd(25)} Error:`, e.message);
    }
  }
}

check();
