import type { Metadata } from "next";

export const metadata: Metadata = { title: "Better Clinic — smart digital healthcare (prototype)" };

import Link from "next/link";
import {
  CalendarCheck,
  ClipboardList,
  HeartPulse,
  LineChart,
  Search,
  Stethoscope,
  Users,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { isDemoMode, isSupabaseConfigured } from "@/lib/env";
import { SetupNotice } from "@/components/shared/setup-notice";

const FEATURES = [
  {
    icon: Search,
    title: "Find the right doctor",
    description: "Search doctors and clinics by specialization, city, fee, rating and availability — powered by real data.",
  },
  {
    icon: CalendarCheck,
    title: "Book, reschedule, cancel",
    description: "Data-driven slot availability with double-booking protection and a fully tracked appointment lifecycle.",
  },
  {
    icon: Users,
    title: "Live queue with tokens",
    description: "Check in, receive a deterministic token, and watch the queue update in realtime — for patients and staff.",
  },
  {
    icon: ClipboardList,
    title: "Structured clinical records",
    description: "Consultations, diagnoses, prescriptions with medicine-level detail, medication schedules and follow-ups.",
  },
  {
    icon: HeartPulse,
    title: "Application-aware assistant",
    description: "An AI assistant that answers from your own records — with a safe, deterministic fallback when no LLM is configured.",
  },
  {
    icon: LineChart,
    title: "Honest analytics",
    description: "Clinic dashboards computed from real records — no fake statistics, ever.",
  },
];

export default function HomePage() {
  const configured = isSupabaseConfigured();

  return (
    <div className="flex min-h-screen flex-col">
      <header className="border-b bg-card">
        <div className="page-container flex h-16 items-center justify-between !py-0">
          <div className="flex items-center gap-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-md bg-primary">
              <Stethoscope className="h-4 w-4 text-primary-foreground" aria-hidden />
            </div>
            <span className="text-base font-semibold tracking-tight">Better Clinic</span>
            {isDemoMode() ? (
              <span className="rounded-full border border-warning/40 bg-warning/10 px-2 py-0.5 text-[11px] font-medium text-warning">
                Demo environment
              </span>
            ) : null}
          </div>
          <nav className="flex items-center gap-2">
            <Button asChild variant="ghost">
              <Link href="/login">Sign in</Link>
            </Button>
            <Button asChild>
              <Link href="/signup">Create account</Link>
            </Button>
          </nav>
        </div>
      </header>

      <main className="flex-1">
        {!configured ? (
          <div className="page-container pt-8">
            <SetupNotice />
          </div>
        ) : null}

        <section className="page-container pb-12 pt-10 text-center sm:pt-14">
          <h1 className="mx-auto max-w-2xl text-3xl font-semibold tracking-tight sm:text-4xl">
            One connected platform for patients, doctors and clinic staff
          </h1>
          <p className="mx-auto mt-4 max-w-2xl text-base text-muted-foreground">
            Better Clinic connects discovery, booking, live queues, clinical records and follow-ups
            into a single workflow — built on a real relational database with role-based security.
          </p>
          <div className="mt-6 flex items-center justify-center gap-3">
            <Button asChild size="lg">
              <Link href="/signup">Get started</Link>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href="/login">Sign in</Link>
            </Button>
          </div>
        </section>

        <section className="page-container pb-16" aria-label="Platform features">
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {FEATURES.map((feature) => (
              <div key={feature.title} className="rounded-lg border bg-card p-5">
                <feature.icon className="h-5 w-5 text-primary" aria-hidden />
                <h2 className="mt-3 text-sm font-semibold">{feature.title}</h2>
                <p className="mt-1.5 text-sm text-muted-foreground">{feature.description}</p>
              </div>
            ))}
          </div>
        </section>
      </main>

      <footer className="border-t bg-card">
        <div className="page-container flex flex-col items-center justify-between gap-2 py-5 text-xs text-muted-foreground sm:flex-row">
          <p>Better Clinic — a final-year engineering prototype. All data shown is fictional.</p>
          <p>
            In a medical emergency call <span className="font-semibold text-foreground">108</span>.
          </p>
        </div>
      </footer>
    </div>
  );
}
