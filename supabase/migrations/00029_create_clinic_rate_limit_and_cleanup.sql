-- Migration 00029: Rate-limiting and orphan cleanup for create_clinic_with_invite

-- 1. Create rate_limit_events table
create table if not exists public.rate_limit_events (
  id bigint generated always as identity primary key,
  action text not null,
  client_identifier text not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_rate_limit_events_lookup
  on public.rate_limit_events (action, client_identifier, created_at desc);

alter table public.rate_limit_events enable row level security;
-- No public policies: only accessible by security definer functions and service_role

-- 2. Add is_claimed column to public.clinics
alter table public.clinics
  add column if not exists is_claimed boolean not null default false;

-- Backfill existing clinics as claimed so existing data is preserved
update public.clinics set is_claimed = true where is_claimed = false;

-- 3. Automatic claim triggers when staff or doctor associates with a clinic
create or replace function public.mark_clinic_claimed()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
begin
  update public.clinics
  set is_claimed = true
  where id = NEW.clinic_id and is_claimed = false;
  return NEW;
end;
$$;

drop trigger if exists trg_clinic_claimed_on_staff on public.clinic_staff;
create trigger trg_clinic_claimed_on_staff
  after insert on public.clinic_staff
  for each row execute function public.mark_clinic_claimed();

drop trigger if exists trg_clinic_claimed_on_doctor on public.doctor_clinics;
create trigger trg_clinic_claimed_on_doctor
  after insert on public.doctor_clinics
  for each row execute function public.mark_clinic_claimed();

-- 4. Update create_clinic_with_invite with IP-based rate limiting & is_claimed = false
create or replace function public.create_clinic_with_invite(
  p_name text,
  p_city text,
  p_area text,
  p_address_line text
) returns jsonb
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_clinic_id uuid;
  v_code text;
  v_doctor_code text;
  v_admin_claim_code text;
  v_dow int;
  v_headers jsonb := nullif(current_setting('request.headers', true), '')::jsonb;
  v_client_ip text;
  v_recent_count int;
begin
  -- 1. Extract client identifier from request headers
  if v_headers is not null then
    v_client_ip := coalesce(
      nullif(trim(v_headers->>'x-client-ip'), ''),
      nullif(trim(v_headers->>'cf-connecting-ip'), ''),
      nullif(trim(split_part(v_headers->>'x-forwarded-for', ',', 1)), ''),
      nullif(trim(v_headers->>'x-real-ip'), '')
    );
  end if;

  if v_client_ip is null or v_client_ip = '' then
    v_client_ip := coalesce(auth.uid()::text, 'unknown_client');
  end if;

  -- 2. Rate limit check: max 5 clinic creations per hour per IP/identifier
  select count(*) into v_recent_count
  from public.rate_limit_events
  where action = 'create_clinic'
    and client_identifier = v_client_ip
    and created_at > now() - interval '1 hour';

  if v_recent_count >= 5 then
    raise exception '[RATE_LIMITED] Too many clinics created from this IP address. Please try again in an hour.';
  end if;

  -- Record rate limit event
  insert into public.rate_limit_events (action, client_identifier)
  values ('create_clinic', v_client_ip);

  -- 3. Input validation
  if length(p_name) < 3 then
    raise exception '[VALIDATION] Clinic name must be at least 3 characters';
  end if;
  if length(p_city) < 2 then
    raise exception '[VALIDATION] City is required';
  end if;
  if length(p_area) < 2 then
    raise exception '[VALIDATION] Area is required';
  end if;
  if length(p_address_line) < 3 then
    raise exception '[VALIDATION] Address line is required';
  end if;

  if exists (
    select 1 from public.clinics 
    where lower(name) = lower(p_name) and lower(city) = lower(p_city)
  ) then
    raise exception '[DUPLICATE_CLINIC] A clinic with this name and city already exists';
  end if;

  -- 4. Insert clinic with is_claimed = false (marked claimed once a user links or registers as admin/doctor)
  insert into public.clinics (name, city, area, address_line, is_active, is_claimed)
  values (p_name, p_city, p_area, p_address_line, true, false)
  returning id into v_clinic_id;

  v_code := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
  v_doctor_code := 'DOC-' || upper(substr(md5(random()::text || clock_timestamp()::text || 'doc'), 1, 6));
  v_admin_claim_code := 'ADM-' || upper(substr(md5(random()::text || clock_timestamp()::text || 'adm'), 1, 6));

  insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code)
  values (v_clinic_id, v_code, v_doctor_code, v_admin_claim_code)
  on conflict (clinic_id) do update
    set code = excluded.code,
        doctor_code = excluded.doctor_code,
        admin_claim_code = excluded.admin_claim_code;

  for v_dow in 1..6 loop
    insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
    values (v_clinic_id, v_dow, '08:00:00', '20:00:00', false)
    on conflict (clinic_id, day_of_week) do nothing;
  end loop;

  return jsonb_build_object(
    'id', v_clinic_id,
    'name', p_name,
    'city', p_city,
    'area', p_area,
    'invite_code', v_code,
    'doctor_invite_code', v_doctor_code,
    'admin_claim_code', v_admin_claim_code
  );
end;
$$;

grant execute on function public.create_clinic_with_invite(text, text, text, text) to anon, authenticated;

-- 5. Cleanup function for orphaned, unclaimed clinics older than specified threshold (default 24 hours)
create or replace function public.purge_unclaimed_clinics(
  p_older_than interval default interval '24 hours'
) returns jsonb
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_count int;
begin
  with deleted as (
    delete from public.clinics
    where is_claimed = false
      and is_synthetic = false
      and created_at < now() - p_older_than
      and not exists (select 1 from public.clinic_staff where clinic_id = clinics.id)
      and not exists (select 1 from public.doctor_clinics where clinic_id = clinics.id)
    returning id
  )
  select count(*) into v_count from deleted;

  return jsonb_build_object('success', true, 'purged_count', v_count);
end;
$$;

revoke all on function public.purge_unclaimed_clinics(interval) from public;
grant execute on function public.purge_unclaimed_clinics(interval) to service_role;
