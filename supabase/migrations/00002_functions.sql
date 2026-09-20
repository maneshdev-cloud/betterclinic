-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00002_functions.sql
-- Business-logic functions, triggers and RPCs. Idempotent.
--
-- All mutation RPCs are SECURITY DEFINER (owner: postgres) so they
-- bypass RLS in a CONTROLLED way: each one re-validates permissions
-- and inputs itself, keeps state transitions valid, writes audit
-- logs and notifications. Clients cannot mutate protected tables
-- directly (their RLS write policies are denied) — they must go
-- through these functions. This gives race-safe booking, atomic
-- check-in + token generation, and a consistent audit trail.
-- ═══════════════════════════════════════════════════════════════════

-- ── updated_at maintenance ───────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

do $$
declare t record;
begin
  for t in
    select table_name from information_schema.columns
    where table_schema = 'public' and column_name = 'updated_at'
  loop
    execute format('drop trigger if exists set_updated_at on public.%I', t.table_name);
    execute format('create trigger set_updated_at before update on public.%I
                    for each row execute function public.set_updated_at()', t.table_name);
  end loop;
end;
$$;

-- ── Security context helpers (used by RLS policies) ──────────────

create or replace function public.current_profile_id()
returns uuid language sql stable security definer set search_path = public, pg_temp as $$
  select id from public.profiles where id = auth.uid();
$$;

create or replace function public.active_role()
returns public.user_role language sql stable security definer set search_path = public, pg_temp as $$
  select role from public.profiles where id = auth.uid();
$$;

create or replace function public.is_clinic_staff(p_clinic uuid)
returns boolean language sql stable security definer set search_path = public, pg_temp as $$
  select exists (
    select 1 from public.clinic_staff cs
    where cs.user_id = auth.uid() and cs.clinic_id = p_clinic and cs.is_active
  );
$$;

create or replace function public.is_clinic_admin(p_clinic uuid)
returns boolean language sql stable security definer set search_path = public, pg_temp as $$
  select exists (
    select 1 from public.clinic_staff cs
    where cs.user_id = auth.uid() and cs.clinic_id = p_clinic and cs.is_active
      and cs.role = 'CLINIC_ADMIN'
  );
$$;

-- A doctor may read a patient's clinical records only when a real
-- care relationship exists: any appointment, consultation or
-- prescription between them (past or present).
-- A doctor may read a patient's clinical records only when a real,
-- DIRECT care relationship exists: an appointment, consultation or
-- prescription between these two specific people. Practising at the
-- same clinic is NOT sufficient (spec: no free read access to every
-- patient).
create or replace function public.has_care_relationship(p_doctor uuid, p_patient uuid)
returns boolean language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from public.appointments a where a.doctor_id = p_doctor and a.patient_id = p_patient)
     or exists (select 1 from public.consultations c where c.doctor_id = p_doctor and c.patient_id = p_patient)
     or exists (select 1 from public.prescriptions pr where pr.doctor_id = p_doctor and pr.patient_id = p_patient)
$$;

create or replace function public.app_env()
returns text language sql stable security definer set search_path = public, pg_temp as $$
  select coalesce((select value from public.app_settings where key = 'app_env'), 'demo');
$$;

-- ── Cross-cutting helpers: notifications & audit ─────────────────

create or replace function public.create_notification(
  p_user uuid,
  p_type public.notification_type,
  p_title text,
  p_body text,
  p_entity_type text default null,
  p_entity_id uuid default null
) returns void
language sql security definer set search_path = public, pg_temp as $$
  insert into public.notifications (user_id, type, title, body, entity_type, entity_id)
  values (p_user, p_type, p_title, p_body, p_entity_type, p_entity_id);
$$;

create or replace function public.log_audit(
  p_action text,
  p_entity_type text,
  p_entity_id uuid default null,
  p_clinic_id uuid default null,
  p_patient_id uuid default null,
  p_metadata jsonb default null
) returns void
language sql security definer set search_path = public, pg_temp as $$
  insert into public.audit_logs (actor_id, actor_role, action, entity_type, entity_id, clinic_id, patient_id, metadata)
  values (public.current_profile_id(), public.active_role(), p_action, p_entity_type, p_entity_id,
          p_clinic_id, p_patient_id, coalesce(p_metadata, '{}'::jsonb));
$$;

-- ── Signup: auth.users → profile → role-specific rows ────────────

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
      new.raw_user_meta_data->>'qualification',
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

  elsif v_role in ('RECEPTIONIST','CLINIC_ADMIN') then
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
    values (new.id, v_clinic, v_role) on conflict do nothing;
  end if;

  -- Mirror the role into the JWT app_metadata so middleware can
  -- route without a database round-trip on every request.
  update auth.users
  set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb)
    || jsonb_build_object('role', v_role::text)
  where id = new.id;

  perform public.log_audit('AUTH_SIGNUP', 'PROFILE', new.id, v_clinic, null,
    jsonb_build_object('role', v_role::text));

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ── Queue tokens: deterministic per clinic/doctor/day ────────────

create or replace function public.format_token_code(p_num integer)
returns text language sql immutable as $$
  select 'T' || lpad(p_num::text, 3, '0');
$$;

create or replace function public.next_queue_token(p_clinic uuid, p_doctor uuid, p_date date)
returns integer
language plpgsql security definer set search_path = public, pg_temp as $$
declare v_num integer;
begin
  insert into public.queue_token_counters (clinic_id, doctor_id, counter_date, last_number)
  values (p_clinic, p_doctor, p_date, 1)
  on conflict (clinic_id, doctor_id, counter_date)
  do update set last_number = public.queue_token_counters.last_number + 1
  returning last_number into v_num;
  return v_num;
end;
$$;

create or replace function public.assign_queue_token()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
declare v_num integer;
begin
  if new.token_number is null or new.token_number <= 0 then
    v_num := public.next_queue_token(new.clinic_id, new.doctor_id, new.queue_date);
    new.token_number := v_num;
    new.token_code := public.format_token_code(v_num);
  end if;
  if new.token_code is null or new.token_code = '' then
    new.token_code := public.format_token_code(new.token_number);
  end if;
  return new;
end;
$$;

drop trigger if exists assign_queue_token on public.queue_entries;
create trigger assign_queue_token
  before insert on public.queue_entries
  for each row execute function public.assign_queue_token();

-- ── Appointment state machine (mirrors lib/constants.ts) ─────────

create or replace function public.appointment_transition_valid(
  p_from public.appointment_status, p_to public.appointment_status
) returns boolean language sql immutable as $$
  select case p_from
    when 'BOOKED'          then p_to in ('CONFIRMED','CHECKED_IN','CANCELLED','NO_SHOW')
    when 'CONFIRMED'       then p_to in ('CHECKED_IN','CANCELLED','NO_SHOW')
    when 'CHECKED_IN'      then p_to in ('WAITING','CANCELLED')
    when 'WAITING'         then p_to in ('CALLED','CANCELLED','NO_SHOW')
    when 'CALLED'          then p_to in ('IN_CONSULTATION','WAITING','NO_SHOW')
    when 'IN_CONSULTATION' then p_to in ('COMPLETED')
    else false
  end;
