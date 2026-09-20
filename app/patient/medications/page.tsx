import type { Metadata } from "next";
import Link from "next/link";
import { Pill } from "lucide-react";
import { PageHeader } from "@/components/shared/page-header";
import { EmptyState } from "@/components/shared/empty-state";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { listActiveMedications } from "@/services/clinical/service";
import { formatDate, formatTimeString, todayClinicDate } from "@/lib/utils";
import { FOOD_RELATION_LABELS } from "@/lib/constants";

export const metadata: Metadata = { title: "My medications" };

export default async function PatientMedicationsPage() {
  const user = await requireRole(["PATIENT"], "/patient/medications");
  const supabase = await createClient();
  const courses = await listActiveMedications(supabase, user.id);
  const today = todayClinicDate();

  // Today's checklist, ordered by time of day.
  const todayDoses = courses
    .flatMap((course) => course.times.map((time) => ({ ...course, time })))
    .sort((a, b) => a.time.localeCompare(b.time));

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="My medications"
        description="Active medication courses generated from your prescriptions — real schedule rows from the database."
      />

      {courses.length === 0 ? (
        <EmptyState
          icon={Pill}
          title="No active medications"
          description="When a doctor prescribes medication, your daily schedule appears here automatically."
          action={
            <Button asChild size="sm">
              <Link href="/patient/prescriptions">View prescriptions</Link>
            </Button>
          }
        />
      ) : (
        <>
          <Card>
            <CardHeader>
              <CardTitle>Today&apos;s schedule ({todayDoses.length} doses)</CardTitle>
            </CardHeader>
            <CardContent>
              <ol className="space-y-2">
                {todayDoses.map((dose, index) => (
                  <li
                    key={`${dose.itemId}-${dose.time}-${index}`}
                    className="flex items-center justify-between gap-3 rounded-lg border p-3 text-sm"
                  >
                    <span className="font-medium">
                      {dose.medicine_name} — {dose.dose}
                    </span>
                    <span className="font-mono text-xs text-muted-foreground">{formatTimeString(dose.time)}</span>
                  </li>
                ))}
              </ol>
            </CardContent>
          </Card>

          <div className="space-y-4">
            {courses.map((course) => {
              const totalDays =
                Math.round(
                  (new Date(`${course.end_date}T12:00:00Z`).getTime() -
                    new Date(`${course.start_date}T12:00:00Z`).getTime()) /
                    86400000
                ) + 1;
              const elapsed =
                Math.round(
                  (new Date(`${today}T12:00:00Z`).getTime() -
                    new Date(`${course.start_date}T12:00:00Z`).getTime()) /
                    86400000
                ) + 1;
              const progress = Math.min(100, Math.max(0, Math.round((elapsed / totalDays) * 100)));
              return (
                <Card key={course.itemId}>
                  <CardContent className="space-y-2 p-4">
                    <div className="flex flex-wrap items-center justify-between gap-2">
                      <p className="font-medium">
                        {course.medicine_name} — {course.dose}
                      </p>
                      <div className="flex gap-1.5">
                        {course.times.map((time) => (
                          <Badge key={time} variant="secondary">
                            {formatTimeString(time)}
                          </Badge>
                        ))}
                      </div>
                    </div>
                    <p className="text-sm text-muted-foreground">
                      {formatDate(course.start_date)} → {formatDate(course.end_date)} · day {Math.min(elapsed, totalDays)} of{" "}
                      {totalDays}
                      {course.food_relation !== "NOT_SPECIFIED" ? ` · ${FOOD_RELATION_LABELS[course.food_relation]}` : ""}
                    </p>
                    <div
                      className="h-2 w-full overflow-hidden rounded-full bg-muted"
                      role="progressbar"
                      aria-valuenow={progress}
                      aria-valuemin={0}
                      aria-valuemax={100}
                      aria-label={`${course.medicine_name} course progress`}
                    >
                      <div className="h-full rounded-full bg-primary transition-all" style={{ width: `${progress}%` }} />
                    </div>
                    {course.instructions ? (
                      <p className="text-xs text-muted-foreground">{course.instructions}</p>
                    ) : null}
                  </CardContent>
                </Card>
              );
            })}
          </div>
        </>
      )}
    </div>
  );
}
