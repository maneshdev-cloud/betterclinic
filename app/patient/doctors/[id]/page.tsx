import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import {
  Award,
  Building2,
  CalendarDays,
  GraduationCap,
  IndianRupee,
  Languages,
  MapPin,
  SearchX,
  UserRound,
} from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Rating } from "@/components/shared/rating";
import { UserAvatar } from "@/components/shared/user-avatar";
import { EmptyState } from "@/components/shared/empty-state";
import { Pagination } from "@/components/shared/pagination";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { BookingSection, type BookingClinic } from "@/components/appointments/booking-section";
import { DoctorIdBadgeModal } from "@/components/doctors/doctor-id-badge-modal";
import { createClient } from "@/lib/supabase/server";
import {
  getDoctorProfile,
  listDoctorReviews,
  getDoctorAvailability,
} from "@/services/doctors/service";
import { buildQueryString } from "@/lib/search-params";
import { formatDate, formatINR, pluralize } from "@/lib/utils";
import { DAYS_OF_WEEK } from "@/lib/constants";

interface PageProps {
  params: { id: string };
  searchParams: Record<string, string | string[] | undefined>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const supabase = await createClient();
  const doctor = await getDoctorProfile(supabase, params.id);
  return { title: doctor ? `${doctor.profile?.full_name} — doctor profile` : "Doctor profile" };
}