$$;

create or replace function public.appointments_before_update()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
begin
  if new.status <> old.status and not public.appointment_transition_valid(old.status, new.status) then
    raise exception '[INVALID_TRANSITION] An appointment cannot move from % to %', old.status, new.status;
  end if;
  if new.status = 'CONFIRMED'    and old.status <> 'CONFIRMED'    then new.confirmed_at := now(); end if;
  if new.status = 'CANCELLED'    and old.status <> 'CANCELLED'    then new.cancelled_at := now(); end if;
  if new.status = 'COMPLETED'    and old.status <> 'COMPLETED'    then new.completed_at := now(); end if;
  if new.status = 'CHECKED_IN'   and old.status <> 'CHECKED_IN'   then new.checked_in_at := now(); end if;
  if new.status in ('CANCELLED','NO_SHOW') and new.cancellation_reason is null and old.status not in ('CANCELLED','NO_SHOW') then
    new.cancellation_reason := 'Status set to ' || new.status;
  end if;
  return new;
end;
$$;

drop trigger if exists appointments_before_update on public.appointments;
create trigger appointments_before_update
  before update on public.appointments
  for each row execute function public.appointments_before_update();

create or replace function public.appointments_after_update()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  e record;
begin
  if new.status <> old.status then
    insert into public.appointment_status_history (appointment_id, from_status, to_status, changed_by, reason)
    values (new.id, old.status, new.status, v_actor, new.cancellation_reason);

    -- Queue consistency: a cancelled / no-show appointment must not
    -- remain active in the queue.
    if new.status in ('CANCELLED','NO_SHOW') then
      for e in
        select id, status from public.queue_entries
        where appointment_id = new.id
          and status in ('WAITING','CALLED','SKIPPED','IN_CONSULTATION')
      loop
        update public.queue_entries set status = 'CANCELLED', completed_at = now() where id = e.id;
        insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by, note)
        values (e.id, 'CANCELLED', e.status, 'CANCELLED', v_actor, 'Appointment ' || new.status);
      end loop;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists appointments_after_update on public.appointments;
create trigger appointments_after_update
  after update on public.appointments
  for each row execute function public.appointments_after_update();

-- ── Slot generation (data-driven from doctor_availability) ───────

create or replace function public.ensure_slots(p_doctor uuid, p_clinic uuid, p_date date)
returns setof public.appointment_slots
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  av record;
  t time;
  v_end time;
  v_existing integer;
begin
  if p_date < current_date then
    raise exception '[PAST_DATE] Cannot generate slots for a past date';
  end if;
  if p_date > current_date + 60 then
    raise exception '[VALIDATION] Slots can only be generated within the next 60 days';
  end if;

  select count(*) into v_existing from public.appointment_slots
  where doctor_id = p_doctor and clinic_id = p_clinic and slot_date = p_date;

  if v_existing = 0 then
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
  end if;

  return query
  select * from public.appointment_slots
  where doctor_id = p_doctor and clinic_id = p_clinic and slot_date = p_date
  order by start_time;
end;
$$;

-- Called after availability changes: drop FREE future slots so they
-- regenerate from the new availability on demand (BOOKED slots are kept).
create or replace function public.refresh_future_slots(p_doctor uuid, p_clinic uuid)
returns void
language sql security definer set search_path = public, pg_temp as $$
  delete from public.appointment_slots
  where doctor_id = p_doctor and clinic_id = p_clinic
    and slot_date >= current_date and status = 'FREE';
$$;

-- ── Booking / rescheduling / cancellation ────────────────────────

create or replace function public.book_appointment(
  p_slot_id uuid,
  p_visit_reason text,
  p_patient_id uuid default null
) returns public.appointments
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_slot public.appointment_slots;
  v_patient uuid;
  v_appointment public.appointments;
  v_doctor_name text;
  v_clinic_name text;
begin
  if v_role = 'PATIENT' then
    if p_patient_id is not null and p_patient_id <> v_actor then
      raise exception '[FORBIDDEN] Patients can only book appointments for themselves';
    end if;
    v_patient := v_actor;
  elsif v_role in ('RECEPTIONIST','CLINIC_ADMIN') and p_patient_id is not null then
    v_patient := p_patient_id;
  else
    raise exception '[FORBIDDEN] Only patients (for themselves) or clinic staff (on behalf of a patient) can book appointments';
  end if;

  if coalesce(p_visit_reason,'') = '' or length(p_visit_reason) < 3 then
    raise exception '[VALIDATION] Please describe the reason for your visit (at least 3 characters)';
  end if;

  select * into v_slot from public.appointment_slots where id = p_slot_id for update;
  if not found then
    raise exception '[NOT_FOUND] The selected slot does not exist';
  end if;
  if v_slot.status <> 'FREE' then
    raise exception '[SLOT_TAKEN] That time was just booked by someone else — please pick another slot';
  end if;
  if v_slot.slot_date < current_date then
    raise exception '[PAST_DATE] Cannot book a slot in the past';
  end if;
  if v_slot.slot_date = current_date
     and v_slot.start_time <= (now() at time zone 'Asia/Kolkata')::time then
    raise exception '[PAST_DATE] That time has already passed today';
  end if;

  if v_role in ('RECEPTIONIST','CLINIC_ADMIN') and not public.is_clinic_staff(v_slot.clinic_id) then
    raise exception '[FORBIDDEN] Staff can only book at their own clinic';
  end if;

  -- Patient double-booking guard: no overlapping active appointment.
  if exists (
    select 1 from public.appointments a
    where a.patient_id = v_patient
      and a.appointment_date = v_slot.slot_date
      and a.status in ('BOOKED','CONFIRMED','CHECKED_IN','WAITING','CALLED','IN_CONSULTATION')
      and a.start_time < v_slot.end_time and a.end_time > v_slot.start_time
  ) then
    raise exception '[DOUBLE_BOOKING] This patient already has an appointment overlapping that time';
  end if;

  insert into public.appointments
    (patient_id, doctor_id, clinic_id, slot_id, appointment_type, status,
     appointment_date, start_time, end_time, visit_reason, created_by)
  values
    (v_patient, v_slot.doctor_id, v_slot.clinic_id, v_slot.id, 'SCHEDULED', 'BOOKED',
     v_slot.slot_date, v_slot.start_time, v_slot.end_time, p_visit_reason, v_actor)
  returning * into v_appointment;

  update public.appointment_slots
  set status = 'BOOKED', appointment_id = v_appointment.id
  where id = v_slot.id;

  insert into public.appointment_status_history (appointment_id, to_status, changed_by)
  values (v_appointment.id, 'BOOKED', v_actor);

  select p.full_name into v_doctor_name from public.profiles p where p.id = v_slot.doctor_id;
  select c.name into v_clinic_name from public.clinics c where c.id = v_slot.clinic_id;

  perform public.create_notification(
    v_patient, 'APPOINTMENT_BOOKED', 'Appointment booked',
    'Your appointment with Dr. ' || v_doctor_name || ' at ' || v_clinic_name || ' on '
      || to_char(v_slot.slot_date, 'DD Mon YYYY') || ', ' || to_char(v_slot.start_time, 'HH12:MI AM')
      || ' is confirmed as booked. Appointment ID: ' || upper(left(v_appointment.id::text, 8)),
    'APPOINTMENT', v_appointment.id);

  perform public.log_audit('APPOINTMENT_BOOKED', 'APPOINTMENT', v_appointment.id, v_slot.clinic_id, v_patient,
    jsonb_build_object('slot_id', p_slot_id, 'date', v_slot.slot_date, 'time', v_slot.start_time));

  return v_appointment;
