-- ─────────────────────────────────────────────────────────────────
-- 00009 — fix emergency_advance_demo
--
-- REAL BUG found by the Phase 6 workflow checks: the UPDATE at the
-- end of emergency_advance_demo referenced `p_req.id`, but the
-- function's parameter is `p_request_id` and the row variable is
-- `v_req` — so the function could never execute (missing FROM-clause
-- entry for table "p_req"). It had never been exercised before.
-- This migration replaces it with the corrected statement.
-- ─────────────────────────────────────────────────────────────────

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
  where id = p_request_id
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
