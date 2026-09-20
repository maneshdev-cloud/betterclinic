-- ====================================================================
-- Migration 00024: Security, Verification, Preferences & Realtime
--
-- 1. Adds admin_claim_code to clinic_invite_codes to prevent unverified
--    takeover of existing clinics.
-- 2. Enforces at most one active admin per clinic via unique partial index.
-- 3. Fixes create_clinic_with_invite RPC column names (opens_at, closes_at).
-- 4. Improves doctor and staff invite code validation (trim + upper) and
--    provides distinct error diagnostics.
-- 5. Introduces user_preferences table and wires category gating into
--    create_notification RPC.
-- ====================================================================

-- 1. Add admin_claim_code to clinic_invite_codes
alter table public.clinic_invite_codes
  add column if not exists admin_claim_code text;

-- Backfill admin_claim_code for all clinics that don't have one
update public.clinic_invite_codes
set admin_claim_code = 'ADM-' || upper(substr(md5(random()::text || clinic_id::text), 1, 6))
where admin_claim_code is null;

-- Ensure doctor_code is backfilled for all clinics
update public.clinic_invite_codes
set doctor_code = 'DOC-' || upper(substr(md5(random()::text || clinic_id::text || 'doc'), 1, 6))
where doctor_code is null;

alter table public.clinic_invite_codes
  alter column admin_claim_code set not null;

create unique index if not exists clinic_invite_codes_admin_claim_code_idx
  on public.clinic_invite_codes (admin_claim_code);

-- 2. Enforce at most one active admin per clinic at the database level
create unique index if not exists clinic_staff_single_admin_idx
  on public.clinic_staff (clinic_id)
  where role = 'CLINIC_ADMIN' and is_active = true;

-- 3. Update create_clinic_with_invite RPC (fixes column names and generates admin claim code)
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
begin
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

  insert into public.clinics (name, city, area, address_line, is_active)
  values (p_name, p_city, p_area, p_address_line, true)
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

  -- Correct column names: opens_at, closes_at
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

-- 4. Update handle_new_user() trigger function
create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_role public.user_role;
  v_clinic uuid;
  v_specialization uuid;
  v_doc_code text;
  v_staff_code text;
  v_admin_code text;