end;
$$;

create or replace function public.reschedule_appointment(
  p_appointment_id uuid,
  p_new_slot_id uuid,
  p_reason text default null
) returns public.appointments
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_app public.appointments;
  v_slot public.appointment_slots;
begin
  select * into v_app from public.appointments where id = p_appointment_id for update;
  if not found then
    raise exception '[NOT_FOUND] Appointment not found';
  end if;

  if not (
    (v_role = 'PATIENT' and v_app.patient_id = v_actor)
    or (v_role = 'DOCTOR' and v_app.doctor_id = v_actor)
    or (v_role in ('RECEPTIONIST','CLINIC_ADMIN') and public.is_clinic_staff(v_app.clinic_id))
  ) then
    raise exception '[FORBIDDEN] You cannot reschedule this appointment';
  end if;

  if v_app.status not in ('BOOKED','CONFIRMED') then
    raise exception '[INVALID_TRANSITION] Only booked or confirmed appointments can be rescheduled';
  end if;

  select * into v_slot from public.appointment_slots where id = p_new_slot_id for update;
  if not found then
    raise exception '[NOT_FOUND] The selected slot does not exist';
  end if;
  if v_slot.status <> 'FREE' then
    raise exception '[SLOT_TAKEN] That time was just booked by someone else — please pick another slot';
  end if;
  if v_slot.slot_date < current_date then
    raise exception '[PAST_DATE] Cannot reschedule into the past';
  end if;
  if v_slot.slot_date = current_date
     and v_slot.start_time <= (now() at time zone 'Asia/Kolkata')::time then
    raise exception '[PAST_DATE] That time has already passed today';
  end if;
  if v_slot.doctor_id <> v_app.doctor_id or v_slot.clinic_id <> v_app.clinic_id then
    raise exception '[VALIDATION] Rescheduling keeps the same doctor and clinic — book a new appointment to change them';
  end if;

  if exists (
    select 1 from public.appointments a
    where a.patient_id = v_app.patient_id and a.id <> v_app.id
      and a.appointment_date = v_slot.slot_date
      and a.status in ('BOOKED','CONFIRMED','CHECKED_IN','WAITING','CALLED','IN_CONSULTATION')
      and a.start_time < v_slot.end_time and a.end_time > v_slot.start_time
  ) then
    raise exception '[DOUBLE_BOOKING] The patient already has another appointment overlapping that time';
  end if;

  -- Preserve history: record the old schedule in the status history.
  insert into public.appointment_status_history (appointment_id, from_status, to_status, changed_by, reason)
  values (v_app.id, v_app.status, v_app.status, v_actor,
    'Rescheduled from ' || to_char(v_app.appointment_date,'DD Mon YYYY') || ' '
    || to_char(v_app.start_time,'HH12:MI AM') || ' to ' || to_char(v_slot.slot_date,'DD Mon YYYY') || ' '
    || to_char(v_slot.start_time,'HH12:MI AM') || coalesce(' — ' || p_reason, ''));

  -- Release the old slot, occupy the new one.
  if v_app.slot_id is not null then
    update public.appointment_slots set status = 'FREE', appointment_id = null
    where id = v_app.slot_id and status = 'BOOKED';
  end if;
  update public.appointment_slots set status = 'BOOKED', appointment_id = v_app.id
  where id = v_slot.id;

  update public.appointments
  set slot_id = v_slot.id,
      appointment_date = v_slot.slot_date,
      start_time = v_slot.start_time,
      end_time = v_slot.end_time,
      booked_at = now()
  where id = v_app.id
  returning * into v_app;

  perform public.create_notification(
    v_app.patient_id, 'APPOINTMENT_RESCHEDULED', 'Appointment rescheduled',
    'Your appointment with Dr. ' || (select p.full_name from public.profiles p where p.id = v_app.doctor_id)
      || ' was moved to ' || to_char(v_slot.slot_date,'DD Mon YYYY') || ', '
      || to_char(v_slot.start_time,'HH12:MI AM') || '.',
    'APPOINTMENT', v_app.id);

  perform public.log_audit('APPOINTMENT_RESCHEDULED', 'APPOINTMENT', v_app.id, v_app.clinic_id, v_app.patient_id,
    jsonb_build_object('new_slot_id', p_new_slot_id, 'reason', p_reason));

  return v_app;
end;
$$;

create or replace function public.cancel_appointment(
  p_appointment_id uuid,
  p_reason text default null
) returns public.appointments
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_app public.appointments;
begin
  select * into v_app from public.appointments where id = p_appointment_id for update;
  if not found then
    raise exception '[NOT_FOUND] Appointment not found';
  end if;

  if not (
    (v_role = 'PATIENT' and v_app.patient_id = v_actor)
    or (v_role = 'DOCTOR' and v_app.doctor_id = v_actor)
    or (v_role in ('RECEPTIONIST','CLINIC_ADMIN') and public.is_clinic_staff(v_app.clinic_id))
  ) then
    raise exception '[FORBIDDEN] You cannot cancel this appointment';
  end if;

  if v_app.status not in ('BOOKED','CONFIRMED','CHECKED_IN','WAITING') then
    raise exception '[INVALID_TRANSITION] This appointment can no longer be cancelled';
  end if;

  -- Release the slot.
  if v_app.slot_id is not null then
    update public.appointment_slots set status = 'FREE', appointment_id = null
    where id = v_app.slot_id and status = 'BOOKED';
  end if;

  update public.appointments
  set status = 'CANCELLED', cancellation_reason = coalesce(p_reason, 'Cancelled by user')
  where id = v_app.id
  returning * into v_app;
  -- (queue cleanup + status history happen in the update triggers)

  perform public.create_notification(
    v_app.patient_id, 'APPOINTMENT_CANCELLED', 'Appointment cancelled',
    'Your appointment on ' || to_char(v_app.appointment_date,'DD Mon YYYY') || ', '
      || to_char(v_app.start_time,'HH12:MI AM') || ' has been cancelled.'
      || coalesce(' Reason: ' || p_reason, ''),
    'APPOINTMENT', v_app.id);

  perform public.log_audit('APPOINTMENT_CANCELLED', 'APPOINTMENT', v_app.id, v_app.clinic_id, v_app.patient_id,
    jsonb_build_object('reason', p_reason));

  return v_app;
