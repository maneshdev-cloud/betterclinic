import Link from "next/link";
import { Building2, MapPin, Users } from "lucide-react";
import { Rating } from "@/components/shared/rating";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import type { ClinicListItem } from "@/services/clinics/service";

/** Clinic result card for the discovery list. */
export function ClinicCard({ clinic }: { clinic: ClinicListItem }) {
  return (
    <Card className="h-full">
      <CardContent className="flex h-full flex-col gap-3 p-5">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <h3 className="truncate text-base font-semibold text-foreground">
              <Link href={`/patient/clinics/${clinic.id}`} className="hover:underline">
                {clinic.name}
              </Link>
            </h3>
            <div className="mt-1.5">
              <Rating value={clinic.avg_rating} count={clinic.review_count} />
            </div>
          </div>
        </div>

        <p className="inline-flex items-center gap-2 text-sm text-muted-foreground">
          <MapPin className="h-4 w-4 shrink-0" aria-hidden />
          {clinic.area}, {clinic.city}
        </p>
        {clinic.description ? (
          <p className="line-clamp-2 text-sm text-muted-foreground">{clinic.description}</p>
        ) : null}

        {clinic.facilities.length > 0 ? (
          <div className="flex flex-wrap gap-1.5">
            {clinic.facilities.slice(0, 4).map((facility) => (
              <Badge key={facility} variant="outline">
                {facility}
              </Badge>
            ))}
            {clinic.facilities.length > 4 ? (
              <Badge variant="outline">+{clinic.facilities.length - 4} more</Badge>
            ) : null}
          </div>
        ) : null}

        <div className="mt-auto flex items-center justify-between pt-1">
          <span className="inline-flex items-center gap-1.5 text-sm text-muted-foreground">
            <Users className="h-4 w-4" aria-hidden />
            {clinic.doctor_count} {clinic.doctor_count === 1 ? "doctor" : "doctors"}
          </span>
          <Button asChild size="sm" variant="outline">
            <Link href={`/patient/clinics/${clinic.id}`}>
              <Building2 className="mr-1.5 h-4 w-4" aria-hidden /> View clinic
            </Link>
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
