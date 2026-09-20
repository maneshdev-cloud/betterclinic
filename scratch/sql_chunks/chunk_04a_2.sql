
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
    