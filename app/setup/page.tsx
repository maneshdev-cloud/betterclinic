import type { Metadata } from "next";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { SetupNotice } from "@/components/shared/setup-notice";

export const metadata: Metadata = { title: "Setup" };

const ENV_VARS: { name: string; where: string; required: boolean; note: string }[] = [
  {
    name: "NEXT_PUBLIC_SUPABASE_URL",
    where: "Project Settings → API → Project URL",
    required: true,
    note: "e.g. https://abcdefgh.supabase.co",
  },
  {
    name: "NEXT_PUBLIC_SUPABASE_ANON_KEY",
    where: "Project Settings → API → Project API keys → anon / public",
    required: true,
    note: "Safe for the browser (RLS protects your data).",
  },
  {
    name: "SUPABASE_SERVICE_ROLE_KEY",
    where: "Project Settings → API → Project API keys → service_role",
    required: true,
    note: "Server-only. Used for seeding and admin actions. Never expose it.",
  },
  {
    name: "DATABASE_URL",
    where: "Project Settings → Database → Connection string → URI",
    required: true,
    note: "Used only by local scripts (migrations, seed, RLS tests). Replace [YOUR-PASSWORD].",
  },
  {
    name: "NEXT_PUBLIC_APP_ENV",
    where: "—",
    required: false,
    note: "Enables simulations and seed fixtures; production disables them.",
  },
  {
    name: "AI_API_KEY",
    where: "Your LLM provider (optional)",
    required: false,
    note: "Any OpenAI-compatible key. Without it the assistant uses its deterministic fallback.",
  },
];

export default function SetupPage() {
  return (
    <div className="page-container max-w-3xl py-10">
      <h1 className="text-xl font-semibold tracking-tight">Connect your Supabase project</h1>
      <p className="mt-1 text-sm text-muted-foreground">
        Better Clinic uses Supabase for its PostgreSQL database, authentication, row-level security
        and realtime updates. This page walks you through connecting your own free project.
      </p>

      <div className="mt-6">
        <SetupNotice />
      </div>

      <section className="mt-8" aria-label="Environment variables">
        <h2 className="text-sm font-semibold">1. Fill .env.local</h2>
        <p className="mt-1 text-sm text-muted-foreground">
          Every variable is pre-created as an empty placeholder in{" "}
          <span className="font-mono text-xs">.env.local</span> — just paste your values in.
        </p>
        <div className="mt-3 overflow-x-auto rounded-lg border">
          <table className="w-full min-w-[640px] text-left text-sm">
            <thead className="border-b bg-muted/50 text-xs uppercase tracking-wide text-muted-foreground">
              <tr>
                <th className="px-4 py-2.5 font-medium">Variable</th>
                <th className="px-4 py-2.5 font-medium">Where to find it</th>
                <th className="px-4 py-2.5 font-medium">Notes</th>
              </tr>
            </thead>
            <tbody>
              {ENV_VARS.map((v) => (
                <tr key={v.name} className="border-b last:border-0">
                  <td className="px-4 py-2.5">
                    <span className="font-mono text-xs">{v.name}</span>
                    {v.required ? (
                      <span className="ml-2 text-[11px] font-medium text-destructive">required</span>
                    ) : (
                      <span className="ml-2 text-[11px] text-muted-foreground">optional</span>
                    )}
                  </td>
                  <td className="px-4 py-2.5 text-muted-foreground">{v.where}</td>
                  <td className="px-4 py-2.5 text-muted-foreground">{v.note}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      <section className="mt-8" aria-label="Database setup commands">
        <h2 className="text-sm font-semibold">2. Create the database schema</h2>
        <pre className="mt-2 overflow-x-auto rounded-lg border bg-muted/50 p-4 text-xs leading-relaxed">
{`npm install
npm run db:push     # applies all migrations (schema, functions, RLS, storage)`}
        </pre>
        <p className="mt-2 text-sm text-muted-foreground">
          Recommended for local development: in Supabase → Authentication → Providers → Email,
          turn <span className="font-medium">“Confirm email”</span> off so new sign-ups can sign
          in immediately. (In production, keep it on.)
        </p>
      </section>

      <section className="mt-8" aria-label="Seed data">
        <h2 className="text-sm font-semibold">3. Seed initial clinic data</h2>
        <pre className="mt-2 overflow-x-auto rounded-lg border bg-muted/50 p-4 text-xs leading-relaxed">
{`npm run seed        # interconnected clinic dataset
npm run verify:rls  # tests that RLS blocks cross-role / cross-patient access`}
        </pre>
        <p className="mt-2 text-sm text-muted-foreground">
          Default test accounts (one per role) are printed by the seed script and documented in the README.
        </p>
      </section>

      <section className="mt-8" aria-label="Run">
        <h2 className="text-sm font-semibold">4. Run the app</h2>
        <pre className="mt-2 overflow-x-auto rounded-lg border bg-muted/50 p-4 text-xs leading-relaxed">
{`npm run dev         # http://localhost:3000`}
        </pre>
      </section>

      <div className="mt-10">
        <Button asChild variant="outline">
          <Link href="/">← Back to home</Link>
        </Button>
      </div>
    </div>
  );
}
