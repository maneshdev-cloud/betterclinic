-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00003_rls.sql
-- Row Level Security for every table. Idempotent.
--
-- Model:
--   • Public discovery data (doctors, clinics, specializations,
--     medicines, availability) → readable by anyone.
--   • Own data (profile, patient record, notifications, AI chat) →
--     readable/writable only by its owner.
--   • Operational data (appointments, queue, check-ins) → the
--     patient, the doctor, and the clinic's staff.
--   • Clinical data (consultations, prescriptions, diagnoses …) →
--     the patient and doctors with a real care relationship
--     (public.has_care_relationship). Receptionists and clinic
--     admins do NOT get clinical history by default.
--   • Protected operational tables (appointments, slots, queue …)
--     are mutated ONLY through the validated security-definer RPCs
--     in 00002_functions.sql — direct write policies are denied.
--   • audit_logs → clinic admins (clinic-scoped); never to patients.
-- ═══════════════════════════════════════════════════════════════════

alter table public.profiles                 enable row level security;
alter table public.locations                enable row level security;
alter table public.specializations          enable row level security;
alter table public.clinics                  enable row level security;
alter table public.clinic_invite_codes      enable row level security;
alter table public.patients                 enable row level security;
alter table public.doctors                  enable row level security;
alter table public.doctor_specializations   enable row level security;
alter table public.doctor_clinics           enable row level security;
alter table public.clinic_staff             enable row level security;
alter table public.clinic_hours             enable row level security;
alter table public.doctor_availability      enable row level security;
alter table public.appointment_slots        enable row level security;
alter table public.appointments             enable row level security;
alter table public.appointment_status_history enable row level security;
alter table public.check_ins                enable row level security;
alter table public.queue_token_counters     enable row level security;
alter table public.queue_entries            enable row level security;
alter table public.queue_events             enable row level security;
alter table public.notifications            enable row level security;
alter table public.consultations            enable row level security;
alter table public.diagnoses                enable row level security;
alter table public.treatment_plans          enable row level security;
alter table public.medical_history          enable row level security;
alter table public.medicines                enable row level security;
alter table public.prescriptions            enable row level security;
alter table public.prescription_items       enable row level security;
alter table public.medication_schedules     enable row level security;
alter table public.follow_ups               enable row level security;
alter table public.reviews                  enable row level security;
alter table public.emergency_requests       enable row level security;
alter table public.audit_logs               enable row level security;
alter table public.app_settings             enable row level security;
alter table public.ai_conversations         enable row level security;
alter table public.ai_messages              enable row level security;

-- ── profiles ─────────────────────────────────────────────────────
-- Names/roles are semi-public within the product (doctor names on
-- discovery, patient names for treating staff); sensitive clinical
-- data lives in the protected clinical tables below.
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to anon, authenticated using (true);

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

-- ── locations / specializations / medicines (public reference data)
drop policy if exists locations_read on public.locations;
create policy locations_read on public.locations
  for select to anon, authenticated using (true);

drop policy if exists specializations_read on public.specializations;
create policy specializations_read on public.specializations
  for select to anon, authenticated using (true);

drop policy if exists medicines_read on public.medicines;
create policy medicines_read on public.medicines
  for select to anon, authenticated using (true);

-- ── clinics ──────────────────────────────────────────────────────
drop policy if exists clinics_read on public.clinics;
create policy clinics_read on public.clinics
  for select to anon, authenticated using (true);

drop policy if exists clinics_update_admin on public.clinics;
create policy clinics_update_admin on public.clinics
  for update to authenticated using (public.is_clinic_admin(id)) with check (public.is_clinic_admin(id));

-- ── clinic invite codes: clinic admins only ──────────────────────
drop policy if exists invite_codes_admin on public.clinic_invite_codes;
create policy invite_codes_admin on public.clinic_invite_codes
  for select to authenticated using (public.is_clinic_admin(clinic_id));

-- ── patients ─────────────────────────────────────────────────────
drop policy if exists patients_select on public.patients;
create policy patients_select on public.patients
  for select to authenticated using (
    id = auth.uid()
    or public.has_care_relationship(auth.uid(), id)
    or exists (
      select 1 from public.appointments a
      where a.patient_id = public.patients.id and public.is_clinic_staff(a.clinic_id)
    )
  );

drop policy if exists patients_update_own on public.patients;
create policy patients_update_own on public.patients
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

-- ── doctors (public discovery) ───────────────────────────────────
drop policy if exists doctors_read on public.doctors;
create policy doctors_read on public.doctors
  for select to anon, authenticated using (true);

