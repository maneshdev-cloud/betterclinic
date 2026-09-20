
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '47114570-6168-4d2f-9d20-712e7abcb1c5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.priya.nair@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Priya Nair","email":"dr.priya.nair@betterclinic.app","role":"DOCTOR","phone":"+919876942110","qualification":"MBBS, DNB (Internal Medicine)","registration_number":"MMC-2012-80510","experience_years":"7","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"3f062123-b03e-41c6-b5bf-84baa4fbae2f","clinic_id":"9defe45b-25a6-4d52-adc3-8082c8a8f56f"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.priya.nair@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Priya Nair","email":"dr.priya.nair@betterclinic.app","role":"DOCTOR","phone":"+919876942110","qualification":"MBBS, DNB (Internal Medicine)","registration_number":"MMC-2012-80510","experience_years":"7","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"3f062123-b03e-41c6-b5bf-84baa4fbae2f","clinic_id":"9defe45b-25a6-4d52-adc3-8082c8a8f56f"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.57,
      review_count = 57,
      is_accepting_patients = true
    WHERE id = '47114570-6168-4d2f-9d20-712e7abcb1c5';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '3f062123-b03e-41c6-b5bf-84baa4fbae2f')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '21110055-1611-482d-b539-5b2ad11e0da6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rohan.rao@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rohan Rao","email":"dr.rohan.rao@betterclinic.app","role":"DOCTOR","phone":"+919354993217","qualification":"MBBS, MD, DM (Cardiology)","registration_number":"MMC-2020-69733","experience_years":"28","consultation_fee":"600","about":"Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"d901feca-d88c-4dcc-9ff9-8716c0265f7f","clinic_id":"274970a3-9522-4dbe-9d41-cc2e32b184ca"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.rohan.rao@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Rohan Rao","email":"dr.rohan.rao@betterclinic.app","role":"DOCTOR","phone":"+919354993217","qualification":"MBBS, MD, DM (Cardiology)","registration_number":"MMC-2020-69733","experience_years":"28","consultation_fee":"600","about":"Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"d901feca-d88c-4dcc-9ff9-8716c0265f7f","clinic_id":"274970a3-9522-4dbe-9d41-cc2e32b184ca"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.5,
      review_count = 91,
      is_accepting_patients = true
    WHERE id = '21110055-1611-482d-b539-5b2ad11e0da6';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', 'd901feca-d88c-4dcc-9ff9-8716c0265f7f')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '351cc204-b20f-408a-9ff9-f1f0e49a8956', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.tanvi.reddy@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Tanvi Reddy","email":"dr.tanvi.reddy@betterclinic.app","role":"DOCTOR","phone":"+918896604911","qualification":"MBBS, MD (Dermatology, Venereology & Leprosy)","registration_number":"MMC-2009-36251","experience_years":"25","consultation_fee":"400","about":"Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"9b15f7ae-e83f-4140-a095-3b0befb5de41","clinic_id":"88e85be0-2235-4bf6-a389-0ae62ceabb8d"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.tanvi.reddy@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Tanvi Reddy","email":"dr.tanvi.reddy@betterclinic.app","role":"DOCTOR","phone":"+918896604911","qualification":"MBBS, MD (Dermatology, Venereology & Leprosy)","registration_number":"MMC-2009-36251","experience_years":"25","consultation_fee":"400","about":"Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"9b15f7ae-e83f-4140-a095-3b0befb5de41","clinic_id":"88e85be0-2235-4bf6-a389-0ae62ceabb8d"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.43,
      review_count = 10,
      is_accepting_patients = true
    WHERE id = '351cc204-b20f-408a-9ff9-f1f0e49a8956';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '9b15f7ae-e83f-4140-a095-3b0befb5de41')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.shreya.deshmukh@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Shreya Deshmukh","email":"dr.shreya.deshmukh@betterclinic.app","role":"DOCTOR","phone":"+917579068040","qualification":"MBBS, MD (Pediatrics)","registration_number":"MMC-2013-24512","experience_years":"18","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"751c5e4a-83a1-432c-98c7-be4a2526ab23","clinic_id":"b9c5ff36-4ef4-441e-b442-775663d8652a"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.shreya.deshmukh@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Shreya Deshmukh","email":"dr.shreya.deshmukh@betterclinic.app","role":"DOCTOR","phone":"+917579068040","qualification":"MBBS, MD (Pediatrics)","registration_number":"MMC-2013-24512","experience_years":"18","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"751c5e4a-83a1-432c-98c7-be4a2526ab23","clinic_id":"b9c5ff36-4ef4-441e-b442-775663d8652a"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.7,
      review_count = 66,
      is_accepting_patients = true
    WHERE id = '78cbec1d-28e6-4079-8eaa-0c2e6b40b359';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', '751c5e4a-83a1-432c-98c7-be4a2526ab23')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '071feecb-1470-47cd-b078-a9db91d7a69d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.swati.kulkarni@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Swati Kulkarni","email":"dr.swati.kulkarni@betterclinic.app","role":"DOCTOR","phone":"+919188543118","qualification":"MBBS, DNB (Ortho)","registration_number":"MMC-2009-70467","experience_years":"23","consultation_fee":"700","about":"Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"333c7946-d872-4130-8e3c-dbb8824ae653","clinic_id":"b75a94a9-eb46-4308-a3ee-2276bf0ae432"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.swati.kulkarni@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Swati Kulkarni","email":"dr.swati.kulkarni@betterclinic.app","role":"DOCTOR","phone":"+919188543118","qualification":"MBBS, DNB (Ortho)","registration_number":"MMC-2009-70467","experience_years":"23","consultation_fee":"700","about":"Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"333c7946-d872-4130-8e3c-dbb8824ae653","clinic_id":"b75a94a9-eb46-4308-a3ee-2276bf0ae432"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.53,
      review_count = 27,
      is_accepting_patients = true
    WHERE id = '071feecb-1470-47cd-b078-a9db91d7a69d';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', '333c7946-d872-4130-8e3c-dbb8824ae653')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '28bc6247-1601-44aa-8acf-065cfbb14d2e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.aarti.rao@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Aarti Rao","email":"dr.aarti.rao@betterclinic.app","role":"DOCTOR","phone":"+919946365868","qualification":"MBBS, MS (OBGYN)","registration_number":"MMC-2016-25848","experience_years":"13","consultation_fee":"800","about":"Compassionate healthcare provider specializing in gynecology obstetrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"1f1b95cd-8630-4054-9161-1568c7edde9a","clinic_id":"e36436e7-563f-4696-a061-c137ca91a8e0"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.aarti.rao@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Aarti Rao","email":"dr.aarti.rao@betterclinic.app","role":"DOCTOR","phone":"+919946365868","qualification":"MBBS, MS (OBGYN)","registration_number":"MMC-2016-25848","experience_years":"13","consultation_fee":"800","about":"Compassionate healthcare provider specializing in gynecology obstetrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"1f1b95cd-8630-4054-9161-1568c7edde9a","clinic_id":"e36436e7-563f-4696-a061-c137ca91a8e0"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.47,
      review_count = 78,
      is_accepting_patients = true
    WHERE id = '28bc6247-1601-44aa-8acf-065cfbb14d2e';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', '1f1b95cd-8630-4054-9161-1568c7edde9a')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'c752c13a-eae5-440b-bd29-2827b8ef812a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.abhishek.nair@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Abhishek Nair","email":"dr.abhishek.nair@betterclinic.app","role":"DOCTOR","phone":"+919190596906","qualification":"MBBS, MS (ENT)","registration_number":"MMC-2017-72302","experience_years":"25","consultation_fee":"600","about":"Compassionate healthcare provider specializing in ent otolaryngology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"87012fa8-f937-4373-9bf2-ce7a255c5ad6","clinic_id":"ec931301-ad5c-4e14-9c3e-ea0332475701"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.abhishek.nair@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Abhishek Nair","email":"dr.abhishek.nair@betterclinic.app","role":"DOCTOR","phone":"+919190596906","qualification":"MBBS, MS (ENT)","registration_number":"MMC-2017-72302","experience_years":"25","consultation_fee":"600","about":"Compassionate healthcare provider specializing in ent otolaryngology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"87012fa8-f937-4373-9bf2-ce7a255c5ad6","clinic_id":"ec931301-ad5c-4e14-9c3e-ea0332475701"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.81,
      review_count = 41,
      is_accepting_patients = true
    WHERE id = 'c752c13a-eae5-440b-bd29-2827b8ef812a';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', '87012fa8-f937-4373-9bf2-ce7a255c5ad6')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '4c1553cf-a88e-4b70-9d40-086d8f872ce3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.amit.mehta@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Amit Mehta","email":"dr.amit.mehta@betterclinic.app","role":"DOCTOR","phone":"+917718284311","qualification":"MBBS, DOMS","registration_number":"MMC-2002-62093","experience_years":"7","consultation_fee":"800","about":"Compassionate healthcare provider specializing in ophthalmology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"6763ec01-e18f-4737-ba0e-a49cbb29a8e2","clinic_id":"a312e21a-1f7c-46df-a593-15baf99a85d8"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.amit.mehta@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Amit Mehta","email":"dr.amit.mehta@betterclinic.app","role":"DOCTOR","phone":"+917718284311","qualification":"MBBS, DOMS","registration_number":"MMC-2002-62093","experience_years":"7","consultation_fee":"800","about":"Compassionate healthcare provider specializing in ophthalmology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"6763ec01-e18f-4737-ba0e-a49cbb29a8e2","clinic_id":"a312e21a-1f7c-46df-a593-15baf99a85d8"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.66,
      review_count = 62,
      is_accepting_patients = true
    WHERE id = '4c1553cf-a88e-4b70-9d40-086d8f872ce3';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', '6763ec01-e18f-4737-ba0e-a49cbb29a8e2')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4c1553cf-a88e-4b70-9d40-086d8f872ce3', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.shreya.rao@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Shreya Rao","email":"dr.shreya.rao@betterclinic.app","role":"DOCTOR","phone":"+919976407842","qualification":"MBBS, MD, DM (Neurology)","registration_number":"MMC-2016-74603","experience_years":"11","consultation_fee":"500","about":"Compassionate healthcare provider specializing in neurology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"f41d4e14-64b1-46b5-96c1-44c208e81d32","clinic_id":"163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.shreya.rao@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Shreya Rao","email":"dr.shreya.rao@betterclinic.app","role":"DOCTOR","phone":"+919976407842","qualification":"MBBS, MD, DM (Neurology)","registration_number":"MMC-2016-74603","experience_years":"11","consultation_fee":"500","about":"Compassionate healthcare provider specializing in neurology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"f41d4e14-64b1-46b5-96c1-44c208e81d32","clinic_id":"163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.86,
      review_count = 43,
      is_accepting_patients = true
    WHERE id = 'b6d2a157-4f8d-4025-b67e-55a87a48a6e8';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', 'f41d4e14-64b1-46b5-96c1-44c208e81d32')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b6d2a157-4f8d-4025-b67e-55a87a48a6e8', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '8106722d-1f9c-48d6-9e26-591de86fc5f8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.nikhil.joshi@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Nikhil Joshi","email":"dr.nikhil.joshi@betterclinic.app","role":"DOCTOR","phone":"+918711973542","qualification":"MBBS, MD, DM (Gastroenterology)","registration_number":"MMC-2020-10332","experience_years":"9","consultation_fee":"600","about":"Compassionate healthcare provider specializing in gastroenterology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"7130c038-22bc-4b7a-b004-c606b8d2b491","clinic_id":"06165788-d672-4bcc-a5bb-2bb81f8889bf"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.nikhil.joshi@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Nikhil Joshi","email":"dr.nikhil.joshi@betterclinic.app","role":"DOCTOR","phone":"+918711973542","qualification":"MBBS, MD, DM (Gastroenterology)","registration_number":"MMC-2020-10332","experience_years":"9","consultation_fee":"600","about":"Compassionate healthcare provider specializing in gastroenterology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"7130c038-22bc-4b7a-b004-c606b8d2b491","clinic_id":"06165788-d672-4bcc-a5bb-2bb81f8889bf"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.71,
      review_count = 80,
      is_accepting_patients = true
    WHERE id = '8106722d-1f9c-48d6-9e26-591de86fc5f8';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '7130c038-22bc-4b7a-b004-c606b8d2b491')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8106722d-1f9c-48d6-9e26-591de86fc5f8', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.ananya.nair@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Ananya Nair","email":"dr.ananya.nair@betterclinic.app","role":"DOCTOR","phone":"+918664227480","qualification":"MBBS, DNB (Internal Medicine)","registration_number":"MMC-2018-26639","experience_years":"12","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"3f062123-b03e-41c6-b5bf-84baa4fbae2f","clinic_id":"d9b6df45-8fb6-4147-adef-b2f7f354e8e8"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.ananya.nair@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Ananya Nair","email":"dr.ananya.nair@betterclinic.app","role":"DOCTOR","phone":"+918664227480","qualification":"MBBS, DNB (Internal Medicine)","registration_number":"MMC-2018-26639","experience_years":"12","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"3f062123-b03e-41c6-b5bf-84baa4fbae2f","clinic_id":"d9b6df45-8fb6-4147-adef-b2f7f354e8e8"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.45,
      review_count = 89,
      is_accepting_patients = true
    WHERE id = 'f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', '3f062123-b03e-41c6-b5bf-84baa4fbae2f')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f5e6d7e4-daf7-42ba-bbcd-93c0c8bd689a', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '59c951c2-4455-4d50-ae23-cd757a96f331', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rhea.kapoor@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rhea Kapoor","email":"dr.rhea.kapoor@betterclinic.app","role":"DOCTOR","phone":"+917544457391","qualification":"MBBS, DNB (Cardiology)","registration_number":"MMC-2007-41917","experience_years":"15","consultation_fee":"700","about":"Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"d901feca-d88c-4dcc-9ff9-8716c0265f7f","clinic_id":"bbb1f407-cf97-4d6c-9e96-1ae68e61d620"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.rhea.kapoor@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Rhea Kapoor","email":"dr.rhea.kapoor@betterclinic.app","role":"DOCTOR","phone":"+917544457391","qualification":"MBBS, DNB (Cardiology)","registration_number":"MMC-2007-41917","experience_years":"15","consultation_fee":"700","about":"Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"d901feca-d88c-4dcc-9ff9-8716c0265f7f","clinic_id":"bbb1f407-cf97-4d6c-9e96-1ae68e61d620"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.56,
      review_count = 52,
      is_accepting_patients = true
    WHERE id = '59c951c2-4455-4d50-ae23-cd757a96f331';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'd901feca-d88c-4dcc-9ff9-8716c0265f7f')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('59c951c2-4455-4d50-ae23-cd757a96f331', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    