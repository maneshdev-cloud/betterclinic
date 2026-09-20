-- ─────────────────────────────────────────────────────────────────
-- 00007 — fix queue_return_to_waiting INSERT column mismatch
--
-- The original function listed 5 columns but supplied 6 values (the
-- 'Called but not present' note had no matching column), so returning
-- a called-but-absent patient to the waiting list always failed with
-- "INSERT has more expressions than target columns". The path was
-- never exercised until the queue-management workflow checks were
-- added; this fix corrects it and that check now guards it.
-- ─────────────────────────────────────────────────────────────────

create or replace function public.queue_return_to_waiting(p_queue_entry_id uuid)
returns public.queue_entries
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_entry public.queue_entries;
begin
  select * into v_entry from public.queue_entries where id = p_queue_entry_id for update;
  if not found then raise exception '[NOT_FOUND] Queue entry not found'; end if;
  if not ((v_role = 'DOCTOR' and v_entry.doctor_id = v_actor)
          or (v_role in ('RECEPTIONIST','CLINIC_ADMIN') and public.is_clinic_staff(v_entry.clinic_id))) then
    raise exception '[FORBIDDEN] You cannot manage this queue';
  end if;
  if v_entry.status <> 'CALLED' then
    raise exception '[INVALID_TRANSITION] Only called tokens can be returned to the waiting list';
  end if;

  update public.queue_entries set status = 'WAITING', called_at = null
  where id = v_entry.id returning * into v_entry;
  update public.appointments set status = 'WAITING' where id = v_entry.appointment_id;
  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by, note)
  values (v_entry.id, 'SKIPPED', 'CALLED', 'WAITING', v_actor, 'Called but not present');

  perform public.log_audit('QUEUE_RETURNED', 'QUEUE_ENTRY', v_entry.id, v_entry.clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code));
  return v_entry;
end;
$$;
