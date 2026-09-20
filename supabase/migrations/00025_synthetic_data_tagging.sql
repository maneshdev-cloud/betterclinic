-- ═══════════════════════════════════════════════════════════════════════════════
-- 00025_synthetic_data_tagging.sql
-- Adds is_synthetic flag across all domain and association tables,
-- provides scoped deletion RPC (purge_synthetic_data), and platform analytics.
-- ═══════════════════════════════════════════════════════════════════════════════

-- 1. Add is_synthetic flag across all non-catalogue public tables
do $$
declare
  t text;
  tables text[] := array[
    'profiles',
    'patients',
    'doctors',
    'clinics',
    'clinic_staff',
    'clinic_hours',
    'clinic_invite_codes',
    'doctor_clinics',
    'doctor_specializations',
    'doctor_availability',
    'appointment_slots',
    'appointments',
    'appointment_status_history',
    'check_ins',
    'queue_entries',
    'queue_events',
    'queue_token_counters',
    'consultations',
    'diagnoses',
    'treatment_plans',
    'prescriptions',
    'prescription_items',
    'medication_schedules',
    'follow_ups',
    'medical_history',
    'reviews',
    'notifications',
    'user_preferences',
    'profile_roles',
    'audit_logs',
    'emergency_requests',
    'ai_conversations',
    'ai_messages'
  ];
begin
  foreach t in array tables loop
    execute format('alter table public.%I add column if not exists is_synthetic boolean not null default false;', t);
  end loop;
end;
$$;

-- Create indexes on is_synthetic for fast filtering
create index if not exists idx_profiles_is_synthetic on public.profiles (is_synthetic);
create index if not exists idx_clinics_is_synthetic on public.clinics (is_synthetic);
create index if not exists idx_doctors_is_synthetic on public.doctors (is_synthetic);
create index if not exists idx_appointments_is_synthetic on public.appointments (is_synthetic);
create index if not exists idx_queue_entries_is_synthetic on public.queue_entries (is_synthetic);
create index if not exists idx_consultations_is_synthetic on public.consultations (is_synthetic);
create index if not exists idx_prescriptions_is_synthetic on public.prescriptions (is_synthetic);
create index if not exists idx_reviews_is_synthetic on public.reviews (is_synthetic);

-- 2. Scoped delete function for synthetic data
create or replace function public.purge_synthetic_data()
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_deleted jsonb := '{}'::jsonb;
  v_count bigint;
begin
  -- Delete in reverse foreign key order

  delete from public.ai_messages where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{ai_messages}', to_jsonb(v_count));

  delete from public.ai_conversations where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{ai_conversations}', to_jsonb(v_count));

  delete from public.emergency_requests where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{emergency_requests}', to_jsonb(v_count));

  delete from public.reviews where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{reviews}', to_jsonb(v_count));

  delete from public.follow_ups where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{follow_ups}', to_jsonb(v_count));

  delete from public.medication_schedules where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{medication_schedules}', to_jsonb(v_count));

  delete from public.prescription_items where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{prescription_items}', to_jsonb(v_count));

  delete from public.prescriptions where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{prescriptions}', to_jsonb(v_count));

  delete from public.diagnoses where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{diagnoses}', to_jsonb(v_count));

  delete from public.treatment_plans where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{treatment_plans}', to_jsonb(v_count));

  delete from public.consultations where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{consultations}', to_jsonb(v_count));

  delete from public.notifications where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{notifications}', to_jsonb(v_count));

  delete from public.queue_events where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{queue_events}', to_jsonb(v_count));

  delete from public.queue_entries where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{queue_entries}', to_jsonb(v_count));

  delete from public.check_ins where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{check_ins}', to_jsonb(v_count));

  delete from public.appointment_status_history where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{appointment_status_history}', to_jsonb(v_count));

  delete from public.appointments where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{appointments}', to_jsonb(v_count));

  delete from public.appointment_slots where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{appointment_slots}', to_jsonb(v_count));

  delete from public.doctor_availability where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{doctor_availability}', to_jsonb(v_count));

  delete from public.clinic_hours where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{clinic_hours}', to_jsonb(v_count));

  delete from public.clinic_staff where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{clinic_staff}', to_jsonb(v_count));

  delete from public.doctor_clinics where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{doctor_clinics}', to_jsonb(v_count));

  delete from public.doctor_specializations where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{doctor_specializations}', to_jsonb(v_count));

  delete from public.medical_history where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{medical_history}', to_jsonb(v_count));

  delete from public.patients where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{patients}', to_jsonb(v_count));

  delete from public.doctors where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{doctors}', to_jsonb(v_count));

  delete from public.clinic_invite_codes where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{clinic_invite_codes}', to_jsonb(v_count));

  delete from public.clinics where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{clinics}', to_jsonb(v_count));

  delete from public.profile_roles where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{profile_roles}', to_jsonb(v_count));

  delete from public.user_preferences where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{user_preferences}', to_jsonb(v_count));

  delete from public.audit_logs where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{audit_logs}', to_jsonb(v_count));

  delete from public.profiles where is_synthetic = true;
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{profiles}', to_jsonb(v_count));

  -- Clean up synthetic auth.users (seed accounts matching domain convention)
  delete from auth.users
  where email like '%@betterclinic.app'
     or email like '%@example.com';
  get diagnostics v_count = row_count;
  v_deleted := jsonb_set(v_deleted, '{auth_users}', to_jsonb(v_count));

  return v_deleted;
end;
$$;

grant execute on function public.purge_synthetic_data() to authenticated, service_role;

