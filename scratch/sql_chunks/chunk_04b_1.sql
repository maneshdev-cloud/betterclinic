
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'd5cdf351-5726-4ae2-b3d7-b404a99160a5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.meera.reddy@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Meera Reddy","email":"dr.meera.reddy@betterclinic.app","role":"DOCTOR","phone":"+919351350950","qualification":"MBBS, MD (Dermatology, Venereology & Leprosy)","registration_number":"MMC-2012-67443","experience_years":"8","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"9b15f7ae-e83f-4140-a095-3b0befb5de41","clinic_id":"177234ab-513d-4eeb-846f-84f768cc3f21"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.meera.reddy@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Meera Reddy","email":"dr.meera.reddy@betterclinic.app","role":"DOCTOR","phone":"+919351350950","qualification":"MBBS, MD (Dermatology, Venereology & Leprosy)","registration_number":"MMC-2012-67443","experience_years":"8","consultation_fee":"1000","about":"Compassionate healthcare provider specializing in dermatology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"9b15f7ae-e83f-4140-a095-3b0befb5de41","clinic_id":"177234ab-513d-4eeb-846f-84f768cc3f21"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.3,
      review_count = 61,
      is_accepting_patients = true
    WHERE id = 'd5cdf351-5726-4ae2-b3d7-b404a99160a5';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '9b15f7ae-e83f-4140-a095-3b0befb5de41')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('d5cdf351-5726-4ae2-b3d7-b404a99160a5', '177234ab-513d-4eeb-846f-84f768cc3f21', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '0c370871-543d-4a3c-8c68-33df3cb19f89', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.siddharth.reddy@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Siddharth Reddy","email":"dr.siddharth.reddy@betterclinic.app","role":"DOCTOR","phone":"+919692379439","qualification":"MBBS, MD (Pediatrics)","registration_number":"MMC-2002-88612","experience_years":"9","consultation_fee":"500","about":"Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"751c5e4a-83a1-432c-98c7-be4a2526ab23","clinic_id":"50f2fd47-2f9d-4c97-acc9-af5021fe2279"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.siddharth.reddy@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Siddharth Reddy","email":"dr.siddharth.reddy@betterclinic.app","role":"DOCTOR","phone":"+919692379439","qualification":"MBBS, MD (Pediatrics)","registration_number":"MMC-2002-88612","experience_years":"9","consultation_fee":"500","about":"Compassionate healthcare provider specializing in pediatrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"751c5e4a-83a1-432c-98c7-be4a2526ab23","clinic_id":"50f2fd47-2f9d-4c97-acc9-af5021fe2279"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.63,
      review_count = 10,
      is_accepting_patients = true
    WHERE id = '0c370871-543d-4a3c-8c68-33df3cb19f89';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '751c5e4a-83a1-432c-98c7-be4a2526ab23')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('0c370871-543d-4a3c-8c68-33df3cb19f89', '50f2fd47-2f9d-4c97-acc9-af5021fe2279', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'c1adcd7d-9edc-49fb-86d2-55f36592dd8d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.rhea.nair@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Rhea Nair","email":"dr.rhea.nair@betterclinic.app","role":"DOCTOR","phone":"+918844175557","qualification":"MBBS, MS (Orthopedics)","registration_number":"MMC-2000-39771","experience_years":"8","consultation_fee":"500","about":"Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"333c7946-d872-4130-8e3c-dbb8824ae653","clinic_id":"b02f15c5-8dff-435c-a749-30f268deec03"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.rhea.nair@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Rhea Nair","email":"dr.rhea.nair@betterclinic.app","role":"DOCTOR","phone":"+918844175557","qualification":"MBBS, MS (Orthopedics)","registration_number":"MMC-2000-39771","experience_years":"8","consultation_fee":"500","about":"Compassionate healthcare provider specializing in orthopedics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"333c7946-d872-4130-8e3c-dbb8824ae653","clinic_id":"b02f15c5-8dff-435c-a749-30f268deec03"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.78,
      review_count = 29,
      is_accepting_patients = true
    WHERE id = 'c1adcd7d-9edc-49fb-86d2-55f36592dd8d';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', '333c7946-d872-4130-8e3c-dbb8824ae653')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('c1adcd7d-9edc-49fb-86d2-55f36592dd8d', 'b02f15c5-8dff-435c-a749-30f268deec03', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '028d8dba-a45e-4516-90dc-cef215806096', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.abhishek.patel@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Abhishek Patel","email":"dr.abhishek.patel@betterclinic.app","role":"DOCTOR","phone":"+919657374114","qualification":"MBBS, MS (OBGYN)","registration_number":"MMC-2005-79376","experience_years":"8","consultation_fee":"700","about":"Compassionate healthcare provider specializing in gynecology obstetrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"1f1b95cd-8630-4054-9161-1568c7edde9a","clinic_id":"6bcb5f55-5297-4dcb-9066-58c174d45013"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.abhishek.patel@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Abhishek Patel","email":"dr.abhishek.patel@betterclinic.app","role":"DOCTOR","phone":"+919657374114","qualification":"MBBS, MS (OBGYN)","registration_number":"MMC-2005-79376","experience_years":"8","consultation_fee":"700","about":"Compassionate healthcare provider specializing in gynecology obstetrics. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"1f1b95cd-8630-4054-9161-1568c7edde9a","clinic_id":"6bcb5f55-5297-4dcb-9066-58c174d45013"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.49,
      review_count = 16,
      is_accepting_patients = true
    WHERE id = '028d8dba-a45e-4516-90dc-cef215806096';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '1f1b95cd-8630-4054-9161-1568c7edde9a')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('028d8dba-a45e-4516-90dc-cef215806096', '6bcb5f55-5297-4dcb-9066-58c174d45013', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'f4c20e46-51e4-42ac-8b76-16e124834911', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.tanvi.rao@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Tanvi Rao","email":"dr.tanvi.rao@betterclinic.app","role":"DOCTOR","phone":"+917793884373","qualification":"MBBS, DLO","registration_number":"MMC-2005-44696","experience_years":"20","consultation_fee":"400","about":"Compassionate healthcare provider specializing in ent otolaryngology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"87012fa8-f937-4373-9bf2-ce7a255c5ad6","clinic_id":"93fb326b-2edc-4ee6-9608-64409c5babda"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.tanvi.rao@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Tanvi Rao","email":"dr.tanvi.rao@betterclinic.app","role":"DOCTOR","phone":"+917793884373","qualification":"MBBS, DLO","registration_number":"MMC-2005-44696","experience_years":"20","consultation_fee":"400","about":"Compassionate healthcare provider specializing in ent otolaryngology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"87012fa8-f937-4373-9bf2-ce7a255c5ad6","clinic_id":"93fb326b-2edc-4ee6-9608-64409c5babda"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.94,
      review_count = 18,
      is_accepting_patients = true
    WHERE id = 'f4c20e46-51e4-42ac-8b76-16e124834911';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '87012fa8-f937-4373-9bf2-ce7a255c5ad6')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('f4c20e46-51e4-42ac-8b76-16e124834911', '93fb326b-2edc-4ee6-9608-64409c5babda', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '70b32e1a-9f1e-4663-b392-27861c5893b5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.deepa.mehta@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Deepa Mehta","email":"dr.deepa.mehta@betterclinic.app","role":"DOCTOR","phone":"+919397062778","qualification":"MBBS, MS (Ophthalmology)","registration_number":"MMC-2006-47765","experience_years":"22","consultation_fee":"500","about":"Compassionate healthcare provider specializing in ophthalmology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"6763ec01-e18f-4737-ba0e-a49cbb29a8e2","clinic_id":"edab5373-01f2-4df1-825e-14099f589ae8"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.deepa.mehta@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Deepa Mehta","email":"dr.deepa.mehta@betterclinic.app","role":"DOCTOR","phone":"+919397062778","qualification":"MBBS, MS (Ophthalmology)","registration_number":"MMC-2006-47765","experience_years":"22","consultation_fee":"500","about":"Compassionate healthcare provider specializing in ophthalmology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"6763ec01-e18f-4737-ba0e-a49cbb29a8e2","clinic_id":"edab5373-01f2-4df1-825e-14099f589ae8"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.75,
      review_count = 83,
      is_accepting_patients = true
    WHERE id = '70b32e1a-9f1e-4663-b392-27861c5893b5';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', '6763ec01-e18f-4737-ba0e-a49cbb29a8e2')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', 1, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', 2, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', 3, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', 4, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', 5, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

      INSERT INTO public.doctor_availability (doctor_id, clinic_id, day_of_week, start_time, end_time, break_start, break_end, slot_duration_minutes, is_active)
      VALUES ('70b32e1a-9f1e-4663-b392-27861c5893b5', 'edab5373-01f2-4df1-825e-14099f589ae8', 6, '09:00:00', '18:00:00', '13:00:00', '14:00:00', 15, true)
      ON CONFLICT (doctor_id, clinic_id, day_of_week, start_time) DO NOTHING;
    

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '93b59638-0343-4385-a9b9-1d205a6d87fc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'dr.kavita.kapoor@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      '{"full_name":"Dr. Kavita Kapoor","email":"dr.kavita.kapoor@betterclinic.app","role":"DOCTOR","phone":"+918467754828","qualification":"MBBS, MD, DM (Neurology)","registration_number":"MMC-2017-56824","experience_years":"12","consultation_fee":"500","about":"Compassionate healthcare provider specializing in neurology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"f41d4e14-64b1-46b5-96c1-44c208e81d32","clinic_id":"8111f72e-b4ea-4362-9cf5-ef69a793fd73"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'dr.kavita.kapoor@betterclinic.app', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"DOCTOR"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Dr. Kavita Kapoor","email":"dr.kavita.kapoor@betterclinic.app","role":"DOCTOR","phone":"+918467754828","qualification":"MBBS, MD, DM (Neurology)","registration_number":"MMC-2017-56824","experience_years":"12","consultation_fee":"500","about":"Compassionate healthcare provider specializing in neurology. Dedicated to patient-centric treatment with proven clinical outcomes.","specialization_id":"f41d4e14-64b1-46b5-96c1-44c208e81d32","clinic_id":"8111f72e-b4ea-4362-9cf5-ef69a793fd73"}'::jsonb;
  

    UPDATE public.doctors SET 
      languages = ARRAY['English','Hindi','Marathi'],
      avg_rating = 4.71,
      review_count = 43,
      is_accepting_patients = true
    WHERE id = '93b59638-0343-4385-a9b9-1d205a6d87fc';

    INSERT INTO public.doctor_specializations (doctor_id, specialization_id)
    VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', 'f41d4e14-64b1-46b5-96c1-44c208e81d32')
    ON CONFLICT (doctor_id, specialization_id) DO NOTHING;

    INSERT INTO public.doctor_clinics (doctor_id, clinic_id, is_primary)
    VALUES ('93b59638-0343-4385-a9b9-1d205a6d87fc', '8111f72e-b4ea-4362-9cf5-ef69a793fd73', true)
    ON CONFLICT (doctor_id, clinic_id) DO NOTHING;
  