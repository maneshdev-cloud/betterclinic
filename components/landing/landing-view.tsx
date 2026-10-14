"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import {
  CalendarCheck,
  ClipboardList,
  HeartPulse,
  Search,
  Stethoscope,
  Users,
  ArrowRight,
  ShieldCheck,
  Sparkles,
  Clock,
  CheckCircle2,
  Building2,
  UserCheck,
  Star,
  FileCheck2,
  PhoneCall,
  MapPin,
  Pill,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/layout/theme-toggle";
import { SetupNotice } from "@/components/shared/setup-notice";

interface LandingViewProps {
  isConfigured: boolean;
}

const STATS = [
  { value: "98%", label: "Patient Satisfaction", detail: "Based on verified post-consultation reviews" },
  { value: "< 10 min", label: "Average Wait Time", detail: "Realtime token queue keeps clinics on schedule" },
  { value: "20+", label: "Specialties Covered", detail: "From primary care to cardiology & pediatrics" },
  { value: "100%", label: "Verified Specialists", detail: "Licensed, board-certified medical doctors" },
];

const ROLES = [
  {
    role: "PATIENT",
    title: "Patient Portal",
    subtitle: "For patients & families",
    description: "Search top doctors, book verified appointments, track your live queue token from home, and download electronic prescriptions.",
    href: "/patient",
    icon: Users,
    badge: "Patients",
    badgeColor: "bg-teal-50 text-teal-700 border-teal-200 dark:bg-teal-950/40 dark:text-teal-300 dark:border-teal-800",
  },
  {
    role: "DOCTOR",
    title: "Doctor Workspace",
    subtitle: "For medical practitioners",
    description: "Access your daily patient schedule, review consultation histories, call patients into your room, and issue structured digital prescriptions.",
    href: "/doctor",
    icon: Stethoscope,
    badge: "Doctors",
    badgeColor: "bg-emerald-50 text-emerald-700 border-emerald-200 dark:bg-emerald-950/40 dark:text-emerald-300 dark:border-emerald-800",
  },
  {
    role: "STAFF",
    title: "Clinic Reception",
    subtitle: "For front-desk teams",
    description: "Check in arriving patients, generate walk-in queue tokens, manage waiting room flow, and assign patients to doctor consultation rooms.",
    href: "/staff",
    icon: UserCheck,
    badge: "Clinic Staff",
    badgeColor: "bg-sky-50 text-sky-700 border-sky-200 dark:bg-sky-950/40 dark:text-sky-300 dark:border-sky-800",
  },
  {
    role: "ADMIN",
    title: "Clinic Management",
    subtitle: "For directors & administrators",
    description: "Configure clinic working hours, manage doctor schedules and staff accounts, and view accurate patient care analytics.",
    href: "/admin",
    icon: Building2,
    badge: "Administration",
    badgeColor: "bg-slate-100 text-slate-800 border-slate-200 dark:bg-slate-800 dark:text-slate-200 dark:border-slate-700",
  },
];

