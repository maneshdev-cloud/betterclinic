import type { SupabaseClient } from "@supabase/supabase-js";
import type { DoctorSearchInput } from "@/lib/validation/appointments";
import { todayClinicDate, dayOfWeek, pageRange, totalPages } from "@/lib/utils";

export interface DoctorListItem {
  id: string;
  qualification: string;
  experience_years: number;
  consultation_fee: number;
  about: string | null;
  languages: string[];
  avg_rating: number;
  review_count: number;
  is_accepting_patients: boolean;
  is_fee_public?: boolean;
  profile: { full_name: string; avatar_url: string | null } | null;
  specializations: { id: string; name: string }[];
  clinics: { id: string; name: string; city: string; area: string }[];
}

export interface DoctorProfile extends DoctorListItem {
  registration_number: string;
  is_fee_public: boolean;
}

export interface ReviewItem {
  id: string;
  rating: number;
  title: string | null;
  comment: string | null;
  created_at: string;
  patient_name: string | null;
}

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

function mapDoctor(row: RawDoctorRow): DoctorListItem {
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

/** Embeds kept in every doctor select so list cards need no extra queries. */
const DOCTOR_SELECT = `
  id, qualification, experience_years, consultation_fee, about, languages,
  avg_rating, review_count, is_accepting_patients,
  profile:profiles!doctors_id_fkey(full_name, avatar_url),
  doctor_specializations(specialization:specializations(id, name)),
  doctor_clinics(clinic:clinics(id, name, city, area))
`;

export const DOCTOR_PAGE_SIZE = 9;
export const REVIEW_PAGE_SIZE = 5;

export interface SearchResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

function emptyResult<T>(page: number, pageSize: number): SearchResult<T> {
  return { items: [], total: 0, page, pageSize, totalPages: 1 };
}

/**
 * Doctor discovery search — real database query with filters, sorting and
 * pagination.
 *
 * Filters that span one-to-many relations (specialization, city, available
 * today) are resolved with cheap id-list queries first, because PostgREST
 * cannot filter a parent table by a child embed's columns. Every filter
 * applied to the main query is a plain column comparison.
 */
export async function searchDoctors(
  client: SupabaseClient,
  filters: DoctorSearchInput
): Promise<SearchResult<DoctorListItem>> {
  // 1. Resolve id-lists for relation filters.
  const idLists: string[][] = [];

  if (filters.specialization) {
    const { data, error } = await client
      .from("doctor_specializations")
      .select("doctor_id")
      .eq("specialization_id", filters.specialization)
      .limit(500);
    if (error) throw error;
    idLists.push(((data ?? []) as { doctor_id: string }[]).map((r) => r.doctor_id));
  }

  if (filters.city) {
    // clinics in the city → doctor_clinics rows → doctor ids (all plain-column filters).
    const { data: clinicRows, error: clinicError } = await client
      .from("clinics")
      .select("id")
      .eq("city", filters.city)
      .limit(500);
    if (clinicError) throw clinicError;
    const clinicIds = ((clinicRows ?? []) as { id: string }[]).map((r) => r.id);
    if (clinicIds.length === 0) {
      idLists.push([]);
    } else {
      const { data: dcRows, error: dcError } = await client
        .from("doctor_clinics")
        .select("doctor_id")
        .in("clinic_id", clinicIds)
        .limit(500);
      if (dcError) throw dcError;
      idLists.push(((dcRows ?? []) as { doctor_id: string }[]).map((r) => r.doctor_id));
    }
  }

  if (filters.availableToday) {
    const { data, error } = await client
      .from("doctor_availability")
      .select("doctor_id")
      .eq("day_of_week", dayOfWeek(todayClinicDate()))
      .eq("is_active", true)
      .limit(500);
    if (error) throw error;
    idLists.push(((data ?? []) as { doctor_id: string }[]).map((r) => r.doctor_id));
  }

  // Intersect the lists (doctor must satisfy every relation filter).
  let doctorIds: string[] | null = null;
  for (const list of idLists) {
    if (doctorIds === null) {
      doctorIds = list;
    } else {
      const keep = new Set(list);
      doctorIds = doctorIds.filter((id) => keep.has(id));
    }
    if (doctorIds.length === 0) return emptyResult(filters.page, DOCTOR_PAGE_SIZE);
  }
  if (doctorIds !== null && doctorIds.length === 0) {
    return emptyResult(filters.page, DOCTOR_PAGE_SIZE);
  }

  // 2. Main query — only plain-column and many-to-one embed filters.
  let query = client
    .from("doctors")
    .select(DOCTOR_SELECT, { count: "exact" });

  if (doctorIds !== null) {
    query = query.in("id", doctorIds);
  }
  if (filters.q) {
    // doctors.id → profiles.id makes this a many-to-one embed filter (supported).
    query = query.ilike("profile.full_name", `%${filters.q}%`);
  }
  if (filters.maxFee !== undefined) {
    query = query.lte("consultation_fee", filters.maxFee);
  }
  if (filters.minRating !== undefined) {
    query = query.gte("avg_rating", filters.minRating);
  }
  if (filters.acceptingPatients) {
    query = query.eq("is_accepting_patients", true);
  }

  switch (filters.sort) {
    case "experience":
      query = query.order("experience_years", { ascending: false });
      break;
    case "fee_asc":
      query = query.order("consultation_fee", { ascending: true });
      break;
    case "fee_desc":
      query = query.order("consultation_fee", { ascending: false });
      break;
    case "rating":
    default:
      query = query
        .order("avg_rating", { ascending: false })
        .order("review_count", { ascending: false });
      break;
  }
  query = query.order("id"); // stable pagination tiebreaker

  const { from, to } = pageRange(filters.page, DOCTOR_PAGE_SIZE);
  const { data, error, count } = await query.range(from, to);
  if (error) throw error;

  const items = ((data ?? []) as unknown as RawDoctorRow[]).map(mapDoctor);
  const total = count ?? items.length;
  return {
    items,
    total,
    page: filters.page,
    pageSize: DOCTOR_PAGE_SIZE,
    totalPages: totalPages(total, DOCTOR_PAGE_SIZE),
  };
}

export async function getDoctorProfile(
  client: SupabaseClient,
  doctorId: string
): Promise<DoctorProfile | null> {
  const [docRes, privacyRes] = await Promise.all([
    client
      .from("doctors")
      .select(`${DOCTOR_SELECT}, registration_number`)
      .eq("id", doctorId)
      .maybeSingle(),
    client.rpc("get_user_privacy_flags", { p_user_ids: [doctorId] }),
  ]);
  if (docRes.error) throw docRes.error;
  if (!docRes.data) return null;
  const row = docRes.data as unknown as RawDoctorRow & { registration_number: string };
  const privacy = (privacyRes.data ?? []) as { public_fee?: boolean }[];
  const isFeePublic = privacy[0]?.public_fee ?? true;

  return {
    ...mapDoctor(row),
    registration_number: row.registration_number,
    is_fee_public: isFeePublic,
  };
}

let cachedSpecializations: { timestamp: number; data: { id: string; name: string }[] } | null = null;
const SPEC_CACHE_TTL_MS = 5 * 60 * 1000;

export async function listSpecializations(
  client: SupabaseClient
): Promise<{ id: string; name: string }[]> {
  if (cachedSpecializations && Date.now() - cachedSpecializations.timestamp < SPEC_CACHE_TTL_MS) {
    return cachedSpecializations.data;
  }
  const { data, error } = await client
    .from("specializations")
    .select("id, name")
    .order("name")
    .limit(100);
  if (error) throw error;
  const result = (data ?? []) as { id: string; name: string }[];
  cachedSpecializations = { timestamp: Date.now(), data: result };
  return result;
}

export async function listDoctorReviews(
  client: SupabaseClient,
  doctorId: string,
  page = 1
): Promise<SearchResult<ReviewItem>> {
  const { from, to } = pageRange(page, REVIEW_PAGE_SIZE);
  const { data, error, count } = await client
    .from("reviews")
    .select(
      `id, rating, title, comment, created_at, patient_id,
       patient:patients!reviews_patient_id_fkey(profile:profiles!patients_id_fkey(full_name))`,
      { count: "exact" }
    )
    .eq("doctor_id", doctorId)
    .eq("is_approved", true)
    .order("created_at", { ascending: false })
    .range(from, to);
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

  return {
    items: rows.map((row) => ({
      id: row.id,
      rating: row.rating,
      title: row.title,
      comment: row.comment,
      created_at: row.created_at,
      patient_name:
        row.patient_id && anonSet.has(row.patient_id)
          ? "Verified Patient"
          : row.patient?.profile?.full_name ?? null,
    })),
    total: count ?? 0,
    page,
    pageSize: REVIEW_PAGE_SIZE,
    totalPages: totalPages(count ?? 0, REVIEW_PAGE_SIZE),
  };
}

/** Active weekly availability of a doctor (all clinics), ordered by day then time. */
export interface AvailabilitySlotWindow {
  clinic_id: string;
  day_of_week: number;
  start_time: string;
  end_time: string;
  break_start: string | null;
  break_end: string | null;
  slot_duration_minutes: number;
}

export async function getDoctorAvailability(
  client: SupabaseClient,
  doctorId: string
): Promise<AvailabilitySlotWindow[]> {
  const { data, error } = await client
    .from("doctor_availability")
    .select(
      "clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes"
    )
    .eq("doctor_id", doctorId)
    .eq("is_active", true)
    .order("day_of_week")
    .order("start_time");
  if (error) throw error;
  return (data ?? []) as AvailabilitySlotWindow[];
}