end;
$$;

create or replace function public.confirm_appointment(p_appointment_id uuid)
returns public.appointments
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_role public.user_role := public.active_role();
  v_app public.appointments;
begin
  select * into v_app from public.appointments where id = p_appointment_id for update;
  if not found then
    raise exception '[NOT_FOUND] Appointment not found';
  end if;
  if v_role not in ('RECEPTIONIST','CLINIC_ADMIN') or not public.is_clinic_staff(v_app.clinic_id) then
    raise exception '[FORBIDDEN] Only clinic staff can confirm appointments';
  end if;
  if v_app.status <> 'BOOKED' then
    raise exception '[INVALID_TRANSITION] Only booked appointments can be confirmed';
  end if;

  update public.appointments set status = 'CONFIRMED' where id = p_appointment_id
  returning * into v_app;

  perform public.create_notification(
    v_app.patient_id, 'APPOINTMENT_CONFIRMED', 'Appointment confirmed',
    'Your appointment on ' || to_char(v_app.appointment_date,'DD Mon YYYY') || ', '
      || to_char(v_app.start_time,'HH12:MI AM') || ' has been confirmed by the clinic.',
    'APPOINTMENT', v_app.id);
  perform public.log_audit('APPOINTMENT_CONFIRMED', 'APPOINTMENT', v_app.id, v_app.clinic_id, v_app.patient_id);

  return v_app;
end;
$$;

-- ── Check-in & walk-ins ──────────────────────────────────────────

create or replace function public.check_in_appointment(
  p_appointment_id uuid,
  p_method public.check_in_method default 'APP'
) returns public.queue_entries
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_app public.appointments;
  v_entry public.queue_entries;
  v_ahead integer;
begin
  select * into v_app from public.appointments where id = p_appointment_id for update;
  if not found then
    raise exception '[NOT_FOUND] Appointment not found';
  end if;

  if not (
    (v_role = 'PATIENT' and v_app.patient_id = v_actor)
    or (v_role in ('RECEPTIONIST','CLINIC_ADMIN') and public.is_clinic_staff(v_app.clinic_id))
  ) then
    raise exception '[FORBIDDEN] You cannot check in this appointment';
  end if;

  if exists (select 1 from public.check_ins where appointment_id = p_appointment_id) then
    raise exception '[DUPLICATE_CHECK_IN] This appointment has already been checked in';
  end if;
  if v_app.status not in ('BOOKED','CONFIRMED') then
    raise exception '[INVALID_TRANSITION] Only booked or confirmed appointments can be checked in';
  end if;
  if v_app.appointment_date <> current_date then
    raise exception '[PAST_DATE] Appointments can only be checked in on the day of the appointment';
  end if;
  if v_app.appointment_date = current_date
     and v_app.end_time < (now() at time zone 'Asia/Kolkata')::time then
    raise exception '[PAST_DATE] The appointment time has already passed — please contact reception';
  end if;

  insert into public.check_ins (appointment_id, patient_id, clinic_id, method, checked_in_by)
  values (v_app.id, v_app.patient_id, v_app.clinic_id,
          (case when v_role = 'PATIENT' then 'APP' else 'RECEPTIONIST' end)::public.check_in_method,
          v_actor);

  update public.appointments set status = 'CHECKED_IN' where id = v_app.id;

  insert into public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, priority, status)
  values (v_app.clinic_id, v_app.doctor_id, v_app.patient_id, v_app.id, current_date, 'NORMAL', 'WAITING')
  returning * into v_entry;

  update public.appointments set status = 'WAITING' where id = v_app.id;

  insert into public.queue_events (queue_entry_id, event_type, to_status, changed_by)
  values (v_entry.id, 'CREATED', 'WAITING', v_actor);

  select count(*) into v_ahead from public.queue_entries q
  where q.doctor_id = v_entry.doctor_id and q.queue_date = v_entry.queue_date
    and q.status = 'WAITING' and q.id <> v_entry.id
    and (case q.priority when 'URGENT' then 0 when 'HIGH' then 1 else 2 end, q.token_number)
        < (case v_entry.priority when 'URGENT' then 0 when 'HIGH' then 1 else 2 end, v_entry.token_number);

  perform public.create_notification(
    v_app.patient_id, 'CHECK_IN_CONFIRMED', 'Checked in',
    'You are checked in. Your token is ' || v_entry.token_code
      || ' — ' || case when v_ahead = 0 then 'you are next in line.'
                       else v_ahead || ' patient(s) ahead of you.' end,
    'QUEUE_ENTRY', v_entry.id);

  perform public.log_audit('CHECK_IN', 'APPOINTMENT', v_app.id, v_app.clinic_id, v_app.patient_id,
    jsonb_build_object('token', v_entry.token_code));

  return v_entry;
end;
$$;

create or replace function public.create_walk_in(
  p_clinic_id uuid,
  p_doctor_id uuid,
  p_patient_id uuid,
  p_visit_reason text,
  p_priority public.priority default 'NORMAL'
) returns public.queue_entries
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_now time := (now() at time zone 'Asia/Kolkata')::time;
  v_appointment public.appointments;
  v_entry public.queue_entries;
  v_ahead integer;
