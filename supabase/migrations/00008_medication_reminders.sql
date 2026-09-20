-- ─────────────────────────────────────────────────────────────────
-- 00008 — daily medication reminder generator
--
-- Creates one MEDICATION_REMINDER notification per patient per day
-- for patients with at least one ACTIVE medication schedule covering
-- today. Idempotent within the day, so it can be run by any scheduler
-- (pg_cron on Supabase, or `npm run reminders` from CI/a server cron).
--
-- Execution is restricted: only the service role / database owner can
-- run it (patients cannot trigger bulk notifications).
-- ─────────────────────────────────────────────────────────────────

create or replace function public.create_medication_reminders()
returns integer
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_count integer := 0;
  v_patient record;
begin
  for v_patient in
    select ms.patient_id,
           string_agg(
             distinct ms.medicine_name || ' (' || to_char(ms.time_of_day, 'HH12:MI AM') || ')',
             ', ' order by ms.medicine_name || ' (' || to_char(ms.time_of_day, 'HH12:MI AM') || ')'
           ) as meds
    from public.medication_schedules ms
    where ms.status = 'ACTIVE'
      and current_date between ms.start_date and ms.end_date
    group by ms.patient_id
  loop
    if not exists (
      select 1 from public.notifications n
      where n.user_id = v_patient.patient_id
        and n.type = 'MEDICATION_REMINDER'
        and n.created_at >= current_date
        and n.created_at < current_date + 1
    ) then
      perform public.create_notification(
        v_patient.patient_id, 'MEDICATION_REMINDER', 'Medication reminder',
        'You have medication scheduled today: ' || v_patient.meds || '. Take each dose as prescribed.',
        'MEDICATION_SCHEDULE', null
      );
      v_count := v_count + 1;
    end if;
  end loop;

  return v_count;
end;
$$;

revoke execute on function public.create_medication_reminders() from anon, authenticated, public;
grant execute on function public.create_medication_reminders() to service_role;
