import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";
import type { ClinicSearchInput } from "@/lib/validation/appointments";
import type { Clinic, Doctor } from "@/lib/types/database";
import { pageRange, totalPages } from "@/lib/utils";
import type { SearchResult, DoctorListItem } from "@/services/doctors/service";

export interface ClinicListItem {
  id: string;
  name: string;
  description: string | null;
  city: string;
  area: string;
  address_line: string;
  image_url: string | null;
  facilities: string[];
  avg_rating: number;
  review_count: number;
  doctor_count: number;
}

export const CLINIC_PAGE_SIZE = 9;

/** Clinic discovery search — filters, sorting, pagination against the real database. */
export async function searchClinics(
  client: SupabaseClient,
  filters: ClinicSearchInput
): Promise<SearchResult<ClinicListItem>> {
  // Specialization filter: specialization → doctor ids → clinic ids, then a
  // plain-column `id in (...)` filter. PostgREST cannot filter clinics by a
  // child embed (doctor_clinics), so we resolve ids first.
  let specClinicIds: string[] | null = null;
  if (filters.specialization) {
    const { data, error } = await client
      .from("doctor_specializations")
      .select("doctor_id")
      .eq("specialization_id", filters.specialization)
      .limit(500);
    if (error) throw error;
    const doctorIds = ((data ?? []) as { doctor_id: string }[]).map((row) => row.doctor_id);
    if (doctorIds.length === 0) {
      return { items: [], total: 0, page: filters.page, pageSize: CLINIC_PAGE_SIZE, totalPages: 1 };
    }
    const { data: dcRows, error: dcError } = await client
      .from("doctor_clinics")
      .select("clinic_id")
      .in("doctor_id", doctorIds)
      .limit(500);
    if (dcError) throw dcError;
    specClinicIds = Array.from(
      new Set(((dcRows ?? []) as { clinic_id: string }[]).map((row) => row.clinic_id))
    );
    if (specClinicIds.length === 0) {
      return { items: [], total: 0, page: filters.page, pageSize: CLINIC_PAGE_SIZE, totalPages: 1 };
    }
  }

  let query = client
    .from("clinics")
    .select(
      `id, name, description, city, area, address_line, image_url, facilities,
       avg_rating, review_count, doctor_clinics(doctor_id)`,
      { count: "exact" }
    )
    .eq("is_active", true);

  if (filters.q) {
    query = query.ilike("name", `%${filters.q}%`);
  }
  if (filters.city) {
    query = query.eq("city", filters.city);
  }
  if (filters.area) {
    query = query.eq("area", filters.area);
  }
  if (filters.minRating !== undefined) {
    query = query.gte("avg_rating", filters.minRating);
  }
  if (specClinicIds) {
    query = query.in("id", specClinicIds);
  }

  if (filters.sort === "name") {
    query = query.order("name", { ascending: true });
  } else {
    query = query.order("avg_rating", { ascending: false }).order("review_count", { ascending: false });
  }
  query = query.order("id");

  const { from, to } = pageRange(filters.page, CLINIC_PAGE_SIZE);
  const { data, error, count } = await query.range(from, to);
  if (error) throw error;

  const rows = (data ?? []) as unknown as {
    id: string;
    name: string;
    description: string | null;
    city: string;
    area: string;
    address_line: string;
    image_url: string | null;
    facilities: string[] | null;
    avg_rating: number;
    review_count: number;
    doctor_clinics: { doctor_id: string }[] | null;
  }[];

  const items: ClinicListItem[] = rows.map((row) => ({
    id: row.id,
    name: row.name,
    description: row.description,
    city: row.city,
    area: row.area,
    address_line: row.address_line,
    image_url: row.image_url,
    facilities: row.facilities ?? [],
    avg_rating: Number(row.avg_rating ?? 0),
    review_count: row.review_count ?? 0,
    doctor_count: row.doctor_clinics?.length ?? 0,
  }));

  const total = count ?? items.length;
  return {
    items,
    total,
    page: filters.page,
    pageSize: CLINIC_PAGE_SIZE,
    totalPages: totalPages(total, CLINIC_PAGE_SIZE),
  };
}

export interface ClinicProfile extends ClinicListItem {
  pincode: string | null;
  contact_phone: string | null;
  contact_email: string | null;
  hours: { day_of_week: number; opens_at: string; closes_at: string; is_closed: boolean }[];
  doctors: DoctorListItem[];
}