-- 3. Platform Stats RPC for Developer Panel
create or replace function public.get_platform_stats(p_hide_demo boolean default false)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_result jsonb := '{}'::jsonb;
  v_counts jsonb := '{}'::jsonb;
  v_appointments jsonb := '{}'::jsonb;
  v_signups jsonb := '{}'::jsonb;
  v_top_clinics jsonb := '[]'::jsonb;
  v_top_doctors jsonb := '[]'::jsonb;
  v_table_row record;
  v_filter text;
begin
  -- 1. Table-by-table synthetic vs real breakdown
  for v_table_row in (
    select tablename from pg_tables where schemaname = 'public' order by tablename
  ) loop
    declare
      v_real bigint := 0;
      v_synth bigint := 0;
      v_has_col boolean;
    begin
      select exists (
        select 1 from information_schema.columns
        where table_schema = 'public' and table_name = v_table_row.tablename and column_name = 'is_synthetic'
      ) into v_has_col;

      if v_has_col then
        execute format('select count(*) filter (where not is_synthetic), count(*) filter (where is_synthetic) from public.%I;', v_table_row.tablename)
        into v_real, v_synth;
      else
        execute format('select count(*), 0 from public.%I;', v_table_row.tablename)
        into v_real, v_synth;
      end if;

      v_counts := jsonb_set(v_counts, array[v_table_row.tablename], jsonb_build_object(
        'real', v_real,
        'synthetic', v_synth,
        'total', v_real + v_synth
      ));
    end;
  end loop;
  v_result := jsonb_set(v_result, '{table_breakdowns}', v_counts);

  -- 2. Signups by role
  select jsonb_build_object(
    'patient', count(*) filter (where r.role = 'PATIENT'),
    'doctor', count(*) filter (where r.role = 'DOCTOR'),
    'receptionist', count(*) filter (where r.role = 'RECEPTIONIST'),
    'clinic_admin', count(*) filter (where r.role = 'CLINIC_ADMIN'),
    'total', count(distinct r.profile_id)
  ) into v_signups
  from public.profile_roles r
  join public.profiles p on p.id = r.profile_id
  where (not p_hide_demo or not p.is_synthetic);
  v_result := jsonb_set(v_result, '{signups_by_role}', v_signups);

  -- 2b. Signups over time by role
  select coalesce(jsonb_agg(sub), '[]'::jsonb) into v_signups_over_time
  from (
    select
      to_char(date_trunc('month', p.created_at), 'Mon YYYY') as period,
      date_trunc('month', p.created_at) as sort_key,
      count(*) filter (where r.role = 'PATIENT')::int as patient_count,
      count(*) filter (where r.role = 'DOCTOR')::int as doctor_count,
      count(*) filter (where r.role = 'RECEPTIONIST')::int as receptionist_count,
      count(*) filter (where r.role = 'CLINIC_ADMIN')::int as admin_count,
      count(distinct r.profile_id)::int as total_signups
    from public.profile_roles r
    join public.profiles p on p.id = r.profile_id
    where (not p_hide_demo or not p.is_synthetic)
    group by date_trunc('month', p.created_at)
    order by sort_key asc
  ) sub;
  v_result := jsonb_set(v_result, '{signups_over_time}', v_signups_over_time);

  -- 3. Appointments Summary
  select jsonb_build_object(
    'total', count(*),
    'completed', count(*) filter (where a.status = 'COMPLETED'),
    'cancelled', count(*) filter (where a.status = 'CANCELLED'),
    'no_show', count(*) filter (where a.status = 'NO_SHOW'),
    'active', count(*) filter (where a.status in ('BOOKED', 'CONFIRMED', 'CHECKED_IN', 'WAITING', 'CALLED', 'IN_CONSULTATION'))
  ) into v_appointments
  from public.appointments a
  where (not p_hide_demo or not a.is_synthetic);
  v_result := jsonb_set(v_result, '{appointments_summary}', v_appointments);

  -- 4. Top Clinics by volume
  select coalesce(jsonb_agg(sub), '[]'::jsonb) into v_top_clinics
  from (
    select c.id, c.name, c.city, count(a.id) as appointment_count
    from public.clinics c
    left join public.appointments a on a.clinic_id = c.id and (not p_hide_demo or not a.is_synthetic)
    where (not p_hide_demo or not c.is_synthetic)
    group by c.id, c.name, c.city
    order by appointment_count desc, c.name asc
    limit 5
  ) sub;
  v_result := jsonb_set(v_result, '{top_clinics}', v_top_clinics);

  -- 5. Top Doctors by volume
  select coalesce(jsonb_agg(sub), '[]'::jsonb) into v_top_doctors
  from (
    select d.id, p.full_name as name, d.qualification, count(a.id) as appointment_count
    from public.doctors d
    join public.profiles p on p.id = d.id
    left join public.appointments a on a.doctor_id = d.id and (not p_hide_demo or not a.is_synthetic)
    where (not p_hide_demo or not d.is_synthetic)
    group by d.id, p.full_name, d.qualification
    order by appointment_count desc, name asc
    limit 5
  ) sub;
  v_result := jsonb_set(v_result, '{top_doctors}', v_top_doctors);

  -- 6. Live storage snapshot
  v_result := jsonb_set(v_result, '{database_size_bytes}', to_jsonb(pg_database_size(current_database())));
  v_result := jsonb_set(v_result, '{database_size_pretty}', to_jsonb(pg_size_pretty(pg_database_size(current_database()))));

  return v_result;
end;
$$;

grant execute on function public.get_platform_stats(boolean) to authenticated, service_role;
