import type { Metadata } from "next";

export const metadata: Metadata = { title: "My health dashboard" };

import Link from "next/link";
import { CheckCircle2, Circle, CalendarDays, Search, Clock } from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import type { Patient } from "@/lib/types/database";
import { formatDate } from "@/lib/utils";

export default async function PatientDashboard() {
  const user = await requireRole(["PATIENT"], "/patient");
  const supabase = await createClient();
  const { data: patient } = await supabase
    .from("patients")
    .select("*")
    .eq("id", user.id)
    .single();

  const p = (patient as Patient) ?? null;
  const checklist = [
    { label: "Full name", done: !!user.fullName },
    { label: "Mobile number", done: !!user.phone },
    { label: "Date of birth", done: !!p?.date_of_birth },
    { label: "City", done: !!p?.city },
    { label: "Emergency contact", done: !!p?.emergency_contact_phone },
  ];
  const completed = checklist.filter((c) => c.done).length;

  return (
    <div className="page-container space-y-6 py-8">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">Hello, {user.fullName.split(" ")[0]}</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {p?.date_of_birth
            ? `Born ${formatDate(p.date_of_birth)}${p.blood_group ? ` · Blood group ${p.blood_group}` : ""}`
            : "Welcome to your health dashboard."}
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>Your care at a glance</CardTitle>
            <CardDescription>
              Appointments, prescriptions and follow-ups appear here as the platform modules come
              online.
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-3 sm:grid-cols-3">
            <Link
              href="/patient/doctors"
              className="flex items-start gap-3 rounded-lg border p-4 transition-colors hover:bg-muted/50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
            >
              <Search className="mt-0.5 h-5 w-5 text-primary" aria-hidden />
              <div>
                <p className="text-sm font-medium">Find a doctor</p>
                <p className="mt-0.5 text-xs text-muted-foreground">
                  Search by specialization, city and fee
                </p>
              </div>
            </Link>
            <Link
              href="/patient/appointments"
              className="flex items-start gap-3 rounded-lg border p-4 transition-colors hover:bg-muted/50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
            >
              <CalendarDays className="mt-0.5 h-5 w-5 text-primary" aria-hidden />
              <div>
                <p className="text-sm font-medium">Appointments</p>
                <p className="mt-0.5 text-xs text-muted-foreground">Book and manage visits</p>
              </div>
            </Link>
            <Link
              href="/patient/queue"
              className="flex items-start gap-3 rounded-lg border p-4 transition-colors hover:bg-muted/50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
            >
              <Clock className="mt-0.5 h-5 w-5 text-primary" aria-hidden />
              <div>
                <p className="text-sm font-medium">Live queue</p>
                <p className="mt-0.5 text-xs text-muted-foreground">Your token after check-in</p>
              </div>
            </Link>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Profile completeness</CardTitle>
            <CardDescription>
              {completed}/{checklist.length} details filled
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-2.5">
            {checklist.map((item) => (
              <div key={item.label} className="flex items-center gap-2 text-sm">
                {item.done ? (
                  <CheckCircle2 className="h-4 w-4 text-success" aria-hidden />
                ) : (
                  <Circle className="h-4 w-4 text-muted-foreground/50" aria-hidden />
                )}
                <span className={item.done ? "text-foreground" : "text-muted-foreground"}>
                  {item.label}
                </span>
              </div>
            ))}
            {completed < checklist.length ? (
              <Button asChild variant="outline" size="sm" className="mt-2 w-full">
                <Link href="/patient/settings">Complete profile</Link>
              </Button>
            ) : null}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
