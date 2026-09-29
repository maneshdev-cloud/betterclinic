async function testRoutes() {
  const routes = [
    '/',
    '/login',
    '/signup',
    '/forgot-password',
    '/setup',
    '/patient',
    '/patient/doctors',
    '/patient/clinics',
    '/patient/appointments',
    '/patient/queue',
    '/patient/prescriptions',
    '/patient/assistant',
    '/patient/settings',
    '/doctor',
    '/doctor/queue',
    '/doctor/consultations',
    '/doctor/patients',
    '/doctor/availability',
    '/doctor/settings',
    '/staff',
    '/staff/queue',
    '/staff/appointments',
    '/staff/settings',
    '/admin',
    '/admin/doctors',
    '/admin/staff',
    '/admin/analytics',
    '/admin/audit',
    '/admin/settings'
  ];

  console.log('Testing production SSR routes on http://localhost:3000:');
  for (const r of routes) {
    try {
      const res = await fetch('http://localhost:3000' + r, { redirect: 'manual' });
      const loc = res.headers.get('location') || '';
      console.log(`  ${r.padEnd(28)} -> Status: ${res.status} ${loc ? `(Redirect to ${loc})` : 'OK'}`);
    } catch (e) {
      console.log(`  ${r.padEnd(28)} -> Error: ${e.message}`);
    }
  }
}
testRoutes();
