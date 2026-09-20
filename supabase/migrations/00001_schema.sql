-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00001_schema.sql
-- Complete relational schema. Idempotent: safe to re-run.
-- Conventions: UUID primary keys, snake_case, created_at/updated_at,
-- foreign keys with explicit ON DELETE behaviour, indexes on common
-- query paths, CHECK constraints for data integrity.
-- ═══════════════════════════════════════════════════════════════════

create extension if not exists pg_trgm;

-- ── Enums (idempotent) ───────────────────────────────────────────
do $$ begin
  create type public.user_role as enum ('PATIENT','DOCTOR','RECEPTIONIST','CLINIC_ADMIN');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.sex as enum ('MALE','FEMALE','OTHER');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.appointment_type as enum ('SCHEDULED','WALK_IN');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.appointment_status as enum
    ('BOOKED','CONFIRMED','CHECKED_IN','WAITING','CALLED','IN_CONSULTATION','COMPLETED','CANCELLED','NO_SHOW');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.slot_status as enum ('FREE','BOOKED','BLOCKED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.check_in_method as enum ('APP','RECEPTIONIST');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.queue_status as enum ('WAITING','CALLED','IN_CONSULTATION','COMPLETED','SKIPPED','CANCELLED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.queue_event_type as enum
    ('CREATED','CALLED','RECALLED','SKIPPED','RESUMED','STARTED','COMPLETED','CANCELLED','PRIORITY_CHANGED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.priority as enum ('NORMAL','HIGH','URGENT');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.notification_type as enum
    ('APPOINTMENT_BOOKED','APPOINTMENT_CONFIRMED','APPOINTMENT_CANCELLED','APPOINTMENT_RESCHEDULED',
     'CHECK_IN_CONFIRMED','QUEUE_UPDATED','QUEUE_CALLED','QUEUE_COMPLETED','CONSULTATION_COMPLETED',
     'PRESCRIPTION_CREATED','FOLLOW_UP_SCHEDULED','MEDICATION_REMINDER','EMERGENCY_UPDATE','SYSTEM');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.consultation_status as enum ('DRAFT','IN_PROGRESS','COMPLETED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.prescription_status as enum ('ACTIVE','COMPLETED','CANCELLED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.prescription_frequency as enum ('OD','BD','TDS','QID','HS','SOS','STAT');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.food_relation as enum ('BEFORE_FOOD','AFTER_FOOD','WITH_FOOD','EMPTY_STOMACH','NOT_SPECIFIED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.medication_schedule_status as enum ('ACTIVE','COMPLETED','CANCELLED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.follow_up_status as enum ('SCHEDULED','COMPLETED','CANCELLED','MISSED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.emergency_status as enum ('CREATED','RECEIVED','ACKNOWLEDGED','CLOSED');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.medicine_form as enum
    ('TABLET','CAPSULE','SYRUP','INJECTION','CREAM','OINTMENT','DROPS','INHALER','POWDER');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.medical_history_type as enum
    ('ALLERGY','CHRONIC_CONDITION','SURGERY','INJURY','FAMILY_HISTORY','LIFESTYLE','IMMUNIZATION','NOTE');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.ai_message_role as enum ('USER','ASSISTANT');
exception when duplicate_object then null; end $$;

-- ── Profiles & role entities ─────────────────────────────────────

create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null,
  email       text not null,
  phone       text,
  role        public.user_role not null default 'PATIENT',
  avatar_url  text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists idx_profiles_role on public.profiles (role);

create table if not exists public.locations (
  id          uuid primary key default gen_random_uuid(),
  city        text not null,
  area        text not null,
  created_at  timestamptz not null default now(),
  unique (city, area)
);

create table if not exists public.specializations (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  slug        text not null unique,
  description text,
  created_at  timestamptz not null default now()
);

create table if not exists public.clinics (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  description    text,
  address_line   text not null,
  city           text not null,
  area           text not null,
  pincode        text,
  contact_phone  text,
  contact_email  text,
  image_url      text,
  avg_rating     numeric(3,2) not null default 0,
  review_count   integer not null default 0,
  is_active      boolean not null default true,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);
create index if not exists idx_clinics_city on public.clinics (city, area);
create index if not exists idx_clinics_name_trgm on public.clinics using gin (name gin_trgm_ops);

-- Invite codes live in their own table so that publicly-readable
-- `clinics` rows never expose the staff invite code.
create table if not exists public.clinic_invite_codes (
  clinic_id   uuid primary key references public.clinics(id) on delete cascade,
  code        text not null unique,
  created_at  timestamptz not null default now()
);

create table if not exists public.patients (
  id                       uuid primary key references public.profiles(id) on delete cascade,
  date_of_birth            date,
  sex                      public.sex,
  blood_group              text check (blood_group in ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
  address_line             text,
  city                     text,
  area                     text,
  pincode                  text,
  emergency_contact_name   text,
  emergency_contact_phone  text,
  created_at               timestamptz not null default now(),
  updated_at               timestamptz not null default now()
);

create table if not exists public.doctors (
  id                    uuid primary key references public.profiles(id) on delete cascade,
  qualification         text not null,
  registration_number   text not null,
  experience_years      integer not null default 0 check (experience_years between 0 and 60),
  consultation_fee      integer not null default 500 check (consultation_fee >= 0),
  about                 text,
  languages             text[] not null default '{English,Hindi}',
  avg_rating            numeric(3,2) not null default 0,
  review_count          integer not null default 0,
  is_accepting_patients boolean not null default true,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create table if not exists public.doctor_specializations (
  doctor_id          uuid not null references public.doctors(id) on delete cascade,
  specialization_id  uuid not null references public.specializations(id) on delete cascade,
  created_at         timestamptz not null default now(),
  primary key (doctor_id, specialization_id)
);

create table if not exists public.doctor_clinics (
  id          uuid primary key default gen_random_uuid(),
  doctor_id   uuid not null references public.doctors(id) on delete cascade,
  clinic_id   uuid not null references public.clinics(id) on delete cascade,
  is_primary  boolean not null default false,
  created_at  timestamptz not null default now(),
  unique (doctor_id, clinic_id)
);

create table if not exists public.clinic_staff (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  clinic_id   uuid not null references public.clinics(id) on delete cascade,
  role        public.user_role not null check (role in ('RECEPTIONIST','CLINIC_ADMIN')),
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (user_id, clinic_id)
);
create index if not exists idx_clinic_staff_clinic on public.clinic_staff (clinic_id) where is_active;

create table if not exists public.clinic_hours (
  id          uuid primary key default gen_random_uuid(),
  clinic_id   uuid not null references public.clinics(id) on delete cascade,
  day_of_week integer not null check (day_of_week between 0 and 6),
  opens_at    time not null,
  closes_at   time not null,
  is_closed   boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (clinic_id, day_of_week),
  constraint clinic_hours_valid check (is_closed or closes_at > opens_at)
);

create table if not exists public.doctor_availability (
  id                      uuid primary key default gen_random_uuid(),
  doctor_id               uuid not null references public.doctors(id) on delete cascade,
  clinic_id               uuid not null references public.clinics(id) on delete cascade,
  day_of_week             integer not null check (day_of_week between 0 and 6),
  start_time              time not null,
  end_time                time not null,
  break_start             time,
  break_end               time,
  slot_duration_minutes   integer not null default 15 check (slot_duration_minutes between 5 and 120),
  is_active               boolean not null default true,
  created_at              timestamptz not null default now(),
  updated_at              timestamptz not null default now(),
  unique (doctor_id, clinic_id, day_of_week, start_time),
  constraint availability_times_valid check (
    end_time > start_time
    and (break_start is null and break_end is null or (break_end is not null and break_start is not null and break_end > break_start))
  )
);
create index if not exists idx_availability_lookup on public.doctor_availability (doctor_id, clinic_id, day_of_week) where is_active;

-- ── Booking: slots & appointments ────────────────────────────────

create table if not exists public.appointment_slots (
  id              uuid primary key default gen_random_uuid(),
  doctor_id       uuid not null references public.doctors(id) on delete cascade,
  clinic_id       uuid not null references public.clinics(id) on delete cascade,
  slot_date       date not null,
  start_time      time not null,
  end_time        time not null,
  status          public.slot_status not null default 'FREE',
  appointment_id  uuid,
  created_at      timestamptz not null default now(),
  unique (doctor_id, clinic_id, slot_date, start_time)
);
create index if not exists idx_slots_lookup on public.appointment_slots (doctor_id, clinic_id, slot_date, status);
create index if not exists idx_slots_free_by_date on public.appointment_slots (slot_date, status) where status = 'FREE';

create table if not exists public.appointments (
  id                  uuid primary key default gen_random_uuid(),
  patient_id          uuid not null references public.patients(id) on delete cascade,
  doctor_id           uuid not null references public.doctors(id) on delete cascade,
  clinic_id           uuid not null references public.clinics(id) on delete cascade,
  slot_id             uuid references public.appointment_slots(id) on delete set null,
  appointment_type    public.appointment_type not null default 'SCHEDULED',
  status              public.appointment_status not null default 'BOOKED',
  appointment_date    date not null,
  start_time          time not null,
  end_time            time not null,
  visit_reason        text not null check (char_length(visit_reason) between 3 and 500),
  notes               text,
  booked_at           timestamptz not null default now(),
  confirmed_at        timestamptz,
  checked_in_at       timestamptz,
  cancelled_at        timestamptz,
  cancellation_reason text,
  completed_at        timestamptz,
  created_by          uuid references public.profiles(id) on delete set null,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
-- One active appointment per slot — the database-level double-booking guard.
create unique index if not exists uq_active_appointment_per_slot
  on public.appointments (slot_id)
  where slot_id is not null
    and status in ('BOOKED','CONFIRMED','CHECKED_IN','WAITING','CALLED','IN_CONSULTATION');
create index if not exists idx_appointments_clinic_date on public.appointments (clinic_id, appointment_date, status);
create index if not exists idx_appointments_doctor_date on public.appointments (doctor_id, appointment_date, status);
create index if not exists idx_appointments_patient on public.appointments (patient_id, appointment_date desc);
create index if not exists idx_appointments_status on public.appointments (status) where status in ('BOOKED','CONFIRMED');

create table if not exists public.appointment_status_history (
  id              uuid primary key default gen_random_uuid(),
  appointment_id  uuid not null references public.appointments(id) on delete cascade,
  from_status     public.appointment_status,
  to_status       public.appointment_status not null,
  changed_by      uuid references public.profiles(id) on delete set null,
  reason          text,
  created_at      timestamptz not null default now()
);
create index if not exists idx_appt_history on public.appointment_status_history (appointment_id, created_at);

create table if not exists public.check_ins (
  id              uuid primary key default gen_random_uuid(),
  appointment_id  uuid not null unique references public.appointments(id) on delete cascade,
  patient_id      uuid not null references public.patients(id) on delete cascade,
  clinic_id       uuid not null references public.clinics(id) on delete cascade,
  method          public.check_in_method not null default 'APP',
  checked_in_by   uuid references public.profiles(id) on delete set null,
  created_at      timestamptz not null default now()
);
create index if not exists idx_check_ins_clinic_day on public.check_ins (clinic_id, created_at desc);

-- ── Queue ────────────────────────────────────────────────────────

create table if not exists public.queue_token_counters (
  clinic_id     uuid not null references public.clinics(id) on delete cascade,
  doctor_id     uuid not null references public.doctors(id) on delete cascade,
  counter_date  date not null,
  last_number   integer not null default 0,
  primary key (clinic_id, doctor_id, counter_date)
);

create table if not exists public.queue_entries (
  id              uuid primary key default gen_random_uuid(),
  clinic_id       uuid not null references public.clinics(id) on delete cascade,
  doctor_id       uuid not null references public.doctors(id) on delete cascade,
  patient_id      uuid not null references public.patients(id) on delete cascade,
  appointment_id  uuid not null unique references public.appointments(id) on delete cascade,
  queue_date      date not null default current_date,
  token_number    integer not null default 0,
  token_code      text not null default '',
  priority        public.priority not null default 'NORMAL',
  status          public.queue_status not null default 'WAITING',
  created_at      timestamptz not null default now(),
  called_at       timestamptz,
  started_at      timestamptz,
  completed_at    timestamptz,
  unique (clinic_id, doctor_id, queue_date, token_number)
);
create index if not exists idx_queue_waiting on public.queue_entries (doctor_id, queue_date, status, priority, token_number) where status = 'WAITING';
create index if not exists idx_queue_clinic_day on public.queue_entries (clinic_id, queue_date, status);
create index if not exists idx_queue_patient on public.queue_entries (patient_id, queue_date desc);

create table if not exists public.queue_events (
  id              uuid primary key default gen_random_uuid(),
  queue_entry_id  uuid not null references public.queue_entries(id) on delete cascade,
  event_type      public.queue_event_type not null,
  from_status     public.queue_status,
  to_status       public.queue_status,
  changed_by      uuid references public.profiles(id) on delete set null,
  note            text,
  created_at      timestamptz not null default now()
);
create index if not exists idx_queue_events_entry on public.queue_events (queue_entry_id, created_at);

-- ── Notifications ────────────────────────────────────────────────

create table if not exists public.notifications (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references public.profiles(id) on delete cascade,
  type         public.notification_type not null default 'SYSTEM',
  title        text not null,
  body         text not null,
  entity_type  text,
  entity_id    uuid,
  is_read      boolean not null default false,
  read_at      timestamptz,
  created_at   timestamptz not null default now()
);
create index if not exists idx_notifications_user on public.notifications (user_id, is_read, created_at desc);

-- ── Clinical records ─────────────────────────────────────────────

create table if not exists public.consultations (
  id               uuid primary key default gen_random_uuid(),
  appointment_id   uuid not null unique references public.appointments(id) on delete cascade,
  patient_id       uuid not null references public.patients(id) on delete cascade,
  doctor_id        uuid not null references public.doctors(id) on delete cascade,
  clinic_id        uuid not null references public.clinics(id) on delete cascade,
  status           public.consultation_status not null default 'IN_PROGRESS',
  chief_complaint  text,
  symptoms         text,
  clinical_notes   text,
  assessment       text,
  started_at       timestamptz not null default now(),
  completed_at     timestamptz,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);
create index if not exists idx_consultations_patient on public.consultations (patient_id, started_at desc);
create index if not exists idx_consultations_doctor on public.consultations (doctor_id, started_at desc);

create table if not exists public.diagnoses (
  id               uuid primary key default gen_random_uuid(),
  consultation_id  uuid not null references public.consultations(id) on delete cascade,
  patient_id       uuid not null references public.patients(id) on delete cascade,
  name             text not null,
  description      text,
  code             text,
  is_primary       boolean not null default false,
  created_at       timestamptz not null default now()
);
create index if not exists idx_diagnoses_patient on public.diagnoses (patient_id, created_at desc);

create table if not exists public.treatment_plans (
  id               uuid primary key default gen_random_uuid(),
  consultation_id  uuid not null references public.consultations(id) on delete cascade,
  patient_id       uuid not null references public.patients(id) on delete cascade,
  title            text not null,
  description      text,
  instructions     text,
  duration_days    integer check (duration_days is null or duration_days between 1 and 365),
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create table if not exists public.medical_history (
  id            uuid primary key default gen_random_uuid(),
  patient_id    uuid not null references public.patients(id) on delete cascade,
  record_type   public.medical_history_type not null default 'NOTE',
  title         text not null,
  description   text,
  recorded_by   uuid references public.doctors(id) on delete set null,
  is_active     boolean not null default true,
  recorded_at   timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index if not exists idx_medical_history_patient on public.medical_history (patient_id, recorded_at desc);

create table if not exists public.medicines (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  generic_name  text not null,
  form          public.medicine_form not null default 'TABLET',
  strength      text,
  category      text not null default 'General',
  is_common     boolean not null default false,
  created_at    timestamptz not null default now()
);
-- Expression uniqueness (nullable strength) requires an index, not a constraint.
create unique index if not exists uq_medicines_identity
  on public.medicines (name, coalesce(strength, ''), form);
create index if not exists idx_medicines_name_trgm on public.medicines using gin (name gin_trgm_ops);
create index if not exists idx_medicines_generic_trgm on public.medicines using gin (generic_name gin_trgm_ops);

create table if not exists public.prescriptions (
  id                 uuid primary key default gen_random_uuid(),
  consultation_id    uuid not null unique references public.consultations(id) on delete cascade,
  patient_id         uuid not null references public.patients(id) on delete cascade,
  doctor_id          uuid not null references public.doctors(id) on delete cascade,
  clinic_id          uuid not null references public.clinics(id) on delete cascade,
  prescription_date  date not null default current_date,
  status             public.prescription_status not null default 'ACTIVE',
  notes              text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);
create index if not exists idx_prescriptions_patient on public.prescriptions (patient_id, prescription_date desc);
create index if not exists idx_prescriptions_doctor on public.prescriptions (doctor_id, prescription_date desc);

create table if not exists public.prescription_items (
  id               uuid primary key default gen_random_uuid(),
  prescription_id  uuid not null references public.prescriptions(id) on delete cascade,
  medicine_id      uuid references public.medicines(id) on delete set null,
  medicine_name    text not null,
  generic_name     text,
  strength         text,
  dose             text not null,
  frequency        public.prescription_frequency not null,
  duration_days    integer not null check (duration_days between 1 and 365),
  instructions     text,
  food_relation    public.food_relation not null default 'NOT_SPECIFIED',
  created_at       timestamptz not null default now()
);
create index if not exists idx_prescription_items_rx on public.prescription_items (prescription_id);

create table if not exists public.medication_schedules (
  id                     uuid primary key default gen_random_uuid(),
  prescription_item_id   uuid not null references public.prescription_items(id) on delete cascade,
  prescription_id        uuid not null references public.prescriptions(id) on delete cascade,
  patient_id             uuid not null references public.patients(id) on delete cascade,
  medicine_name          text not null,
  dose                   text not null,
  time_of_day            time not null,
  start_date             date not null default current_date,
  end_date               date not null,
  instructions           text,
  food_relation          public.food_relation not null default 'NOT_SPECIFIED',
  status                 public.medication_schedule_status not null default 'ACTIVE',
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now()
);
create index if not exists idx_med_sched_patient on public.medication_schedules (patient_id, status, start_date, end_date);

create table if not exists public.follow_ups (
  id               uuid primary key default gen_random_uuid(),
  consultation_id  uuid not null references public.consultations(id) on delete cascade,
  patient_id       uuid not null references public.patients(id) on delete cascade,
  doctor_id        uuid not null references public.doctors(id) on delete cascade,
  clinic_id        uuid not null references public.clinics(id) on delete cascade,
  scheduled_date   date not null,
  reason           text not null,
  instructions     text,
  status           public.follow_up_status not null default 'SCHEDULED',
  completed_at     timestamptz,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  constraint follow_up_scheduled_date_valid check (scheduled_date >= '2000-01-01')
);
create index if not exists idx_follow_ups_patient on public.follow_ups (patient_id, status, scheduled_date);
create index if not exists idx_follow_ups_doctor on public.follow_ups (doctor_id, scheduled_date desc);

-- ── Reviews ──────────────────────────────────────────────────────

create table if not exists public.reviews (
  id          uuid primary key default gen_random_uuid(),
  doctor_id   uuid references public.doctors(id) on delete cascade,
  clinic_id   uuid references public.clinics(id) on delete cascade,
  patient_id  uuid not null references public.patients(id) on delete cascade,
  rating      integer not null check (rating between 1 and 5),
  title       text,
  comment     text,
  is_approved boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  constraint review_has_target check (doctor_id is not null or clinic_id is not null),
  constraint review_single_target check (doctor_id is null or clinic_id is null)
);
create index if not exists idx_reviews_doctor on public.reviews (doctor_id, created_at desc) where doctor_id is not null;
create index if not exists idx_reviews_clinic on public.reviews (clinic_id, created_at desc) where clinic_id is not null;

-- ── Emergency demo (clearly labelled prototype) ──────────────────

create table if not exists public.emergency_requests (
  id              uuid primary key default gen_random_uuid(),
  patient_id      uuid not null references public.patients(id) on delete cascade,
  description     text not null,
  location_text   text not null,
  latitude        numeric(9,6),
  longitude       numeric(9,6),
  status          public.emergency_status not null default 'CREATED',
  is_demo         boolean not null default false,
  created_at      timestamptz not null default now(),
  received_at     timestamptz,
  acknowledged_at timestamptz,
  closed_at       timestamptz,
  updated_at      timestamptz not null default now()
);
create index if not exists idx_emergency_patient on public.emergency_requests (patient_id, created_at desc);

-- ── Audit & settings ─────────────────────────────────────────────

create table if not exists public.audit_logs (
  id           uuid primary key default gen_random_uuid(),
  actor_id     uuid references public.profiles(id) on delete set null,
  actor_role   public.user_role,
  action       text not null,
  entity_type  text not null,
  entity_id    uuid,
  clinic_id    uuid references public.clinics(id) on delete set null,
  patient_id   uuid references public.patients(id) on delete set null,
  metadata     jsonb not null default '{}'::jsonb,
  created_at   timestamptz not null default now()
);
create index if not exists idx_audit_clinic_time on public.audit_logs (clinic_id, created_at desc);
create index if not exists idx_audit_entity on public.audit_logs (entity_type, entity_id);
create index if not exists idx_audit_action on public.audit_logs (action, created_at desc);

create table if not exists public.app_settings (
  key         text primary key,
  value       text not null,
  updated_at  timestamptz not null default now()
);
insert into public.app_settings (key, value) values ('app_env', 'demo') on conflict (key) do nothing;

-- ── AI assistant conversations ───────────────────────────────────

create table if not exists public.ai_conversations (
  id          uuid primary key default gen_random_uuid(),
  patient_id  uuid not null unique references public.patients(id) on delete cascade,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table if not exists public.ai_messages (
  id               uuid primary key default gen_random_uuid(),
  conversation_id  uuid not null references public.ai_conversations(id) on delete cascade,
  role             public.ai_message_role not null,
  content          text not null,
  intent           text,
  used_llm         boolean not null default false,
  created_at       timestamptz not null default now()
);
create index if not exists idx_ai_messages_conversation on public.ai_messages (conversation_id, created_at);
