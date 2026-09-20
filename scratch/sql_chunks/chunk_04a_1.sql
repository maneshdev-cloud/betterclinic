
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
    