begin
  if v_role not in ('RECEPTIONIST','CLINIC_ADMIN') or not public.is_clinic_staff(p_clinic_id) then
    raise exception '[FORBIDDEN] Only clinic staff can create walk-ins';
  end if;
  if not exists (select 1 from public.patients where id = p_patient_id) then
    raise exception '[NOT_FOUND] Patient not found';
  end if;
  if not exists (
    select 1 from public.doctor_clinics dc
    where dc.doctor_id = p_doctor_id and dc.clinic_id = p_clinic_id
  ) then
    raise exception '[VALIDATION] This doctor does not practise at this clinic';
  end if;
  if coalesce(p_visit_reason,'') = '' or length(p_visit_reason) < 3 then
    raise exception '[VALIDATION] Please describe the reason for the visit (at least 3 characters)';
  end if;

  insert into public.appointments
    (patient_id, doctor_id, clinic_id, slot_id, appointment_type, status,
     appointment_date, start_time, end_time, visit_reason, created_by, checked_in_at)
  values
    (p_patient_id, p_doctor_id, p_clinic_id, null, 'WALK_IN', 'CHECKED_IN',
     current_date, v_now, v_now + interval '30 minutes', p_visit_reason, v_actor, now())
  returning * into v_appointment;

  insert into public.check_ins (appointment_id, patient_id, clinic_id, method, checked_in_by)
  values (v_appointment.id, p_patient_id, p_clinic_id, 'RECEPTIONIST', v_actor);

  insert into public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, priority, status)
  values (p_clinic_id, p_doctor_id, p_patient_id, v_appointment.id, current_date, p_priority, 'WAITING')
  returning * into v_entry;

  update public.appointments set status = 'WAITING' where id = v_appointment.id;

  insert into public.queue_events (queue_entry_id, event_type, to_status, changed_by)
  values (v_entry.id, 'CREATED', 'WAITING', v_actor);

  select count(*) into v_ahead from public.queue_entries q
  where q.doctor_id = p_doctor_id and q.queue_date = current_date
    and q.status = 'WAITING' and q.id <> v_entry.id
    and (case q.priority when 'URGENT' then 0 when 'HIGH' then 1 else 2 end, q.token_number)
        < (case v_entry.priority when 'URGENT' then 0 when 'HIGH' then 1 else 2 end, v_entry.token_number);

  perform public.create_notification(
    p_patient_id, 'CHECK_IN_CONFIRMED', 'Walk-in registered',
    'You have been registered at the clinic. Your token is ' || v_entry.token_code
      || ' — ' || case when v_ahead = 0 then 'you are next in line.'
                       else v_ahead || ' patient(s) ahead of you.' end,
    'QUEUE_ENTRY', v_entry.id);

  perform public.log_audit('WALK_IN_CREATED', 'APPOINTMENT', v_appointment.id, p_clinic_id, p_patient_id,
    jsonb_build_object('token', v_entry.token_code, 'priority', p_priority));

  return v_entry;
end;
$$;

-- ── Queue operations ─────────────────────────────────────────────

create or replace function public.queue_call_next(p_clinic_id uuid, p_doctor_id uuid)
returns public.queue_entries
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_entry public.queue_entries;
  v_next_up public.queue_entries;
  v_patient_name text;
begin
  if v_role = 'DOCTOR' then
    if p_doctor_id <> v_actor then
      raise exception '[FORBIDDEN] Doctors can only call their own queue';
    end if;
  elsif v_role in ('RECEPTIONIST','CLINIC_ADMIN') then
    if not public.is_clinic_staff(p_clinic_id) then
      raise exception '[FORBIDDEN] You can only manage your clinic''s queue';
    end if;
  else
    raise exception '[FORBIDDEN] Only doctors and clinic staff can call the next patient';
  end if;

  select * into v_entry from public.queue_entries
  where clinic_id = p_clinic_id and doctor_id = p_doctor_id
    and queue_date = current_date and status = 'WAITING'
  order by case priority when 'URGENT' then 0 when 'HIGH' then 1 else 2 end, token_number
  limit 1
  for update skip locked;

  if not found then
    raise exception '[NOT_FOUND] No patients are waiting in this queue';
  end if;

  update public.queue_entries set status = 'CALLED', called_at = now()
  where id = v_entry.id returning * into v_entry;

  update public.appointments set status = 'CALLED' where id = v_entry.appointment_id;

  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
  values (v_entry.id, 'CALLED', 'WAITING', 'CALLED', v_actor);

  perform public.create_notification(
    v_entry.patient_id, 'QUEUE_CALLED', 'Token ' || v_entry.token_code || ' called',
    'Your token ' || v_entry.token_code || ' has been called — please proceed to the consultation room.',
    'QUEUE_ENTRY', v_entry.id);

  -- Notify the patient who is now next in line.
  select * into v_next_up from public.queue_entries
  where clinic_id = p_clinic_id and doctor_id = p_doctor_id
    and queue_date = current_date and status = 'WAITING'
  order by case priority when 'URGENT' then 0 when 'HIGH' then 1 else 2 end, token_number
  limit 1;

  if found then
    perform public.create_notification(
      v_next_up.patient_id, 'QUEUE_UPDATED', 'You are next',
      'You are next in the queue with token ' || v_next_up.token_code || '. Please be ready.',
      'QUEUE_ENTRY', v_next_up.id);
  end if;

  perform public.log_audit('QUEUE_CALLED', 'QUEUE_ENTRY', v_entry.id, p_clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code));

  return v_entry;
end;
$$;

create or replace function public.queue_call_specific(p_queue_entry_id uuid)
returns public.queue_entries
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_entry public.queue_entries;
begin
  select * into v_entry from public.queue_entries where id = p_queue_entry_id for update;
  if not found then
    raise exception '[NOT_FOUND] Queue entry not found';
  end if;
  if not ((v_role = 'DOCTOR' and v_entry.doctor_id = v_actor)
          or (v_role in ('RECEPTIONIST','CLINIC_ADMIN') and public.is_clinic_staff(v_entry.clinic_id))) then
    raise exception '[FORBIDDEN] You cannot manage this queue';
  end if;
  if v_entry.status <> 'WAITING' then
    raise exception '[INVALID_TRANSITION] Only waiting patients can be called';
  end if;

  update public.queue_entries set status = 'CALLED', called_at = now()
  where id = v_entry.id returning * into v_entry;
  update public.appointments set status = 'CALLED' where id = v_entry.appointment_id;
  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
  values (v_entry.id, 'CALLED', 'WAITING', 'CALLED', v_actor);

  perform public.create_notification(
    v_entry.patient_id, 'QUEUE_CALLED', 'Token ' || v_entry.token_code || ' called',
    'Your token ' || v_entry.token_code || ' has been called — please proceed to the consultation room.',
    'QUEUE_ENTRY', v_entry.id);
  perform public.log_audit('QUEUE_CALLED', 'QUEUE_ENTRY', v_entry.id, v_entry.clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code, 'specific', true));

  return v_entry;
end;
$$;

create or replace function public.queue_recall(p_queue_entry_id uuid)
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
    raise exception '[INVALID_TRANSITION] Only called tokens can be re-called';
  end if;

  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
  values (v_entry.id, 'RECALLED', 'CALLED', 'CALLED', v_actor);

  perform public.create_notification(
    v_entry.patient_id, 'QUEUE_CALLED', 'Token ' || v_entry.token_code || ' called again',
    'Your token ' || v_entry.token_code || ' has been called again — please proceed to the consultation room.',
    'QUEUE_ENTRY', v_entry.id);

  return v_entry;
end;
$$;