export default async function DoctorProfilePage({ params, searchParams }: PageProps) {
  const supabase = await createClient();
  const doctor = await getDoctorProfile(supabase, params.id);
  if (!doctor) notFound();

  const pageParam = Number(
    (Array.isArray(searchParams.page) ? searchParams.page[0] : searchParams.page) ?? "1"
  );
  const reviewPage = Number.isFinite(pageParam) && pageParam >= 1 ? Math.floor(pageParam) : 1;

  const [reviews, availability] = await Promise.all([
    listDoctorReviews(supabase, doctor.id, reviewPage),
    getDoctorAvailability(supabase, doctor.id),
  ]);

  const name = doctor.profile?.full_name ?? "Doctor";

  // Group availability per clinic for the booking section.
  const availabilityByClinic = new Map<string, number[]>();
  for (const window of availability) {
    const list = availabilityByClinic.get(window.clinic_id) ?? [];
    if (!list.includes(window.day_of_week)) list.push(window.day_of_week);
    availabilityByClinic.set(window.clinic_id, list);
  }
  const bookingClinics: BookingClinic[] = doctor.clinics.map((clinic) => ({
    id: clinic.id,
    name: clinic.name,
    city: clinic.city,
    area: clinic.area,
    availableDows: availabilityByClinic.get(clinic.id) ?? [],
  }));

  // Short day labels per clinic for the "Practises at" list.
  const dayShortLabels = new Map<number, string>(
    DAYS_OF_WEEK.map((meta) => [meta.value, meta.label.slice(0, 3)])
  );

  return (
    <div className="page-container space-y-6 py-8">
      <nav aria-label="Breadcrumb" className="text-sm text-muted-foreground">
        <Link href="/patient/doctors" className="hover:underline">
          ← Back to doctors
        </Link>
      </nav>

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <PageHeader title={name} description={doctor.qualification} />
        <div className="shrink-0">
          <DoctorIdBadgeModal
            name={name}
            role={`${doctor.qualification} · ${doctor.specializations[0]?.name ?? "Specialist"}`}
            brand={doctor.clinics[0]?.name ?? "BETTER CLINIC"}
            brandTagline={doctor.clinics[0]?.city ? `${doctor.clinics[0].city} Medical Campus` : "Verified Healthcare"}
            idNumber={`DOC-${doctor.registration_number}`}
            location={doctor.clinics[0]?.area ?? "Clinical Wing"}
            validThru="12/2028"
            pillars={[
              doctor.specializations[0]?.name?.slice(0, 10) ?? "Clinical",
              `${doctor.experience_years}y Exp`,
              "Verified",
            ]}
            avatarUrl={doctor.profile?.avatar_url}
            site="betterclinic.health/verify"
          />
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-[1fr_400px]">
        {/* Left column: profile details */}
        <div className="space-y-6">
          <Card>
            <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-start">
              <UserAvatar name={name} src={doctor.profile?.avatar_url} size="lg" />
              <div className="grid flex-1 gap-2 text-sm text-muted-foreground sm:grid-cols-2">
                <span className="inline-flex items-center gap-2">
                  <Rating value={doctor.avg_rating} count={doctor.review_count} size="md" />
                </span>
                <span className="inline-flex items-center gap-2">
                  <GraduationCap className="h-4 w-4 shrink-0" aria-hidden />
                  {pluralize(doctor.experience_years, "year")} of experience
                </span>
                <span className="inline-flex items-center gap-2">
                  <IndianRupee className="h-4 w-4 shrink-0" aria-hidden />
                  {doctor.is_fee_public === false
                    ? "Fee available at clinic"
                    : `${formatINR(doctor.consultation_fee)} consultation`}
                </span>
                <span className="inline-flex items-center gap-2">
                  <Award className="h-4 w-4 shrink-0" aria-hidden />
                  Reg. {doctor.registration_number}
                </span>
                {doctor.languages.length > 0 ? (
                  <span className="inline-flex items-center gap-2">
                    <Languages className="h-4 w-4 shrink-0" aria-hidden />
                    {doctor.languages.join(", ")}
                  </span>
                ) : null}
                <span className="inline-flex items-center gap-2">
                  <UserRound className="h-4 w-4 shrink-0" aria-hidden />
                  {doctor.is_accepting_patients ? "Accepting new patients" : "Not accepting new patients"}
                </span>
              </div>
            </CardContent>
          </Card>

          {doctor.about ? (
            <Card>
              <CardHeader>
                <CardTitle>About</CardTitle>
              </CardHeader>
              <CardContent className="text-sm leading-relaxed text-muted-foreground">
                {doctor.about}
              </CardContent>
            </Card>
          ) : null}

          <Card>
            <CardHeader>
              <CardTitle>Practises at</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {doctor.clinics.map((clinic) => (
                <div key={clinic.id} className="flex items-start justify-between gap-3">
                  <div>
                    <Link
                      href={`/patient/clinics/${clinic.id}`}
                      className="inline-flex items-center gap-2 text-sm font-medium hover:underline"
                    >
                      <Building2 className="h-4 w-4 text-muted-foreground" aria-hidden />
                      {clinic.name}
                    </Link>
                    <p className="mt-0.5 inline-flex items-center gap-2 text-sm text-muted-foreground">
                      <MapPin className="h-3.5 w-3.5 shrink-0" aria-hidden />
                      {clinic.area}, {clinic.city}
                      <a
                        href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${clinic.name}, ${clinic.area}, ${clinic.city}`)}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-xs text-primary hover:underline inline-flex items-center gap-0.5 ml-1"
                        title="Open in Google Maps"
                      >
                        (Map ↗)
                      </a>
                    </p>
                  </div>
                  <div className="flex flex-wrap justify-end gap-1">
                    {(availabilityByClinic.get(clinic.id) ?? [])
                      .sort((a, b) => a - b)
                      .map((dow) => (
                        <Badge key={dow} variant="outline">
                          {dayShortLabels.get(dow) ?? dow}
                        </Badge>
                      ))}
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>
                Patient reviews{" "}
                <span className="text-sm font-normal text-muted-foreground">
                  ({pluralize(reviews.total, "review")})
                </span>
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-5">
              {reviews.items.length === 0 ? (
                <EmptyState
                  icon={SearchX}
                  title="No reviews yet"
                  description="Reviews can be written after a completed consultation."
                />
              ) : (
                reviews.items.map((review) => (
                  <div key={review.id} className="space-y-1.5">
                    <div className="flex items-center justify-between gap-3">
                      <Rating value={review.rating} />
                      <span className="text-xs text-muted-foreground">{formatDate(review.created_at)}</span>
                    </div>
                    {review.title ? <p className="text-sm font-medium">{review.title}</p> : null}
                    {review.comment ? (
                      <p className="text-sm text-muted-foreground">{review.comment}</p>
                    ) : null}
                    <p className="text-xs text-muted-foreground">— {review.patient_name ?? "Patient"}</p>
                    <Separator />
                  </div>
                ))
              )}
              <Pagination
                page={reviews.page}
                totalPages={reviews.totalPages}
                buildHref={(page) =>
                  `/patient/doctors/${doctor.id}${buildQueryString({ page: page === 1 ? undefined : page })}`
                }
              />
            </CardContent>
          </Card>
        </div>

        {/* Right column: sticky booking */}
        <div className="lg:sticky lg:top-20 lg:self-start">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <CalendarDays className="h-5 w-5 text-muted-foreground" aria-hidden />
                Book an appointment
              </CardTitle>
            </CardHeader>
            <CardContent>
              <BookingSection
                doctorId={doctor.id}
                doctorName={name}
                fee={doctor.consultation_fee}
                clinics={bookingClinics}
              />
            </CardContent>
          </Card>
        </div>
      </div>

      <div className="flex justify-center">
        <Button asChild variant="ghost" size="sm">
          <Link href="/patient/doctors">← Back to all doctors</Link>
        </Button>
      </div>
    </div>
  );
}
