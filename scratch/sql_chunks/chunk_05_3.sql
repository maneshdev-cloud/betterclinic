
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '9d5b76f7-9a18-4067-a411-862c06e1f43b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'ananya.pillai75@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Ananya Pillai","email":"ananya.pillai75@example.com","role":"PATIENT","phone":"+919145506381","date_of_birth":"2000-10-27","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'ananya.pillai75@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Ananya Pillai","email":"ananya.pillai75@example.com","role":"PATIENT","phone":"+919145506381","date_of_birth":"2000-10-27","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('9d5b76f7-9a18-4067-a411-862c06e1f43b', '2000-10-27', 'FEMALE'::public.sex, 'AB-', 'Flat 989, Building 2, Colaba', 'Mumbai', 'Colaba', '403423', 'Family Contact', '+918683171688')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'b44d51e4-4151-4712-a098-d3248c12cd73', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'aarti.deshmukh21@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Aarti Deshmukh","email":"aarti.deshmukh21@example.com","role":"PATIENT","phone":"+919987500548","date_of_birth":"1975-07-16","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'aarti.deshmukh21@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Aarti Deshmukh","email":"aarti.deshmukh21@example.com","role":"PATIENT","phone":"+919987500548","date_of_birth":"1975-07-16","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('b44d51e4-4151-4712-a098-d3248c12cd73', '1975-07-16', 'FEMALE'::public.sex, 'B+', 'Flat 683, Building 6, Goregaon', 'Mumbai', 'Goregaon', '411706', 'Family Contact', '+918711629013')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '1d5b37aa-ae9a-4b5a-a00f-4db605580d9f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'divya.malhotra83@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Divya Malhotra","email":"divya.malhotra83@example.com","role":"PATIENT","phone":"+918731507726","date_of_birth":"1989-10-30","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'divya.malhotra83@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Divya Malhotra","email":"divya.malhotra83@example.com","role":"PATIENT","phone":"+918731507726","date_of_birth":"1989-10-30","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('1d5b37aa-ae9a-4b5a-a00f-4db605580d9f', '1989-10-30', 'FEMALE'::public.sex, 'AB-', 'Flat 1063, Building 10, Bandra', 'Mumbai', 'Bandra', '418658', 'Family Contact', '+917525990838')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '862ed2b6-29dd-45dc-b60a-8e5544386cf2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'isha.deshmukh54@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Isha Deshmukh","email":"isha.deshmukh54@example.com","role":"PATIENT","phone":"+918486605989","date_of_birth":"1992-08-07","sex":"FEMALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'isha.deshmukh54@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Isha Deshmukh","email":"isha.deshmukh54@example.com","role":"PATIENT","phone":"+918486605989","date_of_birth":"1992-08-07","sex":"FEMALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('862ed2b6-29dd-45dc-b60a-8e5544386cf2', '1992-08-07', 'FEMALE'::public.sex, 'O+', 'Flat 240, Building 8, Kasarvadavali', 'Thane', 'Kasarvadavali', '414953', 'Family Contact', '+919978079634')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '74842fd4-9a4a-45bd-9273-080c5a0fac5a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'meera.malhotra63@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Meera Malhotra","email":"meera.malhotra63@example.com","role":"PATIENT","phone":"+917790286629","date_of_birth":"1966-10-18","sex":"FEMALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'meera.malhotra63@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Meera Malhotra","email":"meera.malhotra63@example.com","role":"PATIENT","phone":"+917790286629","date_of_birth":"1966-10-18","sex":"FEMALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('74842fd4-9a4a-45bd-9273-080c5a0fac5a', '1966-10-18', 'FEMALE'::public.sex, 'B+', 'Flat 396, Building 10, Naupada', 'Thane', 'Naupada', '418430', 'Family Contact', '+918687510441')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  

    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'e3825463-1ea8-482d-997e-1fe73d190286', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'divya.joshi42@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Divya Joshi","email":"divya.joshi42@example.com","role":"PATIENT","phone":"+919326340573","date_of_birth":"1987-07-05","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'divya.joshi42@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Divya Joshi","email":"divya.joshi42@example.com","role":"PATIENT","phone":"+919326340573","date_of_birth":"1987-07-05","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('e3825463-1ea8-482d-997e-1fe73d190286', '1987-07-05', 'FEMALE'::public.sex, 'AB-', 'Flat 767, Building 1, Vile Parle', 'Mumbai', 'Vile Parle', '416584', 'Family Contact', '+919855692393')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  