-- Patient did not respond when called: token goes back to WAITING.
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
  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
  values (v_entry.id, 'SKIPPED', 'CALLED', 'WAITING', v_actor, 'Called but not present');

  perform public.log_audit('QUEUE_RETURNED', 'QUEUE_ENTRY', v_entry.id, v_entry.clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code));
  return v_entry;
end;
$$;

-- Explicitly skip a waiting patient's token (patient stepped out etc.).
create or replace function public.queue_skip(p_queue_entry_id uuid)
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
  if v_entry.status <> 'WAITING' then
    raise exception '[INVALID_TRANSITION] Only waiting tokens can be skipped';
  end if;

  update public.queue_entries set status = 'SKIPPED'
  where id = v_entry.id returning * into v_entry;
  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
  values (v_entry.id, 'SKIPPED', 'WAITING', 'SKIPPED', v_actor);

  perform public.create_notification(
    v_entry.patient_id, 'QUEUE_UPDATED', 'Token ' || v_entry.token_code || ' skipped',
    'Your token was skipped. Please contact the reception desk to be resumed.',
    'QUEUE_ENTRY', v_entry.id);
  perform public.log_audit('QUEUE_SKIPPED', 'QUEUE_ENTRY', v_entry.id, v_entry.clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code));
  return v_entry;
end;
$$;

create or replace function public.queue_resume(p_queue_entry_id uuid)
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
  if v_entry.status <> 'SKIPPED' then
    raise exception '[INVALID_TRANSITION] Only skipped tokens can be resumed';
  end if;

  update public.queue_entries set status = 'WAITING'
  where id = v_entry.id returning * into v_entry;
  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
  values (v_entry.id, 'RESUMED', 'SKIPPED', 'WAITING', v_actor);

  perform public.create_notification(
    v_entry.patient_id, 'QUEUE_UPDATED', 'Token ' || v_entry.token_code || ' resumed',
    'You are back in the queue with token ' || v_entry.token_code || '.',
    'QUEUE_ENTRY', v_entry.id);
  perform public.log_audit('QUEUE_RESUMED', 'QUEUE_ENTRY', v_entry.id, v_entry.clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code));
  return v_entry;
end;
$$;

create or replace function public.queue_set_priority(
  p_queue_entry_id uuid,
  p_priority public.priority
) returns public.queue_entries
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
    raise exception '[FORBIDDEN] Only doctors and clinic staff can change priority';
  end if;
  if v_entry.status not in ('WAITING','SKIPPED') then
    raise exception '[INVALID_TRANSITION] Priority can only be changed while a token is waiting or skipped';
  end if;

  update public.queue_entries set priority = p_priority
  where id = v_entry.id returning * into v_entry;
  insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by, note)
  values (v_entry.id, 'PRIORITY_CHANGED', v_entry.status, v_entry.status, v_actor, 'Priority set to ' || p_priority);

  perform public.create_notification(
    v_entry.patient_id, 'QUEUE_UPDATED', 'Queue priority updated',
    'Your token ' || v_entry.token_code || ' has been given ' || p_priority || ' priority.',
    'QUEUE_ENTRY', v_entry.id);
  perform public.log_audit('QUEUE_PRIORITY_CHANGED', 'QUEUE_ENTRY', v_entry.id, v_entry.clinic_id, v_entry.patient_id,
    jsonb_build_object('token', v_entry.token_code, 'priority', p_priority));
  return v_entry;
end;
$$;

create or replace function public.mark_no_show(p_appointment_id uuid)
returns public.appointments
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_role public.user_role := public.active_role();
  v_app public.appointments;
begin
  select * into v_app from public.appointments where id = p_appointment_id for update;
  if not found then raise exception '[NOT_FOUND] Appointment not found'; end if;
  if not ((v_role = 'DOCTOR' and v_app.doctor_id = v_actor)
          or (v_role in ('RECEPTIONIST','CLINIC_ADMIN') and public.is_clinic_staff(v_app.clinic_id))) then
    raise exception '[FORBIDDEN] Only doctors and clinic staff can mark a no-show';
  end if;
  if v_app.status not in ('BOOKED','CONFIRMED','WAITING','CALLED') then
    raise exception '[INVALID_TRANSITION] This appointment can no longer be marked as a no-show';
  end if;

  update public.appointments
  set status = 'NO_SHOW', cancellation_reason = 'Patient did not show up'
  where id = v_app.id returning * into v_app;

  if v_app.slot_id is not null then
    update public.appointment_slots set status = 'FREE', appointment_id = null
    where id = v_app.slot_id and status = 'BOOKED';
  end if;

  perform public.create_notification(
    v_app.patient_id, 'APPOINTMENT_CANCELLED', 'Marked as no-show',
    'Your appointment on ' || to_char(v_app.appointment_date,'DD Mon YYYY')
      || ' was marked as a no-show. Contact the clinic if this is unexpected.',
    'APPOINTMENT', v_app.id);
  perform public.log_audit('APPOINTMENT_NO_SHOW', 'APPOINTMENT', v_app.id, v_app.clinic_id, v_app.patient_id);
  return v_app;
end;
$$;

-- ── Consultations ────────────────────────────────────────────────

create or replace function public.start_consultation(p_appointment_id uuid)
returns public.consultations
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_app public.appointments;
  v_consult public.consultations;
  v_entry public.queue_entries;
begin
  select * into v_app from public.appointments where id = p_appointment_id for update;
  if not found then raise exception '[NOT_FOUND] Appointment not found'; end if;
  if v_app.doctor_id <> v_actor then
    raise exception '[FORBIDDEN] Only the appointed doctor can start this consultation';
  end if;
  if v_app.status not in ('CALLED','WAITING') then
    raise exception '[INVALID_TRANSITION] Call the patient before starting the consultation';
  end if;

  insert into public.consultations (appointment_id, patient_id, doctor_id, clinic_id, status)
  values (v_app.id, v_app.patient_id, v_app.doctor_id, v_app.clinic_id, 'IN_PROGRESS')
  on conflict (appointment_id) do update set status = 'IN_PROGRESS'
  returning * into v_consult;

  update public.appointments set status = 'IN_CONSULTATION' where id = v_app.id;

  select * into v_entry from public.queue_entries where appointment_id = v_app.id;
  if found then
    update public.queue_entries set status = 'IN_CONSULTATION', started_at = now() where id = v_entry.id;
    insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
    values (v_entry.id, 'STARTED', 'CALLED', 'IN_CONSULTATION', v_actor);
  end if;

  perform public.log_audit('CONSULTATION_STARTED', 'CONSULTATION', v_consult.id, v_app.clinic_id, v_app.patient_id);
  return v_consult;
end;
$$;

create or replace function public.complete_consultation(p_consultation_id uuid)
returns public.consultations
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_actor uuid := public.current_profile_id();
  v_consult public.consultations;
  v_app public.appointments;
  v_entry public.queue_entries;
