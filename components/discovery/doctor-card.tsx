import Link from "next/link";
import { CalendarClock, MapPin, GraduationCap, Languages } from "lucide-react";
import { UserAvatar } from "@/components/shared/user-avatar";
import { Rating } from "@/components/shared/rating";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { formatINR } from "@/lib/utils";
import type { DoctorListItem } from "@/services/doctors/service";

interface DoctorCardProps {
  doctor: DoctorListItem;
}

/** Doctor result card for the discovery list (server-rendered, no client JS). */
export function DoctorCard({ doctor }: DoctorCardProps) {
  const name = doctor.profile?.full_name ?? "Doctor";
  const areas = Array.from(new Set(doctor.clinics.map((clinic) => `${clinic.area}, ${clinic.city}`)))
    .slice(0, 3)
    .join(" · ");

  return (
    <Card className="h-full">
      <CardContent className="flex h-full flex-col gap-4 p-5">
        <div className="flex items-start gap-4">
          <UserAvatar name={name} src={doctor.profile?.avatar_url} size="lg" />
          <div className="min-w-0 flex-1">
            <div className="flex flex-wrap items-center gap-2">
              <h3 className="truncate text-base font-semibold text-foreground">
                <Link href={`/patient/doctors/${doctor.id}`} className="hover:underline">
                  {name}
                </Link>
              </h3>
              {!doctor.is_accepting_patients ? <Badge variant="muted">Not accepting patients</Badge> : null}
            </div>
            <p className="mt-0.5 truncate text-sm text-muted-foreground">{doctor.qualification}</p>
            <div className="mt-1.5">
              <Rating value={doctor.avg_rating} count={doctor.review_count} />
            </div>
          </div>
          <div className="hidden shrink-0 text-right sm:block">
            <p className="text-base font-semibold text-foreground">{formatINR(doctor.consultation_fee)}</p>
            <p className="text-xs text-muted-foreground">consultation</p>
          </div>
        </div>

        <div className="flex flex-wrap gap-1.5">
          {doctor.specializations.slice(0, 3).map((spec) => (
            <Badge key={spec.id} variant="secondary">
              {spec.name}
            </Badge>
          ))}
        </div>

        <div className="grid gap-1.5 text-sm text-muted-foreground">
          <span className="inline-flex items-center gap-2">
            <GraduationCap className="h-4 w-4 shrink-0" aria-hidden />
            {doctor.experience_years} {doctor.experience_years === 1 ? "year" : "years"} of experience
          </span>
          {areas ? (
            <span className="inline-flex items-center gap-2">
              <MapPin className="h-4 w-4 shrink-0" aria-hidden />
              <span className="truncate">{areas}</span>
            </span>
          ) : null}
          {doctor.languages.length > 0 ? (
            <span className="inline-flex items-center gap-2">
              <Languages className="h-4 w-4 shrink-0" aria-hidden />
              <span className="truncate">{doctor.languages.join(", ")}</span>
            </span>
          ) : null}
        </div>

        <div className="mt-auto flex items-center justify-between gap-3 pt-1">
          <span className="text-sm font-medium text-foreground sm:hidden">
            {formatINR(doctor.consultation_fee)}
          </span>
          <Button asChild className="ml-auto" size="sm">
            <Link href={`/patient/doctors/${doctor.id}`}>
              <CalendarClock className="mr-1.5 h-4 w-4" aria-hidden />
              View profile & book
            </Link>
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
