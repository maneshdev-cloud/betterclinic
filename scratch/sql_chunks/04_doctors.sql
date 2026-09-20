
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '69925e3a-71ce-4949-bc9f-87a48ed5b385', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rahul.pillai@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rahul Pillai","email":"dr.rahul.pillai@betterclinic.app","role":"DOCTOR","phone":"+919920682168"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.rahul.pillai@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'Dr. Rahul Pillai', 'dr.rahul.pillai@betterclinic.app', '+919920682168', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Rahul Pillai', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'MBBS, DNB (Internal Medicine)', 'MMC-2018-85425', 5, 400, 'Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.48, 92, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '69925e3a-71ce-4949-bc9f-87a48ed5b385', id FROM public.specializations WHERE slug = 'general-medicine'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('69925e3a-71ce-4949-bc9f-87a48ed5b385', 'a923ac40-1961-4256-b903-4cffc4464ad4', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '06924ca6-15e8-4d53-9fce-76cad2473357', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.krishna.gaekwad@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Krishna Gaekwad","email":"dr.krishna.gaekwad@betterclinic.app","role":"DOCTOR","phone":"+918898832330"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.krishna.gaekwad@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', 'Dr. Krishna Gaekwad', 'dr.krishna.gaekwad@betterclinic.app', '+918898832330', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Krishna Gaekwad', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', 'MBBS, DNB (Cardiology)', 'MMC-2003-58449', 5, 600, 'Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.22, 26, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '06924ca6-15e8-4d53-9fce-76cad2473357', id FROM public.specializations WHERE slug = 'cardiology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06924ca6-15e8-4d53-9fce-76cad2473357', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '89bd46ab-866f-4085-acf9-903f35540f2e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.prathamesh.kulkarni@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Prathamesh Kulkarni","email":"dr.prathamesh.kulkarni@betterclinic.app","role":"DOCTOR","phone":"+919945945740"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.prathamesh.kulkarni@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', 'Dr. Prathamesh Kulkarni', 'dr.prathamesh.kulkarni@betterclinic.app', '+919945945740', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Prathamesh Kulkarni', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', 'MBBS, MD (Dermatology, Venereology & Leprosy)', 'MMC-2007-24451', 11, 1000, 'Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.51, 47, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '89bd46ab-866f-4085-acf9-903f35540f2e', id FROM public.specializations WHERE slug = 'dermatology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('89bd46ab-866f-4085-acf9-903f35540f2e', '0edfc0fe-7703-4de8-817f-d35bd39e082a', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.manisha.malhotra@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Manisha Malhotra","email":"dr.manisha.malhotra@betterclinic.app","role":"DOCTOR","phone":"+919625116276"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.manisha.malhotra@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'Dr. Manisha Malhotra', 'dr.manisha.malhotra@betterclinic.app', '+919625116276', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Manisha Malhotra', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'MBBS, DCH', 'MMC-2013-50166', 15, 600, 'Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.9, 32, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', id FROM public.specializations WHERE slug = 'pediatrics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('4e2b98b7-630e-4224-89e5-9a6cdf9a08a8', 'edab5373-01f2-4df1-825e-14099f589ae8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '70048948-b17e-4bc2-bd18-20af12c7ad16', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.kunal.mishra@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Kunal Mishra","email":"dr.kunal.mishra@betterclinic.app","role":"DOCTOR","phone":"+919676473949"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.kunal.mishra@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', 'Dr. Kunal Mishra', 'dr.kunal.mishra@betterclinic.app', '+919676473949', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Kunal Mishra', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', 'MBBS, MS (Orthopedics)', 'MMC-2018-16673', 23, 600, 'Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.77, 76, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '70048948-b17e-4bc2-bd18-20af12c7ad16', id FROM public.specializations WHERE slug = 'orthopedics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70048948-b17e-4bc2-bd18-20af12c7ad16', '177234ab-513d-4eeb-846f-84f768cc3f21', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '8c42b624-28d5-4357-9e7b-eafe78459ccb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.anil.banerjee@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Anil Banerjee","email":"dr.anil.banerjee@betterclinic.app","role":"DOCTOR","phone":"+919766376286"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.anil.banerjee@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', 'Dr. Anil Banerjee', 'dr.anil.banerjee@betterclinic.app', '+919766376286', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Anil Banerjee', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', 'MBBS, DGO', 'MMC-2010-26612', 6, 400, 'Compassionate healthcare provider specializing in gynecology obstetrics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.2, 10, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '8c42b624-28d5-4357-9e7b-eafe78459ccb', id FROM public.specializations WHERE slug = 'gynecology-obstetrics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8c42b624-28d5-4357-9e7b-eafe78459ccb', '06165788-d672-4bcc-a5bb-2bb81f8889bf', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '43ee2c0a-20bc-4dc0-b26e-406fa828a624', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.gaurav.deshpande@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Gaurav Deshpande","email":"dr.gaurav.deshpande@betterclinic.app","role":"DOCTOR","phone":"+918424589970"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.gaurav.deshpande@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', 'Dr. Gaurav Deshpande', 'dr.gaurav.deshpande@betterclinic.app', '+918424589970', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Gaurav Deshpande', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', 'MBBS, MS (ENT)', 'MMC-2003-47993', 10, 400, 'Compassionate healthcare provider specializing in ent otolaryngology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.57, 75, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '43ee2c0a-20bc-4dc0-b26e-406fa828a624', id FROM public.specializations WHERE slug = 'ent-otolaryngology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('43ee2c0a-20bc-4dc0-b26e-406fa828a624', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.arjun.bhosle@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Arjun Bhosle","email":"dr.arjun.bhosle@betterclinic.app","role":"DOCTOR","phone":"+919110839450"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.arjun.bhosle@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', 'Dr. Arjun Bhosle', 'dr.arjun.bhosle@betterclinic.app', '+919110839450', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Arjun Bhosle', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', 'MBBS, DOMS', 'MMC-2006-96115', 10, 500, 'Compassionate healthcare provider specializing in ophthalmology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.33, 44, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', id FROM public.specializations WHERE slug = 'ophthalmology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('3fcae6e0-6ed6-4b8a-b2cf-4f9c48115bbb', '16181d96-9229-48ed-96e4-5673a5118844', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '7a487bbb-8a54-4347-bac0-9cc1860c1df6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.zeel.khanna@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Zeel Khanna","email":"dr.zeel.khanna@betterclinic.app","role":"DOCTOR","phone":"+919873773582"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.zeel.khanna@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'Dr. Zeel Khanna', 'dr.zeel.khanna@betterclinic.app', '+919873773582', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Zeel Khanna', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'MBBS, MD, DM (Neurology)', 'MMC-2003-30442', 24, 600, 'Compassionate healthcare provider specializing in neurology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.51, 91, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '7a487bbb-8a54-4347-bac0-9cc1860c1df6', id FROM public.specializations WHERE slug = 'neurology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('7a487bbb-8a54-4347-bac0-9cc1860c1df6', 'b71cbebd-b233-42ae-9986-0e6666386a26', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.kirti.pillai@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Kirti Pillai","email":"dr.kirti.pillai@betterclinic.app","role":"DOCTOR","phone":"+919792228303"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.kirti.pillai@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', 'Dr. Kirti Pillai', 'dr.kirti.pillai@betterclinic.app', '+919792228303', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Kirti Pillai', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', 'MBBS, MD, DM (Gastroenterology)', 'MMC-2008-77864', 22, 800, 'Compassionate healthcare provider specializing in gastroenterology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.26, 71, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'fce23ccf-fc8d-468a-844e-c7cf3dee21b3', id FROM public.specializations WHERE slug = 'gastroenterology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fce23ccf-fc8d-468a-844e-c7cf3dee21b3', '6bcb5f55-5297-4dcb-9066-58c174d45013', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '06f4db07-3d5a-4a30-a537-a3e46d39f922', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.sonal.chatterjee@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Sonal Chatterjee","email":"dr.sonal.chatterjee@betterclinic.app","role":"DOCTOR","phone":"+918724489338"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.sonal.chatterjee@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'Dr. Sonal Chatterjee', 'dr.sonal.chatterjee@betterclinic.app', '+918724489338', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Sonal Chatterjee', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'MBBS, DNB (Internal Medicine)', 'MMC-2017-32795', 26, 600, 'Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.45, 11, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '06f4db07-3d5a-4a30-a537-a3e46d39f922', id FROM public.specializations WHERE slug = 'general-medicine'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('06f4db07-3d5a-4a30-a537-a3e46d39f922', 'bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '82c29b93-ec49-4939-8b09-903dc9c54a1d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.diya.verma@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Diya Verma","email":"dr.diya.verma@betterclinic.app","role":"DOCTOR","phone":"+919985972575"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.diya.verma@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'Dr. Diya Verma', 'dr.diya.verma@betterclinic.app', '+919985972575', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Diya Verma', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'MBBS, MD, DM (Cardiology)', 'MMC-2015-82340', 25, 400, 'Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.59, 38, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '82c29b93-ec49-4939-8b09-903dc9c54a1d', id FROM public.specializations WHERE slug = 'cardiology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('82c29b93-ec49-4939-8b09-903dc9c54a1d', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '606d4868-195b-4f1f-be60-5f4c67ca870f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rashmi.deshmukh@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rashmi Deshmukh","email":"dr.rashmi.deshmukh@betterclinic.app","role":"DOCTOR","phone":"+918838937802"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.rashmi.deshmukh@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', 'Dr. Rashmi Deshmukh', 'dr.rashmi.deshmukh@betterclinic.app', '+918838937802', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Rashmi Deshmukh', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', 'MBBS, MD (Dermatology, Venereology & Leprosy)', 'MMC-2015-52322', 19, 600, 'Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.75, 88, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '606d4868-195b-4f1f-be60-5f4c67ca870f', id FROM public.specializations WHERE slug = 'dermatology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('606d4868-195b-4f1f-be60-5f4c67ca870f', '163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'fc5e6d75-9720-442d-b149-6d61c806fe9d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.sunil.sinha@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Sunil Sinha","email":"dr.sunil.sinha@betterclinic.app","role":"DOCTOR","phone":"+917532929974"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.sunil.sinha@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'Dr. Sunil Sinha', 'dr.sunil.sinha@betterclinic.app', '+917532929974', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Sunil Sinha', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'MBBS, MD (Pediatrics)', 'MMC-2007-27671', 21, 500, 'Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.28, 18, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'fc5e6d75-9720-442d-b149-6d61c806fe9d', id FROM public.specializations WHERE slug = 'pediatrics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('fc5e6d75-9720-442d-b149-6d61c806fe9d', 'd9b6df45-8fb6-4147-adef-b2f7f354e8e8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.nandish.kadam@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Nandish Kadam","email":"dr.nandish.kadam@betterclinic.app","role":"DOCTOR","phone":"+919877942286"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.nandish.kadam@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', 'Dr. Nandish Kadam', 'dr.nandish.kadam@betterclinic.app', '+919877942286', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Nandish Kadam', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', 'MBBS, MS (Orthopedics)', 'MMC-2014-27086', 25, 700, 'Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.64, 22, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', id FROM public.specializations WHERE slug = 'orthopedics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('eb50b29e-57d2-4f3a-8ea6-2e5b84da241c', '52cf3065-6234-4b0d-ba6b-cf33ea26639b', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'afcf0f1b-8e62-416c-8c3e-dd6946bae562', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.tanmay.hegde@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Tanmay Hegde","email":"dr.tanmay.hegde@betterclinic.app","role":"DOCTOR","phone":"+919353382397"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.tanmay.hegde@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'Dr. Tanmay Hegde', 'dr.tanmay.hegde@betterclinic.app', '+919353382397', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Tanmay Hegde', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'MBBS, MS (OBGYN)', 'MMC-2003-84088', 20, 700, 'Compassionate healthcare provider specializing in gynecology obstetrics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.82, 34, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'afcf0f1b-8e62-416c-8c3e-dd6946bae562', id FROM public.specializations WHERE slug = 'gynecology-obstetrics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('afcf0f1b-8e62-416c-8c3e-dd6946bae562', 'a312e21a-1f7c-46df-a593-15baf99a85d8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '5ccd8187-7f21-4f83-ad57-63e64847047d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.seema.gandhi@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Seema Gandhi","email":"dr.seema.gandhi@betterclinic.app","role":"DOCTOR","phone":"+918711520814"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.seema.gandhi@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'Dr. Seema Gandhi', 'dr.seema.gandhi@betterclinic.app', '+918711520814', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Seema Gandhi', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'MBBS, MS (ENT)', 'MMC-2000-34271', 21, 1000, 'Compassionate healthcare provider specializing in ent otolaryngology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.38, 15, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '5ccd8187-7f21-4f83-ad57-63e64847047d', id FROM public.specializations WHERE slug = 'ent-otolaryngology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('5ccd8187-7f21-4f83-ad57-63e64847047d', 'acf4854e-b4fd-43b1-9c4e-15d2c3003880', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'bbb24217-2d6f-40b9-9565-baa3c7e58e15', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.renu.naik@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Renu Naik","email":"dr.renu.naik@betterclinic.app","role":"DOCTOR","phone":"+919689208289"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.renu.naik@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'Dr. Renu Naik', 'dr.renu.naik@betterclinic.app', '+919689208289', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Renu Naik', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'MBBS, MS (Ophthalmology)', 'MMC-2010-58739', 17, 600, 'Compassionate healthcare provider specializing in ophthalmology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.88, 28, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'bbb24217-2d6f-40b9-9565-baa3c7e58e15', id FROM public.specializations WHERE slug = 'ophthalmology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('bbb24217-2d6f-40b9-9565-baa3c7e58e15', 'b02f15c5-8dff-435c-a749-30f268deec03', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '47635d04-7235-42c0-a322-0c5eb94b5741', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.ashish.kale@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Ashish Kale","email":"dr.ashish.kale@betterclinic.app","role":"DOCTOR","phone":"+917538499959"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.ashish.kale@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', 'Dr. Ashish Kale', 'dr.ashish.kale@betterclinic.app', '+917538499959', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Ashish Kale', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', 'MBBS, MD, DM (Neurology)', 'MMC-2001-45619', 26, 700, 'Compassionate healthcare provider specializing in neurology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.31, 77, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '47635d04-7235-42c0-a322-0c5eb94b5741', id FROM public.specializations WHERE slug = 'neurology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('47635d04-7235-42c0-a322-0c5eb94b5741', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '51850c4d-4544-447f-a211-69d201e822b9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.vishal.dange@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Vishal Dange","email":"dr.vishal.dange@betterclinic.app","role":"DOCTOR","phone":"+919862156587"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.vishal.dange@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'Dr. Vishal Dange', 'dr.vishal.dange@betterclinic.app', '+919862156587', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Vishal Dange', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'MBBS, MD, DM (Gastroenterology)', 'MMC-2013-84539', 5, 800, 'Compassionate healthcare provider specializing in gastroenterology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.66, 15, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '51850c4d-4544-447f-a211-69d201e822b9', id FROM public.specializations WHERE slug = 'gastroenterology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('51850c4d-4544-447f-a211-69d201e822b9', 'e36436e7-563f-4696-a061-c137ca91a8e0', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.milind.gaikwad@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Milind Gaikwad","email":"dr.milind.gaikwad@betterclinic.app","role":"DOCTOR","phone":"+919347106576"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.milind.gaikwad@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', 'Dr. Milind Gaikwad', 'dr.milind.gaikwad@betterclinic.app', '+919347106576', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Milind Gaikwad', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', 'MBBS, DNB (Internal Medicine)', 'MMC-2004-63553', 12, 800, 'Compassionate healthcare provider specializing in general medicine. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.77, 20, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', id FROM public.specializations WHERE slug = 'general-medicine'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('ae1cb7dd-fe5b-499f-b5ae-d0907fbcffee', '80798686-5ecd-47e3-8dfa-334fac68fbe8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'e098a789-4f27-4f46-9c89-1137063e7d55', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.dhruv.mishra@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Dhruv Mishra","email":"dr.dhruv.mishra@betterclinic.app","role":"DOCTOR","phone":"+919623738491"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.dhruv.mishra@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', 'Dr. Dhruv Mishra', 'dr.dhruv.mishra@betterclinic.app', '+919623738491', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Dhruv Mishra', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', 'MBBS, MD, DM (Cardiology)', 'MMC-2002-33139', 14, 500, 'Compassionate healthcare provider specializing in cardiology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.62, 21, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'e098a789-4f27-4f46-9c89-1137063e7d55', id FROM public.specializations WHERE slug = 'cardiology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('e098a789-4f27-4f46-9c89-1137063e7d55', '9c795e23-a828-476e-8c4b-9d855cd3e8bf', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '8eea63dd-59d9-4d08-9122-9bb6477d9c96', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rohit.bhosle@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rohit Bhosle","email":"dr.rohit.bhosle@betterclinic.app","role":"DOCTOR","phone":"+917771977959"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.rohit.bhosle@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', 'Dr. Rohit Bhosle', 'dr.rohit.bhosle@betterclinic.app', '+917771977959', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Rohit Bhosle', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', 'MBBS, DVD', 'MMC-2020-20926', 6, 400, 'Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.28, 26, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '8eea63dd-59d9-4d08-9122-9bb6477d9c96', id FROM public.specializations WHERE slug = 'dermatology'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('8eea63dd-59d9-4d08-9122-9bb6477d9c96', '93fb326b-2edc-4ee6-9608-64409c5babda', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '2f672242-27f5-4196-af0a-591eadc81be0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.karan.naik@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Karan Naik","email":"dr.karan.naik@betterclinic.app","role":"DOCTOR","phone":"+919631104402"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.karan.naik@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', 'Dr. Karan Naik', 'dr.karan.naik@betterclinic.app', '+919631104402', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Karan Naik', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', 'MBBS, MD (Pediatrics)', 'MMC-2004-12186', 19, 800, 'Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.4, 63, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT '2f672242-27f5-4196-af0a-591eadc81be0', id FROM public.specializations WHERE slug = 'pediatrics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('2f672242-27f5-4196-af0a-591eadc81be0', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.zeel.more@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Zeel More","email":"dr.zeel.more@betterclinic.app","role":"DOCTOR","phone":"+917579777086"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET email = 'dr.zeel.more@betterclinic.app', raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb;

    INSERT INTO public.profiles (id, full_name, email, phone, role)
    VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'Dr. Zeel More', 'dr.zeel.more@betterclinic.app', '+917579777086', 'DOCTOR'::public.user_role)
    ON CONFLICT (id) DO UPDATE SET full_name = 'Dr. Zeel More', role = 'DOCTOR'::public.user_role;
  

    INSERT INTO public.doctors (id, qualification, registration_number, experience_years, consultation_fee, about, languages, avg_rating, review_count, is_accepting_patients)
    VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'MBBS, MS (Orthopedics)', 'MMC-2017-58717', 14, 800, 'Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.', ARRAY['English','Hindi','Marathi'], 4.39, 28, true)
    ON CONFLICT (id) DO UPDATE SET qualification = EXCLUDED.qualification, consultation_fee = EXCLUDED.consultation_fee;

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    SELECT 'b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', id FROM public.specializations WHERE slug = 'orthopedics'
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('b9bca5d3-7a65-45be-87e8-1f6d1faa2d0e', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    