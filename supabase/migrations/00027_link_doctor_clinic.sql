-- Migration: 00027_link_doctor_clinic.sql
-- Function to allow an authenticated doctor to link themselves to an existing clinic using the clinic's doctor invite code.

create or replace function public.link_doctor_to_clinic(
  p_clinic_id uuid,
  p_doctor_code text
) returns jsonb
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_uid uuid := auth.uid();
  v_is_primary boolean;
begin
  if v_uid is null then
    raise exception '[UNAUTHENTICATED] You must be logged in to link a clinic';
  end if;

  if not exists (select 1 from public.doctors where id = v_uid) then
    raise exception '[NOT_A_DOCTOR] Only doctor accounts can be linked to clinics';
  end if;

  if not exists (select 1 from public.clinics where id = p_clinic_id and is_active) then
    raise exception '[CLINIC_NOT_FOUND] The specified clinic could not be found or is inactive';
  end if;

  if exists (
    select 1 from public.doctor_clinics
    where doctor_id = v_uid and clinic_id = p_clinic_id
  ) then
    raise exception '[ALREADY_LINKED] You are already affiliated with this clinic';
  end if;

  if not exists (
    select 1 from public.clinic_invite_codes cic
    where cic.clinic_id = p_clinic_id
      and cic.doctor_code is not null
      and upper(trim(cic.doctor_code)) = upper(trim(coalesce(p_doctor_code, '')))
  ) then
    raise exception '[DOCTOR_INVITE_CODE_INVALID] The clinic doctor invite code is invalid';
  end if;

  v_is_primary := not exists (
    select 1 from public.doctor_clinics
    where doctor_id = v_uid and is_primary = true
  );

  insert into public.doctor_clinics (doctor_id, clinic_id, is_primary)
  values (v_uid, p_clinic_id, v_is_primary)
  on conflict (doctor_id, clinic_id) do nothing;

  perform public.log_audit('DOCTOR_LINK_CLINIC', 'CLINIC', v_uid, p_clinic_id, null,
    jsonb_build_object('clinic_id', p_clinic_id, 'is_primary', v_is_primary));

  return jsonb_build_object('success', true, 'clinic_id', p_clinic_id);
end;
$$;

revoke all on function public.link_doctor_to_clinic(uuid, text) from public;
grant execute on function public.link_doctor_to_clinic(uuid, text) to authenticated;
