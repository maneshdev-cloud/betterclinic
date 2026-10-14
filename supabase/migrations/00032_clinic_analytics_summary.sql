-- Migration 00032: Database-side aggregation RPC for clinic analytics
-- Moves raw appointment and queue record aggregation into PostgreSQL,
-- returning compact summary statistics and preventing silent row truncation.

create or replace function public.get_clinic_analytics_summary(
  p_clinic_id uuid,
  p_from date,
  p_to date,
  p_doctor_id uuid default null,
  p_hide_demo boolean default false
) returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_caller uuid := auth.uid();
  v_is_authorized boolean := false;
  v_start_time timestamptz;
  v_end_time timestamptz;
  v_total_appts int := 0;
  v_completed int := 0;
  v_cancelled int := 0;
  v_no_show int := 0;
  v_walk_ins int := 0;
  v_unique_patients int := 0;
  v_finalized int := 0;
  v_median_wait int := null;
  v_wait_samples int := 0;
  v_avg_consult int := null;
  v_consult_samples int := 0;
  v_new_patients int := 0;
  v_daily_series jsonb := '[]'::jsonb;
  v_statuses jsonb := '[]'::jsonb;
  v_doctor_rollups jsonb := '[]'::jsonb;
begin
  -- Caller authorization: only active staff or admin of this clinic can view its analytics
  -- (or a doctor linked to this clinic)
  select exists (
    select 1 from public.clinic_staff cs
    where cs.user_id = v_caller
      and cs.clinic_id = p_clinic_id
      and cs.is_active
  ) or exists (
    select 1 from public.doctor_clinics dc
    where dc.doctor_id = v_caller
      and dc.clinic_id = p_clinic_id
      and (p_doctor_id is null or p_doctor_id = v_caller)
  ) into v_is_authorized;

  if not v_is_authorized then
    raise exception '[FORBIDDEN] You do not have permission to view analytics for this clinic';
  end if;

  v_start_time := (p_from::text || 'T00:00:00+05:30')::timestamptz;
  v_end_time := ((p_to + interval '1 day')::date::text || 'T00:00:00+05:30')::timestamptz;

  -- 1. Appointment KPIs
  select
    coalesce(count(*), 0),
    coalesce(count(*) filter (where a.status = 'COMPLETED'), 0),
    coalesce(count(*) filter (where a.status = 'CANCELLED'), 0),
    coalesce(count(*) filter (where a.status = 'NO_SHOW'), 0),
    coalesce(count(*) filter (where a.appointment_type = 'WALK_IN'), 0),
    coalesce(count(distinct a.patient_id), 0)
  into
    v_total_appts,
    v_completed,
    v_cancelled,
    v_no_show,
    v_walk_ins,
    v_unique_patients
  from public.appointments a
  where a.clinic_id = p_clinic_id
    and a.appointment_date >= p_from
    and a.appointment_date <= p_to
    and (p_doctor_id is null or a.doctor_id = p_doctor_id)
    and (not p_hide_demo or not a.is_synthetic);

  v_finalized := v_completed + v_cancelled + v_no_show;

  -- 2. Queue wait & consult duration KPIs
  select
    coalesce(count(*) filter (where q.called_at is not null and q.called_at > q.created_at), 0),
    greatest(1, round(percentile_cont(0.5) within group (
      order by case when q.called_at is not null and q.called_at > q.created_at
        then extract(epoch from (q.called_at - q.created_at)) / 60.0
        else null end
    ))),
    coalesce(count(*) filter (where q.started_at is not null and q.completed_at is not null and q.completed_at > q.started_at), 0),
    greatest(1, round(avg(
      case when q.started_at is not null and q.completed_at is not null and q.completed_at > q.started_at
        then extract(epoch from (q.completed_at - q.started_at)) / 60.0
        else null end
    )))
  into
    v_wait_samples,
    v_median_wait,
    v_consult_samples,
    v_avg_consult
  from public.queue_entries q
  where q.clinic_id = p_clinic_id
    and q.created_at >= v_start_time
    and q.created_at < v_end_time
    and (p_doctor_id is null or q.doctor_id = p_doctor_id)
    and (not p_hide_demo or not q.is_synthetic);

  -- 3. New Patients: patients whose first-ever appointment at this clinic falls in range
  select coalesce(count(distinct a.patient_id), 0)
  into v_new_patients
  from public.appointments a
  where a.clinic_id = p_clinic_id
    and a.appointment_date >= p_from
    and a.appointment_date <= p_to
    and (p_doctor_id is null or a.doctor_id = p_doctor_id)
    and (not p_hide_demo or not a.is_synthetic)
    and not exists (
      select 1
      from public.appointments prev
      where prev.clinic_id = p_clinic_id
        and prev.patient_id = a.patient_id
        and prev.appointment_date < p_from
        and (p_doctor_id is null or prev.doctor_id = p_doctor_id)
        and (not p_hide_demo or not prev.is_synthetic)
    );

  -- 4. Daily series aggregation
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'date', d.appointment_date::text,
        'total', d.total,
        'completed', d.completed,
        'cancelled', d.cancelled
      ) order by d.appointment_date
    ),
    '[]'::jsonb
  )
  into v_daily_series
  from (
    select
      a.appointment_date,
      count(*)::int as total,
      count(*) filter (where a.status = 'COMPLETED')::int as completed,
      count(*) filter (where a.status = 'CANCELLED')::int as cancelled
    from public.appointments a
    where a.clinic_id = p_clinic_id
      and a.appointment_date >= p_from
      and a.appointment_date <= p_to
      and (p_doctor_id is null or a.doctor_id = p_doctor_id)
      and (not p_hide_demo or not a.is_synthetic)
    group by a.appointment_date
  ) d;

  -- 5. Status breakdown
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'status', s.status,
        'count', s.count
      ) order by s.count desc, s.status asc
    ),
    '[]'::jsonb
  )
  into v_statuses
  from (
    select
      a.status,
      count(*)::int as count
    from public.appointments a
    where a.clinic_id = p_clinic_id
      and a.appointment_date >= p_from
      and a.appointment_date <= p_to
      and (p_doctor_id is null or a.doctor_id = p_doctor_id)
      and (not p_hide_demo or not a.is_synthetic)
    group by a.status
  ) s;

  -- 6. Per-doctor rollups
  with doctor_appts as (
    select
      a.doctor_id,
      count(*)::int as total,
      count(*) filter (where a.status = 'COMPLETED')::int as completed,
      count(*) filter (where a.status = 'CANCELLED')::int as cancelled,
      count(*) filter (where a.status = 'NO_SHOW')::int as no_show,
      count(*) filter (where a.appointment_type = 'WALK_IN')::int as walk_ins,
      count(distinct a.patient_id)::int as unique_patients
    from public.appointments a
    where a.clinic_id = p_clinic_id
      and a.appointment_date >= p_from
      and a.appointment_date <= p_to
      and (p_doctor_id is null or a.doctor_id = p_doctor_id)
      and (not p_hide_demo or not a.is_synthetic)
    group by a.doctor_id
  ),
  doctor_queue as (
    select
      q.doctor_id,
      greatest(1, round(percentile_cont(0.5) within group (
        order by case when q.called_at is not null and q.called_at > q.created_at
          then extract(epoch from (q.called_at - q.created_at)) / 60.0
          else null end
      )))::int as median_wait,
      count(*) filter (where q.called_at is not null and q.called_at > q.created_at) as wait_count,
      greatest(1, round(avg(
        case when q.started_at is not null and q.completed_at is not null and q.completed_at > q.started_at
          then extract(epoch from (q.completed_at - q.started_at)) / 60.0
          else null end
      )))::int as avg_consult,
      count(*) filter (where q.started_at is not null and q.completed_at is not null and q.completed_at > q.started_at) as consult_count
    from public.queue_entries q
    where q.clinic_id = p_clinic_id
      and q.created_at >= v_start_time
      and q.created_at < v_end_time
      and (p_doctor_id is null or q.doctor_id = p_doctor_id)
      and (not p_hide_demo or not q.is_synthetic)
    group by q.doctor_id
  )
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'doctorId', coalesce(da.doctor_id, dq.doctor_id),
        'total', coalesce(da.total, 0),
        'completed', coalesce(da.completed, 0),
        'cancelled', coalesce(da.cancelled, 0),
        'noShow', coalesce(da.no_show, 0),
        'walkIns', coalesce(da.walk_ins, 0),
        'uniquePatients', coalesce(da.unique_patients, 0),
        'medianWaitMinutes', case when dq.wait_count > 0 then dq.median_wait else null end,
        'avgConsultMinutes', case when dq.consult_count > 0 then dq.avg_consult else null end
      )
    ),
    '[]'::jsonb
  )
  into v_doctor_rollups
  from doctor_appts da
  full outer join doctor_queue dq on da.doctor_id = dq.doctor_id;

  return jsonb_build_object(
    'kpis', jsonb_build_object(
      'total', v_total_appts,
      'completed', v_completed,
      'cancelled', v_cancelled,
      'noShow', v_no_show,
      'walkIns', v_walk_ins,
      'uniquePatients', v_unique_patients,
      'completionRate', case when v_finalized > 0 then round((v_completed::numeric / v_finalized) * 100) else null end,
      'noShowRate', case when v_finalized > 0 then round((v_no_show::numeric / v_finalized) * 100) else null end,
      'medianWaitMinutes', case when v_wait_samples > 0 then v_median_wait else null end,
      'waitSamples', v_wait_samples,
      'avgConsultMinutes', case when v_consult_samples > 0 then v_avg_consult else null end,
      'consultSamples', v_consult_samples
    ),
    'newPatients', v_new_patients,
    'dailySeries', v_daily_series,
    'statuses', v_statuses,
    'doctorRollups', v_doctor_rollups
  );
end;
$$;

grant execute on function public.get_clinic_analytics_summary(uuid, date, date, uuid, boolean) to authenticated;
