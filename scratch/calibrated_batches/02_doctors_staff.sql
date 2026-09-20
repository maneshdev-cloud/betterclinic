-- Batch 2: Doctors & Staff Profiles
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo-doctor@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Aarav Deshmukh","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'demo-doctor@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', 'Dr. Aarav Deshmukh', 'demo-doctor@betterclinic.app', '+919820011223', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Aarav Deshmukh', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', 'MBBS, MD (General Medicine)', 'MMC-2010-48291', 14, 600, 'Senior General Physician with 14 years clinical experience in diagnosis and treatment of chronic and acute illnesses.', '{"English","Hindi","Marathi"}', 4.88, 86, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '3f062123-b03e-41c6-b5bf-84baa4fbae2f', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('20501482-962c-466c-981b-a6eb6418a97b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.shilpa.shah1@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Shilpa Shah","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.shilpa.shah1@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'Dr. Shilpa Shah', 'dr.shilpa.shah1@betterclinic.app', '+919918006723', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Shilpa Shah', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'MBBS, MD (Pediatrics)', 'MMC-2011-98712', 19, 500, 'Experienced Orthopedics specialist committed to evidence-based, empathetic patient care.', '{"English","Gujarati"}', 4.51, 55, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', '333c7946-d872-4130-8e3c-dbb8824ae653', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('45406535-0798-4097-b82e-4aa9250370ad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.kunal.patil2@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Kunal Patil","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.kunal.patil2@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', 'Dr. Kunal Patil', 'dr.kunal.patil2@betterclinic.app', '+919524624956', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Kunal Patil', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', 'MBBS, MS (ENT)', 'MMC-2019-15906', 14, 750, 'Experienced Pediatrics specialist committed to evidence-based, empathetic patient care.', '{"Marathi","English","Hindi"}', 4.34, 16, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '751c5e4a-83a1-432c-98c7-be4a2526ab23', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.rohan.kapoor3@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Rohan Kapoor","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.rohan.kapoor3@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', 'Dr. Rohan Kapoor', 'dr.rohan.kapoor3@betterclinic.app', '+918429044375', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Rohan Kapoor', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', 'MBBS, MS (ENT)', 'MMC-2008-94779', 24, 600, 'Experienced Pediatrics specialist committed to evidence-based, empathetic patient care.', '{"Gujarati","Hindi","English"}', 4.83, 40, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '751c5e4a-83a1-432c-98c7-be4a2526ab23', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.manish.gaikwad4@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Manish Gaikwad","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.manish.gaikwad4@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', 'Dr. Manish Gaikwad', 'dr.manish.gaikwad4@betterclinic.app', '+919329025156', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Manish Gaikwad', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', 'MBBS, MS (Orthopedics)', 'MMC-2019-81521', 20, 500, 'Experienced Orthopedics specialist committed to evidence-based, empathetic patient care.', '{"Hindi","English","Marathi"}', 4.26, 56, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '333c7946-d872-4130-8e3c-dbb8824ae653', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.anjali.patel5@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Anjali Patel","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.anjali.patel5@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'Dr. Anjali Patel', 'dr.anjali.patel5@betterclinic.app', '+918810220208', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Anjali Patel', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'MBBS, DGO (Obstetrics & Gynecology)', 'MMC-2016-37853', 10, 750, 'Experienced Neurology specialist committed to evidence-based, empathetic patient care.', '{"English","Hindi"}', 4.81, 59, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'f41d4e14-64b1-46b5-96c1-44c208e81d32', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.rohan.malhotra6@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Rohan Malhotra","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.rohan.malhotra6@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', 'Dr. Rohan Malhotra', 'dr.rohan.malhotra6@betterclinic.app', '+917774058637', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Rohan Malhotra', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', 'MBBS, DGO (Obstetrics & Gynecology)', 'MMC-2012-91144', 14, 600, 'Experienced Dermatology specialist committed to evidence-based, empathetic patient care.', '{"Hindi","English"}', 4.29, 66, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '9b15f7ae-e83f-4140-a095-3b0befb5de41', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.omkar.iyer7@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Omkar Iyer","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.omkar.iyer7@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'Dr. Omkar Iyer', 'dr.omkar.iyer7@betterclinic.app', '+917765606841', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Omkar Iyer', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'MBBS, MD (Pediatrics)', 'MMC-2019-18363', 8, 500, 'Experienced Gynecology & Obstetrics specialist committed to evidence-based, empathetic patient care.', '{"Gujarati","Marathi","Hindi"}', 4.24, 42, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', '1f1b95cd-8630-4054-9161-1568c7edde9a', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.ritu.gupta8@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Ritu Gupta","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.ritu.gupta8@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', 'Dr. Ritu Gupta', 'dr.ritu.gupta8@betterclinic.app', '+919745562513', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Ritu Gupta', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', 'MBBS, MD (General Medicine)', 'MMC-2022-93329', 20, 500, 'Experienced Endocrinology specialist committed to evidence-based, empathetic patient care.', '{"Marathi","Hindi","Gujarati"}', 4.2, 51, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', 'dd98735c-005b-41cb-8e19-7ecda93a5bf6', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.mayur.bhosale9@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Mayur Bhosale","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.mayur.bhosale9@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', 'Dr. Mayur Bhosale', 'dr.mayur.bhosale9@betterclinic.app', '+919535445875', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Mayur Bhosale', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', 'MBBS, MS (ENT)', 'MMC-2011-85725', 21, 750, 'Experienced Dermatology specialist committed to evidence-based, empathetic patient care.', '{"Marathi","Gujarati"}', 4.43, 34, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '9b15f7ae-e83f-4140-a095-3b0befb5de41', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.gayatri.shah10@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Gayatri Shah","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.gayatri.shah10@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'Dr. Gayatri Shah', 'dr.gayatri.shah10@betterclinic.app', '+919135689947', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Gayatri Shah', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'MBBS, MS (ENT)', 'MMC-2007-42723', 21, 500, 'Experienced Dentistry specialist committed to evidence-based, empathetic patient care.', '{"Marathi","English","Gujarati"}', 4.67, 46, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'f5936a69-f20b-45e7-813c-a5a6819ca5d7', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.deepa.patel11@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Deepa Patel","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.deepa.patel11@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'Dr. Deepa Patel', 'dr.deepa.patel11@betterclinic.app', '+918416725471', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Deepa Patel', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'MBBS, DGO (Obstetrics & Gynecology)', 'MMC-2007-74056', 24, 600, 'Experienced General Medicine specialist committed to evidence-based, empathetic patient care.', '{"English","Gujarati","Hindi"}', 4.8, 15, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', '3f062123-b03e-41c6-b5bf-84baa4fbae2f', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.vaishali.sharma12@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Vaishali Sharma","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.vaishali.sharma12@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', 'Dr. Vaishali Sharma', 'dr.vaishali.sharma12@betterclinic.app', '+918658361208', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Vaishali Sharma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', 'MBBS, MD (Pediatrics)', 'MMC-2006-78694', 10, 400, 'Experienced Neurology specialist committed to evidence-based, empathetic patient care.', '{"English","Marathi"}', 4.36, 43, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', 'f41d4e14-64b1-46b5-96c1-44c208e81d32', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.pooja.verma13@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Pooja Verma","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.pooja.verma13@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'Dr. Pooja Verma', 'dr.pooja.verma13@betterclinic.app', '+919799673917', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Pooja Verma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'MBBS, DNB (Cardiology)', 'MMC-2017-95987', 23, 900, 'Experienced General Medicine specialist committed to evidence-based, empathetic patient care.', '{"English","Hindi","Marathi"}', 4.51, 32, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', '3f062123-b03e-41c6-b5bf-84baa4fbae2f', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.amit.bhosale14@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Amit Bhosale","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.amit.bhosale14@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', 'Dr. Amit Bhosale', 'dr.amit.bhosale14@betterclinic.app', '+919557191990', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Amit Bhosale', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', 'MBBS, DGO (Obstetrics & Gynecology)', 'MMC-2015-95687', 16, 750, 'Experienced Orthopedics specialist committed to evidence-based, empathetic patient care.', '{"English","Hindi"}', 4.32, 14, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '333c7946-d872-4130-8e3c-dbb8824ae653', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.aditya.malhotra15@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Aditya Malhotra","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.aditya.malhotra15@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', 'Dr. Aditya Malhotra', 'dr.aditya.malhotra15@betterclinic.app', '+919677201467', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Aditya Malhotra', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', 'MBBS, MS (ENT)', 'MMC-2005-10474', 13, 600, 'Experienced Ophthalmology specialist committed to evidence-based, empathetic patient care.', '{"English","Gujarati","Marathi"}', 4.8, 10, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6763ec01-e18f-4737-ba0e-a49cbb29a8e2', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.gayatri.shah16@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Gayatri Shah","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.gayatri.shah16@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', 'Dr. Gayatri Shah', 'dr.gayatri.shah16@betterclinic.app', '+918871772661', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Gayatri Shah', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', 'MBBS, DNB (Cardiology)', 'MMC-2018-39770', 8, 400, 'Experienced Ophthalmology specialist committed to evidence-based, empathetic patient care.', '{"English","Marathi"}', 4.41, 67, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '6763ec01-e18f-4737-ba0e-a49cbb29a8e2', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('33a0f9e8-bab7-40e7-aceb-d6ca8ce627aa', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.sneha.shinde17@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Sneha Shinde","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.sneha.shinde17@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', 'Dr. Sneha Shinde', 'dr.sneha.shinde17@betterclinic.app', '+918879299204', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Sneha Shinde', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', 'BDS, MDS (Oral Surgery)', 'MMC-2010-48178', 13, 400, 'Experienced Orthopedics specialist committed to evidence-based, empathetic patient care.', '{"English","Hindi"}', 4.77, 35, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '333c7946-d872-4130-8e3c-dbb8824ae653', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('357951af-dc0b-43a3-939b-79e777de0b26', '938b2836-9050-4b10-bdbf-979298838f58', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a39534df-a87c-473f-a90d-4849a9683283', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.sneha.gaikwad18@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Sneha Gaikwad","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.sneha.gaikwad18@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', 'Dr. Sneha Gaikwad', 'dr.sneha.gaikwad18@betterclinic.app', '+918658622133', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Sneha Gaikwad', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', 'MBBS, MD (General Medicine)', 'MMC-2016-26570', 10, 500, 'Experienced Pediatrics specialist committed to evidence-based, empathetic patient care.', '{"Gujarati","Hindi"}', 4.53, 47, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '751c5e4a-83a1-432c-98c7-be4a2526ab23', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('a39534df-a87c-473f-a90d-4849a9683283', '8c5171bc-eb25-4634-9355-48dab31b3620', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dr.arjun.iyer19@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dr. Arjun Iyer","role":"DOCTOR"}'::jsonb)
on conflict (id) do update set email = 'dr.arjun.iyer19@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', 'Dr. Arjun Iyer', 'dr.arjun.iyer19@betterclinic.app', '+919716061441', 'DOCTOR', true)
on conflict (id) do update set full_name = 'Dr. Arjun Iyer', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', 'DOCTOR', true)
on conflict (profile_id, role) do nothing;
insert into public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', 'MBBS, DGO (Obstetrics & Gynecology)', 'MMC-2011-47027', 22, 400, 'Experienced Neurology specialist committed to evidence-based, empathetic patient care.', '{"Marathi","Gujarati"}', 4.57, 65, true, true)
on conflict (id) do nothing;
insert into public.doctor_clinics (doctor_id, clinic_id, is_primary, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', true, true)
on conflict do nothing;
insert into public.doctor_specializations (doctor_id, specialization_id, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', 'f41d4e14-64b1-46b5-96c1-44c208e81d32', true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active, is_synthetic)
values ('732baf9f-6ee0-4fd1-ae44-581576ca9acf', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true, true)
on conflict do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo-receptionist@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sunita Patil","role":"RECEPTIONIST"}'::jsonb)
on conflict (id) do update set email = 'demo-receptionist@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000003', 'Sunita Patil', 'demo-receptionist@betterclinic.app', '+919636302276', 'RECEPTIONIST'::public.user_role, true)
on conflict (id) do update set full_name = 'Sunita Patil', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000003', 'RECEPTIONIST'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000003', '938b2836-9050-4b10-bdbf-979298838f58', 'RECEPTIONIST'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo-admin@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rajesh Joshi","role":"CLINIC_ADMIN"}'::jsonb)
on conflict (id) do update set email = 'demo-admin@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000004', 'Rajesh Joshi', 'demo-admin@betterclinic.app', '+919134898053', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (id) do update set full_name = 'Rajesh Joshi', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000004', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('00000000-0000-0000-0000-000000000004', '938b2836-9050-4b10-bdbf-979298838f58', 'CLINIC_ADMIN'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('3ff92817-bb51-49d5-89c3-2aae54ca97fd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'receptionist.aarav.1@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Rao","role":"RECEPTIONIST"}'::jsonb)
on conflict (id) do update set email = 'receptionist.aarav.1@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('3ff92817-bb51-49d5-89c3-2aae54ca97fd', 'Aarav Rao', 'receptionist.aarav.1@betterclinic.app', '+918462930317', 'RECEPTIONIST'::public.user_role, true)
on conflict (id) do update set full_name = 'Aarav Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('3ff92817-bb51-49d5-89c3-2aae54ca97fd', 'RECEPTIONIST'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('3ff92817-bb51-49d5-89c3-2aae54ca97fd', '8c5171bc-eb25-4634-9355-48dab31b3620', 'RECEPTIONIST'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a259763f-1b48-4f01-a673-cb191dcbadc2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'clinic_admin.vaishali.2@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Vaishali Patel","role":"CLINIC_ADMIN"}'::jsonb)
on conflict (id) do update set email = 'clinic_admin.vaishali.2@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a259763f-1b48-4f01-a673-cb191dcbadc2', 'Vaishali Patel', 'clinic_admin.vaishali.2@betterclinic.app', '+918682356120', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (id) do update set full_name = 'Vaishali Patel', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a259763f-1b48-4f01-a673-cb191dcbadc2', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('a259763f-1b48-4f01-a673-cb191dcbadc2', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'CLINIC_ADMIN'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('7f631d75-9094-420a-90bd-8e53f1881689', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'receptionist.neha.3@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Neha Nair","role":"RECEPTIONIST"}'::jsonb)
on conflict (id) do update set email = 'receptionist.neha.3@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('7f631d75-9094-420a-90bd-8e53f1881689', 'Neha Nair', 'receptionist.neha.3@betterclinic.app', '+918893750937', 'RECEPTIONIST'::public.user_role, true)
on conflict (id) do update set full_name = 'Neha Nair', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('7f631d75-9094-420a-90bd-8e53f1881689', 'RECEPTIONIST'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('7f631d75-9094-420a-90bd-8e53f1881689', '9ae5c640-7396-468f-93c5-f50f917e3bd7', 'RECEPTIONIST'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('9d23082b-8e9a-4946-a846-571b7819304c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'clinic_admin.arjun.4@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Arjun Chavan","role":"CLINIC_ADMIN"}'::jsonb)
on conflict (id) do update set email = 'clinic_admin.arjun.4@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('9d23082b-8e9a-4946-a846-571b7819304c', 'Arjun Chavan', 'clinic_admin.arjun.4@betterclinic.app', '+918889074496', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (id) do update set full_name = 'Arjun Chavan', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('9d23082b-8e9a-4946-a846-571b7819304c', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('9d23082b-8e9a-4946-a846-571b7819304c', 'cf2d9d96-47cc-47da-8645-76b95437dbc9', 'CLINIC_ADMIN'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('644715a1-8a61-49e9-932b-b7b8a43d3a67', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'receptionist.sagar.5@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sagar Deshmukh","role":"RECEPTIONIST"}'::jsonb)
on conflict (id) do update set email = 'receptionist.sagar.5@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('644715a1-8a61-49e9-932b-b7b8a43d3a67', 'Sagar Deshmukh', 'receptionist.sagar.5@betterclinic.app', '+919919857287', 'RECEPTIONIST'::public.user_role, true)
on conflict (id) do update set full_name = 'Sagar Deshmukh', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('644715a1-8a61-49e9-932b-b7b8a43d3a67', 'RECEPTIONIST'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('644715a1-8a61-49e9-932b-b7b8a43d3a67', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 'RECEPTIONIST'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a485ba3d-faac-40f1-8c90-83e0c261bc67', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'clinic_admin.smita.6@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Smita Gaikwad","role":"CLINIC_ADMIN"}'::jsonb)
on conflict (id) do update set email = 'clinic_admin.smita.6@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a485ba3d-faac-40f1-8c90-83e0c261bc67', 'Smita Gaikwad', 'clinic_admin.smita.6@betterclinic.app', '+919869451559', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (id) do update set full_name = 'Smita Gaikwad', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a485ba3d-faac-40f1-8c90-83e0c261bc67', 'CLINIC_ADMIN'::public.user_role, true)
on conflict (profile_id, role) do nothing;
insert into public.clinic_staff (user_id, clinic_id, role, is_active, is_synthetic)
values ('a485ba3d-faac-40f1-8c90-83e0c261bc67', 'b414fd6a-3853-4a05-af92-9676d226eca1', 'CLINIC_ADMIN'::public.user_role, true, true)
on conflict (user_id, clinic_id) do nothing;
