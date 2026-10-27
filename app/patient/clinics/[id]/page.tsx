import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { Building2, Clock, Mail, MapPin, Phone, SearchX } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { Rating } from "@/components/shared/rating";
import { EmptyState } from "@/components/shared/empty-state";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { DoctorCard } from "@/components/discovery/doctor-card";
import { createClient } from "@/lib/supabase/server";
import { getClinicProfile, listClinicReviews } from "@/services/clinics/service";
import { formatDate } from "@/lib/utils";
import { DAYS_OF_WEEK } from "@/lib/constants";
import { GoogleMapEmbed } from "@/components/shared/google-map-embed";

interface PageProps {
  params: { id: string };
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const supabase = await createClient();
  const clinic = await getClinicProfile(supabase, params.id);
  return { title: clinic ? `${clinic.name} — clinic` : "Clinic" };
}

export default async function ClinicProfilePage({ params }: PageProps) {
  const supabase = await createClient();
  const clinic = await getClinicProfile(supabase, params.id);
  if (!clinic) notFound();

  const reviews = await listClinicReviews(supabase, clinic.id);

  const hoursByDay = new Map(clinic.hours.map((hours) => [hours.day_of_week, hours]));

  return (
    <div className="page-container space-y-6 py-8">
      <nav aria-label="Breadcrumb" className="text-sm text-muted-foreground">
        <Link href="/patient/clinics" className="hover:underline">
          ← Back to clinics
        </Link>
      </nav>

      <PageHeader
        title={clinic.name}
        description={clinic.description ?? `${clinic.area}, ${clinic.city}`}
        actions={<Rating value={clinic.avg_rating} count={clinic.review_count} size="md" />}
      />

      <div className="grid gap-6 lg:grid-cols-[1fr_340px]">
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Doctors at this clinic</CardTitle>
            </CardHeader>
            <CardContent>
              {clinic.doctors.length === 0 ? (
                <EmptyState
                  icon={SearchX}
                  title="No doctors listed"
                  description="No doctors are linked to this clinic yet."
                />
              ) : (
                <div className="grid gap-4 md:grid-cols-2">
                  {clinic.doctors.map((doctor) => (
                    <DoctorCard key={doctor.id} doctor={doctor} />
                  ))}
                </div>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Clinic reviews</CardTitle>
            </CardHeader>
            <CardContent className="space-y-5">
              {reviews.length === 0 ? (
                <EmptyState
                  icon={SearchX}
                  title="No reviews yet"
                  description="Reviews can be written after a completed consultation at this clinic."
                />
              ) : (
                reviews.map((review) => (
                  <div key={review.id} className="space-y-1.5">
                    <div className="flex items-center justify-between gap-3">
                      <Rating value={review.rating} />
                      <span className="text-xs text-muted-foreground">{formatDate(review.created_at)}</span>
                    </div>
                    {review.title ? <p className="text-sm font-medium">{review.title}</p> : null}
                    {review.comment ? <p className="text-sm text-muted-foreground">{review.comment}</p> : null}
                    <p className="text-xs text-muted-foreground">— {review.patient_name ?? "Patient"}</p>
                    <Separator />
                  </div>
                ))
              )}
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <MapPin className="h-5 w-5 text-muted-foreground" aria-hidden /> Address
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3 text-sm text-muted-foreground">
              <div className="space-y-1">
                <p className="font-medium text-foreground">{clinic.address_line}</p>
                <p>
                  {clinic.area}, {clinic.city}
                  {clinic.pincode ? ` — ${clinic.pincode}` : ""}
                </p>
                {clinic.contact_phone ? (
                  <p className="inline-flex items-center gap-2 pt-1 text-xs">
                    <Phone className="h-3.5 w-3.5" aria-hidden /> {clinic.contact_phone}
                  </p>
                ) : null}
                {clinic.contact_email ? (
                  <p className="inline-flex items-center gap-2 text-xs">
                    <Mail className="h-3.5 w-3.5" aria-hidden /> {clinic.contact_email}
                  </p>
                ) : null}
              </div>

              <GoogleMapEmbed
                query={`${clinic.name}, ${clinic.address_line}, ${clinic.area}, ${clinic.city}`}
                title={clinic.name}
                heightClass="h-48"
              />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Clock className="h-5 w-5 text-muted-foreground" aria-hidden /> Working hours
              </CardTitle>
            </CardHeader>
            <CardContent>
              <dl className="space-y-1.5 text-sm">
                {DAYS_OF_WEEK.map((meta) => {
                  const hours = hoursByDay.get(meta.value);
                  const closed = !hours || hours.is_closed;
                  return (
                    <div key={meta.value} className="flex items-center justify-between gap-4">
                      <dt className="text-muted-foreground">{meta.label}</dt>
                      <dd className={closed ? "text-muted-foreground/70" : "font-medium"}>
                        {closed
                          ? "Closed"
                          : `${hours!.opens_at.slice(0, 5)} – ${hours!.closes_at.slice(0, 5)}`}
                      </dd>
                    </div>
                  );
                })}
              </dl>
            </CardContent>
          </Card>

          {clinic.facilities.length > 0 ? (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-5 w-5 text-muted-foreground" aria-hidden /> Facilities
                </CardTitle>
              </CardHeader>
              <CardContent className="flex flex-wrap gap-1.5">
                {clinic.facilities.map((facility) => (
                  <Badge key={facility} variant="secondary">
                    {facility}
                  </Badge>
                ))}
              </CardContent>
            </Card>
          ) : null}
        </div>
      </div>
    </div>
  );
}
