"use client";

import { useEffect, useState, type ReactNode } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useFormState } from "react-dom";
import {
  ArrowRight,
  Stethoscope,
  AlertCircle,
  Loader2,
  User,
  Users,
} from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { signUpAction, type FormState } from "@/app/(auth)/actions";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured } from "@/lib/env";
import { SEX_LABELS, SEXES } from "@/lib/constants";

const images = [
  "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=800&q=80",
  "https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&w=800&q=80",
  "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=800&q=80",
  "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?auto=format&fit=crop&w=800&q=80",
];

const highlights = [
  "Find top verified specialists, book instant slots, and skip clinic waiting rooms with live digital tokens.",
  "Direct electronic prescriptions with dosage schedules, follow-up alerts, and verifiable medical records.",
  "Unified clinical workspace for doctors, front-desk receptionists, and clinic management.",
  "Private and secure health records protected with role-based medical access controls.",
];

type Role = "PATIENT" | "DOCTOR" | "RECEPTIONIST";

const initialState: FormState = {};

interface AuthSectionTwoProps {
  specializations?: { id: string; name: string }[];
  clinics?: { id: string; name: string; city: string }[];
  disabled?: boolean;
}

export default function AuthSectionTwo({
  specializations = [],
  clinics = [],
  disabled = false,
}: AuthSectionTwoProps) {
  const router = useRouter();
  const [activeIndex, setActiveIndex] = useState(0);
  const [state, formAction, pending] = useFormState(signUpAction, initialState);
  const [role, setRole] = useState<Role>("PATIENT");
  const [specializationId, setSpecializationId] = useState("");
  const [clinicId, setClinicId] = useState("");
  const [sex, setSex] = useState("");
  const [socialLoading, setSocialLoading] = useState<string | null>(null);

  // Auto-advance carousel
  useEffect(() => {
    const interval = window.setInterval(() => {
      setActiveIndex((current) => (current + 1) % images.length);
    }, 3200);

    return () => window.clearInterval(interval);
  }, []);

  // Handle redirect after successful sign up
  useEffect(() => {
    if (state.redirectUrl) {
      router.replace(state.redirectUrl);
      router.refresh();
    }
  }, [state.redirectUrl, router]);

  const handleOAuth = async (provider: "google" | "apple") => {
    setSocialLoading(provider);
    if (!isSupabaseConfigured()) {
      try {
        const { quickDemoLoginAction } = await import("@/app/(auth)/actions");
        const res = await quickDemoLoginAction("PATIENT");
        if (res.redirectUrl) {
          router.replace(res.redirectUrl);
          router.refresh();
        }
      } catch {
        setSocialLoading(null);
      }
      return;
    }
    try {
      const supabase = createClient();
      await supabase.auth.signInWithOAuth({
        provider,
        options: {
          redirectTo: `${window.location.origin}/auth/callback`,
        },
      });
    } catch {
      setSocialLoading(null);
    }
  };

  return (
    <section className="min-h-screen bg-background text-foreground antialiased [font-synthesis:none]">
      <div className="grid min-h-screen lg:grid-cols-[0.92fr_1.08fr]">
        {/* Left Side: Modern Medical Showcase */}
        <div className="hidden lg:flex min-h-[760px] justify-center overflow-hidden bg-slate-950 px-8 py-12 text-white sm:px-10 lg:min-h-0 lg:py-16 xl:py-20">
          <div className="flex w-full max-w-[480px] flex-col items-center justify-between">
            {/* Brand Header */}
            <Link href="/" className="flex items-center gap-3 text-lg font-bold text-white group">
              <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-teal-500 text-slate-950 shadow-md">
                <Stethoscope className="h-5 w-5" aria-hidden />
              </div>
              <span>Better Clinic</span>
            </Link>

            {/* Carousel Tiles */}
            <div className="relative mt-8 grid w-full grid-cols-[1.55fr_1fr] gap-2 rounded-xl">
              <div className="pointer-events-none absolute inset-x-0 top-0 z-20 h-16 bg-gradient-to-b from-slate-950 to-transparent" />
              <div className="pointer-events-none absolute inset-x-0 bottom-0 z-20 h-20 bg-gradient-to-t from-slate-950 to-transparent" />

              <ImageTile
                src={images[0]}
                active={activeIndex === 0}
                className="row-span-2 h-[240px]"
              />
              <ImageTile
                src={images[1]}
                active={activeIndex === 1}
                className="h-[116px]"
              />
              <ImageTile
                src={images[3]}
                active={activeIndex === 3}
                className="h-[116px]"
              />
              <ImageTile
                src={images[2]}
                active={activeIndex === 2}
                className="col-span-2 h-[116px]"
              />
            </div>

            {/* Dynamic Quote Box */}
            <div className="mt-6 w-full rounded-xl border border-white/15 bg-white/5 px-5 py-4 backdrop-blur-md">
              <div className="flex items-end gap-4">
                <p className="line-clamp-3 flex-1 text-xs leading-relaxed text-white/70">
                  <span className="font-semibold text-white">Better Clinic Care:</span>{" "}
                  {highlights[activeIndex]}
                </p>
                <button
                  type="button"
                  aria-label="Next highlight"
                  onClick={() => setActiveIndex((current) => (current + 1) % images.length)}
                  className="grid size-8 shrink-0 place-items-center rounded-full bg-white/20 text-white transition-colors hover:bg-white/30"
                >
                  <ArrowRight className="size-4" />
                </button>
              </div>
            </div>

            <p className="mt-6 text-center text-lg font-medium text-white/90">
              Compassionate, connected care for patients and doctors
            </p>

            {/* Pagination Dots */}
            <div className="mt-6 flex gap-2">
              {highlights.map((_, index) => (
                <button
                  key={index}
                  type="button"
                  onClick={() => setActiveIndex(index)}
                  className={
                    activeIndex === index
                      ? "h-1.5 w-8 rounded-full bg-teal-400 transition-all duration-300"
                      : "h-1.5 w-3 rounded-full bg-white/30 transition-all duration-300 hover:bg-white/50"
                  }
                  aria-label={`Highlight ${index + 1}`}
                />
              ))}
            </div>
          </div>
        </div>

        {/* Right Side: Supabase Powered Auth Form */}
        <div className="flex min-h-screen items-center justify-center p-6 sm:p-10 lg:p-12 xl:p-16">
          <div className="w-full max-w-[480px]">
            {/* Mobile Header Logo */}
            <div className="mb-6 flex items-center justify-between lg:hidden">
              <Link href="/" className="flex items-center gap-2">
                <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                  <Stethoscope className="h-4 w-4" aria-hidden />
                </div>
                <span className="font-bold text-base">Better Clinic</span>
              </Link>
              <Link href="/login" className="text-xs font-semibold text-primary">
                Sign in
              </Link>
            </div>

            <div className="text-left">
              <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
                Create an account
              </h1>
              <p className="mt-1.5 text-sm text-muted-foreground">
                Already registered?{" "}
                <Link href="/login" className="font-semibold text-primary hover:underline">
                  Sign in here
                </Link>
              </p>
            </div>

            {/* Social Logins */}
            <div className="mt-6 grid gap-3 sm:grid-cols-2">
              <SocialButton
                onClick={() => handleOAuth("google")}
                loading={socialLoading === "google"}
                icon={<GoogleIcon />}
                label="Sign up with Google"
              />
              <SocialButton
                onClick={() => handleOAuth("apple")}
                loading={socialLoading === "apple"}
                icon={<AppleIcon />}
                label="Sign up with Apple"
              />
            </div>

            {/* Divider */}
            <div className="my-6 flex items-center gap-4 text-xs font-medium text-muted-foreground uppercase">
              <div className="h-px flex-1 bg-border" />
              <span>or continue with email</span>
              <div className="h-px flex-1 bg-border" />
            </div>

            {/* Role selector tabs */}
            <div className="mb-5 grid grid-cols-3 gap-1 rounded-xl bg-muted p-1">
              <button
                type="button"
                onClick={() => setRole("PATIENT")}
                className={`flex items-center justify-center gap-1.5 rounded-lg py-2 text-xs font-bold transition-all ${
                  role === "PATIENT"
                    ? "bg-card text-foreground shadow-xs"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                <User className="h-3.5 w-3.5" />
                <span>Patient</span>
              </button>
              <button
                type="button"
                onClick={() => setRole("DOCTOR")}
                className={`flex items-center justify-center gap-1.5 rounded-lg py-2 text-xs font-bold transition-all ${
                  role === "DOCTOR"
                    ? "bg-card text-foreground shadow-xs"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                <Stethoscope className="h-3.5 w-3.5" />
                <span>Doctor</span>
              </button>
              <button
                type="button"
                onClick={() => setRole("RECEPTIONIST")}
                className={`flex items-center justify-center gap-1.5 rounded-lg py-2 text-xs font-bold transition-all ${
                  role === "RECEPTIONIST"
                    ? "bg-card text-foreground shadow-xs"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                <Users className="h-3.5 w-3.5" />
                <span>Staff</span>
              </button>
            </div>

            {/* Supabase Error Alerts */}
            {state.error ? (
              <Alert variant="destructive" className="mb-5">
                <AlertCircle className="h-4 w-4" aria-hidden />
                <AlertDescription>{state.error}</AlertDescription>
              </Alert>
            ) : null}

            {/* Form */}
            <form action={formAction} className="space-y-4 text-left">
              <input type="hidden" name="role" value={role} />

              {/* Full Name */}
              <div>
                <label className="block text-xs font-medium text-foreground mb-1">
                  Full Name
                </label>
                <input
                  required
                  name="full_name"
                  type="text"
                  placeholder="e.g. Dr. Sarah Jenkins or John Doe"
                  className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
                />
                {state.fieldErrors?.full_name ? (
                  <p className="mt-1 text-xs text-destructive">{state.fieldErrors.full_name}</p>
                ) : null}
              </div>

              {/* Email & Phone Row */}
              <div className="grid gap-3 sm:grid-cols-2">
                <div>
                  <label className="block text-xs font-medium text-foreground mb-1">
                    Email Address
                  </label>
                  <input
                    required
                    name="email"
                    type="email"
                    placeholder="you@example.com"
                    className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
                  />
                  {state.fieldErrors?.email ? (
                    <p className="mt-1 text-xs text-destructive">{state.fieldErrors.email}</p>
                  ) : null}
                </div>
                <div>
                  <label className="block text-xs font-medium text-foreground mb-1">
                    Phone Number
                  </label>
                  <input
                    required
                    name="phone"
                    type="tel"
                    placeholder="10-digit mobile"
                    className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
                  />
                  {state.fieldErrors?.phone ? (
                    <p className="mt-1 text-xs text-destructive">{state.fieldErrors.phone}</p>
                  ) : null}
                </div>
              </div>

              {/* Password */}
              <div>
                <label className="block text-xs font-medium text-foreground mb-1">
                  Password
                </label>
                <input
                  required
                  name="password"
                  type="password"
                  placeholder="At least 8 characters (letters & numbers)"
                  className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
                />
                {state.fieldErrors?.password ? (
                  <p className="mt-1 text-xs text-destructive">{state.fieldErrors.password}</p>
                ) : null}
              </div>

              {/* Patient Fields */}
              {role === "PATIENT" ? (
                <div className="grid gap-3 sm:grid-cols-2">
                  <div>
                    <label className="block text-xs font-medium text-foreground mb-1">
                      Date of Birth
                    </label>
                    <input
                      name="date_of_birth"
                      type="date"
                      className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-foreground mb-1">
                      Sex
                    </label>
                    <select
                      name="sex"
                      value={sex}
                      onChange={(e) => setSex(e.target.value)}
                      className="w-full h-11 rounded-xl border border-input bg-card px-3 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
                    >
                      <option value="">Select sex</option>
                      {SEXES.map((s) => (
                        <option key={s} value={s}>
                          {SEX_LABELS[s]}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>
              ) : null}

              {/* Doctor Fields */}
              {role === "DOCTOR" ? (
                <div className="space-y-3 pt-1">
                  <div className="grid gap-3 sm:grid-cols-2">
                    <div>
                      <label className="block text-xs font-medium text-foreground mb-1">
                        Qualification
                      </label>
                      <input
                        required
                        name="qualification"
                        placeholder="e.g. MBBS, MD (Medicine)"
                        className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-medium text-foreground mb-1">
                        Registration Number
                      </label>
                      <input
                        required
                        name="registration_number"
                        placeholder="e.g. MCI-2015-8839"
                        className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary"
                      />
                    </div>
                  </div>

                  <div className="grid gap-3 sm:grid-cols-2">
                    <div>
                      <label className="block text-xs font-medium text-foreground mb-1">
                        Specialization
                      </label>
                      <select
                        required
                        name="specialization_id"
                        value={specializationId}
                        onChange={(e) => setSpecializationId(e.target.value)}
                        className="w-full h-11 rounded-xl border border-input bg-card px-3 text-sm outline-none transition-colors focus:border-primary"
                      >
                        <option value="">Select specialty</option>
                        {specializations.map((spec) => (
                          <option key={spec.id} value={spec.id}>
                            {spec.name}
                          </option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block text-xs font-medium text-foreground mb-1">
                        Years of Experience
                      </label>
                      <input
                        required
                        name="experience_years"
                        type="number"
                        min="0"
                        max="60"
                        placeholder="e.g. 8"
                        className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-xs font-medium text-foreground mb-1">
                      Primary Clinic (Optional)
                    </label>
                    <select
                      name="clinic_id"
                      value={clinicId}
                      onChange={(e) => setClinicId(e.target.value)}
                      className="w-full h-11 rounded-xl border border-input bg-card px-3 text-sm outline-none transition-colors focus:border-primary"
                    >
                      <option value="">No clinic initially</option>
                      {clinics.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.name} ({c.city})
                        </option>
                      ))}
                    </select>
                  </div>
                </div>
              ) : null}

              {/* Staff Fields */}
              {role === "RECEPTIONIST" ? (
                <div className="space-y-3 pt-1">
                  <div>
                    <label className="block text-xs font-medium text-foreground mb-1">
                      Assigned Clinic
                    </label>
                    <select
                      required
                      name="clinic_id"
                      value={clinicId}
                      onChange={(e) => setClinicId(e.target.value)}
                      className="w-full h-11 rounded-xl border border-input bg-card px-3 text-sm outline-none transition-colors focus:border-primary"
                    >
                      <option value="">Select clinic</option>
                      {clinics.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.name} ({c.city})
                        </option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-foreground mb-1">
                      Staff Invite Code
                    </label>
                    <input
                      required
                      name="staff_invite_code"
                      placeholder="Enter invite code provided by clinic admin"
                      className="w-full h-11 rounded-xl border border-input bg-card px-3.5 text-sm outline-none transition-colors focus:border-primary"
                    />
                  </div>
                </div>
              ) : null}

              {/* Terms checkbox */}
              <div className="pt-2">
                <label className="flex items-start gap-2.5 text-xs text-muted-foreground cursor-pointer">
                  <input
                    type="checkbox"
                    required
                    defaultChecked
                    className="mt-0.5 rounded border-border text-primary focus:ring-primary"
                  />
                  <span>
                    By creating an account, you agree to our{" "}
                    <span className="text-foreground underline">Terms of Service</span> and{" "}
                    <span className="text-foreground underline">Privacy Policy</span>.
                  </span>
                </label>
              </div>

              {/* Submit button */}
              <button
                type="submit"
                disabled={disabled || pending}
                className="mt-4 flex h-12 w-full items-center justify-center rounded-xl bg-primary text-base font-bold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 disabled:opacity-50"
              >
                {pending ? (
                  <span className="flex items-center gap-2">
                    <Loader2 className="h-4 w-4 animate-spin" />
                    Creating account…
                  </span>
                ) : (
                  <span>Create account</span>
                )}
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>
  );
}

function ImageTile({
  src,
  active,
  className,
}: {
  src: string;
  active: boolean;
  className: string;
}) {
  return (
    <div className={`${className} relative overflow-visible rounded-xl ${active ? "z-10" : "z-0"}`}>
      <img
        src={src}
        alt="Better Clinic Care"
        className={`h-full w-full rounded-xl object-cover transition-opacity duration-700 ${
          active ? "opacity-100" : "opacity-35"
        }`}
      />
      <FocusCorners active={active} />
    </div>
  );
}

function FocusCorners({ active }: { active: boolean }) {
  const baseClass = `pointer-events-none absolute h-4 w-4 border-teal-400 transition-all duration-500 ease-out ${
    active ? "translate-x-0 translate-y-0 opacity-100" : "opacity-0"
  }`;

  return (
    <>
      <div
        className={`${baseClass} -left-1.5 -top-1.5 border-l-2 border-t-2 ${
          active ? "" : "-translate-x-2 -translate-y-2"
        }`}
      />
      <div
        className={`${baseClass} -right-1.5 -top-1.5 border-r-2 border-t-2 ${
          active ? "" : "translate-x-2 -translate-y-2"
        }`}
      />
      <div
        className={`${baseClass} -bottom-1.5 -left-1.5 border-b-2 border-l-2 ${
          active ? "" : "-translate-x-2 translate-y-2"
        }`}
      />
      <div
        className={`${baseClass} -bottom-1.5 -right-1.5 border-b-2 border-r-2 ${
          active ? "" : "translate-x-2 translate-y-2"
        }`}
      />
    </>
  );
}

function SocialButton({
  icon,
  label,
  onClick,
  loading,
}: {
  icon: ReactNode;
  label: string;
  onClick?: () => void;
  loading?: boolean;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={loading}
      className="flex h-10 items-center justify-center gap-2 rounded-xl border border-input bg-card px-3 text-xs font-semibold text-foreground transition-all hover:bg-muted disabled:opacity-60"
    >
      {loading ? <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" /> : icon}
      <span className="truncate">{label}</span>
    </button>
  );
}

function GoogleIcon() {
  return (
    <svg width="15" height="15" viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09Z"
        fill="#4285F4"
      />
      <path
        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23Z"
        fill="#34A853"
      />
      <path
        d="M5.84 14.1c-.22-.66-.35-1.36-.35-2.1s.13-1.44.35-2.1V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l3.66-2.84Z"
        fill="#FBBC05"
      />
      <path
        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84C6.71 7.3 9.14 5.38 12 5.38Z"
        fill="#EB4335"
      />
    </svg>
  );
}

function AppleIcon() {
  return (
    <svg
      width="15"
      height="15"
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden="true"
    >
      <path d="M17.05 12.54c-.03-3.02 2.47-4.47 2.58-4.54-1.41-2.06-3.6-2.34-4.38-2.37-1.86-.19-3.64 1.1-4.58 1.1-.95 0-2.42-1.07-3.98-1.04-2.05.03-3.94 1.19-4.99 3.02-2.13 3.69-.54 9.16 1.53 12.15 1.01 1.46 2.22 3.1 3.81 3.04 1.53-.06 2.11-.99 3.96-.99s2.37.99 3.99.96c1.65-.03 2.69-1.49 3.69-2.96 1.16-1.69 1.64-3.33 1.66-3.41-.04-.02-3.2-1.23-3.24-4.87ZM14.03 3.66c.84-1.02 1.41-2.43 1.25-3.84-1.21.05-2.68.81-3.55 1.83-.78.9-1.46 2.34-1.28 3.72 1.35.1 2.73-.69 3.58-1.71Z" />
    </svg>
  );
}