drop policy if exists doctors_update_own on public.doctors;
create policy doctors_update_own on public.doctors
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

-- ── doctor ↔ specialization / clinic links ───────────────────────
drop policy if exists doctor_specializations_read on public.doctor_specializations;
create policy doctor_specializations_read on public.doctor_specializations
  for select to anon, authenticated using (true);

drop policy if exists doctor_specializations_write_doctor on public.doctor_specializations;
create policy doctor_specializations_write_doctor on public.doctor_specializations
  for insert to authenticated with check (doctor_id = auth.uid());

drop policy if exists doctor_specializations_delete_doctor on public.doctor_specializations;
create policy doctor_specializations_delete_doctor on public.doctor_specializations
  for delete to authenticated using (doctor_id = auth.uid());

drop policy if exists doctor_clinics_read on public.doctor_clinics;
create policy doctor_clinics_read on public.doctor_clinics
  for select to anon, authenticated using (true);

drop policy if exists doctor_clinics_insert on public.doctor_clinics;
create policy doctor_clinics_insert on public.doctor_clinics
  for insert to authenticated
  with check (doctor_id = auth.uid() or public.is_clinic_admin(clinic_id));

drop policy if exists doctor_clinics_delete on public.doctor_clinics;
create policy doctor_clinics_delete on public.doctor_clinics
  for delete to authenticated
  using (doctor_id = auth.uid() or public.is_clinic_admin(clinic_id));

-- ── clinic staff directory ───────────────────────────────────────
drop policy if exists clinic_staff_select on public.clinic_staff;
create policy clinic_staff_select on public.clinic_staff
  for select to authenticated
  using (user_id = auth.uid() or public.is_clinic_staff(clinic_id));

drop policy if exists clinic_staff_insert_admin on public.clinic_staff;
create policy clinic_staff_insert_admin on public.clinic_staff
  for insert to authenticated with check (public.is_clinic_admin(clinic_id));

drop policy if exists clinic_staff_update_admin on public.clinic_staff;
create policy clinic_staff_update_admin on public.clinic_staff
  for update to authenticated
  using (public.is_clinic_admin(clinic_id)) with check (public.is_clinic_admin(clinic_id));

drop policy if exists clinic_staff_delete_admin on public.clinic_staff;
create policy clinic_staff_delete_admin on public.clinic_staff
  for delete to authenticated using (public.is_clinic_admin(clinic_id));

-- ── clinic hours & doctor availability ───────────────────────────
drop policy if exists clinic_hours_read on public.clinic_hours;
create policy clinic_hours_read on public.clinic_hours
  for select to anon, authenticated using (true);

drop policy if exists clinic_hours_write on public.clinic_hours;
create policy clinic_hours_write on public.clinic_hours
  for all to authenticated
  using (public.is_clinic_admin(clinic_id)) with check (public.is_clinic_admin(clinic_id));

drop policy if exists availability_read on public.doctor_availability;
create policy availability_read on public.doctor_availability
  for select to anon, authenticated using (true);

drop policy if exists availability_write_doctor on public.doctor_availability;
create policy availability_write_doctor on public.doctor_availability
  for all to authenticated
  using (doctor_id = auth.uid()) with check (doctor_id = auth.uid());

-- ── appointment slots: read-only for clients, mutated via RPCs ───
drop policy if exists slots_read on public.appointment_slots;
create policy slots_read on public.appointment_slots
  for select to authenticated using (true);

-- ── appointments ─────────────────────────────────────────────────
drop policy if exists appointments_select on public.appointments;
create policy appointments_select on public.appointments
  for select to authenticated using (
    patient_id = auth.uid()
    or doctor_id = auth.uid()
    or public.is_clinic_staff(clinic_id)
  );
-- writes only through book/reschedule/cancel/check-in RPCs

drop policy if exists appointment_history_select on public.appointment_status_history;
create policy appointment_history_select on public.appointment_status_history
  for select to authenticated using (
    exists (
      select 1 from public.appointments a
      where a.id = public.appointment_status_history.appointment_id
        and (a.patient_id = auth.uid() or a.doctor_id = auth.uid() or public.is_clinic_staff(a.clinic_id))
    )
  );

drop policy if exists check_ins_select on public.check_ins;
create policy check_ins_select on public.check_ins
  for select to authenticated using (
    patient_id = auth.uid()
    or exists (
      select 1 from public.appointments a
      where a.id = public.check_ins.appointment_id
        and (a.doctor_id = auth.uid() or public.is_clinic_staff(a.clinic_id))
    )
  );

-- ── queue ────────────────────────────────────────────────────────
-- counters: no direct client access at all (RLS on, no policies)

