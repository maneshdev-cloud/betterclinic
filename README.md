# Better Clinic — Smart Digital Healthcare Platform

A realistic, functional digital healthcare ecosystem for **patients, doctors, receptionists and clinic admins** — built as a final-year engineering prototype on a real relational database with role-based security, deterministic business logic, realtime updates and an application-aware AI assistant.

> **Status: Phase 1 of 9 complete** (foundation: schema, auth, RLS, app shell).
> See [Build progress](#build-progress) for exactly what works today.

---

## Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Tech stack](#tech-stack)
4. [Quick start](#quick-start)
5. [Environment variables](#environment-variables)
6. [Database setup](#database-setup)
7. [Authentication & roles](#authentication--roles)
8. [Seed / demo data](#seed--demo-data)
9. [Demo vs production mode](#demo-vs-production-mode)
10. [AI assistant configuration](#ai-assistant-configuration)
11. [Medication reminders](#medication-reminders)
12. [Testing](#testing)
13. [Project structure](#project-structure)
14. [Deployment](#deployment)
15. [Security notes](#security-notes)
16. [Known limitations](#known-limitations)
17. [Build progress](#build-progress)

---

## Overview

Better Clinic connects the whole clinic workflow on one database:

- **Patients** discover doctors/clinics, book real appointments from data-driven slots, check in, watch a live token queue, and manage prescriptions, medication schedules, follow-ups and their medical history.
- **Doctors** manage availability, run the operational queue, document consultations, and write structured prescriptions that generate medication schedules and follow-ups.
- **Receptionists** manage walk-ins, check-ins, tokens and the live queue — with operational visibility but **no access to clinical history**.
- **Clinic admins** oversee their clinic: staff, doctors, and analytics computed from real records only.

Every action is written to PostgreSQL through validated, race-safe database functions; every sensitive table is protected by Row Level Security.

## Architecture

```
UI (React components)
  → Pages / Screen components (App Router)
    → Feature components
      → Application services (services/*)         ← business logic lives here
        → Supabase clients (lib/supabase/*)
          → PostgreSQL: tables + RLS + security-definer RPCs
             (booking, queue, consultation — race-safe & validated in the DB)
```

**Why RPCs?** Multi-step operations (book → occupy slot → notify → audit; check-in → create queue entry → assign token) must be atomic. Since supabase-js cannot run multi-statement transactions from the browser, these flows are implemented as `SECURITY DEFINER` PostgreSQL functions (see `supabase/migrations/00002_functions.sql`) that re-validate permissions and inputs internally. Direct writes to protected tables (appointments, slots, queue) are denied by RLS for all client roles — mutations can only go through the functions. This is what makes double-booking impossible even under concurrent requests.

## Tech stack

| Layer | Choice |
|---|---|
| Framework | Next.js 14 (App Router) + TypeScript |
| Database & Auth | Supabase (PostgreSQL, Supabase Auth, RLS, Realtime, Storage) |
| Styling & UI | Tailwind CSS + shadcn/ui-style primitives (Radix) |
| Forms & validation | Zod (shared schemas) |
| Charts | Recharts |
| Tests | Vitest (unit) + SQL verification suites (integration) |
| Hosting | Vercel (frontend) + Supabase (backend) — free tier friendly |

## Quick start

```bash
# 1. Install dependencies
npm install

# 2. Connect your Supabase project — paste your values into .env.local
#    (placeholders are already there; see the table below for where to find each)
cp .env.example .env.local   # if not already present
$EDITOR .env.local

# 3. Create the database schema (tables, functions, RLS, storage)
npm run db:push

# 4. (Recommended for development) allow sign-in without email confirmation:
#    Supabase Dashboard → Authentication → Providers → Email → turn OFF "Confirm email"

# 5. Run the app
npm run dev                  # http://localhost:3000

# 6. Verify security & business logic against your database (optional but recommended)
npm run verify:rls           # 25 checks: RLS blocks cross-role/cross-patient access
npm run verify:workflows     # 52 checks: booking → queue → consultation → prescription
```

The app boots **without** Supabase values too — every screen degrades to a friendly setup guide instead of crashing.

## Environment variables

All configuration lives in `.env.local` (never committed; `.env.example` documents every variable).

| Variable | Required | Where to find it | Notes |
|---|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | yes | Supabase → Project Settings → API → Project URL | e.g. `https://xxxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | yes | Project Settings → API → anon / public | Safe for the browser; RLS protects data |
| `SUPABASE_SERVICE_ROLE_KEY` | yes (for seeding / admin actions) | Project Settings → API → service_role | **Server-only. Never expose.** |
| `DATABASE_URL` | yes (for local scripts only) | Project Settings → Database → Connection string → URI | Used by `db:push`, seed, verification suites. Replace `[YOUR-PASSWORD]` |
| `NEXT_PUBLIC_APP_ENV` | no (`demo` default) | — | `demo` or `production` — see [Demo vs production](#demo-vs-production-mode) |
| `AI_PROVIDER` / `AI_BASE_URL` / `AI_MODEL` / `AI_API_KEY` | no | your LLM provider | Optional; assistant falls back deterministically |
| `MAPS_API_KEY` | no | maps provider | Optional; not required for core features |
| `NEXT_PUBLIC_APP_URL` | no | — | Used in auth emails; falls back to request origin |

## Database setup

Migrations are plain, **idempotent** SQL — no Supabase CLI required:

| File | Contents |
|---|---|
| `supabase/migrations/00001_schema.sql` | 36 tables, enums, constraints, indexes |
| `supabase/migrations/00002_functions.sql` | signup trigger, state machines, token generator, slot generator, all business-logic RPCs, audit & notification helpers, realtime publication |
| `supabase/migrations/00003_rls.sql` | Row Level Security for every table + PostgREST role grants |
| `supabase/migrations/00004_storage.sql` | `avatars` storage bucket + owner-scoped policies |
| `supabase/migrations/00005_clinic_facilities.sql` | `clinics.facilities` badge column |
| `supabase/migrations/00006_ensure_slots_regenerate.sql` | `ensure_slots` regenerates missing FREE slots alongside surviving BOOKED ones |
| `supabase/migrations/00007_queue_return_to_waiting_fix.sql` | fixes the column mismatch that broke returning a called-but-absent token to the queue |

```bash
npm run db:push        # apply everything (safe to re-run)
npm run db:fresh       # DROP public schema and re-apply (development only)
npm run db:production  # switch the DATABASE to production mode (app_settings)
```

`db:fresh` refuses to run when `NEXT_PUBLIC_APP_ENV=production`.

## Authentication & roles

- **Supabase Auth** (email + password) with cookie-based sessions (`@supabase/ssr`), refreshed by middleware.
- On signup, a database trigger (`handle_new_user`) creates the profile **and** the role-specific rows (`patients` / `doctors` + specializations / `clinic_staff`):
  - **Patients** self-register freely.
  - **Doctors** self-register with qualification, registration number, specialization and (optionally) their clinic.
  - **Receptionists / Clinic admins** must supply their clinic + the clinic's **staff invite code** (visible to that clinic's admin) — strangers cannot grant themselves staff access.
- Password reset via email; role-based routing in middleware (fast JWT claim check) **and** in every role layout (database-backed check). The real enforcement is RLS.

## Seed / demo data

The full synthetic dataset (500+ patients, 100+ doctors, 50+ clinics, interconnected appointments, queues, consultations, prescriptions, schedules, follow-ups, notifications and reviews — fictional Indian names and locations) is generated in **Phase 8** by:

```bash
npm run seed          # relational, reproducible demo dataset
npm run seed:reset    # wipe demo data and re-seed (development only)
```

## Demo vs production mode

`NEXT_PUBLIC_APP_ENV` (the APP_ENV toggle) switches behaviour **in code, not just in a label**:

| Behaviour | `demo` | `production` |
|---|---|---|
| Emergency status progression simulation | available | the RPC raises `FORBIDDEN` — simulation is impossible |
| Demo dataset / demo accounts | allowed | seed script refuses to run |
| Demo banner in the UI | shown | hidden |

Additionally, `npm run db:production` flips `app_settings.app_env` **in the database**, so even a modified client cannot simulate emergency progression. The emergency UI always states that it is a prototype and never claims a real ambulance was dispatched.

## AI assistant configuration

The assistant (`/patient/assistant`, Phase 5) has two engines behind one contract:

1. **Deterministic fallback** (default) — `lib/assistant/fallback.ts` detects one of 13 intents (emergency first) and composes the reply from the patient's real records via the service layer. Works with **no LLM key configured**; this is what the demo runs on.
2. **LLM provider** (optional) — any OpenAI-compatible endpoint via the `AI_*` variables (`lib/assistant/llm.ts`, server-side only; the key never reaches the browser). The patient's database context is injected as grounding; temperature 0.2, 350-token replies, 20s timeout. Any failure falls back to engine 1.

Safety rules (enforced in both paths): never diagnoses, never prescribes, never edits records, always distinguishes *stored information* from *general health information*, always states it is not a doctor. Emergencies get an immediate "call 108 / 112" response.

## Medication reminders

`create_medication_reminders()` (migration `00008`) creates one `MEDICATION_REMINDER` notification per patient per day for patients with ACTIVE medication schedules covering today — listing the actual medicines and dose times. It is idempotent within the day, so any scheduler can call it:

```bash
npm run reminders   # runs it once against DATABASE_URL — schedule this however you like
```

Or with pg_cron on Supabase (SQL editor → run once):

```sql
select cron.schedule('medication-reminders', '30 2 * * *',
  $$select public.create_medication_reminders();$$);
-- 02:30 UTC = 08:00 IST daily
```

Execution is restricted to the service role (`revoke … from anon, authenticated, public`), so patients cannot trigger bulk notifications.

## Testing

```bash
npm run test               # 135 unit tests (state machines, SQL splitter, errors, formatters, assistant, analytics, utils)
npm run verify:rls         # 25 live-DB checks: RLS cross-role/cross-patient isolation
npm run verify:workflows   # 92 live-DB checks: full business flows & audit trail
npm run test:db            # local harness: applies stub + migrations (incl. re-run idempotency)
```

The verification suites create fixtures through the **real signup trigger**, impersonate users exactly like PostgREST does (`request.jwt.claims` + role), run the real RPCs, and clean up after themselves. `test:db` runs against a local PostgreSQL using a Supabase stub (`scripts/dev/supabase-stub.sql`) — it is *not* needed when you use a real Supabase project.

## Project structure

```
app/                    # App Router pages (patient/, doctor/, staff/, admin/, (auth)/, print/)
components/
  ui/                   # design-system primitives (button, card, select, …)
  shared/               # empty states, status badges, page headers, setup notice
  layout/               # app shell, navigation, user menu
  settings/             # shared settings surface
lib/
  env.ts                # single source of truth for configuration
  constants.ts          # canonical domain vocabulary + state machines
  errors.ts             # error → safe user message mapping
  validation/           # zod schemas
  supabase/             # browser / server / admin clients
  sql/                  # SQL statement splitter (tested)
  types/database.ts     # TypeScript mirror of the schema
services/               # business logic (auth, users, clinics, …)
scripts/
  apply-migrations.ts   # npm run db:push
  verify-rls.ts         # npm run verify:rls
  verify-workflows.ts   # npm run verify:workflows
  seed.ts               # Phase 8
  dev/                  # local test harness (Supabase stub)
supabase/migrations/    # seven idempotent SQL migrations
tests/                  # vitest unit tests
```

## Deployment

1. **Supabase**: create a project, copy the keys into `.env.local`, run `npm run db:push` (pointing `DATABASE_URL` at your project). Turn email confirmation **on** for production.
2. **Vercel**: import the repository, set the environment variables (`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `NEXT_PUBLIC_APP_ENV=production`, optional `AI_*`), deploy.
3. Run `npm run db:production` once against the production database (disables all simulation at the DB level).
4. No custom backend server is required beyond Supabase + Next.js. All URLs come from environment variables — nothing is hard-coded to localhost.

## Security notes

- The **service-role key and AI keys are server-only** (non-`NEXT_PUBLIC` variables, guarded by the `server-only` package).
- **RLS is enabled on every table.** Patients see only their own healthcare data; doctors only where a direct care relationship exists (appointment/consultation/prescription with that patient — *same clinic is not enough*); receptionists get operational data but not clinical history; clinic admins get clinic-scoped administrative data; audit logs are admin-only; staff invite codes are never exposed publicly.
- Protected operational tables (appointments, slots, queue, check-ins) **cannot be written directly by any client role** — only through the validated security-definer RPCs.
- All user input is validated (zod client+server, SQL-side constraints and checks). Raw database errors never reach the UI (mapped in `lib/errors.ts`).
- Audit logs record security events and every state change (signup, booking, reschedule, cancel, check-in, walk-in, queue actions, consultations, prescriptions, follow-ups, emergency).

## Known limitations

- Walk-ins require an existing patient account (no anonymous quick-register yet).
- Times are stored per-clinic local time (IST assumed) — single-timezone design.
- Password change requires an active session (standard Supabase recovery flow).
- Client-facing Supabase queries are currently untyped generics with casts (a full generated `Database` type can be introduced later; `lib/types/database.ts` documents the schema shape).
- FCM push notifications are optional and not yet configured — in-app notifications are the baseline (Phase 5).

## Build progress

Honest status per the project's working agreement (never present a stub as complete):

| Phase | Scope | Status |
|---|---|---|
| 0 — Audit | existing codebase | ✅ workspace was empty; nothing to consolidate |
| 1 — Foundation | schema (36 tables), migrations, auth, RLS, app shell, role dashboards, settings | ✅ **complete & verified** (25/25 RLS checks) |
| 2 — Discovery & booking | doctor/clinic search, availability editor, slots, booking/reschedule/cancel UI, staff confirm/no-show | ✅ **complete & verified** (62/62 workflow checks, 67 unit tests) |
| 3 — Queue operations | check-in, tokens, walk-ins, live realtime queue, wait estimator | ✅ **complete & verified** (70/70 workflow checks, 80 unit tests) |
| 4 — Clinical | consultation workspace, prescriptions, medication schedules, follow-ups, records timeline | ✅ **complete & verified** (77/77 workflow checks, 90 unit tests) |
| 5 — Notifications & AI | notification center (bell + per-role pages, realtime), daily medication reminders, AI health assistant with deterministic fallback | ✅ **complete & verified** (81/81 workflow checks, 114 unit tests) |
| 6 — Admin & analytics | clinic analytics, emergency demo, audit viewer, doctor/staff directories, avatar storage | ✅ **complete & verified** (92/92 workflow checks, 132 unit tests) |
| 7 — Cross-cutting quality | search, pagination, responsive polish, loading/error boundaries | ✅ **complete & verified** (audit-driven pass; 135 unit tests, 92/92 workflow checks) |
| 8 — Demo data | synthetic seed at scale | ⏳ pending (seed script placeholder is honest about it) |
| 9 — Build, test, deploy, docs | — | 🔶 build/lint/typecheck/tests green; README maintained continuously |

### Phase 2 — what works end to end

- **Doctor discovery** (`/patient/doctors`): server-rendered search with name/specialization/city/fee/rating/available-today/accepting filters, sorting and pagination — all state lives in the URL. Filters across one-to-many relations (specialization, city, availability) are resolved with id-list queries because PostgREST cannot filter a parent by a child embed.
- **Doctor profile & booking** (`/patient/doctors/[id]`): profile, clinics with practice days, reviews (read-only — writing requires a completed consultation, later phase), and a real slot picker: 14-day IST date strip → slots generated on demand by `ensure_slots` → morning/afternoon/evening groups → booking dialog with visit reason.
- **Clinic discovery & profile** (`/patient/clinics`, `/patient/clinics/[id]`): search with city/area/specialization filters, hours table, facilities, doctors, reviews.
- **My appointments** (`/patient/appointments`): upcoming/past tabs with real pagination, cancel with reason, reschedule to a new slot, appointment detail with status timeline and browser print.
- **Doctor availability editor** (`/doctor/availability`): weekly schedule per clinic (window, break, slot length). Saving keeps booked slots and refreshes free future slots.
- **Staff appointments** (`/staff/appointments`): today's counts (real data only), today/upcoming/past lists, patient-name search, confirm and no-show actions.
- **Migration `00006`**: `ensure_slots` now regenerates missing FREE slots for dates that still hold booked slots (was: a date with any surviving booked slot never regenerated — verified by a dedicated workflow check).

Not in this phase (by design): walk-in/check-in UI and booking on behalf of patients (Phase 3), consultation workspace (Phase 4), notification UI (Phase 5), doctor photos via storage (Phase 6 — initials avatars until then).

### Phase 3 — what works end to end

- **Patient queue** (`/patient/queue`): live token card (position, patients ahead, estimated wait), "now serving" for the doctor, personal queue timeline, and app check-in for today's appointments (also available on the appointments list). Updates in real time via Supabase Realtime (`queue_entries` + `appointments`), with a visibility-aware polling fallback if the realtime connection drops.
- **Doctor queue** (`/doctor/queue`): per-clinic board — "now calling" panel, priority-ordered waiting list, call next / call specific / call again / not-present / skip / resume, priority changes, and start consultation. Real-time updates.
- **Staff queue** (`/staff/queue`): per-doctor sections with the same management actions, a **walk-in registration dialog** (search registered patients by name/email, pick doctor + priority + reason — creates appointment, check-in and token in one transaction), and an arrivals desk for checking booked patients in. Real-time updates.
- **Wait estimator**: people-ahead × the doctor's **actual average completed consultation length** (min 3 samples); falls back to the doctor's configured slot length; shows "not enough data yet" instead of inventing numbers.
- **Migration `00007`**: fixed a real bug the new workflow checks exposed — returning a called-but-absent token to the waiting list always failed on an INSERT column mismatch. Guarded by a dedicated check now.

Queue mechanics worth knowing: tokens are assigned by a database function (T001, T002… per clinic+doctor+day), URGENT/HIGH tokens jump the line, and every action above maps 1:1 to a `SECURITY DEFINER` SQL function that re-validates permissions and the state machine — the UI never mutates queue rows directly. Realtime respects RLS, so each role only receives its own rows.

Not in this phase (by design): the consultation workspace itself (Phase 4 — doctors can *start* a consultation from the queue, but notes/prescriptions UI comes next), notification center UI (Phase 5).

### Phase 4 — what works end to end

- **Consultation workspace** (`/doctor/consultations/[id]`): visit context, patient allergy/condition banner, four clinical narrative fields (chief complaint, symptoms, notes, assessment) with explicit save, **diagnosis recording** (with ICD code + primary flag), **prescription builder**, **follow-up scheduling**, and complete-consultation (closes appointment + queue entry and notifies the patient). Past-consultation links give the doctor context mid-visit.
- **Prescription builder**: multiple medicines with dose, frequency (OD/BD/TDS/QID/HS/SOS/STAT), duration, food relation and instructions. Saving writes the prescription + items and the **database trigger generates the daily medication schedule** (e.g. BD → 09:00 & 21:00 rows); the patient is notified. One prescription per consultation; later saves append medicines.
- **Doctor's patients** (`/doctor/patients`, `/doctor/patients/[id]`): searchable directory of patients with a care relationship (RLS-enforced), visit counts, last visit, and a full record view — consultations, prescriptions, follow-ups, medical history — plus recording allergies/chronic conditions on the spot.
- **Patient prescriptions** (`/patient/prescriptions`): full history with per-medicine dosing and browser print.
- **Patient medications** (`/patient/medications`): today's dose checklist ordered by time, and active courses with times, food guidance and course progress — all from the real schedule rows.
- **Patient follow-ups** (`/patient/follow-ups`): upcoming visits with instructions + past history.
- **Medical records timeline** (`/patient/records`): merged consultation/prescription/history timeline with allergy and chronic-condition summary chips.

Data-integrity notes: medical history can only be recorded by doctors (RLS + FK backstop, verified), diagnoses attach to the consultation that produced them, and receptionists can read none of these tables (verified in the RLS suite).

Verified in Phase 4: `npm run build` succeeds (43 routes), 90 unit tests, 25/25 RLS + 77/77 workflow checks (7 new clinical-record checks) against the local PostgreSQL 17 harness.

### Phase 5 — what works end to end

- **Notification center** (`/patient/notifications`, `/doctor/notifications`, `/staff/notifications`, `/admin/notifications`): full per-role page with all/unread tabs, real pagination (15/page), mark-one-read and mark-all-read. Every notification is created by a real database event — booking, confirmation, reschedule, cancellation, queue calls, prescription created, follow-ups, reminders. Nothing is synthetic.
- **Live bell** (header, all roles): unread badge + recent-8 popover, updated in real time via Supabase Realtime on the user's own notification rows (RLS-scoped channel), with mark-all-read and a link to the full page. The bell also re-fetches on every notification INSERT/UPDATE it receives.
- **Daily medication reminders**: `create_medication_reminders()` (migration `00008`, SECURITY DEFINER, service-role only) aggregates each patient's ACTIVE medication schedules covering today into one `MEDICATION_REMINDER` notification per patient per day — idempotent within the day. Run it with `npm run reminders` (any scheduler/cron) or pg_cron on Supabase (see [Medication reminders](#medication-reminders)).
- **AI health assistant** (`/patient/assistant`): a patient-side chat that answers **only from the patient's real records** — upcoming appointments, active medications, prescriptions, allergies, chronic conditions, follow-ups and today's queue token. Two engines behind one contract:
  - **Deterministic fallback** (default, zero configuration): keyword intent detection (13 intents, emergency checked first) → grounded reply built from the same service-layer queries the real pages use. Unanswerable questions get an honest menu of what it *can* do, never invented advice; emergencies get an immediate "call 108/112" reply.
  - **Optional LLM** (`AI_*` env vars): any OpenAI-compatible chat-completions endpoint, called **server-side only** with the patient's database context injected as grounding, temperature 0.2, 20s timeout. Any failure — no key, network error, bad response — silently falls back to the deterministic engine. The chat shows an honest mode badge ("Rule-based assistant" / "LLM: *model*"), and every stored message records whether the LLM produced it (`ai_messages.used_llm`, plus detected `intent`).
- **Conversation persistence** (`ai_conversations` + `ai_messages`): one conversation per patient, last turns reused as LLM history; RLS keeps patients inside their own conversation.

Safety rules (both engines): never diagnoses, never prescribes, never edits records, always distinguishes stored information from general guidance, always identifies itself as not a doctor. The emergency intent short-circuits everything with 108/112 numbers.

Verified in Phase 5: `npm run build` succeeds (43 routes incl. 4 new notification pages), `tsc --noEmit` + `next lint` clean, **114 unit tests** (24 new assistant-intent/fallback tests), 25/25 RLS + **81/81 workflow checks** (4 new medication-reminder checks: created for a medicated patient, body lists the real medicines, idempotent re-run, patients denied execution).

### Phase 6 — what works end to end

- **Clinic analytics** (`/admin/analytics`): KPIs (appointments, completed, no-shows + rates, cancellations, walk-ins, unique/new patients, median queue wait, average consultation length), a per-day stacked bar chart (pure CSS — no chart dependency), status breakdown and per-doctor activity — with 7/30/90-day presets, custom ranges and a doctor filter, all in URL state. Aggregation lives in pure, unit-tested functions (`lib/analytics/aggregate.ts`); **admins see operational data only** (appointments + queue) because RLS intentionally blocks admins from clinical tables — notes, prescriptions and diagnoses are never in analytics. Metrics without samples show "not enough data" instead of zeros-that-look-like-numbers.
- **Admin dashboard**: the placeholder "analytics preview" card is now real 30-day numbers with a link to the full page.
- **Audit viewer** (`/admin/audit`): filterable (action, entity type, IST date range), paginated, read-only trail of every clinic event the database functions recorded. Emergency events are audited globally (not clinic-scoped) and intentionally do not appear here.
- **Emergency demo** (`/patient/emergency`): honest prototype — big "call 108/112" callout first, request form (description + location), status timeline CREATED → RECEIVED → ACKNOWLEDGED → CLOSED with a **demo-only** advance button (disabled in production mode), realtime updates, and the emergency card (blood group, allergies, chronic conditions, ICE contact) from real records.
- **Doctor directory** (`/admin/doctors`): doctors practising at the clinic with real 30-day activity (appointments, completed, no-shows, unique patients, median wait). Read-only — doctors link themselves to clinics at signup.
- **Staff directory** (`/admin/staff`): receptionists/admins linked to the clinic, invite code with copy button, and per-member recorded audit action counts.
- **Avatar storage** (settings, all roles): upload to the public `avatars` bucket (migration `00004`) restricted to each user's own folder — ≤ 1 MB, PNG/JPEG/WebP only. The server action only accepts URLs from that bucket; the profile falls back to deterministic initials avatars when no photo is set (or storage isn't configured).

**Real bug found & fixed (migration `00009`):** `emergency_advance_demo` referenced a non-existent `p_req` variable in its UPDATE — the function could never run and had never been exercised. The new workflow checks caught it immediately; the migration replaces it with the corrected statement.

Verified in Phase 6: `npm run build` succeeds (44 routes incl. the new `/admin/audit`), `tsc --noEmit` + `next lint` clean, **132 unit tests** (18 new analytics-aggregation tests), 25/25 RLS + **92/92 workflow checks** (6 emergency-flow checks incl. production-mode refusal, 1 global-emergency-audit check, 4 analytics-fixture checks).

### Phase 7 — what was audited & improved

A cross-cutting quality pass over the whole app (audit first, then fixes — no invented work):

- **Loading & error boundaries (was the biggest gap — none existed)**: per-role `loading.tsx` skeletons, per-role + root `error.tsx` boundaries (honest message, retry, back-to-dashboard; raw error details stay in the console, never on screen), and a custom `not-found.tsx` 404 page.
- **Search gap closed**: the doctor's consultation list now has debounced patient-name search (`UrlSearch`) that preserves the active status tab and pagination — same id-list resolution pattern as the staff search (PostgREST cannot filter a parent by a child embed). `UrlSearch` gained a reusable `extraParams` prop for this.
- **Honest caps on unpaginated lists**: past follow-ups show the 10 most recent with an explicit "showing 10 of N" note; the medical-records timeline renders at most 60 events with the same honesty note (services already cap the underlying queries).
- **Responsive audit**: mobile drawer nav, wrapped tables, collapsing grids and the availability editor were verified across every page — all lists use `overflow-x-auto` tables and breakpoint-aware grids; no fixed-width offenders remained.
- **Consistency**: `ageFrom` helper deduplicated into `lib/utils` (was copied in two doctor pages) with unit tests; every page now exports `metadata` (dashboards and the landing page were missing theirs).
- **Verified**: search/pagination coverage re-checked list by list — every list that can grow either paginates (appointments, consultations, prescriptions, doctors, clinics, notifications, audit, patients directory) or displays a capped, labelled slice.

Verified in Phase 7: `npm run build` succeeds (44 routes, 41/41 static pages — boundaries add no routes), `tsc --noEmit` + `next lint` clean, **135 unit tests** (+3 `ageFrom` boundary tests), 25/25 RLS + 92/92 workflow checks unchanged (no database changes in this phase).

Verified in this phase: `npm run build` succeeds (38 routes), `next lint` clean, `tsc --noEmit` clean, 67 unit tests pass, 25/25 RLS + 62/62 workflow integration checks pass against PostgreSQL 17 (local harness) — and the same suites run against your Supabase project via `DATABASE_URL`.

Verified in Phase 3: `npm run build` succeeds (39 routes), 80 unit tests, 25/25 RLS + 70/70 workflow checks (8 new queue-management checks) against the same harness.