export async function getClinicProfile(
  client: SupabaseClient,
  clinicId: string
): Promise<ClinicProfile | null> {
  const { data, error } = await client
    .from("clinics")
    .select("*")
    .eq("id", clinicId)
    .eq("is_active", true)
    .maybeSingle();
  if (error) throw error;
  if (!data) return null;
  const clinic = data as unknown as Clinic;

  const [hoursResult, doctorsResult] = await Promise.all([
    client
      .from("clinic_hours")
      .select("day_of_week, opens_at, closes_at, is_closed")
      .eq("clinic_id", clinicId)
      .order("day_of_week"),
    client
      .from("doctors")
      .select(
        `id, qualification, experience_years, consultation_fee, about, languages,
         avg_rating, review_count, is_accepting_patients,
         profile:profiles!doctors_id_fkey(full_name, avatar_url),
         doctor_specializations(specialization:specializations(id, name)),
         doctor_clinics!inner(clinic:clinics(id, name, city, area))`
      )
      .eq("doctor_clinics.clinic_id", clinicId)
      .order("avg_rating", { ascending: false })
      .limit(20),
  ]);
  if (hoursResult.error) throw hoursResult.error;
  if (doctorsResult.error) throw doctorsResult.error;

  const rawDoctors = doctorsResult.data as unknown as Parameters<
    typeof mapDoctorRow
  >[0][];
  return {
    id: clinic.id,
    name: clinic.name,
    description: clinic.description,
    city: clinic.city,
    area: clinic.area,
    address_line: clinic.address_line,
    image_url: clinic.image_url,
    facilities: clinic.facilities ?? [],
    avg_rating: Number(clinic.avg_rating ?? 0),
    review_count: clinic.review_count ?? 0,
    doctor_count: rawDoctors.length,
    pincode: clinic.pincode,
    contact_phone: clinic.contact_phone,
    contact_email: clinic.contact_email,
    hours: (hoursResult.data ?? []) as ClinicProfile["hours"],
    doctors: rawDoctors.map(mapDoctorRow),
  };
}

/* Local mapper mirroring services/doctors (kept private to avoid a circular import). */
interface RawDoctorRow {
  id: string;
  qualification: string;
  experience_years: number;
  consultation_fee: number;
  about: string | null;
  languages: string[] | null;
  avg_rating: number;
  review_count: number;
  is_accepting_patients: boolean;
  profile: { full_name: string; avatar_url: string | null } | null;
  doctor_specializations: { specialization: { id: string; name: string } | null }[] | null;
  doctor_clinics: { clinic: { id: string; name: string; city: string; area: string } | null }[] | null;
}
function mapDoctorRow(row: RawDoctorRow): DoctorListItem {
  return {
    id: row.id,
    qualification: row.qualification,
    experience_years: row.experience_years,
    consultation_fee: row.consultation_fee,
    about: row.about,
    languages: row.languages ?? [],
    avg_rating: Number(row.avg_rating ?? 0),
    review_count: row.review_count ?? 0,
    is_accepting_patients: row.is_accepting_patients,
    profile: row.profile,
    specializations: (row.doctor_specializations ?? [])
      .map((ds) => ds?.specialization)
      .filter((s): s is { id: string; name: string } => !!s),
    clinics: (row.doctor_clinics ?? [])
      .map((dc) => dc?.clinic)
      .filter((c): c is { id: string; name: string; city: string; area: string } => !!c),
  };
}

export interface ClinicReviewItem {
  id: string;
  rating: number;
  title: string | null;
  comment: string | null;
  created_at: string;
  patient_name: string | null;
}