begin
  v_role := coalesce((new.raw_user_meta_data->>'role')::public.user_role, 'PATIENT');

  insert into public.profiles (id, full_name, email, phone, role)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data->>'full_name',''), split_part(new.email,'@',1)),
    new.email,
    nullif(new.raw_user_meta_data->>'phone',''),
    v_role
  ) on conflict (id) do nothing;

  -- Insert into profile_roles table
  insert into public.profile_roles (profile_id, role)
  values (new.id, v_role)
  on conflict (profile_id, role) do nothing;

  if v_role = 'PATIENT' then
    insert into public.patients (id, date_of_birth, sex, city)
    values (
      new.id,
      nullif(new.raw_user_meta_data->>'date_of_birth','')::date,
      nullif(new.raw_user_meta_data->>'sex','')::public.sex,
      nullif(new.raw_user_meta_data->>'city','')
    ) on conflict (id) do nothing;

  elsif v_role = 'DOCTOR' then
    v_clinic := nullif(new.raw_user_meta_data->>'clinic_id','')::uuid;

    -- If joining an existing clinic, doctor invite code is required (unless created in same session)
    if v_clinic is not null and (new.raw_user_meta_data->>'is_new_clinic') is distinct from 'true' then
      if not exists (select 1 from public.clinics where id = v_clinic) then
        raise exception '[CLINIC_NOT_FOUND] The selected clinic could not be found';
      end if;

      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic and cic.doctor_code is not null
      ) then
        raise exception '[DOCTOR_CODE_NOT_CONFIGURED] No doctor invite code is configured for this clinic yet';
      end if;

      v_doc_code := coalesce(new.raw_user_meta_data->>'doctor_invite_code', '');
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic
          and upper(trim(cic.doctor_code)) = upper(trim(v_doc_code))
      ) then
        raise exception '[DOCTOR_INVITE_CODE_INVALID] The clinic doctor invite code is not valid';
      end if;
    end if;

    insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about)
    values (
      new.id,
      coalesce(nullif(new.raw_user_meta_data->>'qualification',''), 'MBBS'),
      new.raw_user_meta_data->>'registration_number',
      coalesce((nullif(new.raw_user_meta_data->>'experience_years',''))::int, 0),
      coalesce((nullif(new.raw_user_meta_data->>'consultation_fee',''))::int, 500),
      nullif(new.raw_user_meta_data->>'about','')
    ) on conflict (id) do nothing;

    v_specialization := nullif(new.raw_user_meta_data->>'specialization_id','')::uuid;
    if v_specialization is not null and exists (select 1 from public.specializations where id = v_specialization) then
      insert into public.doctor_specializations (doctor_id, specialization_id)
      values (new.id, v_specialization) on conflict do nothing;
    end if;

    if v_clinic is not null and exists (select 1 from public.clinics where id = v_clinic and is_active) then
      insert into public.doctor_clinics (doctor_id, clinic_id, is_primary)
      values (new.id, v_clinic, true) on conflict do nothing;
    end if;

  elsif v_role = 'CLINIC_ADMIN' then
    v_clinic := nullif(new.raw_user_meta_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[CLINIC_NOT_FOUND] A valid clinic is required for clinic admin accounts';
    end if;

    -- Strict DB check: at most one active admin
    if exists (
      select 1 from public.clinic_staff cs
      where cs.clinic_id = v_clinic and cs.role = 'CLINIC_ADMIN' and cs.is_active
    ) then
      raise exception '[CLINIC_HAS_ADMIN] This clinic already has an administrator';
    end if;

    -- Path B: claiming an existing clinic requires valid clinic_admin_claim_code
    if (new.raw_user_meta_data->>'is_new_clinic') is distinct from 'true' then
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic and cic.admin_claim_code is not null
      ) then
        raise exception '[ADMIN_CODE_NOT_CONFIGURED] No claim code has been configured for this clinic yet';
      end if;

      v_admin_code := coalesce(new.raw_user_meta_data->>'clinic_admin_claim_code', '');
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic
          and upper(trim(cic.admin_claim_code)) = upper(trim(v_admin_code))
      ) then
        raise exception '[ADMIN_CLAIM_CODE_INVALID] The clinic admin verification code is invalid';
      end if;
    end if;

    insert into public.clinic_staff (user_id, clinic_id, role)
    values (new.id, v_clinic, 'CLINIC_ADMIN') on conflict do nothing;

  elsif v_role = 'RECEPTIONIST' then
    v_clinic := nullif(new.raw_user_meta_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[CLINIC_NOT_FOUND] A valid clinic is required for staff accounts';
    end if;

    v_staff_code := coalesce(new.raw_user_meta_data->>'staff_invite_code', '');
    if not exists (
      select 1 from public.clinic_invite_codes cic
      where cic.clinic_id = v_clinic
        and upper(trim(cic.code)) = upper(trim(v_staff_code))
    ) then
      raise exception '[INVITE_CODE_INVALID] The clinic staff invite code is not valid';
    end if;

    insert into public.clinic_staff (user_id, clinic_id, role)
    values (new.id, v_clinic, 'RECEPTIONIST') on conflict do nothing;
  end if;

  -- Mirror all roles into JWT app_metadata
  update auth.users
  set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb)
    || jsonb_build_object(
      'role', v_role::text,
      'roles', (select jsonb_agg(role) from public.profile_roles where profile_id = new.id)
    )
  where id = new.id;

  perform public.log_audit('AUTH_SIGNUP', 'PROFILE', new.id, v_clinic, null,
    jsonb_build_object('role', v_role::text));

  return new;
end;
$$;

-- 5. Update add_profile_role() RPC
create or replace function public.add_profile_role(
  p_user_id uuid,
  p_role public.user_role,
  p_data jsonb default '{}'::jsonb
) returns jsonb
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_clinic uuid;
  v_specialization uuid;
  v_doc_code text;
  v_staff_code text;
  v_admin_code text;
