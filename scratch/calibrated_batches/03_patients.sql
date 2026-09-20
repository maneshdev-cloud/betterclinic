-- Batch 3: 60 Patients
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo-patient@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Sharma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'demo-patient@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000001', 'Aarav Sharma', 'demo-patient@betterclinic.app', '+919819922334', 'PATIENT', true)
on conflict (id) do update set full_name = 'Aarav Sharma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('00000000-0000-0000-0000-000000000001', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('00000000-0000-0000-0000-000000000001', '1994-08-14', 'MALE'::public.sex, 'O+', 'Flat 402, Lotus Heights, Andheri West', 'Mumbai', 'Andheri', '400053', 'Family Member', '+919548898800', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('efb76641-e045-4f09-b58a-9f11e3a50b05', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.komal.jadhav1@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Komal Jadhav","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.komal.jadhav1@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('efb76641-e045-4f09-b58a-9f11e3a50b05', 'Komal Jadhav', 'patient.komal.jadhav1@betterclinic.app', '+919789859721', 'PATIENT', true)
on conflict (id) do update set full_name = 'Komal Jadhav', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('efb76641-e045-4f09-b58a-9f11e3a50b05', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('efb76641-e045-4f09-b58a-9f11e3a50b05', '1990-03-24', 'FEMALE'::public.sex, 'AB+', 'Flat 715, Tower B, Manpada', 'Thane', 'Manpada', '405707', 'Family Member', '+917584770726', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('efb76641-e045-4f09-b58a-9f11e3a50b05', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('caafb38e-6580-41d8-b03b-cff74c544c18', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pooja.verma2@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pooja Verma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.pooja.verma2@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('caafb38e-6580-41d8-b03b-cff74c544c18', 'Pooja Verma', 'patient.pooja.verma2@betterclinic.app', '+917725464281', 'PATIENT', true)
on conflict (id) do update set full_name = 'Pooja Verma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('caafb38e-6580-41d8-b03b-cff74c544c18', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('caafb38e-6580-41d8-b03b-cff74c544c18', '1998-09-10', 'FEMALE'::public.sex, 'O+', 'Flat 721, Tower C, Belapur', 'Navi Mumbai', 'Belapur', '403174', 'Family Member', '+918642503622', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('5eb28e9f-a887-4708-969b-9370f092c80f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aarav.joshi3@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Joshi","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.aarav.joshi3@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('5eb28e9f-a887-4708-969b-9370f092c80f', 'Aarav Joshi', 'patient.aarav.joshi3@betterclinic.app', '+918722508301', 'PATIENT', true)
on conflict (id) do update set full_name = 'Aarav Joshi', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('5eb28e9f-a887-4708-969b-9370f092c80f', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('5eb28e9f-a887-4708-969b-9370f092c80f', '2003-12-28', 'MALE'::public.sex, 'O+', 'Flat 757, Tower C, Manpada', 'Thane', 'Manpada', '408010', 'Family Member', '+919383108361', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('5eb28e9f-a887-4708-969b-9370f092c80f', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('3258f3d2-cb78-4178-ad18-35263b42b8cb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.karan.mehta4@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Karan Mehta","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.karan.mehta4@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('3258f3d2-cb78-4178-ad18-35263b42b8cb', 'Karan Mehta', 'patient.karan.mehta4@betterclinic.app', '+919390435365', 'PATIENT', true)
on conflict (id) do update set full_name = 'Karan Mehta', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('3258f3d2-cb78-4178-ad18-35263b42b8cb', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('3258f3d2-cb78-4178-ad18-35263b42b8cb', '2004-02-09', 'MALE'::public.sex, 'O-', 'Flat 534, Tower C, Kasarvadavali', 'Thane', 'Kasarvadavali', '410705', 'Family Member', '+918492658069', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('3258f3d2-cb78-4178-ad18-35263b42b8cb', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('723962c6-03ce-43a8-a62b-e543664f7908', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.yash.joshi5@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Yash Joshi","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.yash.joshi5@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('723962c6-03ce-43a8-a62b-e543664f7908', 'Yash Joshi', 'patient.yash.joshi5@betterclinic.app', '+918623498820', 'PATIENT', true)
on conflict (id) do update set full_name = 'Yash Joshi', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('723962c6-03ce-43a8-a62b-e543664f7908', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('723962c6-03ce-43a8-a62b-e543664f7908', '1971-01-12', 'MALE'::public.sex, 'A-', 'Flat 889, Tower B, Nerul', 'Navi Mumbai', 'Nerul', '402038', 'Family Member', '+918684824402', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('8f1a4e44-ea28-428b-ac08-b427d4a26131', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.isha.patil6@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Isha Patil","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.isha.patil6@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('8f1a4e44-ea28-428b-ac08-b427d4a26131', 'Isha Patil', 'patient.isha.patil6@betterclinic.app', '+919926625423', 'PATIENT', true)
on conflict (id) do update set full_name = 'Isha Patil', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('8f1a4e44-ea28-428b-ac08-b427d4a26131', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('8f1a4e44-ea28-428b-ac08-b427d4a26131', '1986-05-24', 'FEMALE'::public.sex, 'O+', 'Flat 1028, Tower A, Panvel', 'Navi Mumbai', 'Panvel', '403963', 'Family Member', '+918652007208', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('28aab011-5031-40d8-ae55-f85627a8678a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sagar.shah7@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sagar Shah","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.sagar.shah7@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('28aab011-5031-40d8-ae55-f85627a8678a', 'Sagar Shah', 'patient.sagar.shah7@betterclinic.app', '+919360624687', 'PATIENT', true)
on conflict (id) do update set full_name = 'Sagar Shah', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('28aab011-5031-40d8-ae55-f85627a8678a', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('28aab011-5031-40d8-ae55-f85627a8678a', '1994-04-19', 'MALE'::public.sex, 'O+', 'Flat 510, Tower B, Dadar', 'Mumbai', 'Dadar', '403434', 'Family Member', '+918617963076', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('28aab011-5031-40d8-ae55-f85627a8678a', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('1e3839b0-2030-4822-9776-b21ef934420a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.karan.verma8@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Karan Verma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.karan.verma8@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('1e3839b0-2030-4822-9776-b21ef934420a', 'Karan Verma', 'patient.karan.verma8@betterclinic.app', '+919554087690', 'PATIENT', true)
on conflict (id) do update set full_name = 'Karan Verma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('1e3839b0-2030-4822-9776-b21ef934420a', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('1e3839b0-2030-4822-9776-b21ef934420a', '1976-06-26', 'MALE'::public.sex, 'O+', 'Flat 522, Tower B, Powai', 'Mumbai', 'Powai', '401704', 'Family Member', '+918823589395', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('1e3839b0-2030-4822-9776-b21ef934420a', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('b920252a-46f9-4001-b456-fd87298f3069', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.dev.iyer9@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dev Iyer","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.dev.iyer9@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('b920252a-46f9-4001-b456-fd87298f3069', 'Dev Iyer', 'patient.dev.iyer9@betterclinic.app', '+918691819080', 'PATIENT', true)
on conflict (id) do update set full_name = 'Dev Iyer', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('b920252a-46f9-4001-b456-fd87298f3069', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('b920252a-46f9-4001-b456-fd87298f3069', '1964-01-12', 'MALE'::public.sex, 'B-', 'Flat 352, Tower A, Viman Nagar', 'Pune', 'Viman Nagar', '407646', 'Family Member', '+918416767416', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('004e7863-d49c-4148-a334-c6094694cebd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sameer.nair10@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sameer Nair","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.sameer.nair10@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('004e7863-d49c-4148-a334-c6094694cebd', 'Sameer Nair', 'patient.sameer.nair10@betterclinic.app', '+918872146031', 'PATIENT', true)
on conflict (id) do update set full_name = 'Sameer Nair', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('004e7863-d49c-4148-a334-c6094694cebd', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('004e7863-d49c-4148-a334-c6094694cebd', '1988-10-11', 'MALE'::public.sex, 'O+', 'Flat 698, Tower A, Kasarvadavali', 'Thane', 'Kasarvadavali', '405324', 'Family Member', '+919629423214', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('004e7863-d49c-4148-a334-c6094694cebd', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('9a49d610-c854-4d03-87be-1a7dd595214c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.kavita.kulkarni11@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Kavita Kulkarni","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.kavita.kulkarni11@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('9a49d610-c854-4d03-87be-1a7dd595214c', 'Kavita Kulkarni', 'patient.kavita.kulkarni11@betterclinic.app', '+919557947915', 'PATIENT', true)
on conflict (id) do update set full_name = 'Kavita Kulkarni', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('9a49d610-c854-4d03-87be-1a7dd595214c', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('9a49d610-c854-4d03-87be-1a7dd595214c', '1986-08-30', 'FEMALE'::public.sex, 'AB+', 'Flat 349, Tower A, Bandra', 'Mumbai', 'Bandra', '406130', 'Family Member', '+918847451801', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.varun.kulkarni12@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Varun Kulkarni","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.varun.kulkarni12@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 'Varun Kulkarni', 'patient.varun.kulkarni12@betterclinic.app', '+917548750408', 'PATIENT', true)
on conflict (id) do update set full_name = 'Varun Kulkarni', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', '1990-02-25', 'MALE'::public.sex, 'B+', 'Flat 638, Tower B, Panvel', 'Navi Mumbai', 'Panvel', '400222', 'Family Member', '+917567050501', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('2446e034-e030-4ffb-830f-3dd8d3f10161', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.abhishek.patil13@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Abhishek Patil","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.abhishek.patil13@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('2446e034-e030-4ffb-830f-3dd8d3f10161', 'Abhishek Patil', 'patient.abhishek.patil13@betterclinic.app', '+919583727818', 'PATIENT', true)
on conflict (id) do update set full_name = 'Abhishek Patil', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('2446e034-e030-4ffb-830f-3dd8d3f10161', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('2446e034-e030-4ffb-830f-3dd8d3f10161', '1971-12-18', 'MALE'::public.sex, 'O+', 'Flat 330, Tower B, Andheri', 'Mumbai', 'Andheri', '400491', 'Family Member', '+917527009306', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a78963b2-f214-403d-b977-cf59852f63e9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.gaurav.rao14@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Gaurav Rao","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.gaurav.rao14@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a78963b2-f214-403d-b977-cf59852f63e9', 'Gaurav Rao', 'patient.gaurav.rao14@betterclinic.app', '+917777957351', 'PATIENT', true)
on conflict (id) do update set full_name = 'Gaurav Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a78963b2-f214-403d-b977-cf59852f63e9', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('a78963b2-f214-403d-b977-cf59852f63e9', '1963-03-31', 'MALE'::public.sex, 'AB+', 'Flat 317, Tower B, Kharghar', 'Navi Mumbai', 'Kharghar', '410333', 'Family Member', '+918817408266', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('a78963b2-f214-403d-b977-cf59852f63e9', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('730a9ea5-c509-4bab-ba5b-90805528bfa4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rohan.patel15@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rohan Patel","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.rohan.patel15@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('730a9ea5-c509-4bab-ba5b-90805528bfa4', 'Rohan Patel', 'patient.rohan.patel15@betterclinic.app', '+919976769090', 'PATIENT', true)
on conflict (id) do update set full_name = 'Rohan Patel', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('730a9ea5-c509-4bab-ba5b-90805528bfa4', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('730a9ea5-c509-4bab-ba5b-90805528bfa4', '1990-06-11', 'MALE'::public.sex, 'A+', 'Flat 234, Tower C, Hinjewadi', 'Pune', 'Hinjewadi', '403494', 'Family Member', '+919831976481', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('730a9ea5-c509-4bab-ba5b-90805528bfa4', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('bd006633-930c-4e21-a494-358efacb415d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.amit.mehta16@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Amit Mehta","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.amit.mehta16@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('bd006633-930c-4e21-a494-358efacb415d', 'Amit Mehta', 'patient.amit.mehta16@betterclinic.app', '+917515535425', 'PATIENT', true)
on conflict (id) do update set full_name = 'Amit Mehta', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('bd006633-930c-4e21-a494-358efacb415d', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('bd006633-930c-4e21-a494-358efacb415d', '2011-12-24', 'MALE'::public.sex, 'B-', 'Flat 296, Tower B, Chembur', 'Mumbai', 'Chembur', '406945', 'Family Member', '+919667372992', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('d1946453-a5ec-4dfa-861a-661fec5c3b71', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.gayatri.rao17@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Gayatri Rao","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.gayatri.rao17@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('d1946453-a5ec-4dfa-861a-661fec5c3b71', 'Gayatri Rao', 'patient.gayatri.rao17@betterclinic.app', '+917574743680', 'PATIENT', true)
on conflict (id) do update set full_name = 'Gayatri Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('d1946453-a5ec-4dfa-861a-661fec5c3b71', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('d1946453-a5ec-4dfa-861a-661fec5c3b71', '1996-12-31', 'FEMALE'::public.sex, 'AB-', 'Flat 946, Tower C, Kothrud', 'Pune', 'Kothrud', '404859', 'Family Member', '+919124712942', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('d1946453-a5ec-4dfa-861a-661fec5c3b71', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('4120622b-cb28-4946-aa92-f9751e225716', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.dev.rao18@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Dev Rao","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.dev.rao18@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('4120622b-cb28-4946-aa92-f9751e225716', 'Dev Rao', 'patient.dev.rao18@betterclinic.app', '+917742695703', 'PATIENT', true)
on conflict (id) do update set full_name = 'Dev Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('4120622b-cb28-4946-aa92-f9751e225716', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('4120622b-cb28-4946-aa92-f9751e225716', '1989-04-29', 'MALE'::public.sex, 'A-', 'Flat 937, Tower C, Viman Nagar', 'Pune', 'Viman Nagar', '403297', 'Family Member', '+918769900924', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('4120622b-cb28-4946-aa92-f9751e225716', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('176934c2-6a44-44fd-8f74-97ded4f49dc2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.divya.jadhav19@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Divya Jadhav","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.divya.jadhav19@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('176934c2-6a44-44fd-8f74-97ded4f49dc2', 'Divya Jadhav', 'patient.divya.jadhav19@betterclinic.app', '+919880678149', 'PATIENT', true)
on conflict (id) do update set full_name = 'Divya Jadhav', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('176934c2-6a44-44fd-8f74-97ded4f49dc2', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('176934c2-6a44-44fd-8f74-97ded4f49dc2', '1960-10-25', 'FEMALE'::public.sex, 'O-', 'Flat 228, Tower C, Aundh', 'Pune', 'Aundh', '401280', 'Family Member', '+919187184762', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('685dd87e-f83f-4ef4-a56d-aa869052ae17', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.varun.nair20@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Varun Nair","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.varun.nair20@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('685dd87e-f83f-4ef4-a56d-aa869052ae17', 'Varun Nair', 'patient.varun.nair20@betterclinic.app', '+919787947228', 'PATIENT', true)
on conflict (id) do update set full_name = 'Varun Nair', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('685dd87e-f83f-4ef4-a56d-aa869052ae17', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('685dd87e-f83f-4ef4-a56d-aa869052ae17', '1999-05-04', 'MALE'::public.sex, 'AB+', 'Flat 1134, Tower A, Chembur', 'Mumbai', 'Chembur', '403445', 'Family Member', '+918462002372', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('89512172-c2ef-4d75-99e2-491498e1b438', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.vikram.kulkarni21@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Vikram Kulkarni","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.vikram.kulkarni21@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('89512172-c2ef-4d75-99e2-491498e1b438', 'Vikram Kulkarni', 'patient.vikram.kulkarni21@betterclinic.app', '+918716371642', 'PATIENT', true)
on conflict (id) do update set full_name = 'Vikram Kulkarni', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('89512172-c2ef-4d75-99e2-491498e1b438', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('89512172-c2ef-4d75-99e2-491498e1b438', '1985-07-06', 'MALE'::public.sex, 'O-', 'Flat 322, Tower B, Baner', 'Pune', 'Baner', '402273', 'Family Member', '+917797094214', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('4269078d-2025-4f83-a955-707f0bec0724', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.neha.malhotra22@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Neha Malhotra","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.neha.malhotra22@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('4269078d-2025-4f83-a955-707f0bec0724', 'Neha Malhotra', 'patient.neha.malhotra22@betterclinic.app', '+919687077488', 'PATIENT', true)
on conflict (id) do update set full_name = 'Neha Malhotra', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('4269078d-2025-4f83-a955-707f0bec0724', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('4269078d-2025-4f83-a955-707f0bec0724', '2005-06-04', 'FEMALE'::public.sex, 'O-', 'Flat 972, Tower B, Panvel', 'Navi Mumbai', 'Panvel', '404318', 'Family Member', '+919528961885', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('4269078d-2025-4f83-a955-707f0bec0724', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.omkar.verma23@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Omkar Verma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.omkar.verma23@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', 'Omkar Verma', 'patient.omkar.verma23@betterclinic.app', '+918663938855', 'PATIENT', true)
on conflict (id) do update set full_name = 'Omkar Verma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', '2003-07-14', 'MALE'::public.sex, 'B-', 'Flat 705, Tower C, Dadar', 'Mumbai', 'Dadar', '400805', 'Family Member', '+918734098779', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('214eaaa0-d604-4c9e-9eaa-c89fdc40aca3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aarav.shah24@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Shah","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.aarav.shah24@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('214eaaa0-d604-4c9e-9eaa-c89fdc40aca3', 'Aarav Shah', 'patient.aarav.shah24@betterclinic.app', '+917791257881', 'PATIENT', true)
on conflict (id) do update set full_name = 'Aarav Shah', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('214eaaa0-d604-4c9e-9eaa-c89fdc40aca3', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('214eaaa0-d604-4c9e-9eaa-c89fdc40aca3', '2000-11-11', 'MALE'::public.sex, 'A-', 'Flat 601, Tower C, Majiwada', 'Thane', 'Majiwada', '406743', 'Family Member', '+918690374388', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('214eaaa0-d604-4c9e-9eaa-c89fdc40aca3', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('11adc1bc-ae6d-4d2e-ab7e-d2bfab7def3a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.komal.kapoor25@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Komal Kapoor","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.komal.kapoor25@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('11adc1bc-ae6d-4d2e-ab7e-d2bfab7def3a', 'Komal Kapoor', 'patient.komal.kapoor25@betterclinic.app', '+919945478006', 'PATIENT', true)
on conflict (id) do update set full_name = 'Komal Kapoor', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('11adc1bc-ae6d-4d2e-ab7e-d2bfab7def3a', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('11adc1bc-ae6d-4d2e-ab7e-d2bfab7def3a', '1980-10-21', 'FEMALE'::public.sex, 'A+', 'Flat 309, Tower C, Vartak Nagar', 'Thane', 'Vartak Nagar', '408148', 'Family Member', '+919975434600', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('338ea150-f146-4f11-b771-3bb44f35ebcc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rahul.mehta26@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rahul Mehta","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.rahul.mehta26@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('338ea150-f146-4f11-b771-3bb44f35ebcc', 'Rahul Mehta', 'patient.rahul.mehta26@betterclinic.app', '+919343274185', 'PATIENT', true)
on conflict (id) do update set full_name = 'Rahul Mehta', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('338ea150-f146-4f11-b771-3bb44f35ebcc', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('338ea150-f146-4f11-b771-3bb44f35ebcc', '1961-08-01', 'MALE'::public.sex, 'A+', 'Flat 822, Tower B, Baner', 'Pune', 'Baner', '402302', 'Family Member', '+918762834898', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('338ea150-f146-4f11-b771-3bb44f35ebcc', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('e030eba9-cee9-41d8-9bbb-c5009dda1ed6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.arjun.kapoor27@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Arjun Kapoor","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.arjun.kapoor27@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('e030eba9-cee9-41d8-9bbb-c5009dda1ed6', 'Arjun Kapoor', 'patient.arjun.kapoor27@betterclinic.app', '+919790863800', 'PATIENT', true)
on conflict (id) do update set full_name = 'Arjun Kapoor', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('e030eba9-cee9-41d8-9bbb-c5009dda1ed6', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('e030eba9-cee9-41d8-9bbb-c5009dda1ed6', '2007-08-25', 'MALE'::public.sex, 'O+', 'Flat 351, Tower B, Manpada', 'Thane', 'Manpada', '409312', 'Family Member', '+919886128709', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('ad2ef999-0a20-477d-967d-14dd28dac2e2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.smita.more28@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Smita More","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.smita.more28@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('ad2ef999-0a20-477d-967d-14dd28dac2e2', 'Smita More', 'patient.smita.more28@betterclinic.app', '+918631882026', 'PATIENT', true)
on conflict (id) do update set full_name = 'Smita More', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('ad2ef999-0a20-477d-967d-14dd28dac2e2', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('ad2ef999-0a20-477d-967d-14dd28dac2e2', '1997-03-08', 'FEMALE'::public.sex, 'A-', 'Flat 995, Tower B, Kharghar', 'Navi Mumbai', 'Kharghar', '402319', 'Family Member', '+919123621449', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('ad2ef999-0a20-477d-967d-14dd28dac2e2', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('c3ea3ace-8725-4017-ba5b-ca817ad4c57e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.komal.shinde29@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Komal Shinde","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.komal.shinde29@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('c3ea3ace-8725-4017-ba5b-ca817ad4c57e', 'Komal Shinde', 'patient.komal.shinde29@betterclinic.app', '+919973665402', 'PATIENT', true)
on conflict (id) do update set full_name = 'Komal Shinde', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('c3ea3ace-8725-4017-ba5b-ca817ad4c57e', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('c3ea3ace-8725-4017-ba5b-ca817ad4c57e', '1963-11-20', 'FEMALE'::public.sex, 'A-', 'Flat 1170, Tower C, Nerul', 'Navi Mumbai', 'Nerul', '404805', 'Family Member', '+919989775382', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('dd89f199-bacf-4848-845c-011cff58dd80', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.mayur.nair30@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Mayur Nair","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.mayur.nair30@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('dd89f199-bacf-4848-845c-011cff58dd80', 'Mayur Nair', 'patient.mayur.nair30@betterclinic.app', '+919634287349', 'PATIENT', true)
on conflict (id) do update set full_name = 'Mayur Nair', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('dd89f199-bacf-4848-845c-011cff58dd80', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('dd89f199-bacf-4848-845c-011cff58dd80', '1972-03-18', 'MALE'::public.sex, 'A+', 'Flat 870, Tower A, Andheri', 'Mumbai', 'Andheri', '409517', 'Family Member', '+918662572130', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('dd89f199-bacf-4848-845c-011cff58dd80', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('b9359158-3fb0-4a2e-b677-2cd4c9d856ec', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.tanvi.jadhav31@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Tanvi Jadhav","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.tanvi.jadhav31@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('b9359158-3fb0-4a2e-b677-2cd4c9d856ec', 'Tanvi Jadhav', 'patient.tanvi.jadhav31@betterclinic.app', '+918465189403', 'PATIENT', true)
on conflict (id) do update set full_name = 'Tanvi Jadhav', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('b9359158-3fb0-4a2e-b677-2cd4c9d856ec', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('b9359158-3fb0-4a2e-b677-2cd4c9d856ec', '2006-04-16', 'FEMALE'::public.sex, 'O-', 'Flat 783, Tower B, Belapur', 'Navi Mumbai', 'Belapur', '406125', 'Family Member', '+918477189830', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('636d99f5-0695-4077-9180-1f7bca13f228', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aditya.iyer32@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aditya Iyer","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.aditya.iyer32@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('636d99f5-0695-4077-9180-1f7bca13f228', 'Aditya Iyer', 'patient.aditya.iyer32@betterclinic.app', '+919946751884', 'PATIENT', true)
on conflict (id) do update set full_name = 'Aditya Iyer', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('636d99f5-0695-4077-9180-1f7bca13f228', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('636d99f5-0695-4077-9180-1f7bca13f228', '2001-09-07', 'MALE'::public.sex, 'A-', 'Flat 836, Tower C, Panvel', 'Navi Mumbai', 'Panvel', '409718', 'Family Member', '+919743702878', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a9e10fcf-7e51-4d2e-9d35-c95abb1ed360', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sunita.mehta33@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sunita Mehta","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.sunita.mehta33@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a9e10fcf-7e51-4d2e-9d35-c95abb1ed360', 'Sunita Mehta', 'patient.sunita.mehta33@betterclinic.app', '+919696647789', 'PATIENT', true)
on conflict (id) do update set full_name = 'Sunita Mehta', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a9e10fcf-7e51-4d2e-9d35-c95abb1ed360', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('a9e10fcf-7e51-4d2e-9d35-c95abb1ed360', '2006-03-12', 'FEMALE'::public.sex, 'A+', 'Flat 687, Tower B, Baner', 'Pune', 'Baner', '407077', 'Family Member', '+918812762251', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('a9e10fcf-7e51-4d2e-9d35-c95abb1ed360', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('3ee80670-3e9b-453c-b84c-04734bf8f9da', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.arjun.iyer34@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Arjun Iyer","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.arjun.iyer34@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('3ee80670-3e9b-453c-b84c-04734bf8f9da', 'Arjun Iyer', 'patient.arjun.iyer34@betterclinic.app', '+919363323616', 'PATIENT', true)
on conflict (id) do update set full_name = 'Arjun Iyer', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('3ee80670-3e9b-453c-b84c-04734bf8f9da', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('3ee80670-3e9b-453c-b84c-04734bf8f9da', '2000-11-10', 'MALE'::public.sex, 'AB-', 'Flat 584, Tower C, Bandra', 'Mumbai', 'Bandra', '405652', 'Family Member', '+917567067736', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('3ee80670-3e9b-453c-b84c-04734bf8f9da', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('c61f8c3f-b31a-4ea0-9600-99027b2d3b66', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.mayur.joshi35@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Mayur Joshi","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.mayur.joshi35@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('c61f8c3f-b31a-4ea0-9600-99027b2d3b66', 'Mayur Joshi', 'patient.mayur.joshi35@betterclinic.app', '+918739450911', 'PATIENT', true)
on conflict (id) do update set full_name = 'Mayur Joshi', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('c61f8c3f-b31a-4ea0-9600-99027b2d3b66', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('c61f8c3f-b31a-4ea0-9600-99027b2d3b66', '1965-05-28', 'MALE'::public.sex, 'AB-', 'Flat 138, Tower A, Aundh', 'Pune', 'Aundh', '408264', 'Family Member', '+919747641856', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('54570384-bf17-4d9e-b59d-759b4a951940', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aditya.rao36@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aditya Rao","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.aditya.rao36@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('54570384-bf17-4d9e-b59d-759b4a951940', 'Aditya Rao', 'patient.aditya.rao36@betterclinic.app', '+919582692254', 'PATIENT', true)
on conflict (id) do update set full_name = 'Aditya Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('54570384-bf17-4d9e-b59d-759b4a951940', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('54570384-bf17-4d9e-b59d-759b4a951940', '2005-04-05', 'MALE'::public.sex, 'B+', 'Flat 595, Tower A, Majiwada', 'Thane', 'Majiwada', '404514', 'Family Member', '+919983052734', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('54570384-bf17-4d9e-b59d-759b4a951940', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('673ad57e-0dbc-45ff-bbf3-2401d1cbf920', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.karan.gaikwad37@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Karan Gaikwad","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.karan.gaikwad37@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('673ad57e-0dbc-45ff-bbf3-2401d1cbf920', 'Karan Gaikwad', 'patient.karan.gaikwad37@betterclinic.app', '+918653625454', 'PATIENT', true)
on conflict (id) do update set full_name = 'Karan Gaikwad', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('673ad57e-0dbc-45ff-bbf3-2401d1cbf920', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('673ad57e-0dbc-45ff-bbf3-2401d1cbf920', '2006-05-12', 'MALE'::public.sex, 'O-', 'Flat 989, Tower C, Naupada', 'Thane', 'Naupada', '406369', 'Family Member', '+919535609050', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a94be75b-e4a0-4144-8801-677cfbe24928', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.isha.verma38@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Isha Verma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.isha.verma38@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a94be75b-e4a0-4144-8801-677cfbe24928', 'Isha Verma', 'patient.isha.verma38@betterclinic.app', '+918853169698', 'PATIENT', true)
on conflict (id) do update set full_name = 'Isha Verma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a94be75b-e4a0-4144-8801-677cfbe24928', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('a94be75b-e4a0-4144-8801-677cfbe24928', '1960-12-12', 'FEMALE'::public.sex, 'O+', 'Flat 937, Tower C, Andheri', 'Mumbai', 'Andheri', '403429', 'Family Member', '+919338843382', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('21b04355-3182-4fda-9c4d-a0e5ca80d62e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.alok.chavan39@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Alok Chavan","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.alok.chavan39@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('21b04355-3182-4fda-9c4d-a0e5ca80d62e', 'Alok Chavan', 'patient.alok.chavan39@betterclinic.app', '+917574357402', 'PATIENT', true)
on conflict (id) do update set full_name = 'Alok Chavan', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('21b04355-3182-4fda-9c4d-a0e5ca80d62e', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('21b04355-3182-4fda-9c4d-a0e5ca80d62e', '1988-07-03', 'MALE'::public.sex, 'AB+', 'Flat 1002, Tower A, Borivali', 'Mumbai', 'Borivali', '403449', 'Family Member', '+919577269283', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('b4c6e175-5fce-43e8-96d7-4ad4ae8e3c24', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sunita.pawar40@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sunita Pawar","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.sunita.pawar40@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('b4c6e175-5fce-43e8-96d7-4ad4ae8e3c24', 'Sunita Pawar', 'patient.sunita.pawar40@betterclinic.app', '+918725795511', 'PATIENT', true)
on conflict (id) do update set full_name = 'Sunita Pawar', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('b4c6e175-5fce-43e8-96d7-4ad4ae8e3c24', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('b4c6e175-5fce-43e8-96d7-4ad4ae8e3c24', '1973-01-18', 'FEMALE'::public.sex, 'O+', 'Flat 691, Tower B, Nerul', 'Navi Mumbai', 'Nerul', '406015', 'Family Member', '+919668338973', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('b4c6e175-5fce-43e8-96d7-4ad4ae8e3c24', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('86de1769-dee3-4c65-b1e6-58e94a0b3ba3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.gayatri.kulkarni41@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Gayatri Kulkarni","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.gayatri.kulkarni41@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('86de1769-dee3-4c65-b1e6-58e94a0b3ba3', 'Gayatri Kulkarni', 'patient.gayatri.kulkarni41@betterclinic.app', '+919946660011', 'PATIENT', true)
on conflict (id) do update set full_name = 'Gayatri Kulkarni', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('86de1769-dee3-4c65-b1e6-58e94a0b3ba3', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('86de1769-dee3-4c65-b1e6-58e94a0b3ba3', '1998-12-18', 'FEMALE'::public.sex, 'O-', 'Flat 1033, Tower C, Vashi', 'Navi Mumbai', 'Vashi', '403121', 'Family Member', '+918751649412', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('1ef65248-1b0e-4588-96ce-e35dd631dd8d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.gayatri.rao42@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Gayatri Rao","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.gayatri.rao42@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('1ef65248-1b0e-4588-96ce-e35dd631dd8d', 'Gayatri Rao', 'patient.gayatri.rao42@betterclinic.app', '+919165567385', 'PATIENT', true)
on conflict (id) do update set full_name = 'Gayatri Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('1ef65248-1b0e-4588-96ce-e35dd631dd8d', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('1ef65248-1b0e-4588-96ce-e35dd631dd8d', '1972-07-12', 'FEMALE'::public.sex, 'AB+', 'Flat 194, Tower A, Bandra', 'Mumbai', 'Bandra', '403709', 'Family Member', '+919935429467', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('1ef65248-1b0e-4588-96ce-e35dd631dd8d', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('06f59a52-e7d3-412b-a1e9-97f37cf9f3cc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pallavi.sharma43@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pallavi Sharma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.pallavi.sharma43@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('06f59a52-e7d3-412b-a1e9-97f37cf9f3cc', 'Pallavi Sharma', 'patient.pallavi.sharma43@betterclinic.app', '+918698166778', 'PATIENT', true)
on conflict (id) do update set full_name = 'Pallavi Sharma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('06f59a52-e7d3-412b-a1e9-97f37cf9f3cc', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('06f59a52-e7d3-412b-a1e9-97f37cf9f3cc', '2001-05-31', 'FEMALE'::public.sex, 'B+', 'Flat 685, Tower A, Belapur', 'Navi Mumbai', 'Belapur', '404664', 'Family Member', '+919167021501', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('06f59a52-e7d3-412b-a1e9-97f37cf9f3cc', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('7df5ea65-ea6f-4759-822c-937c46e909f5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.karan.patel44@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Karan Patel","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.karan.patel44@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('7df5ea65-ea6f-4759-822c-937c46e909f5', 'Karan Patel', 'patient.karan.patel44@betterclinic.app', '+918610796611', 'PATIENT', true)
on conflict (id) do update set full_name = 'Karan Patel', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('7df5ea65-ea6f-4759-822c-937c46e909f5', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('7df5ea65-ea6f-4759-822c-937c46e909f5', '1997-03-16', 'MALE'::public.sex, 'B+', 'Flat 598, Tower A, Ghodbunder Road', 'Thane', 'Ghodbunder Road', '410277', 'Family Member', '+917744427677', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('ae7b3208-2966-4e75-970c-03d2c70c6a90', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.yash.nair45@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Yash Nair","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.yash.nair45@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('ae7b3208-2966-4e75-970c-03d2c70c6a90', 'Yash Nair', 'patient.yash.nair45@betterclinic.app', '+918820049405', 'PATIENT', true)
on conflict (id) do update set full_name = 'Yash Nair', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('ae7b3208-2966-4e75-970c-03d2c70c6a90', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('ae7b3208-2966-4e75-970c-03d2c70c6a90', '1995-04-07', 'MALE'::public.sex, 'A-', 'Flat 119, Tower B, Baner', 'Pune', 'Baner', '406111', 'Family Member', '+917545445037', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a0d76162-fd6c-444f-b50a-2c426052a526', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rhea.shah46@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rhea Shah","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.rhea.shah46@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a0d76162-fd6c-444f-b50a-2c426052a526', 'Rhea Shah', 'patient.rhea.shah46@betterclinic.app', '+919570588547', 'PATIENT', true)
on conflict (id) do update set full_name = 'Rhea Shah', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a0d76162-fd6c-444f-b50a-2c426052a526', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('a0d76162-fd6c-444f-b50a-2c426052a526', '1995-01-13', 'FEMALE'::public.sex, 'AB+', 'Flat 742, Tower B, Powai', 'Mumbai', 'Powai', '405854', 'Family Member', '+918643685808', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('86ac023b-5aa9-434a-b7f6-dd7489194e20', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sameer.pawar47@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sameer Pawar","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.sameer.pawar47@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('86ac023b-5aa9-434a-b7f6-dd7489194e20', 'Sameer Pawar', 'patient.sameer.pawar47@betterclinic.app', '+919536060772', 'PATIENT', true)
on conflict (id) do update set full_name = 'Sameer Pawar', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('86ac023b-5aa9-434a-b7f6-dd7489194e20', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('86ac023b-5aa9-434a-b7f6-dd7489194e20', '2009-01-10', 'MALE'::public.sex, 'O-', 'Flat 258, Tower B, Aundh', 'Pune', 'Aundh', '405261', 'Family Member', '+919313731421', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('5e2c6b50-fc23-410d-ac8b-f575b9166ee8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.amit.rao48@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Amit Rao","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.amit.rao48@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('5e2c6b50-fc23-410d-ac8b-f575b9166ee8', 'Amit Rao', 'patient.amit.rao48@betterclinic.app', '+919310448087', 'PATIENT', true)
on conflict (id) do update set full_name = 'Amit Rao', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('5e2c6b50-fc23-410d-ac8b-f575b9166ee8', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('5e2c6b50-fc23-410d-ac8b-f575b9166ee8', '1981-08-18', 'MALE'::public.sex, 'B-', 'Flat 151, Tower A, Viman Nagar', 'Pune', 'Viman Nagar', '400459', 'Family Member', '+918487146118', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('5e2c6b50-fc23-410d-ac8b-f575b9166ee8', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('35e245bd-9f38-4636-aa73-ec98a7114c51', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.tanvi.more49@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Tanvi More","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.tanvi.more49@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('35e245bd-9f38-4636-aa73-ec98a7114c51', 'Tanvi More', 'patient.tanvi.more49@betterclinic.app', '+919769702906', 'PATIENT', true)
on conflict (id) do update set full_name = 'Tanvi More', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('35e245bd-9f38-4636-aa73-ec98a7114c51', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('35e245bd-9f38-4636-aa73-ec98a7114c51', '1979-12-23', 'FEMALE'::public.sex, 'O-', 'Flat 313, Tower C, Ghodbunder Road', 'Thane', 'Ghodbunder Road', '409671', 'Family Member', '+918417919354', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('e8cd28ee-ab3b-4f60-bf93-3fada85ddc26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.swati.gupta50@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Swati Gupta","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.swati.gupta50@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('e8cd28ee-ab3b-4f60-bf93-3fada85ddc26', 'Swati Gupta', 'patient.swati.gupta50@betterclinic.app', '+918476010131', 'PATIENT', true)
on conflict (id) do update set full_name = 'Swati Gupta', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('e8cd28ee-ab3b-4f60-bf93-3fada85ddc26', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('e8cd28ee-ab3b-4f60-bf93-3fada85ddc26', '1980-01-10', 'FEMALE'::public.sex, 'B+', 'Flat 468, Tower B, Kharghar', 'Navi Mumbai', 'Kharghar', '407036', 'Family Member', '+919926905516', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('e8cd28ee-ab3b-4f60-bf93-3fada85ddc26', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('28995026-12fc-4f27-a711-bfacc59244b7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.amit.pawar51@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Amit Pawar","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.amit.pawar51@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('28995026-12fc-4f27-a711-bfacc59244b7', 'Amit Pawar', 'patient.amit.pawar51@betterclinic.app', '+918729519945', 'PATIENT', true)
on conflict (id) do update set full_name = 'Amit Pawar', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('28995026-12fc-4f27-a711-bfacc59244b7', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('28995026-12fc-4f27-a711-bfacc59244b7', '1988-01-19', 'MALE'::public.sex, 'A-', 'Flat 344, Tower A, Majiwada', 'Thane', 'Majiwada', '400377', 'Family Member', '+918884531372', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('28995026-12fc-4f27-a711-bfacc59244b7', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('27915388-f9bc-4f38-b52a-4be5f7f0d458', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.shreya.sharma52@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Shreya Sharma","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.shreya.sharma52@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('27915388-f9bc-4f38-b52a-4be5f7f0d458', 'Shreya Sharma', 'patient.shreya.sharma52@betterclinic.app', '+918854895050', 'PATIENT', true)
on conflict (id) do update set full_name = 'Shreya Sharma', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('27915388-f9bc-4f38-b52a-4be5f7f0d458', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('27915388-f9bc-4f38-b52a-4be5f7f0d458', '2002-09-22', 'FEMALE'::public.sex, 'AB-', 'Flat 861, Tower B, Vashi', 'Navi Mumbai', 'Vashi', '401382', 'Family Member', '+919625938397', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('bd9be713-be87-4756-9e6d-671ec8ee6ae4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.meera.kapoor53@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Meera Kapoor","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.meera.kapoor53@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('bd9be713-be87-4756-9e6d-671ec8ee6ae4', 'Meera Kapoor', 'patient.meera.kapoor53@betterclinic.app', '+919732516113', 'PATIENT', true)
on conflict (id) do update set full_name = 'Meera Kapoor', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('bd9be713-be87-4756-9e6d-671ec8ee6ae4', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('bd9be713-be87-4756-9e6d-671ec8ee6ae4', '2011-12-30', 'FEMALE'::public.sex, 'AB+', 'Flat 1126, Tower B, Viman Nagar', 'Pune', 'Viman Nagar', '404041', 'Family Member', '+918870485335', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('f29e82a0-b265-46e6-a0fb-3b9a603f52f8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sneha.gaikwad54@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sneha Gaikwad","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.sneha.gaikwad54@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('f29e82a0-b265-46e6-a0fb-3b9a603f52f8', 'Sneha Gaikwad', 'patient.sneha.gaikwad54@betterclinic.app', '+919676689161', 'PATIENT', true)
on conflict (id) do update set full_name = 'Sneha Gaikwad', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('f29e82a0-b265-46e6-a0fb-3b9a603f52f8', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('f29e82a0-b265-46e6-a0fb-3b9a603f52f8', '1971-12-11', 'FEMALE'::public.sex, 'O+', 'Flat 693, Tower C, Kharghar', 'Navi Mumbai', 'Kharghar', '401544', 'Family Member', '+919837045832', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('a5a663d4-3217-46c0-a316-d8383c0ee95f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.neha.joshi55@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Neha Joshi","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.neha.joshi55@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('a5a663d4-3217-46c0-a316-d8383c0ee95f', 'Neha Joshi', 'patient.neha.joshi55@betterclinic.app', '+919725698685', 'PATIENT', true)
on conflict (id) do update set full_name = 'Neha Joshi', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('a5a663d4-3217-46c0-a316-d8383c0ee95f', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('a5a663d4-3217-46c0-a316-d8383c0ee95f', '1987-10-07', 'FEMALE'::public.sex, 'A+', 'Flat 223, Tower C, Juhu', 'Mumbai', 'Juhu', '408334', 'Family Member', '+919690185006', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('ba3e0636-8411-4aaa-b6e9-11c90507f23c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.deepa.malhotra56@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Deepa Malhotra","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.deepa.malhotra56@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('ba3e0636-8411-4aaa-b6e9-11c90507f23c', 'Deepa Malhotra', 'patient.deepa.malhotra56@betterclinic.app', '+919191050190', 'PATIENT', true)
on conflict (id) do update set full_name = 'Deepa Malhotra', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('ba3e0636-8411-4aaa-b6e9-11c90507f23c', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('ba3e0636-8411-4aaa-b6e9-11c90507f23c', '1994-02-25', 'FEMALE'::public.sex, 'O-', 'Flat 597, Tower C, Vartak Nagar', 'Thane', 'Vartak Nagar', '401495', 'Family Member', '+919110007412', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('ba3e0636-8411-4aaa-b6e9-11c90507f23c', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('0a49df4d-0720-4637-8b30-a342a219f307', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.nikhil.gaikwad57@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Nikhil Gaikwad","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.nikhil.gaikwad57@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('0a49df4d-0720-4637-8b30-a342a219f307', 'Nikhil Gaikwad', 'patient.nikhil.gaikwad57@betterclinic.app', '+917765745955', 'PATIENT', true)
on conflict (id) do update set full_name = 'Nikhil Gaikwad', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('0a49df4d-0720-4637-8b30-a342a219f307', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('0a49df4d-0720-4637-8b30-a342a219f307', '1961-03-01', 'MALE'::public.sex, 'A-', 'Flat 827, Tower A, Baner', 'Pune', 'Baner', '407832', 'Family Member', '+919733636188', true)
on conflict (id) do nothing;
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('101f141d-7144-4f59-991b-8868c5e83cc9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.meera.iyer58@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Meera Iyer","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.meera.iyer58@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('101f141d-7144-4f59-991b-8868c5e83cc9', 'Meera Iyer', 'patient.meera.iyer58@betterclinic.app', '+919893937742', 'PATIENT', true)
on conflict (id) do update set full_name = 'Meera Iyer', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('101f141d-7144-4f59-991b-8868c5e83cc9', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('101f141d-7144-4f59-991b-8868c5e83cc9', '2000-11-06', 'FEMALE'::public.sex, 'B-', 'Flat 860, Tower A, Borivali', 'Mumbai', 'Borivali', '402196', 'Family Member', '+918486929669', true)
on conflict (id) do nothing;
insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic)
values ('101f141d-7144-4f59-991b-8868c5e83cc9', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
values ('f8a153d4-cf67-4c00-bfef-ca7c35a3acdb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.nikhil.malhotra59@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Nikhil Malhotra","role":"PATIENT"}'::jsonb)
on conflict (id) do update set email = 'patient.nikhil.malhotra59@betterclinic.app';
insert into public.profiles (id, full_name, email, phone, role, is_synthetic)
values ('f8a153d4-cf67-4c00-bfef-ca7c35a3acdb', 'Nikhil Malhotra', 'patient.nikhil.malhotra59@betterclinic.app', '+919786800208', 'PATIENT', true)
on conflict (id) do update set full_name = 'Nikhil Malhotra', is_synthetic = true;
insert into public.profile_roles (profile_id, role, is_synthetic)
values ('f8a153d4-cf67-4c00-bfef-ca7c35a3acdb', 'PATIENT', true)
on conflict (profile_id, role) do nothing;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('f8a153d4-cf67-4c00-bfef-ca7c35a3acdb', '1970-10-05', 'MALE'::public.sex, 'O+', 'Flat 243, Tower A, Naupada', 'Thane', 'Naupada', '403656', 'Family Member', '+919649053974', true)
on conflict (id) do nothing;