drop policy if exists queue_select on public.queue_entries;
create policy queue_select on public.queue_entries
  for select to authenticated using (
    patient_id = auth.uid()
    or doctor_id = auth.uid()
    or public.is_clinic_staff(clinic_id)
  );
-- mutations only via queue RPCs

drop policy if exists queue_events_select on public.queue_events;
create policy queue_events_select on public.queue_events
  for select to authenticated using (
    exists (
      select 1 from public.queue_entries q
      where q.id = public.queue_events.queue_entry_id
        and (q.patient_id = auth.uid() or q.doctor_id = auth.uid() or public.is_clinic_staff(q.clinic_id))
    )
  );

-- ── notifications ────────────────────────────────────────────────
drop policy if exists notifications_select on public.notifications;
create policy notifications_select on public.notifications
  for select to authenticated using (user_id = auth.uid());

drop policy if exists notifications_update_own on public.notifications;
create policy notifications_update_own on public.notifications
  for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists notifications_delete_own on public.notifications;
create policy notifications_delete_own on public.notifications
  for delete to authenticated using (user_id = auth.uid());

-- ── clinical records ─────────────────────────────────────────────
drop policy if exists consultations_select on public.consultations;
create policy consultations_select on public.consultations
  for select to authenticated using (
    patient_id = auth.uid()
    or doctor_id = auth.uid()
    or public.has_care_relationship(auth.uid(), patient_id)
  );

drop policy if exists consultations_update_doctor on public.consultations;
create policy consultations_update_doctor on public.consultations
  for update to authenticated
  using (doctor_id = auth.uid()) with check (doctor_id = auth.uid());

drop policy if exists diagnoses_select on public.diagnoses;
create policy diagnoses_select on public.diagnoses
  for select to authenticated using (
    patient_id = auth.uid() or public.has_care_relationship(auth.uid(), patient_id)
  );

drop policy if exists diagnoses_insert_doctor on public.diagnoses;
create policy diagnoses_insert_doctor on public.diagnoses
  for insert to authenticated with check (
    exists (
      select 1 from public.consultations c
      where c.id = consultation_id and c.doctor_id = auth.uid()
    )
  );

drop policy if exists treatment_plans_select on public.treatment_plans;
create policy treatment_plans_select on public.treatment_plans
  for select to authenticated using (
    patient_id = auth.uid() or public.has_care_relationship(auth.uid(), patient_id)
  );

drop policy if exists treatment_plans_write_doctor on public.treatment_plans;
create policy treatment_plans_write_doctor on public.treatment_plans
  for all to authenticated using (
    exists (
      select 1 from public.consultations c
      where c.id = consultation_id and c.doctor_id = auth.uid()
    )
  ) with check (
    exists (
      select 1 from public.consultations c
      where c.id = consultation_id and c.doctor_id = auth.uid()
    )
  );

drop policy if exists medical_history_select on public.medical_history;
create policy medical_history_select on public.medical_history
  for select to authenticated using (
    patient_id = auth.uid() or public.has_care_relationship(auth.uid(), patient_id)
  );

drop policy if exists medical_history_insert_doctor on public.medical_history;
create policy medical_history_insert_doctor on public.medical_history
  for insert to authenticated with check (recorded_by = auth.uid());

drop policy if exists medical_history_update_doctor on public.medical_history;
create policy medical_history_update_doctor on public.medical_history
  for update to authenticated
  using (recorded_by = auth.uid()) with check (recorded_by = auth.uid());

drop policy if exists medical_history_delete_doctor on public.medical_history;
create policy medical_history_delete_doctor on public.medical_history
  for delete to authenticated using (recorded_by = auth.uid());

-- ── prescriptions ────────────────────────────────────────────────
drop policy if exists prescriptions_select on public.prescriptions;
create policy prescriptions_select on public.prescriptions
  for select to authenticated using (
    patient_id = auth.uid()
    or doctor_id = auth.uid()
    or public.has_care_relationship(auth.uid(), patient_id)
  );

drop policy if exists prescriptions_insert_doctor on public.prescriptions;
create policy prescriptions_insert_doctor on public.prescriptions
  for insert to authenticated
  with check (doctor_id = auth.uid() and patient_id <> auth.uid());

drop policy if exists prescriptions_update_doctor on public.prescriptions;
create policy prescriptions_update_doctor on public.prescriptions
  for update to authenticated
  using (doctor_id = auth.uid()) with check (doctor_id = auth.uid());