begin
  if not exists (select 1 from public.profiles where id = p_user_id) then
    raise exception '[NOT_FOUND] User profile does not exist';
  end if;

  if exists (select 1 from public.profile_roles where profile_id = p_user_id and role = p_role) then
    raise exception '[ROLE_EXISTS] You already have this role registered';
  end if;

  if p_role = 'PATIENT' then
    insert into public.patients (id, date_of_birth, sex, city)
    values (
      p_user_id,
      nullif(p_data->>'date_of_birth','')::date,
      nullif(p_data->>'sex','')::public.sex,
      nullif(p_data->>'city','')
    ) on conflict (id) do nothing;

  elsif p_role = 'DOCTOR' then
    v_clinic := nullif(p_data->>'clinic_id','')::uuid;

    if v_clinic is not null and (p_data->>'is_new_clinic') is distinct from 'true' then
      if not exists (select 1 from public.clinics where id = v_clinic) then
        raise exception '[CLINIC_NOT_FOUND] The selected clinic could not be found';
      end if;

      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic and cic.doctor_code is not null
      ) then
        raise exception '[DOCTOR_CODE_NOT_CONFIGURED] No doctor invite code is configured for this clinic yet';
      end if;

      v_doc_code := coalesce(p_data->>'doctor_invite_code', '');
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic
          and upper(trim(cic.doctor_code)) = upper(trim(v_doc_code))
      ) then
        raise exception '[DOCTOR_INVITE_CODE_INVALID] The clinic doctor invite code is not valid';
      end if;
    end if;

    insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about)
    values (
      p_user_id,
      coalesce(nullif(p_data->>'qualification',''), 'MBBS'),
      p_data->>'registration_number',
      coalesce((nullif(p_data->>'experience_years',''))::int, 0),
      coalesce((nullif(p_data->>'consultation_fee',''))::int, 500),
      nullif(p_data->>'about','')
    ) on conflict (id) do nothing;

    v_specialization := nullif(p_data->>'specialization_id','')::uuid;
    if v_specialization is not null and exists (select 1 from public.specializations where id = v_specialization) then
      insert into public.doctor_specializations (doctor_id, specialization_id)
      values (p_user_id, v_specialization) on conflict do nothing;
    end if;

    if v_clinic is not null and exists (select 1 from public.clinics where id = v_clinic and is_active) then
      insert into public.doctor_clinics (doctor_id, clinic_id, is_primary)
      values (p_user_id, v_clinic, true) on conflict do nothing;
    end if;

  elsif p_role = 'CLINIC_ADMIN' then
    v_clinic := nullif(p_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[CLINIC_NOT_FOUND] A valid clinic is required for clinic admin accounts';
    end if;

    if exists (
      select 1 from public.clinic_staff cs
      where cs.clinic_id = v_clinic and cs.role = 'CLINIC_ADMIN' and cs.is_active
    ) then
      raise exception '[CLINIC_HAS_ADMIN] This clinic already has an administrator';
    end if;

    if (p_data->>'is_new_clinic') is distinct from 'true' then
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic and cic.admin_claim_code is not null
      ) then
        raise exception '[ADMIN_CODE_NOT_CONFIGURED] No claim code has been configured for this clinic yet';
      end if;

      v_admin_code := coalesce(p_data->>'clinic_admin_claim_code', '');
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic
          and upper(trim(cic.admin_claim_code)) = upper(trim(v_admin_code))
      ) then
        raise exception '[ADMIN_CLAIM_CODE_INVALID] The clinic admin verification code is invalid';
      end if;
    end if;

    insert into public.clinic_staff (user_id, clinic_id, role)
    values (p_user_id, v_clinic, 'CLINIC_ADMIN') on conflict do nothing;

  elsif p_role = 'RECEPTIONIST' then
    v_clinic := nullif(p_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[CLINIC_NOT_FOUND] A valid clinic is required for staff accounts';
    end if;

    v_staff_code := coalesce(p_data->>'staff_invite_code', '');
    if not exists (
      select 1 from public.clinic_invite_codes cic
      where cic.clinic_id = v_clinic
        and upper(trim(cic.code)) = upper(trim(v_staff_code))
    ) then
      raise exception '[INVITE_CODE_INVALID] The clinic staff invite code is not valid';
    end if;

    insert into public.clinic_staff (user_id, clinic_id, role)
    values (p_user_id, v_clinic, 'RECEPTIONIST') on conflict do nothing;
  end if;

  -- Insert into profile_roles
  insert into public.profile_roles (profile_id, role)
  values (p_user_id, p_role)
  on conflict (profile_id, role) do nothing;

  -- Update JWT app_metadata
  update auth.users
  set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb)
    || jsonb_build_object(
      'role', p_role::text,
      'roles', (select jsonb_agg(role) from public.profile_roles where profile_id = p_user_id)
    )
  where id = p_user_id;

  perform public.log_audit('AUTH_ADD_ROLE', 'PROFILE', p_user_id, v_clinic, null,
    jsonb_build_object('role', p_role::text));

  return jsonb_build_object('success', true, 'role', p_role::text);
