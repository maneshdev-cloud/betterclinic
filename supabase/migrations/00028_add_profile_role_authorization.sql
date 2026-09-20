-- Migration 00028: Add caller-identity check to add_profile_role and audit hardening

-- 1. Update public.add_profile_role with strict caller-identity check
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
  -- Caller identity verification: callers can only modify their own profile
  if p_user_id is distinct from auth.uid() then
    raise exception '[FORBIDDEN] You can only modify your own profile';
  end if;

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

-- 2. Revoke execute from anon and public, grant only to authenticated and service_role
revoke execute on function public.add_profile_role(uuid, public.user_role, jsonb) from anon;
revoke execute on function public.add_profile_role(uuid, public.user_role, jsonb) from public;
grant execute on function public.add_profile_role(uuid, public.user_role, jsonb) to authenticated, service_role;

-- 3. Harden refresh_future_slots with caller-identity / clinic-admin check
create or replace function public.refresh_future_slots(p_doctor uuid, p_clinic uuid)
returns void
language plpgsql security definer set search_path = public, pg_temp as $$
begin
  if p_doctor is distinct from auth.uid() and not public.is_clinic_admin(p_clinic) then
    raise exception '[FORBIDDEN] You can only refresh your own slots or slots for your clinic';
  end if;

  delete from public.appointment_slots
  where doctor_id = p_doctor and clinic_id = p_clinic
    and slot_date >= current_date and status = 'FREE';
end;
$$;

-- 4. Revoke create_notification from anon and public (internal DB use only)
revoke execute on function public.create_notification(uuid, public.notification_type, text, text, text, uuid) from anon;
revoke execute on function public.create_notification(uuid, public.notification_type, text, text, text, uuid) from public;
