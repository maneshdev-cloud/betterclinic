-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00022_round2_fixes.sql
-- Live-testing fixes:
-- 1. Unique index on clinic name + city for deduplication
-- 2. Scoped RLS on clinic_invite_codes for affiliated doctors
-- 3. Trigger update: CLINIC_ADMIN does not require invite code (verifies no existing admin)
-- 4. Atomic create_clinic_with_invite RPC
-- ═══════════════════════════════════════════════════════════════════

-- 1. Unique index on clinic name + city (case-insensitive)
create unique index if not exists idx_clinics_name_city_unique 
  on public.clinics (lower(name), lower(city));

-- 2. Invite codes viewable by both Clinic Admin and affiliated Doctors
drop policy if exists invite_codes_admin on public.clinic_invite_codes;
drop policy if exists invite_codes_staff_and_doctors on public.clinic_invite_codes;

create policy invite_codes_staff_and_doctors on public.clinic_invite_codes
  for select to authenticated using (
    public.is_clinic_admin(clinic_id)
    or exists (
      select 1 from public.doctor_clinics dc
      where dc.clinic_id = public.clinic_invite_codes.clinic_id
        and dc.doctor_id = auth.uid()
    )
  );

-- 3. Atomic create_clinic_with_invite RPC (SECURITY DEFINER)
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

  -- Deduplication check: case-insensitive match on name + city
  if exists (
    select 1 from public.clinics 
    where lower(name) = lower(p_name) and lower(city) = lower(p_city)
  ) then
    raise exception '[DUPLICATE_CLINIC] A clinic with this name and city already exists';
  end if;

  -- Insert clinic
  insert into public.clinics (name, city, area, address_line, is_active)
  values (p_name, p_city, p_area, p_address_line, true)
  returning id into v_clinic_id;

  -- Generate 6-char alphanumeric invite code
  v_code := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
  insert into public.clinic_invite_codes (clinic_id, code)
  values (v_clinic_id, v_code)
  on conflict (clinic_id) do update set code = excluded.code;

  -- Initialize standard clinic hours (Mon-Sat 08:00 - 20:00)
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
    'invite_code', v_code
  );
end;
$$;

-- Grant execution to anon and authenticated (used during signup)
grant execute on function public.create_clinic_with_invite(text, text, text, text) to anon, authenticated;

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
  );

  if v_role = 'PATIENT' then
    insert into public.patients (id, date_of_birth, sex, city)
    values (
      new.id,
      nullif(new.raw_user_meta_data->>'date_of_birth','')::date,
      nullif(new.raw_user_meta_data->>'sex','')::public.sex,
      nullif(new.raw_user_meta_data->>'city','')
    );

  elsif v_role = 'DOCTOR' then
    insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about)
    values (
      new.id,
      coalesce(nullif(new.raw_user_meta_data->>'qualification',''), 'MBBS'),
      new.raw_user_meta_data->>'registration_number',
      coalesce((nullif(new.raw_user_meta_data->>'experience_years',''))::int, 0),
      coalesce((nullif(new.raw_user_meta_data->>'consultation_fee',''))::int, 500),
      nullif(new.raw_user_meta_data->>'about','')
    );
    v_specialization := nullif(new.raw_user_meta_data->>'specialization_id','')::uuid;
    if v_specialization is not null and exists (select 1 from public.specializations where id = v_specialization) then
      insert into public.doctor_specializations (doctor_id, specialization_id)
      values (new.id, v_specialization) on conflict do nothing;
    end if;
    v_clinic := nullif(new.raw_user_meta_data->>'clinic_id','')::uuid;
    if v_clinic is not null and exists (select 1 from public.clinics where id = v_clinic and is_active) then
      insert into public.doctor_clinics (doctor_id, clinic_id, is_primary)
      values (new.id, v_clinic, true) on conflict do nothing;
    end if;

  elsif v_role = 'CLINIC_ADMIN' then
    v_clinic := nullif(new.raw_user_meta_data->>'clinic_id','')::uuid;
    if v_clinic is null or not exists (select 1 from public.clinics where id = v_clinic) then
      raise exception '[VALIDATION] A valid clinic is required for clinic admin accounts';
    end if;
    -- Clinic Admin does NOT require an invite code. Guard against multiple admins if already taken.
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
    -- Receptionist still requires an invite code
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

  -- Mirror the role into the JWT app_metadata so middleware can route
  update auth.users
  set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb)
    || jsonb_build_object('role', v_role::text)
  where id = new.id;

  perform public.log_audit('AUTH_SIGNUP', 'PROFILE', new.id, v_clinic, null,
    jsonb_build_object('role', v_role::text));

  return new;
end;
$$;
