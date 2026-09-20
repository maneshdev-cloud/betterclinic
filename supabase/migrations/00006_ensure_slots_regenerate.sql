-- ─────────────────────────────────────────────────────────────────
-- 00006 — ensure_slots regenerates missing FREE slots
--
-- The original ensure_slots only generated slots when a date had ZERO
-- rows. After refresh_future_slots (called when a doctor saves their
-- availability), dates that still hold a BOOKED slot would never get
-- their FREE slots back — patients would see "fully booked" forever on
-- those dates.
--
-- New behaviour: always generate from the CURRENT availability and rely
-- on the (doctor_id, clinic_id, slot_date, start_time) unique index to
-- keep existing rows (including BOOKED ones) untouched. This makes the
-- function fully idempotent and self-healing per slot.
-- ─────────────────────────────────────────────────────────────────

create or replace function public.ensure_slots(p_doctor uuid, p_clinic uuid, p_date date)
returns setof public.appointment_slots
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  av record;
  t time;
  v_end time;
begin
  if p_date < current_date then
    raise exception '[PAST_DATE] Cannot generate slots for a past date';
  end if;
  if p_date > current_date + 60 then
    raise exception '[VALIDATION] Slots can only be generated within the next 60 days';
  end if;

  for av in
    select * from public.doctor_availability
    where doctor_id = p_doctor and clinic_id = p_clinic and is_active
      and day_of_week = extract(dow from p_date)::int
  loop
    t := av.start_time;
    while t + make_interval(mins => av.slot_duration_minutes) <= av.end_time loop
      v_end := t + make_interval(mins => av.slot_duration_minutes);
      -- Skip slots that overlap the doctor's break window at all.
      if av.break_start is null or av.break_end is null
         or v_end <= av.break_start or t >= av.break_end then
        insert into public.appointment_slots (doctor_id, clinic_id, slot_date, start_time, end_time, status)
        values (p_doctor, p_clinic, p_date, t, v_end, 'FREE')
        on conflict (doctor_id, clinic_id, slot_date, start_time) do nothing;
      end if;
      t := v_end;
    end loop;
  end loop;

  return query
  select * from public.appointment_slots
  where doctor_id = p_doctor and clinic_id = p_clinic and slot_date = p_date
  order by start_time;
end;
$$;
