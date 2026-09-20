import type { SupabaseClient } from "@supabase/supabase-js";

/**
 * Read-only clinic administration queries: the doctors practising at
 * the admin's clinic (with real 30-day activity stats) and the staff
 * accounts linked to it. Account creation stays with signup +
 * invite code — admins never create credentials here.
 */

export interface ClinicDoctorItem {
  doctorId: string;
  name: string;
  qualification: string;
  registrationNumber: string;
  experienceYears: number;
  fee: number;
  avgRating: number;
  specializations: string[];
  /** Real activity in the last 30 days (clinic appointments + queue). */
  appointments30d: number;
  completed30d: number;
  noShow30d: number;
  walkIns30d: number;
  uniquePatients30d: number;
  medianWaitMinutes: number | null;
}

export interface ClinicStaffItem {
  userId: string;
  name: string;
  email: string;
  phone: string | null;
  role: "RECEPTIONIST" | "CLINIC_ADMIN";
  active: boolean;
  memberSince: string;
  auditEvents: number;
}

function rangeStartIso(days: number): string {
  const base = new Date();
  base.setUTCDate(base.getUTCDate() - (days - 1));
  return base.toISOString().slice(0, 10);
}

export async function listClinicDoctorsWithStats(
  client: SupabaseClient,
  clinicId: string
): Promise<ClinicDoctorItem[]> {
  const since = rangeStartIso(30);

  const [doctorsRes, apptsRes, queueRes] = await Promise.all([
    client
      .from("doctor_clinics")
      .select(
        `doctor:doctors!doctor_clinics_doctor_id_fkey(
          id, qualification, registration_number, experience_years, consultation_fee, avg_rating,
          profile:profiles!doctors_id_fkey(full_name),
          doctor_specializations(specialization:specializations(name))
        )`
      )
      .eq("clinic_id", clinicId),
    client
      .from("appointments")
      .select("doctor_id, patient_id, status, appointment_type")
      .eq("clinic_id", clinicId)
      .gte("appointment_date", since),
    client
      .from("queue_entries")
      .select("doctor_id, created_at, called_at")
      .eq("clinic_id", clinicId)
      .gte("created_at", `${since}T00:00:00+05:30`),
  ]);
  if (doctorsRes.error) throw doctorsRes.error;
  if (apptsRes.error) throw apptsRes.error;
  if (queueRes.error) throw queueRes.error;

  const doctorRows = (doctorsRes.data ?? []) as unknown as {
    doctor: {
      id: string;
      qualification: string;
      registration_number: string;
      experience_years: number;
      consultation_fee: number;
      avg_rating: string | number;
      profile: { full_name: string } | null;
      doctor_specializations: { specialization: { name: string } }[];
    };
  }[];
  const appts = (apptsRes.data ?? []) as unknown as {
    doctor_id: string;
    patient_id: string;
    status: string;
    appointment_type: string;
  }[];
  const queue = (queueRes.data ?? []) as unknown as {
    doctor_id: string;
    created_at: string;
    called_at: string | null;
  }[];

  return doctorRows
    .map((row) => row.doctor)
    .filter((doctor): doctor is NonNullable<typeof doctor> => Boolean(doctor))
    .map((doctor) => {
      const mine = appts.filter((a) => a.doctor_id === doctor.id);
      const myQueue = queue.filter((q) => q.doctor_id === doctor.id);
      const waits = myQueue
        .filter((q) => q.called_at && new Date(q.called_at) > new Date(q.created_at))
        .map((q) => (new Date(q.called_at as string).getTime() - new Date(q.created_at).getTime()) / 60000)
        .sort((a, b) => a - b);
      const mid = Math.floor(waits.length / 2);
      const medianWait =
        waits.length === 0
          ? null
          : waits.length % 2 === 1
            ? Math.max(1, Math.round(waits[mid]))
            : Math.max(1, Math.round((waits[mid - 1] + waits[mid]) / 2));

      return {
        doctorId: doctor.id,
        name: doctor.profile?.full_name ?? "Unknown doctor",
        qualification: doctor.qualification,
        registrationNumber: doctor.registration_number,
        experienceYears: doctor.experience_years,
        fee: doctor.consultation_fee,
        avgRating: Number(doctor.avg_rating) || 0,
        specializations: doctor.doctor_specializations.map((ds) => ds.specialization.name),
        appointments30d: mine.length,
        completed30d: mine.filter((a) => a.status === "COMPLETED").length,
        noShow30d: mine.filter((a) => a.status === "NO_SHOW").length,
        walkIns30d: mine.filter((a) => a.appointment_type === "WALK_IN").length,
        uniquePatients30d: new Set(mine.map((a) => a.patient_id)).size,
        medianWaitMinutes: medianWait,
      };
    })
    .sort((a, b) => b.appointments30d - a.appointments30d || a.name.localeCompare(b.name));
}

export async function listClinicStaff(
  client: SupabaseClient,
  clinicId: string
): Promise<ClinicStaffItem[]> {
  const [staffRes, auditRes] = await Promise.all([
    client
      .from("clinic_staff")
      .select(
        `user_id, role, is_active, created_at,
         profile:profiles!clinic_staff_user_id_fkey(full_name, email, phone)`
      )
      .eq("clinic_id", clinicId)
      .order("created_at", { ascending: true }),
    client.from("audit_logs").select("actor_id").eq("clinic_id", clinicId).limit(2000),
  ]);
  if (staffRes.error) throw staffRes.error;
  // Audit read may fail only if RLS changes; stats are best-effort.
  const auditRows =
    auditRes.error ? [] : ((auditRes.data ?? []) as unknown as { actor_id: string | null }[]);

  const rows = (staffRes.data ?? []) as unknown as {
    user_id: string;
    role: "RECEPTIONIST" | "CLINIC_ADMIN";
    is_active: boolean;
    created_at: string;
    profile: { full_name: string; email: string; phone: string | null } | null;
  }[];

  return rows.map((row) => ({
    userId: row.user_id,
    name: row.profile?.full_name ?? "Unknown",
    email: row.profile?.email ?? "",
    phone: row.profile?.phone ?? null,
    role: row.role,
    active: row.is_active,
    memberSince: row.created_at,
    auditEvents: auditRows.filter((a) => a.actor_id === row.user_id).length,
  }));
}
