"use client";

import { useRouter } from "next/navigation";
import { useCallback, useTransition } from "react";
import { RotateCcw } from "lucide-react";
import { SearchInput } from "@/components/shared/search-input";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { buildQueryString } from "@/lib/search-params";

export interface DoctorFilterValues {
  q: string;
  specialization: string;
  city: string;
  maxFee: string;
  minRating: string;
  availableToday: boolean;
  acceptingPatients: boolean;
  sort: string;
}

interface DoctorFiltersProps {
  values: DoctorFilterValues;
  specializations: { id: string; name: string }[];
  cities: string[];
}

const ANY = "__any__";

const FEE_OPTIONS = [
  { value: ANY, label: "Any fee" },
  { value: "300", label: "Under ₹300" },
  { value: "500", label: "Under ₹500" },
  { value: "1000", label: "Under ₹1,000" },
  { value: "2000", label: "Under ₹2,000" },
];

const RATING_OPTIONS = [
  { value: ANY, label: "Any rating" },
  { value: "3", label: "3+ stars" },
  { value: "4", label: "4+ stars" },
  { value: "4.5", label: "4.5+ stars" },
];

const SORT_OPTIONS = [
  { value: "rating", label: "Top rated" },
  { value: "experience", label: "Most experienced" },
  { value: "fee_asc", label: "Fee: low to high" },
  { value: "fee_desc", label: "Fee: high to low" },
];

/**
 * Doctor discovery filters. All state lives in the URL (server-rendered
 * results); this component only pushes new URLs — debounced for text,
 * immediate for dropdowns and checkboxes.
 */
export function DoctorFilters({ values, specializations, cities }: DoctorFiltersProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  const apply = useCallback(
    (patch: Partial<DoctorFilterValues>) => {
      const next = { ...values, ...patch };
      const qs = buildQueryString({
        q: next.q || undefined,
        specialization: next.specialization || undefined,
        city: next.city || undefined,
        maxFee: next.maxFee === ANY ? undefined : next.maxFee,
        minRating: next.minRating === ANY ? undefined : next.minRating,
        availableToday: next.availableToday || undefined,
        acceptingPatients: next.acceptingPatients || undefined,
        sort: next.sort === "rating" ? undefined : next.sort,
      });
      startTransition(() => {
        router.push(`/patient/doctors${qs}`, { scroll: false });
      });
    },
    [router, values]
  );

  const hasFilters =
    !!values.q ||
    !!values.specialization ||
    !!values.city ||
    (values.maxFee && values.maxFee !== ANY) ||
    (values.minRating && values.minRating !== ANY) ||
    values.availableToday ||
    values.acceptingPatients ||
    (values.sort && values.sort !== "rating");

  return (
    <Card aria-busy={isPending} className={isPending ? "opacity-70 transition-opacity" : undefined}>
      <CardContent className="grid gap-4 p-4 md:grid-cols-2 xl:grid-cols-[1.5fr_1fr_1fr_1fr]">
        <div className="space-y-1.5">
          <Label htmlFor="doctor-search">Search by name</Label>
          <SearchInput
            value={values.q}
            onChange={(q) => apply({ q })}
            placeholder="e.g. Ananya Deshmukh"
            ariaLabel="Search doctors by name"
          />
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="doctor-specialization">Specialization</Label>
          <Select value={values.specialization || ANY} onValueChange={(v) => apply({ specialization: v === ANY ? "" : v })}>
            <SelectTrigger id="doctor-specialization" className="w-full">
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
          <Label htmlFor="doctor-city">City</Label>
          <Select value={values.city || ANY} onValueChange={(v) => apply({ city: v === ANY ? "" : v })}>
            <SelectTrigger id="doctor-city" className="w-full">
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
          <Label htmlFor="doctor-fee">Fee</Label>
          <Select value={values.maxFee || ANY} onValueChange={(v) => apply({ maxFee: v })}>
            <SelectTrigger id="doctor-fee" className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {FEE_OPTIONS.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="doctor-rating">Rating</Label>
          <Select value={values.minRating || ANY} onValueChange={(v) => apply({ minRating: v })}>
            <SelectTrigger id="doctor-rating" className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {RATING_OPTIONS.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="doctor-sort">Sort by</Label>
          <Select value={values.sort || "rating"} onValueChange={(v) => apply({ sort: v })}>
            <SelectTrigger id="doctor-sort" className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {SORT_OPTIONS.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <fieldset className="flex items-end gap-5 md:col-span-2">
          <legend className="sr-only">Quick filters</legend>
          <label className="flex cursor-pointer items-center gap-2 pb-1 text-sm">
            <Checkbox
              checked={values.availableToday}
              onCheckedChange={(checked) => apply({ availableToday: checked === true })}
              id="filter-available-today"
            />
            <Label htmlFor="filter-available-today" className="cursor-pointer font-normal">
              Available today
            </Label>
          </label>
          <label className="flex cursor-pointer items-center gap-2 pb-1 text-sm">
            <Checkbox
              checked={values.acceptingPatients}
              onCheckedChange={(checked) => apply({ acceptingPatients: checked === true })}
              id="filter-accepting"
            />
            <Label htmlFor="filter-accepting" className="cursor-pointer font-normal">
              Accepting new patients
            </Label>
          </label>
          {hasFilters ? (
            <Button
              variant="ghost"
              size="sm"
              className="mb-0.5"
              onClick={() =>
                startTransition(() => {
                  router.push("/patient/doctors", { scroll: false });
                })
              }
            >
              <RotateCcw className="mr-1.5 h-4 w-4" aria-hidden /> Reset
            </Button>
          ) : null}
        </fieldset>
      </CardContent>
    </Card>
  );
}