/** Approved reviews left for a clinic (patient name via nested profile embed). */
export async function listClinicReviews(
  client: SupabaseClient,
  clinicId: string,
  limit = 5
): Promise<ClinicReviewItem[]> {
  const { data, error } = await client
    .from("reviews")
    .select(
      `id, rating, title, comment, created_at, patient_id,
       patient:patients!reviews_patient_id_fkey(profile:profiles!patients_id_fkey(full_name))`
    )
    .eq("clinic_id", clinicId)
    .eq("is_approved", true)
    .order("created_at", { ascending: false })
    .limit(limit);
  if (error) throw error;
  const rows = (data ?? []) as unknown as {
    id: string;
    rating: number;
    title: string | null;
    comment: string | null;
    created_at: string;
    patient_id: string | null;
    patient: { profile: { full_name: string } | null } | null;
  }[];

  const patientIds = Array.from(new Set(rows.map((r) => r.patient_id).filter(Boolean))) as string[];
  const anonSet = new Set<string>();
  if (patientIds.length > 0) {
    const { data: privacyFlags } = await client.rpc("get_user_privacy_flags", { p_user_ids: patientIds });
    if (privacyFlags) {
      for (const flag of (privacyFlags as { user_id: string; anonymous_reviews: boolean }[])) {
        if (flag.anonymous_reviews) anonSet.add(flag.user_id);
      }
    }
  }

  return rows.map((row) => ({
    id: row.id,
    rating: row.rating,
    title: row.title,
    comment: row.comment,
    created_at: row.created_at,
    patient_name:
      row.patient_id && anonSet.has(row.patient_id)
        ? "Verified Patient"
        : row.patient?.profile?.full_name ?? null,
  }));
}

/** Distinct cities where active clinics exist (for the filter dropdown). */
export async function listClinicCities(client: SupabaseClient): Promise<string[]> {  const { data, error } = await client
    .from("clinics")
    .select("city")
    .eq("is_active", true)
    .limit(1000);
  if (error) throw error;
  const cities = Array.from(new Set(((data ?? []) as { city: string }[]).map((row) => row.city)));
  return cities.sort();
}

/** Distinct areas within a city (for the dependent filter dropdown). */
export async function listClinicAreas(client: SupabaseClient, city: string): Promise<string[]> {
  const { data, error } = await client
    .from("clinics")
    .select("area")
    .eq("is_active", true)
    .eq("city", city)
    .limit(1000);
  if (error) throw error;
  const areas = Array.from(new Set(((data ?? []) as { area: string }[]).map((row) => row.area)));
  return areas.sort();
}

/** The clinic a staff member (receptionist/admin) belongs to. */
export async function getStaffClinicContext(
  userId: string
): Promise<Pick<Clinic, "id" | "name" | "city"> | null> {
  const { createClient } = await import("@/lib/supabase/server");
  const supabase = await createClient();
  const { data } = await supabase
    .from("clinic_staff")
    .select("clinic:clinics!inner(id, name, city)")
    .eq("user_id", userId)
    .eq("is_active", true)
    .maybeSingle();
  const row = data as unknown as { clinic: Pick<Clinic, "id" | "name" | "city"> } | null;
  return row?.clinic ?? null;
}

export interface ClinicInviteCodes {
  staffCode: string | null;
  doctorCode: string | null;
  adminClaimCode: string | null;
}

/** The admin-visible invite codes for a clinic (staff, doctor & admin onboarding/claim). */
export async function getClinicInviteCodes(clinicId: string): Promise<ClinicInviteCodes> {
  const { createClient } = await import("@/lib/supabase/server");
  const supabase = await createClient();
  const { data } = await supabase
    .from("clinic_invite_codes")
    .select("code, doctor_code, admin_claim_code")
    .eq("clinic_id", clinicId)
    .maybeSingle();
  const row = data as { code?: string; doctor_code?: string; admin_claim_code?: string } | null;
  return {
    staffCode: row?.code ?? null,
    doctorCode: row?.doctor_code ?? null,
    adminClaimCode: row?.admin_claim_code ?? null,
  };
}

/** The admin-visible staff invite code for a clinic (for onboarding receptionists). */
export async function getClinicInviteCode(clinicId: string): Promise<string | null> {
  const codes = await getClinicInviteCodes(clinicId);
  return codes.staffCode;
}

/** The admin-visible doctor invite code for a clinic (for onboarding doctors). */
export async function getClinicDoctorInviteCode(clinicId: string): Promise<string | null> {
  const codes = await getClinicInviteCodes(clinicId);
  return codes.doctorCode;
}

/** The admin-visible claim code for an existing clinic (out-of-band admin verification). */
export async function getClinicAdminClaimCode(clinicId: string): Promise<string | null> {
  const codes = await getClinicInviteCodes(clinicId);
  return codes.adminClaimCode;
}

export type { Doctor };
