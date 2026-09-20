"use client";

import { useRouter } from "next/navigation";
import { useCallback, useTransition } from "react";
import { RotateCcw } from "lucide-react";
import { SearchInput } from "@/components/shared/search-input";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { buildQueryString } from "@/lib/search-params";

export interface ClinicFilterValues {
  q: string;
  city: string;
  area: string;
  specialization: string;
  minRating: string;
  sort: string;
}

interface ClinicFiltersProps {
  values: ClinicFilterValues;
  cities: string[];
  areas: string[];
  specializations: { id: string; name: string }[];
}

const ANY = "__any__";

/** Clinic discovery filters — URL-driven, same pattern as doctor filters. */
export function ClinicFilters({ values, cities, areas, specializations }: ClinicFiltersProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  const apply = useCallback(
    (patch: Partial<ClinicFilterValues>) => {
      const next = { ...values, ...patch };
      const qs = buildQueryString({
        q: next.q || undefined,
        city: next.city || undefined,
        area: next.area || undefined,
        specialization: next.specialization || undefined,
        minRating: next.minRating === ANY ? undefined : next.minRating,
        sort: next.sort === "rating" ? undefined : next.sort,
      });
      startTransition(() => {
        router.push(`/patient/clinics${qs}`, { scroll: false });
      });
    },
    [router, values]
  );

  const hasFilters =
    !!values.q || !!values.city || !!values.area || !!values.specialization ||
    (values.minRating && values.minRating !== ANY) ||
    (values.sort && values.sort !== "rating");

  return (
    <Card aria-busy={isPending} className={isPending ? "opacity-70 transition-opacity" : undefined}>
      <CardContent className="grid gap-4 p-4 md:grid-cols-2 xl:grid-cols-[1.5fr_1fr_1fr_1fr_1fr]">
        <div className="space-y-1.5">
          <Label htmlFor="clinic-search">Search by name</Label>
          <SearchInput
            value={values.q}
            onChange={(q) => apply({ q })}
            placeholder="e.g. Sunrise Polyclinic"
            ariaLabel="Search clinics by name"
          />
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="clinic-city">City</Label>
          <Select
            value={values.city || ANY}
            onValueChange={(v) => apply({ city: v === ANY ? "" : v, area: "" })}
          >
            <SelectTrigger id="clinic-city" className="w-full">
              <SelectValue placeholder="All cities" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ANY}>All cities</SelectItem>
              {cities.map((city) => (
                <SelectItem key={city} value={city}>
                  {city}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="clinic-area">Area</Label>
          <Select
            value={values.area || ANY}
            onValueChange={(v) => apply({ area: v === ANY ? "" : v })}
            disabled={!values.city || areas.length === 0}
          >
            <SelectTrigger id="clinic-area" className="w-full">
              <SelectValue placeholder={values.city ? "All areas" : "Pick a city first"} />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ANY}>All areas</SelectItem>
              {areas.map((area) => (
                <SelectItem key={area} value={area}>
                  {area}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="clinic-specialization">Specialization</Label>
          <Select value={values.specialization || ANY} onValueChange={(v) => apply({ specialization: v === ANY ? "" : v })}>
            <SelectTrigger id="clinic-specialization" className="w-full">
              <SelectValue placeholder="All specializations" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ANY}>All specializations</SelectItem>
              {specializations.map((spec) => (
                <SelectItem key={spec.id} value={spec.id}>
                  {spec.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="clinic-rating">Rating</Label>
          <Select value={values.minRating || ANY} onValueChange={(v) => apply({ minRating: v })}>
            <SelectTrigger id="clinic-rating" className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ANY}>Any rating</SelectItem>
              <SelectItem value="3">3+ stars</SelectItem>
              <SelectItem value="4">4+ stars</SelectItem>
              <SelectItem value="4.5">4.5+ stars</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {hasFilters ? (
          <div className="flex items-end md:col-span-2 xl:col-span-5">
            <Button
              variant="ghost"
              size="sm"
              onClick={() =>
                startTransition(() => {
                  router.push("/patient/clinics", { scroll: false });
                })
              }
            >
              <RotateCcw className="mr-1.5 h-4 w-4" aria-hidden /> Reset filters
            </Button>
          </div>
        ) : null}
      </CardContent>
    </Card>
  );
}