export function LandingView({ isConfigured }: LandingViewProps) {
  return (
    <div className="relative min-h-screen bg-background text-foreground">
      {/* Gentle ambient healthcare background */}
      <div className="pointer-events-none fixed inset-0 -z-10 medical-soft-bg" />

      {/* Clean, Trusted Medical Header */}
      <header className="sticky top-0 z-40 border-b border-border/60 bg-card/90 backdrop-blur-md">
        <div className="page-container flex h-16 items-center justify-between !py-0">
          <Link href="/" className="flex items-center gap-3 group">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm shadow-primary/25 transition-transform group-hover:scale-105">
              <Stethoscope className="h-5 w-5" aria-hidden />
            </div>
            <div className="flex flex-col">
              <span className="text-lg font-bold tracking-tight text-foreground flex items-center gap-1.5">
                Better Clinic
              </span>
              <span className="text-[11px] font-medium text-muted-foreground hidden sm:inline">
                Modern Healthcare Platform
              </span>
            </div>
          </Link>

          {/* Navigation Links */}
          <nav className="hidden md:flex items-center gap-7 text-sm font-medium text-muted-foreground">
            <a href="#services" className="hover:text-foreground transition-colors">
              Our Services
            </a>
            <a href="#doctors" className="hover:text-foreground transition-colors">
              Find Doctors
            </a>
            <a href="#portals" className="hover:text-foreground transition-colors">
              Clinic Portals
            </a>
            <Link href="/choose-role" className="hover:text-foreground transition-colors">
              Switch Role
            </Link>
          </nav>

          {/* Action CTAs */}
          <div className="flex items-center gap-3">
            <ThemeToggle />
            <Button asChild variant="ghost" size="sm" className="hidden sm:inline-flex text-sm font-medium">
              <Link href="/login">Sign in</Link>
            </Button>
            <Button
              asChild
              size="sm"
              className="rounded-lg bg-primary text-primary-foreground font-semibold shadow-sm hover:bg-primary/90 transition-all"
            >
              <Link href="/signup">
                Book appointment
                <ArrowRight className="ml-1.5 h-3.5 w-3.5" />
              </Link>
            </Button>
          </div>
        </div>
      </header>

      <main>
        {!isConfigured ? (
          <div className="page-container pt-6">
            <SetupNotice />
          </div>
        ) : null}

        {/* ── HERO SECTION ────────────────────────────────────────── */}
        <section className="page-container pt-12 pb-16 sm:pt-20 text-center">
          {/* Calming Welcome Badge */}
          <motion.div
            initial={{ opacity: 0, y: -8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4 }}
            className="inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-3.5 py-1.5 text-xs font-semibold text-primary"
          >
            <Sparkles className="h-3.5 w-3.5 text-primary" />
            <span>Smart Care · Faster Appointments · Zero Waiting Room Stress</span>
          </motion.div>

          {/* Hero Main Heading */}
          <motion.h1
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
            className="mx-auto mt-5 max-w-3xl text-4xl font-extrabold tracking-tight sm:text-5xl lg:text-6xl text-foreground"
          >
            Compassionate Care.{" "}
            <span className="text-gradient-medical block sm:inline">Seamlessly Connected.</span>
          </motion.h1>

          {/* Subheading */}
          <motion.p
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="mx-auto mt-5 max-w-2xl text-base sm:text-lg text-muted-foreground leading-relaxed"
          >
            Find top verified specialists, book confirmed appointments, track your turn with live
            digital clinic tokens, and access all your medical records in one secure place.
          </motion.p>

          {/* Hero CTAs */}
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
            className="mt-8 flex flex-wrap items-center justify-center gap-3.5"
          >
            <Button
              asChild
              size="lg"
              className="h-12 px-7 rounded-xl bg-primary text-primary-foreground font-semibold shadow-md hover:bg-primary/90 transition-all hover:scale-[1.02]"
            >
              <Link href="/signup" className="flex items-center gap-2">
                <span>Book an Appointment</span>
                <ArrowRight className="h-4 w-4" />
              </Link>
            </Button>
            <Button
              asChild
              size="lg"
              variant="outline"
              className="h-12 px-7 rounded-xl border-border bg-card hover:bg-muted font-medium transition-all"
            >
              <Link href="/choose-role">Explore Clinic Portals</Link>
            </Button>
          </motion.div>

          {/* Trust Indicators */}
          <div className="mt-8 flex flex-wrap items-center justify-center gap-6 text-xs text-muted-foreground">
            <span className="flex items-center gap-1.5 font-medium">
              <CheckCircle2 className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
              Verified Board-Certified Doctors
            </span>
            <span className="flex items-center gap-1.5 font-medium">
              <Clock className="h-4 w-4 text-primary" />
              Live Waiting Queue Tracking
            </span>
            <span className="flex items-center gap-1.5 font-medium">
              <ShieldCheck className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
              100% Private & Confidential Records
            </span>
          </div>

          {/* ── REALISTIC HEALTHCARE APP PREVIEW CARD ───────────────── */}
          <motion.div
            initial={{ opacity: 0, y: 25 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.35 }}
            className="mx-auto mt-12 max-w-4xl rounded-2xl border border-border/80 bg-card p-3 shadow-xl sm:p-5 text-left"
          >
            <div className="rounded-xl border border-border/50 bg-muted/20 p-4 sm:p-6">
              {/* Card top banner */}
              <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border/60 pb-4">
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary/10 text-primary">
                    <HeartPulse className="h-5 w-5" />
                  </div>
                  <div>
                    <h2 className="text-sm font-bold text-foreground">City Central Health Clinic</h2>
                    <p className="text-xs text-muted-foreground flex items-center gap-1">
                      <MapPin className="h-3 w-3 text-muted-foreground" /> Main Medical Campus · Open Today
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-700 border border-emerald-200 dark:bg-emerald-950/40 dark:text-emerald-300 dark:border-emerald-800">
                    <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
                    Live Clinic Queue Active
                  </span>
                </div>
              </div>

              {/* Three Medical Preview Panels */}
              <div className="mt-5 grid gap-4 sm:grid-cols-3">
                {/* 1. Doctor Profile */}
                <div className="rounded-xl border border-border/80 bg-card p-4 shadow-sm">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold uppercase tracking-wider text-primary">
                      Consulting Doctor
                    </span>
                    <span className="flex items-center gap-0.5 text-xs font-semibold text-amber-500">
                      <Star className="h-3 w-3 fill-amber-400 text-amber-400" />
                      4.9
                    </span>
                  </div>
                  <div className="mt-3">
                    <p className="text-sm font-bold text-foreground">Dr. Sarah Jenkins, MD</p>
                    <p className="text-xs text-muted-foreground mt-0.5">Senior Cardiologist · 12 yrs exp</p>
                  </div>
                  <div className="mt-3 rounded-lg bg-muted/40 p-2 text-xs text-muted-foreground">
                    <span className="font-medium text-foreground">Next Available:</span> Today at 10:30 AM
                  </div>
                </div>

                {/* 2. Patient Live Token */}
                <div className="rounded-xl border border-primary/30 bg-primary/5 p-4 shadow-sm">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold uppercase tracking-wider text-primary">
                      Your Queue Token
                    </span>
                    <span className="rounded-full bg-primary/20 px-2 py-0.5 text-[10px] font-semibold text-primary">
                      Room 3
                    </span>
                  </div>
                  <div className="mt-2.5 flex items-baseline gap-2">
                    <span className="text-3xl font-extrabold tracking-tight text-primary font-mono">
                      #A-024
                    </span>
                    <span className="text-xs font-medium text-emerald-700 dark:text-emerald-400">
                      Almost your turn!
                    </span>
                  </div>
                  <div className="mt-3 space-y-1">
                    <div className="flex justify-between text-[11px] text-muted-foreground">
                      <span>2 patients ahead</span>
                      <span>~8 mins wait</span>
                    </div>
                    <div className="h-2 w-full rounded-full bg-border overflow-hidden">
                      <div className="h-full w-4/5 rounded-full bg-primary" />
                    </div>
                  </div>
                </div>

                {/* 3. Prescription & Care Summary */}
                <div className="rounded-xl border border-border/80 bg-card p-4 shadow-sm">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold uppercase tracking-wider text-muted-foreground">
                      Digital Prescription
                    </span>
                    <Pill className="h-4 w-4 text-primary" />
                  </div>
                  <div className="mt-2.5">
                    <p className="text-xs font-bold text-foreground">Amoxicillin 500mg</p>
                    <p className="text-[11px] text-muted-foreground mt-0.5">
                      1 tablet · 3 times daily after meals
                    </p>
                  </div>
                  <div className="mt-3 flex items-center justify-between pt-2 border-t border-border/60 text-[11px]">
                    <span className="text-emerald-600 dark:text-emerald-400 font-semibold flex items-center gap-1">
                      <CheckCircle2 className="h-3 w-3" /> Signed by Dr. Jenkins
                    </span>
                    <span className="text-primary font-medium">Download Rx</span>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
        </section>

        {/* ── STATS STRIP ─────────────────────────────────────────── */}
        <section className="border-y border-border/60 bg-muted/30 py-10">
          <div className="page-container !py-0">
            <div className="grid grid-cols-2 gap-6 sm:grid-cols-4">
              {STATS.map((stat) => (
                <div key={stat.label} className="text-center">
                  <div className="text-3xl font-extrabold tracking-tight sm:text-4xl text-primary">
                    {stat.value}
                  </div>
                  <div className="mt-1 text-sm font-semibold text-foreground">{stat.label}</div>
                  <div className="mt-0.5 text-xs text-muted-foreground">{stat.detail}</div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ── CORE MEDICAL FEATURES ───────────────────────────────── */}
        <section id="services" className="page-container py-20" aria-label="Our Healthcare Services">
          <div className="text-center max-w-2xl mx-auto mb-14">
            <span className="text-xs font-bold uppercase tracking-wider text-primary">
              What We Offer
            </span>
            <h2 className="mt-2 text-3xl font-bold tracking-tight sm:text-4xl text-foreground">
              Everything You Need for Clinic Visits
            </h2>
            <p className="mt-3 text-sm text-muted-foreground leading-relaxed">
              Better Clinic eliminates long waiting lines and administrative hassles so patients
              and medical professionals can focus on what matters most — health and care.
            </p>
          </div>

          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {/* Feature 1 */}
            <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-teal-50 text-teal-700 dark:bg-teal-950/40 dark:text-teal-300">
                <Search className="h-5 w-5" />
              </div>
              <h3 className="mt-4 text-base font-bold text-foreground">Find the Right Specialist</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                Search licensed doctors and clinics by medical specialty, consultation fees, patient
                ratings, and immediate slot availability.
              </p>
            </div>

            {/* Feature 2 */}
            <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-primary/10 text-primary">
                <CalendarCheck className="h-5 w-5" />
              </div>
              <h3 className="mt-4 text-base font-bold text-foreground">Guaranteed Appointment Slots</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                Book with instant confirmation. Double-booking protection ensures your reserved time is
                exclusively yours with easy rescheduling.
              </p>
            </div>

            {/* Feature 3 */}
            <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-emerald-50 text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-300">
                <Clock className="h-5 w-5" />
              </div>
              <h3 className="mt-4 text-base font-bold text-foreground">Live Waiting Room Queue</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                Check in digitally and track your token position from anywhere. Arrive at the clinic
                just in time for your consultation.
              </p>
            </div>

            {/* Feature 4 */}
            <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-sky-50 text-sky-700 dark:bg-sky-950/40 dark:text-sky-300">
                <ClipboardList className="h-5 w-5" />
              </div>
              <h3 className="mt-4 text-base font-bold text-foreground">Structured Digital Prescriptions</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                Receive clear, legible medication instructions with exact dosages, frequency, and duration.
                Download or print anytime.
              </p>
            </div>

            {/* Feature 5 */}
            <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-amber-50 text-amber-700 dark:bg-amber-950/40 dark:text-amber-300">
                <HeartPulse className="h-5 w-5" />
              </div>
              <h3 className="mt-4 text-base font-bold text-foreground">Personal Health Assistant</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                An intelligent healthcare assistant that can answer questions about your consultation history
                and medication schedules safely.
              </p>
            </div>

            {/* Feature 6 */}
            <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-indigo-50 text-indigo-700 dark:bg-indigo-950/40 dark:text-indigo-300">
                <FileCheck2 className="h-5 w-5" />
              </div>
              <h3 className="mt-4 text-base font-bold text-foreground">Complete Health History</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                All your diagnoses, doctor consultation notes, past prescriptions, and follow-up visits
                organized in one confidential timeline.
              </p>
            </div>
          </div>
        </section>

        {/* ── ROLE PORTALS SHOWCASE ────────────────────────────────── */}
        <section id="portals" className="border-t border-border/60 bg-muted/20 py-20">
          <div className="page-container !py-0">
            <div className="text-center max-w-2xl mx-auto mb-14">
              <span className="text-xs font-bold uppercase tracking-wider text-primary">
                Designed for Healthcare
              </span>
              <h2 className="mt-2 text-3xl font-bold tracking-tight sm:text-4xl text-foreground">
                Dedicated Spaces for Patients & Clinic Staff
              </h2>
              <p className="mt-3 text-sm text-muted-foreground leading-relaxed">
                Each participant gets a customized, distraction-free interface tailored to their
                exact daily needs.
              </p>
            </div>

            <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
              {ROLES.map((role) => (
                <div
                  key={role.role}
                  className="flex flex-col justify-between rounded-2xl border border-border/80 bg-card p-6 shadow-sm medical-card"
                >
                  <div>
                    <div className="flex items-center justify-between">
                      <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 text-primary">
                        <role.icon className="h-5 w-5" />
                      </div>
                      <span className={`rounded-full px-2.5 py-0.5 text-[10px] font-bold border ${role.badgeColor}`}>
                        {role.badge}
                      </span>
                    </div>
                    <h3 className="mt-4 text-base font-bold text-foreground">{role.title}</h3>
                    <p className="text-xs font-medium text-primary mt-0.5">{role.subtitle}</p>
                    <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
                      {role.description}
                    </p>
                  </div>
                  <div className="mt-6 pt-4 border-t border-border/60">
                    <Button asChild variant="outline" size="sm" className="w-full justify-between">
                      <Link href={role.href}>
                        <span>Open {role.title}</span>
                        <ArrowRight className="h-3.5 w-3.5" />
                      </Link>
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ── CALL TO ACTION BANNER ─────────────────────────────────── */}
        <section className="page-container py-16">
          <div className="rounded-3xl border border-primary/20 bg-gradient-to-br from-primary/10 via-primary/5 to-card p-8 sm:p-12 text-center shadow-lg">
            <h2 className="text-2xl font-bold tracking-tight sm:text-4xl text-foreground">
              Ready for a Better Healthcare Experience?
            </h2>
            <p className="mx-auto mt-3 max-w-xl text-sm sm:text-base text-muted-foreground leading-relaxed">
              Join thousands of patients and healthcare providers enjoying seamless clinic visits,
              live queues, and organized medical records.
            </p>
            <div className="mt-7 flex flex-wrap items-center justify-center gap-3.5">
              <Button
                asChild
                size="lg"
                className="h-11 px-7 rounded-xl bg-primary text-primary-foreground font-semibold shadow-md hover:bg-primary/90"
              >
                <Link href="/signup">Get Started Free</Link>
              </Button>
              <Button
                asChild
                size="lg"
                variant="outline"
                className="h-11 px-7 rounded-xl border-border bg-card hover:bg-muted"
              >
                <Link href="/login">Sign In to Your Account</Link>
              </Button>
            </div>
          </div>
        </section>
      </main>

      {/* ── RESPECTFUL HEALTHCARE FOOTER ──────────────────────────── */}
      <footer className="border-t border-border/60 bg-card py-10">
        <div className="page-container flex flex-col items-center justify-between gap-4 text-xs text-muted-foreground sm:flex-row !py-0">
          <div className="flex items-center gap-2.5">
            <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-primary text-primary-foreground">
              <Stethoscope className="h-4 w-4" aria-hidden />
            </div>
            <span className="font-bold text-foreground">Better Clinic</span>
            <span>— Smart Digital Healthcare</span>
          </div>

          <div className="flex flex-wrap items-center gap-6">
            <Link href="/choose-role" className="hover:text-foreground transition-colors">
              Role Switcher
            </Link>
            <Link href="/login" className="hover:text-foreground transition-colors">
              Sign In
            </Link>
            <div className="flex items-center gap-1.5 font-semibold text-rose-600 dark:text-rose-400">
              <PhoneCall className="h-3.5 w-3.5" />
              <span>Medical Emergency: Call 108</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
