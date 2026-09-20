-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00023_round3_features.sql
-- Multi-role identity, doctor invite codes, and add_profile_role RPC
-- ═══════════════════════════════════════════════════════════════════

-- 1. Create public.profile_roles
create table if not exists public.profile_roles (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  role public.user_role not null,
  created_at timestamptz not null default now(),
  constraint uq_profile_role unique (profile_id, role)
);

alter table public.profile_roles enable row level security;

drop policy if exists profile_roles_select on public.profile_roles;
create policy profile_roles_select on public.profile_roles
  for select to anon, authenticated using (true);

drop policy if exists profile_roles_manage_own on public.profile_roles;
create policy profile_roles_manage_own on public.profile_roles
  for all to authenticated
  using (profile_id = auth.uid()) with check (profile_id = auth.uid());

-- Backfill from existing profiles
insert into public.profile_roles (profile_id, role)
select id, role from public.profiles
on conflict (profile_id, role) do nothing;

-- 2. Add doctor_code to public.clinic_invite_codes
alter table public.clinic_invite_codes
  add column if not exists doctor_code text;

-- Backfill existing clinics with unique doctor codes
do $$
declare
  r record;
  v_code text;
begin
  for r in select clinic_id from public.clinic_invite_codes where doctor_code is null loop
    v_code := upper(substr(md5(random()::text || clock_timestamp()::text || r.clinic_id::text), 1, 6));
    update public.clinic_invite_codes set doctor_code = v_code where clinic_id = r.clinic_id;
  end loop;
end $$;

-- Make doctor_code unique and not null
alter table public.clinic_invite_codes
  alter column doctor_code set not null;

create unique index if not exists idx_clinic_invite_codes_doctor_code
  on public.clinic_invite_codes (doctor_code);

-- 3. Update create_clinic_with_invite RPC to generate both codes
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
  v_dow int;
begin
  p_name := trim(p_name);
  p_city := trim(p_city);
  p_area := trim(p_area);
  p_address_line := trim(p_address_line);

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
  v_doctor_code := upper(substr(md5(random()::text || clock_timestamp()::text || 'doc'), 1, 6));

  insert into public.clinic_invite_codes (clinic_id, code, doctor_code)
  values (v_clinic_id, v_code, v_doctor_code)
  on conflict (clinic_id) do update set code = excluded.code, doctor_code = excluded.doctor_code;

  for v_dow in 1..6 loop
    insert into public.clinic_hours (clinic_id, day_of_week, open_time, close_time, is_closed)
    values (v_clinic_id, v_dow, '08:00:00', '20:00:00', false)
    on conflict (clinic_id, day_of_week) do nothing;
  end loop;

  return jsonb_build_object(
    'id', v_clinic_id,
    'name', p_name,
    'city', p_city,
    'area', p_area,
    'invite_code', v_code,
    'doctor_invite_code', v_doctor_code
  );
end;
$$;

-- 4. Update handle_new_user() trigger function
create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_role public.user_role;
  v_clinic uuid;
  v_specialization uuid;
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

  -- Record role in profile_roles
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
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic
          and upper(cic.doctor_code) = upper(coalesce(new.raw_user_meta_data->>'doctor_invite_code',''))
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
      raise exception '[VALIDATION] A valid clinic is required for clinic admin accounts';
    end if;
    if exists (
      select 1 from public.clinic_staff cs
      where cs.clinic_id = v_clinic and cs.role = 'CLINIC_ADMIN' and cs.is_active
    ) then
      raise exception '[CLINIC_HAS_ADMIN] This clinic already has an administrator';
    end if;
    insert into public.clinic_staff (user_id, clinic_id, role)
    values (new.id, v_clinic, 'CLINIC_ADMIN') on conflict do nothing;

  elsif v_role = 'RECEPTIONIST' then
    v_clinic := nullif(new.raw_user_meta_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[VALIDATION] A valid clinic is required for staff accounts';
    end if;
    if not exists (
      select 1 from public.clinic_invite_codes cic
      where cic.clinic_id = v_clinic
        and upper(cic.code) = upper(coalesce(new.raw_user_meta_data->>'staff_invite_code',''))
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

-- 5. RPC to add a new role to an existing user
create or replace function public.add_profile_role(
  p_user_id uuid,
  p_role public.user_role,
  p_data jsonb default '{}'::jsonb
) returns jsonb
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_clinic uuid;
  v_specialization uuid;
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
      if not exists (
        select 1 from public.clinic_invite_codes cic
        where cic.clinic_id = v_clinic
          and upper(cic.doctor_code) = upper(coalesce(p_data->>'doctor_invite_code',''))
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
      raise exception '[VALIDATION] A valid clinic is required for clinic admin accounts';
    end if;
    if exists (
      select 1 from public.clinic_staff cs
      where cs.clinic_id = v_clinic and cs.role = 'CLINIC_ADMIN' and cs.is_active
    ) then
      raise exception '[CLINIC_HAS_ADMIN] This clinic already has an administrator';
    end if;
    insert into public.clinic_staff (user_id, clinic_id, role)
    values (p_user_id, v_clinic, 'CLINIC_ADMIN') on conflict do nothing;

  elsif p_role = 'RECEPTIONIST' then
    v_clinic := nullif(p_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[VALIDATION] A valid clinic is required for staff accounts';
    end if;
    if not exists (
      select 1 from public.clinic_invite_codes cic
      where cic.clinic_id = v_clinic
        and upper(cic.code) = upper(coalesce(p_data->>'staff_invite_code',''))
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
