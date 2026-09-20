
      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '1f202350-3240-4ec8-aa2d-c5b49afcd3e4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.abhishek.kapoor@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Abhishek Kapoor","email":"dr.abhishek.kapoor@betterclinic.app","role":"DOCTOR","phone":"+918861674830","qualification":"MBBS, MD, DM (Gastroenterology)","registration_number":"MMC-2018-19954","experience_years":"5","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in gastroenterology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"7130c038-22bc-4b7a-b004-c606b8d2b491","clinic_id":"bd5f1196-97fe-4f16-bb6d-d32f3d3503ad"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.abhishek.kapoor@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Abhishek Kapoor","email":"dr.abhishek.kapoor@betterclinic.app","role":"DOCTOR","phone":"+918861674830","qualification":"MBBS, MD, DM (Gastroenterology)","registration_number":"MMC-2018-19954","experience_years":"5","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in gastroenterology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"7130c038-22bc-4b7a-b004-c606b8d2b491","clinic_id":"bd5f1196-97fe-4f16-bb6d-d32f3d3503ad"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.71,
      review_count = 14,
      is_accepting_patients = true
    WHERE id = '1f202350-3240-4ec8-aa2d-c5b49afcd3e4';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', '7130c038-22bc-4b7a-b004-c606b8d2b491')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('1f202350-3240-4ec8-aa2d-c5b49afcd3e4', 'bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '314cab11-3cb3-4121-a8ec-20aed919c811', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.vikram.pillai@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Vikram Pillai","email":"dr.vikram.pillai@betterclinic.app","role":"DOCTOR","phone":"+918856092309","qualification":"MBBS, DNB (Internal Medicine)","registration_number":"MMC-2009-40128","experience_years":"8","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"3f062123-b03e-41c6-b5bf-84baa4fbae2f","clinic_id":"0edfc0fe-7703-4de8-817f-d35bd39e082a"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.vikram.pillai@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Vikram Pillai","email":"dr.vikram.pillai@betterclinic.app","role":"DOCTOR","phone":"+918856092309","qualification":"MBBS, DNB (Internal Medicine)","registration_number":"MMC-2009-40128","experience_years":"8","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"3f062123-b03e-41c6-b5bf-84baa4fbae2f","clinic_id":"0edfc0fe-7703-4de8-817f-d35bd39e082a"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.33,
      review_count = 58,
      is_accepting_patients = true
    WHERE id = '314cab11-3cb3-4121-a8ec-20aed919c811';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '3f062123-b03e-41c6-b5bf-84baa4fbae2f')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('314cab11-3cb3-4121-a8ec-20aed919c811', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.pranav.deshmukh@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Pranav Deshmukh","email":"dr.pranav.deshmukh@betterclinic.app","role":"DOCTOR","phone":"+919516293792","qualification":"MBBS, MD, DM (Cardiology)","registration_number":"MMC-2010-43395","experience_years":"9","consultation_fee":"800","about":"Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"d901feca-d88c-4dcc-9ff9-8716c0265f7f","clinic_id":"80798686-5ecd-47e3-8dfa-334fac68fbe8"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.pranav.deshmukh@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Pranav Deshmukh","email":"dr.pranav.deshmukh@betterclinic.app","role":"DOCTOR","phone":"+919516293792","qualification":"MBBS, MD, DM (Cardiology)","registration_number":"MMC-2010-43395","experience_years":"9","consultation_fee":"800","about":"Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"d901feca-d88c-4dcc-9ff9-8716c0265f7f","clinic_id":"80798686-5ecd-47e3-8dfa-334fac68fbe8"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.74,
      review_count = 22,
      is_accepting_patients = true
    WHERE id = '584b64a1-75f3-4fb7-adee-ffdf6af5ff12';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', 'd901feca-d88c-4dcc-9ff9-8716c0265f7f')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('584b64a1-75f3-4fb7-adee-ffdf6af5ff12', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '5d93b70e-5e26-4187-b553-3e1f54479168', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.pooja.kapoor@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Pooja Kapoor","email":"dr.pooja.kapoor@betterclinic.app","role":"DOCTOR","phone":"+917764788748","qualification":"MBBS, MD (Dermatology, Venereology & Leprosy)","registration_number":"MMC-2006-24420","experience_years":"26","consultation_fee":"500","about":"Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"9b15f7ae-e83f-4140-a095-3b0befb5de41","clinic_id":"52cf3065-6234-4b0d-ba6b-cf33ea26639b"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.pooja.kapoor@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Pooja Kapoor","email":"dr.pooja.kapoor@betterclinic.app","role":"DOCTOR","phone":"+917764788748","qualification":"MBBS, MD (Dermatology, Venereology & Leprosy)","registration_number":"MMC-2006-24420","experience_years":"26","consultation_fee":"500","about":"Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"9b15f7ae-e83f-4140-a095-3b0befb5de41","clinic_id":"52cf3065-6234-4b0d-ba6b-cf33ea26639b"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.8,
      review_count = 84,
      is_accepting_patients = true
    WHERE id = '5d93b70e-5e26-4187-b553-3e1f54479168';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '9b15f7ae-e83f-4140-a095-3b0befb5de41')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5d93b70e-5e26-4187-b553-3e1f54479168', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rohan.verma@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rohan Verma","email":"dr.rohan.verma@betterclinic.app","role":"DOCTOR","phone":"+919348728407","qualification":"MBBS, MD (Pediatrics)","registration_number":"MMC-2007-86093","experience_years":"17","consultation_fee":"600","about":"Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"751c5e4a-83a1-432c-98c7-be4a2526ab23","clinic_id":"a04ba937-d27c-47e1-aab1-b2140fa4bf4c"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.rohan.verma@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Rohan Verma","email":"dr.rohan.verma@betterclinic.app","role":"DOCTOR","phone":"+919348728407","qualification":"MBBS, MD (Pediatrics)","registration_number":"MMC-2007-86093","experience_years":"17","consultation_fee":"600","about":"Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"751c5e4a-83a1-432c-98c7-be4a2526ab23","clinic_id":"a04ba937-d27c-47e1-aab1-b2140fa4bf4c"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.41,
      review_count = 68,
      is_accepting_patients = true
    WHERE id = 'e0518e86-99b6-4f52-bfff-ea0ea1a63c3f';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', '751c5e4a-83a1-432c-98c7-be4a2526ab23')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e0518e86-99b6-4f52-bfff-ea0ea1a63c3f', 'a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '0834d2dd-2529-4f67-adf5-9042639afb49', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.priya.shah@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Priya Shah","email":"dr.priya.shah@betterclinic.app","role":"DOCTOR","phone":"+919573506222","qualification":"MBBS, MS (Orthopedics)","registration_number":"MMC-2003-52435","experience_years":"9","consultation_fee":"600","about":"Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"333c7946-d872-4130-8e3c-dbb8824ae653","clinic_id":"9c795e23-a828-476e-8c4b-9d855cd3e8bf"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.priya.shah@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Priya Shah","email":"dr.priya.shah@betterclinic.app","role":"DOCTOR","phone":"+919573506222","qualification":"MBBS, MS (Orthopedics)","registration_number":"MMC-2003-52435","experience_years":"9","consultation_fee":"600","about":"Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"333c7946-d872-4130-8e3c-dbb8824ae653","clinic_id":"9c795e23-a828-476e-8c4b-9d855cd3e8bf"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.78,
      review_count = 83,
      is_accepting_patients = true
    WHERE id = '0834d2dd-2529-4f67-adf5-9042639afb49';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '333c7946-d872-4130-8e3c-dbb8824ae653')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0834d2dd-2529-4f67-adf5-9042639afb49', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    