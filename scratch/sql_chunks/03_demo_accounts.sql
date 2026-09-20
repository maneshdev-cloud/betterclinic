
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'doctor.demo@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Aarav Deshmukh","email":"doctor.demo@betterclinic.app","role":"DOCTOR","phone":"+919820011222"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'doctor.demo@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('00000000-0000-0000-0000-000000000002', 'Dr. Aarav Deshmukh', 'doctor.demo@betterclinic.app', '+919820011222', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Aarav Deshmukh', role = 'DOCTOR'::public.user_role;
  

  INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
  VALUES ('00000000-0000-0000-0000-000000000002', 'MBBS, MD (General Medicine)', 'MCI-2012-78901', 14, 600, 'Senior Consultant Physician with extensive experience in chronic disease management, diabetes, hypertension, and holistic preventive care.', ARRAY['English','Hindi','Marathi'], 4.9, 84, true)
  ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

  INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
  SELECT '00000000-0000-0000-0000-000000000002', id FROM public.specializations WHERE slug = 'general-medicine'
  ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

  INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
  VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', true)
  ON CONFLICT (doctor_id, clinic_id) DO NOTHING;


    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'receptionist.demo@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"RECEPTIONIST"}'::jsonb,
      '{"full_name":"Sunita Patil","email":"receptionist.demo@betterclinic.app","role":"RECEPTIONIST","phone":"+919820033444"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'receptionist.demo@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"RECEPTIONIST"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('00000000-0000-0000-0000-000000000003', 'Sunita Patil', 'receptionist.demo@betterclinic.app', '+919820033444', 'RECEPTIONIST'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Sunita Patil', role = 'RECEPTIONIST'::public.user_role;
  

  INSERT INTO public.clinic_staff (user_id, clinic_id, role, is_active)
  VALUES ('00000000-0000-0000-0000-000000000003', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'RECEPTIONIST', true)
  ON CONFLICT (user_id, clinic_id) DO NOTHING;


    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'admin.demo@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"CLINIC_ADMIN"}'::jsonb,
      '{"full_name":"Rajesh Joshi","email":"admin.demo@betterclinic.app","role":"CLINIC_ADMIN","phone":"+919820055666"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'admin.demo@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"CLINIC_ADMIN"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('00000000-0000-0000-0000-000000000004', 'Rajesh Joshi', 'admin.demo@betterclinic.app', '+919820055666', 'CLINIC_ADMIN'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Rajesh Joshi', role = 'CLINIC_ADMIN'::public.user_role;
  

  INSERT INTO public.clinic_staff (user_id, clinic_id, role, is_active)
  VALUES ('00000000-0000-0000-0000-000000000004', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'CLINIC_ADMIN', true)
  ON CONFLICT (user_id, clinic_id) DO NOTHING;


    INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
    VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 1, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true)
    ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
  

    INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
    VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 2, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true)
    ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
  

    INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
    VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 3, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true)
    ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
  

    INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
    VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 4, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true)
    ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
  

    INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
    VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 5, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true)
    ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
  

    INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
    VALUES ('00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 6, '09:00:00', '17:00:00', '13:00:00', '14:00:00', 15, true)
    ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
  