end;
$$;

grant execute on function public.add_profile_role(uuid, public.user_role, jsonb) to authenticated;

-- 6. User Preferences Table
create table if not exists public.user_preferences (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  theme text not null default 'system' check (theme in ('system', 'light', 'dark')),
  sound_enabled boolean not null default false,
  notify_appointments boolean not null default true,
  notify_queue boolean not null default true,
  notify_prescriptions boolean not null default true,
  notify_followups boolean not null default true,
  notify_reminders boolean not null default true,
  anonymous_reviews boolean not null default false,
  public_fee boolean not null default true,
  show_emergency_contact boolean not null default true,
  ai_assistant_enabled boolean not null default true,
  ai_response_length text not null default 'concise' check (ai_response_length in ('concise', 'detailed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.user_preferences enable row level security;

create policy "user_preferences_select" on public.user_preferences
  for select to authenticated using (auth.uid() = user_id);

create policy "user_preferences_insert" on public.user_preferences
  for insert to authenticated with check (auth.uid() = user_id);

create policy "user_preferences_update" on public.user_preferences
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 7. Update create_notification RPC to enforce per-category notification preferences
create or replace function public.create_notification(
  p_user uuid,
  p_type public.notification_type,
  p_title text,
  p_body text,
  p_entity_type text default null,
  p_entity_id uuid default null
) returns void
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_pref record;
begin
  select * into v_pref from public.user_preferences where user_id = p_user;
  if found then
    if p_type in ('APPOINTMENT_BOOKED', 'APPOINTMENT_CONFIRMED', 'APPOINTMENT_CANCELLED', 'APPOINTMENT_RESCHEDULED') and not v_pref.notify_appointments then
      return;
    end if;
    if p_type in ('CHECK_IN_CONFIRMED', 'QUEUE_UPDATED', 'QUEUE_CALLED', 'QUEUE_COMPLETED') and not v_pref.notify_queue then
      return;
    end if;
    if p_type in ('CONSULTATION_COMPLETED', 'PRESCRIPTION_CREATED') and not v_pref.notify_prescriptions then
      return;
    end if;
    if p_type in ('FOLLOW_UP_SCHEDULED') and not v_pref.notify_followups then
      return;
    end if;
    if p_type in ('MEDICATION_REMINDER') and not v_pref.notify_reminders then
      return;
    end if;
  end if;

  insert into public.notifications (user_id, type, title, body, entity_type, entity_id)
  values (p_user, p_type, p_title, p_body, p_entity_type, p_entity_id);
end;
$$;

grant execute on function public.create_notification(uuid, public.notification_type, text, text, text, uuid) to authenticated, anon;

-- 8. Add user_preferences to realtime publication if not already present
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'user_preferences'
  ) then
    alter publication supabase_realtime add table public.user_preferences;
  end if;
end;
$$;

-- 9. Privacy flags getter (security definer so any authenticated user can view reviewer anonymity and doctor public fee flag)
create or replace function public.get_user_privacy_flags(p_user_ids uuid[])
returns table (
  user_id uuid,
  anonymous_reviews boolean,
  public_fee boolean,
  show_emergency_contact boolean
)
language sql
security definer
stable
set search_path = public
as $$
  select
    p.id as user_id,
    coalesce(up.anonymous_reviews, false) as anonymous_reviews,
    coalesce(up.public_fee, true) as public_fee,
    coalesce(up.show_emergency_contact, true) as show_emergency_contact
  from unnest(p_user_ids) p(id)
  left join public.user_preferences up on up.user_id = p.id;
$$;

grant execute on function public.get_user_privacy_flags(uuid[]) to authenticated, anon;