drop policy if exists prescription_items_select on public.prescription_items;
create policy prescription_items_select on public.prescription_items
  for select to authenticated using (
    exists (
      select 1 from public.prescriptions p
      where p.id = prescription_id
        and (p.patient_id = auth.uid() or p.doctor_id = auth.uid()
             or public.has_care_relationship(auth.uid(), p.patient_id))
    )
  );

drop policy if exists prescription_items_write_doctor on public.prescription_items;
create policy prescription_items_write_doctor on public.prescription_items
  for all to authenticated using (
    exists (
      select 1 from public.prescriptions p
      where p.id = prescription_id and p.doctor_id = auth.uid()
    )
  ) with check (
    exists (
      select 1 from public.prescriptions p
      where p.id = prescription_id and p.doctor_id = auth.uid()
    )
  );

drop policy if exists medication_schedules_select on public.medication_schedules;
create policy medication_schedules_select on public.medication_schedules
  for select to authenticated using (
    patient_id = auth.uid() or public.has_care_relationship(auth.uid(), patient_id)
  );
-- rows are generated by the prescription_items trigger; status changes
-- go through the prescribing doctor's service layer

drop policy if exists follow_ups_select on public.follow_ups;
create policy follow_ups_select on public.follow_ups
  for select to authenticated using (
    patient_id = auth.uid()
    or doctor_id = auth.uid()
    or public.has_care_relationship(auth.uid(), patient_id)
  );

drop policy if exists follow_ups_insert_doctor on public.follow_ups;
create policy follow_ups_insert_doctor on public.follow_ups
  for insert to authenticated
  with check (
    exists (
      select 1 from public.consultations c
      where c.id = consultation_id and c.doctor_id = auth.uid()
    )
  );

drop policy if exists follow_ups_update_doctor on public.follow_ups;
create policy follow_ups_update_doctor on public.follow_ups
  for update to authenticated
  using (doctor_id = auth.uid()) with check (doctor_id = auth.uid());

-- ── reviews ──────────────────────────────────────────────────────
drop policy if exists reviews_read on public.reviews;
create policy reviews_read on public.reviews
  for select to anon, authenticated using (is_approved);

drop policy if exists reviews_insert_patient on public.reviews;
create policy reviews_insert_patient on public.reviews
  for insert to authenticated with check (patient_id = auth.uid());
-- eligibility (completed appointment) is enforced by trigger

drop policy if exists reviews_update_own on public.reviews;
create policy reviews_update_own on public.reviews
  for update to authenticated
  using (patient_id = auth.uid()) with check (patient_id = auth.uid());

drop policy if exists reviews_delete_own on public.reviews;
create policy reviews_delete_own on public.reviews
  for delete to authenticated using (patient_id = auth.uid());

-- ── emergency (patient's own; demo simulation via RPC) ───────────
drop policy if exists emergency_select on public.emergency_requests;
create policy emergency_select on public.emergency_requests
  for select to authenticated using (patient_id = auth.uid());

-- ── audit logs: clinic admins only, clinic-scoped ────────────────
drop policy if exists audit_select_admin on public.audit_logs;
create policy audit_select_admin on public.audit_logs
  for select to authenticated
  using (clinic_id is not null and public.is_clinic_admin(clinic_id));

-- ── app settings: readable (mode is public), not writable ────────
drop policy if exists app_settings_read on public.app_settings;
create policy app_settings_read on public.app_settings
  for select to anon, authenticated using (true);

-- ── AI conversations: strictly the patient's own ─────────────────
drop policy if exists ai_conversations_all on public.ai_conversations;
create policy ai_conversations_all on public.ai_conversations
  for all to authenticated
  using (patient_id = auth.uid()) with check (patient_id = auth.uid());

drop policy if exists ai_messages_select on public.ai_messages;
create policy ai_messages_select on public.ai_messages
  for select to authenticated using (
    exists (
      select 1 from public.ai_conversations c
      where c.id = conversation_id and c.patient_id = auth.uid()
    )
  );

drop policy if exists ai_messages_insert on public.ai_messages;
create policy ai_messages_insert on public.ai_messages
  for insert to authenticated with check (
    exists (
      select 1 from public.ai_conversations c
      where c.id = conversation_id and c.patient_id = auth.uid()
    )
  );

-- ── Table grants for the PostgREST roles ─────────────────────────
grant usage on schema public to anon, authenticated, service_role;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant select on all tables in schema public to anon;
grant all on all tables in schema public to service_role;
alter default privileges in schema public
  grant select, insert, update, delete on tables to authenticated;
alter default privileges in schema public grant select on tables to anon;
alter default privileges in schema public grant all on tables to service_role;