begin
  select * into v_consult from public.consultations where id = p_consultation_id for update;
  if not found then raise exception '[NOT_FOUND] Consultation not found'; end if;
  if v_consult.doctor_id <> v_actor then
    raise exception '[FORBIDDEN] Only the consulting doctor can complete this consultation';
  end if;
  if v_consult.status <> 'IN_PROGRESS' then
    raise exception '[INVALID_TRANSITION] This consultation is not in progress';
  end if;
  if coalesce(v_consult.chief_complaint,'') = '' or coalesce(v_consult.clinical_notes,'') = '' then
    raise exception '[VALIDATION] Add the chief complaint and clinical notes before completing';
  end if;

  update public.consultations
  set status = 'COMPLETED', completed_at = now()
  where id = p_consultation_id returning * into v_consult;

  select * into v_app from public.appointments where id = v_consult.appointment_id;
  if v_app.status = 'IN_CONSULTATION' then
    update public.appointments set status = 'COMPLETED' where id = v_app.id;
  end if;

  select * into v_entry from public.queue_entries where appointment_id = v_consult.appointment_id;
  if found and v_entry.status = 'IN_CONSULTATION' then
    update public.queue_entries set status = 'COMPLETED', completed_at = now() where id = v_entry.id;
    insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, changed_by)
    values (v_entry.id, 'COMPLETED', 'IN_CONSULTATION', 'COMPLETED', v_actor);
  end if;

  perform public.create_notification(
    v_consult.patient_id, 'CONSULTATION_COMPLETED', 'Consultation completed',
    'Your consultation with Dr. ' || (select p.full_name from public.profiles p where p.id = v_consult.doctor_id)
      || ' is complete. Check your prescriptions and follow-ups.',
    'CONSULTATION', v_consult.id);

  perform public.log_audit('CONSULTATION_COMPLETED', 'CONSULTATION', v_consult.id, v_consult.clinic_id, v_consult.patient_id);
  return v_consult;
end;
$$;

-- ── Medication schedules from prescription items ─────────────────

create or replace function public.generate_medication_schedules()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_times text[];
  v_start date;
  v_end date;
  v_patient uuid;
begin
  if new.frequency in ('SOS','STAT') then
    return new; -- as-needed / single immediate dose: no daily schedule
  end if;

  v_times := case new.frequency
    when 'OD'  then array['09:00']
    when 'BD'  then array['09:00','21:00']
    when 'TDS' then array['08:00','14:00','20:00']
    when 'QID' then array['08:00','14:00','20:00','02:00']
    when 'HS'  then array['22:00']
    else array[]::text[]
  end;

  select prescription_date, patient_id into v_start, v_patient
  from public.prescriptions where id = new.prescription_id;
  v_end := v_start + (new.duration_days - 1);

  insert into public.medication_schedules
    (prescription_item_id, prescription_id, patient_id, medicine_name, dose,
     time_of_day, start_date, end_date, instructions, food_relation)
  select new.id, new.prescription_id, v_patient, new.medicine_name, new.dose,
         t::time, v_start, v_end, new.instructions, new.food_relation
  from unnest(v_times) as t;

  return new;
end;
$$;

drop trigger if exists on_prescription_item_insert on public.prescription_items;
create trigger on_prescription_item_insert
  after insert on public.prescription_items
  for each row execute function public.generate_medication_schedules();

-- ── Review validation & rating aggregation ───────────────────────

create or replace function public.validate_review_eligibility()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
begin
  if new.doctor_id is not null then
    if not exists (
      select 1 from public.appointments a
      where a.patient_id = new.patient_id and a.doctor_id = new.doctor_id
        and a.status = 'COMPLETED'
    ) then
      raise exception '[VALIDATION] You can review a doctor only after a completed appointment with them';
    end if;
  end if;
  if new.clinic_id is not null then
    if not exists (
      select 1 from public.appointments a
      where a.patient_id = new.patient_id and a.clinic_id = new.clinic_id
        and a.status = 'COMPLETED'
    ) then
      raise exception '[VALIDATION] You can review a clinic only after a completed appointment there';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists validate_review_eligibility on public.reviews;
create trigger validate_review_eligibility
  before insert on public.reviews
  for each row execute function public.validate_review_eligibility();

create or replace function public.recalculate_review_ratings()
returns trigger
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_doctor uuid := coalesce(new.doctor_id, old.doctor_id);
  v_clinic uuid := coalesce(new.clinic_id, old.clinic_id);
begin
  if v_doctor is not null then
    update public.doctors d
    set avg_rating = s.avg_rating, review_count = s.review_count
    from (
      select coalesce(avg(rating),0) as avg_rating, count(*) as review_count
      from public.reviews where doctor_id = v_doctor and is_approved
    ) s
    where d.id = v_doctor;
  end if;
  if v_clinic is not null then
    update public.clinics c
    set avg_rating = s.avg_rating, review_count = s.review_count
    from (
      select coalesce(avg(rating),0) as avg_rating, count(*) as review_count
      from public.reviews where clinic_id = v_clinic and is_approved
    ) s
    where c.id = v_clinic;
  end if;
  return coalesce(new, old);
end;
$$;

drop trigger if exists recalculate_review_ratings on public.reviews;
create trigger recalculate_review_ratings
  after insert or update or delete on public.reviews
  for each row execute function public.recalculate_review_ratings();

-- ── Service-layer notification helpers (guarded) ─────────────────

create or replace function public.notify_prescription_created(p_prescription_id uuid)
returns void
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_rx public.prescriptions;
begin
  select * into v_rx from public.prescriptions where id = p_prescription_id;
  if not found then raise exception '[NOT_FOUND] Prescription not found'; end if;
  if v_rx.doctor_id <> public.current_profile_id() then
    raise exception '[FORBIDDEN] Only the prescribing doctor can send this notification';
  end if;
  perform public.create_notification(
    v_rx.patient_id, 'PRESCRIPTION_CREATED', 'New prescription',
    'Dr. ' || (select p.full_name from public.profiles p where p.id = v_rx.doctor_id)
      || ' has prescribed medication for you. Open My Medications to see the full schedule.',
    'PRESCRIPTION', v_rx.id);
  perform public.log_audit('PRESCRIPTION_CREATED', 'PRESCRIPTION', v_rx.id, v_rx.clinic_id, v_rx.patient_id);
end;
$$;

