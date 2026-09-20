-- ═══════════════════════════════════════════════════════════════════
-- LOCAL TEST HARNESS ONLY — do NOT run this on a real Supabase project.
-- Real Supabase already provides everything stubbed here.
--
-- Stubs the parts of Supabase the migrations touch: the auth schema
-- (users table + auth.uid()), the storage schema (buckets/objects +
-- foldername()), the PostgREST roles (anon/authenticated/service_role)
-- and the supabase_realtime publication. Used by `npm run test:db`.
-- ═══════════════════════════════════════════════════════════════════

create extension if not exists pgcrypto;

create schema if not exists auth;

create table if not exists auth.users (
  id                 uuid primary key default gen_random_uuid(),
  instance_id        uuid,
  aud                text default 'authenticated',
  role               text default 'authenticated',
  email              text unique,
  encrypted_password text,
  email_confirmed_at timestamptz,
  created_at         timestamptz default now(),
  updated_at         timestamptz default now(),
  raw_app_meta_data  jsonb default '{}'::jsonb,
  raw_user_meta_data jsonb default '{}'::jsonb
);

-- Defensive: once a custom GUC has been set locally and the transaction
-- ends, it resets to '' (not NULL) — ''::jsonb would raise a syntax
-- error. Real Supabase never sees this via PostgREST (it always sets
-- claims), but direct SQL connections do.
create or replace function auth.uid() returns uuid
language sql stable as $$
  select nullif(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub', '')::uuid
$$;

create or replace function auth.role() returns text
language sql stable as $$
  select nullif(current_setting('request.jwt.claims', true)::jsonb ->> 'role', '')
$$;

-- ── storage ──────────────────────────────────────────────────────
create schema if not exists storage;

create table if not exists storage.buckets (
  id                 text primary key,
  name               text,
  public             boolean default false,
  file_size_limit    integer,
  allowed_mime_types text[]
);

create table if not exists storage.objects (
  id         uuid primary key default gen_random_uuid(),
  bucket_id  text references storage.buckets(id),
  name       text,
  owner      uuid,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table storage.objects enable row level security;

create or replace function storage.foldername(name text)
returns text[] language sql immutable as $$
  select string_to_array(name, '/')
$$;

-- ── PostgREST roles ──────────────────────────────────────────────
do $$ begin
  create role anon nologin;
exception when duplicate_object then null; end $$;
do $$ begin
  create role authenticated nologin;
exception when duplicate_object then null; end $$;
do $$ begin
  create role service_role nologin;
exception when duplicate_object then null; end $$;

-- ── realtime publication ─────────────────────────────────────────
do $$ begin
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
end $$;