create or replace function public.notify_follow_up_created(p_follow_up_id uuid)
returns void
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_fu public.follow_ups;
begin
  select * into v_fu from public.follow_ups where id = p_follow_up_id;
  if not found then raise exception '[NOT_FOUND] Follow-up not found'; end if;
  if v_fu.doctor_id <> public.current_profile_id() then
    raise exception '[FORBIDDEN] Only the treating doctor can send this notification';
  end if;
  perform public.create_notification(
    v_fu.patient_id, 'FOLLOW_UP_SCHEDULED', 'Follow-up scheduled',
    'A follow-up with Dr. ' || (select p.full_name from public.profiles p where p.id = v_fu.doctor_id)
      || ' is scheduled for ' || to_char(v_fu.scheduled_date, 'DD Mon YYYY') || '.',
    'FOLLOW_UP', v_fu.id);
  perform public.log_audit('FOLLOW_UP_CREATED', 'FOLLOW_UP', v_fu.id, v_fu.clinic_id, v_fu.patient_id);
end;
$$;

-- Idempotent medication reminders for today (called from the patient app).
create or replace function public.ensure_medication_reminders()
returns integer
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_patient uuid := public.current_profile_id();
  v_created integer := 0;
begin
  if v_patient is null or public.active_role() <> 'PATIENT' then
    raise exception '[FORBIDDEN] Only patients can generate their medication reminders';
  end if;

  with due as (
    select ms.id, ms.medicine_name, ms.time_of_day
    from public.medication_schedules ms
    where ms.patient_id = v_patient
      and ms.status = 'ACTIVE'
      and current_date between ms.start_date and ms.end_date
  ),
  inserted as (
    insert into public.notifications (user_id, type, title, body, entity_type, entity_id)
    select v_patient, 'MEDICATION_REMINDER',
           'Medication today: ' || d.medicine_name,
           'Reminder: take ' || d.medicine_name || ' at ' || to_char(d.time_of_day, 'HH12:MI AM') || ' (as prescribed by your doctor).',
           'MEDICATION_SCHEDULE', d.id
    from due d
    where not exists (
      select 1 from public.notifications n
      where n.user_id = v_patient
        and n.type = 'MEDICATION_REMINDER'
        and n.entity_id = d.id
        and n.created_at::date = current_date
    )
    returning 1
  )
  select count(*) into v_created from inserted;

  return v_created;
end;
$$;

-- ── Emergency demo (clearly labelled prototype) ──────────────────

create or replace function public.create_emergency_request(
  p_description text,
  p_location_text text,
  p_latitude numeric default null,
  p_longitude numeric default null
) returns public.emergency_requests
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_patient uuid := public.current_profile_id();
  v_req public.emergency_requests;
  v_demo boolean := public.app_env() = 'demo';
begin
  if v_patient is null or public.active_role() <> 'PATIENT' then
    raise exception '[FORBIDDEN] Only patients can raise emergency requests';
  end if;
  if coalesce(p_description,'') = '' or coalesce(p_location_text,'') = '' then
    raise exception '[VALIDATION] Description and location are required';
  end if;

  insert into public.emergency_requests (patient_id, description, location_text, latitude, longitude, is_demo)
  values (v_patient, p_description, p_location_text, p_latitude, p_longitude, v_demo)
  returning * into v_req;

  perform public.create_notification(
    v_patient, 'EMERGENCY_UPDATE', 'Emergency request received (Prototype demo)',
    'Your emergency request has been recorded. NOTE: this is a prototype demonstration — '
      || 'no real ambulance or emergency service has been contacted. In a real emergency call 108.',
    'EMERGENCY', v_req.id);

  perform public.log_audit('EMERGENCY_CREATED', 'EMERGENCY', v_req.id, null, v_patient);
  return v_req;
end;
$$;

create or replace function public.emergency_advance_demo(p_request_id uuid)
returns public.emergency_requests
language plpgsql security definer set search_path = public, pg_temp as $$
declare
  v_patient uuid := public.current_profile_id();
  v_req public.emergency_requests;
  v_new_status public.emergency_status;
begin
  if public.app_env() <> 'demo' then
    raise exception '[FORBIDDEN] Demo simulation is disabled in production mode';
  end if;
  select * into v_req from public.emergency_requests where id = p_request_id for update;
  if not found then raise exception '[NOT_FOUND] Emergency request not found'; end if;
  if v_req.patient_id <> v_patient then
    raise exception '[FORBIDDEN] You can only advance your own demo requests';
  end if;

  v_new_status := case v_req.status
    when 'CREATED' then 'RECEIVED'
    when 'RECEIVED' then 'ACKNOWLEDGED'
    when 'ACKNOWLEDGED' then 'CLOSED'
    else null
  end;
  if v_new_status is null then
    raise exception '[INVALID_TRANSITION] This request is already closed';
  end if;

  update public.emergency_requests
  set status = v_new_status,
      received_at = case when v_new_status = 'RECEIVED' then now() else received_at end,
      acknowledged_at = case when v_new_status = 'ACKNOWLEDGED' then now() else acknowledged_at end,
      closed_at = case when v_new_status = 'CLOSED' then now() else closed_at end
  where id = p_req.id
  returning * into v_req;

  perform public.create_notification(
    v_patient, 'EMERGENCY_UPDATE', 'Emergency update (Prototype demo)',
    'Demo status update: your request is now ' || v_new_status
      || '. This is a simulated progression — no real emergency service is involved.',
    'EMERGENCY', v_req.id);

  perform public.log_audit('EMERGENCY_DEMO_ADVANCED', 'EMERGENCY', v_req.id, null, v_patient,
    jsonb_build_object('to_status', v_new_status));
  return v_req;
end;
$$;

-- ── Realtime publication ─────────────────────────────────────────
do $$ begin
  alter publication supabase_realtime add table public.appointments;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.queue_entries;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.queue_events;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.notifications;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.emergency_requests;
exception when duplicate_object then null; end $$;

-- ── Function privileges ──────────────────────────────────────────
-- Authenticated clients may call the public RPCs (each re-validates
-- permissions internally); anon may not. Internal trigger helpers are
-- not callable by any client role.

revoke execute on all functions in schema public from anon, public;
grant execute on all functions in schema public to authenticated;

revoke execute on function public.handle_new_user() from anon, authenticated, public;
revoke execute on function public.set_updated_at() from anon, authenticated, public;
revoke execute on function public.assign_queue_token() from anon, authenticated, public;
revoke execute on function public.appointments_before_update() from anon, authenticated, public;
revoke execute on function public.appointments_after_update() from anon, authenticated, public;
revoke execute on function public.generate_medication_schedules() from anon, authenticated, public;
revoke execute on function public.validate_review_eligibility() from anon, authenticated, public;
revoke execute on function public.recalculate_review_ratings() from anon, authenticated, public;
revoke execute on function public.next_queue_token(uuid, uuid, date) from anon, authenticated, public;
revoke execute on function public.format_token_code(integer) from anon, authenticated, public;
revoke execute on function public.create_notification(uuid, public.notification_type, text, text, text, uuid) from anon, authenticated, public;
revoke execute on function public.log_audit(text, text, uuid, uuid, uuid, jsonb) from anon, authenticated, public;
