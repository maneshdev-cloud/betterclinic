
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      'd1b088f2-4e19-4c87-8313-9749c9caca04', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sameer.kapoor82@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Sameer Kapoor","email":"sameer.kapoor82@example.com","role":"PATIENT","phone":"+918620298876","date_of_birth":"1964-01-20","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'sameer.kapoor82@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Sameer Kapoor","email":"sameer.kapoor82@example.com","role":"PATIENT","phone":"+918620298876","date_of_birth":"1964-01-20","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('d1b088f2-4e19-4c87-8313-9749c9caca04', '1964-01-20', 'MALE'::public.sex, 'A-', 'Flat 393, Building 7, Mulund', 'Mumbai', 'Mulund', '408986', 'Family Contact', '+917534286644')
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
      '65fd5d79-2034-4490-bc6e-6472d4d908d3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'aditya.gupta47@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Aditya Gupta","email":"aditya.gupta47@example.com","role":"PATIENT","phone":"+918615801660","date_of_birth":"1974-12-25","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'aditya.gupta47@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Aditya Gupta","email":"aditya.gupta47@example.com","role":"PATIENT","phone":"+918615801660","date_of_birth":"1974-12-25","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('65fd5d79-2034-4490-bc6e-6472d4d908d3', '1974-12-25', 'MALE'::public.sex, 'B-', 'Flat 610, Building 10, Kurla', 'Mumbai', 'Kurla', '406492', 'Family Contact', '+918721897504')
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
      'baa1a141-b344-43ca-a31d-c1412db9ca5d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sneha.gupta61@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Sneha Gupta","email":"sneha.gupta61@example.com","role":"PATIENT","phone":"+918797855014","date_of_birth":"1974-04-26","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'sneha.gupta61@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Sneha Gupta","email":"sneha.gupta61@example.com","role":"PATIENT","phone":"+918797855014","date_of_birth":"1974-04-26","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('baa1a141-b344-43ca-a31d-c1412db9ca5d', '1974-04-26', 'FEMALE'::public.sex, 'O+', 'Flat 131, Building 2, Bandra', 'Mumbai', 'Bandra', '418183', 'Family Contact', '+919595386633')
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
      '88fb2f4e-000b-4208-821d-3e1d89d26977', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'aarti.shah23@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Aarti Shah","email":"aarti.shah23@example.com","role":"PATIENT","phone":"+919977532639","date_of_birth":"1989-03-15","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'aarti.shah23@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Aarti Shah","email":"aarti.shah23@example.com","role":"PATIENT","phone":"+919977532639","date_of_birth":"1989-03-15","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('88fb2f4e-000b-4208-821d-3e1d89d26977', '1989-03-15', 'FEMALE'::public.sex, 'O+', 'Flat 302, Building 5, Kandivali', 'Mumbai', 'Kandivali', '412551', 'Family Contact', '+917783057299')
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
      '4a585ad1-dbe4-4cde-ab12-4dbca9964f14', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sameer.iyer80@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Sameer Iyer","email":"sameer.iyer80@example.com","role":"PATIENT","phone":"+918643016758","date_of_birth":"1960-08-19","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'sameer.iyer80@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Sameer Iyer","email":"sameer.iyer80@example.com","role":"PATIENT","phone":"+918643016758","date_of_birth":"1960-08-19","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('4a585ad1-dbe4-4cde-ab12-4dbca9964f14', '1960-08-19', 'MALE'::public.sex, 'AB-', 'Flat 661, Building 9, Malad', 'Mumbai', 'Malad', '419328', 'Family Contact', '+919382950151')
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
      '8a5bb9dd-6592-4e61-b16e-870138e50d18', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'meera.gupta79@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Meera Gupta","email":"meera.gupta79@example.com","role":"PATIENT","phone":"+918491352318","date_of_birth":"1994-09-07","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'meera.gupta79@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Meera Gupta","email":"meera.gupta79@example.com","role":"PATIENT","phone":"+918491352318","date_of_birth":"1994-09-07","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('8a5bb9dd-6592-4e61-b16e-870138e50d18', '1994-09-07', 'FEMALE'::public.sex, 'B+', 'Flat 963, Building 8, Lower Parel', 'Mumbai', 'Lower Parel', '414916', 'Family Contact', '+917514482068')
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
      '335e7748-f8a8-49b8-b7a1-e3f192099cbb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'vikram.nair93@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Vikram Nair","email":"vikram.nair93@example.com","role":"PATIENT","phone":"+919371859069","date_of_birth":"1984-08-04","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'vikram.nair93@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Vikram Nair","email":"vikram.nair93@example.com","role":"PATIENT","phone":"+919371859069","date_of_birth":"1984-08-04","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('335e7748-f8a8-49b8-b7a1-e3f192099cbb', '1984-08-04', 'MALE'::public.sex, 'A-', 'Flat 750, Building 1, Malad', 'Mumbai', 'Malad', '407885', 'Family Contact', '+918794794636')
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
      '862e653d-c17b-4bc9-8269-0f8b695fbf5f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'divya.reddy18@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Divya Reddy","email":"divya.reddy18@example.com","role":"PATIENT","phone":"+919756839933","date_of_birth":"1995-09-30","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'divya.reddy18@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Divya Reddy","email":"divya.reddy18@example.com","role":"PATIENT","phone":"+919756839933","date_of_birth":"1995-09-30","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('862e653d-c17b-4bc9-8269-0f8b695fbf5f', '1995-09-30', 'FEMALE'::public.sex, 'O-', 'Flat 1030, Building 10, Kurla', 'Mumbai', 'Kurla', '411334', 'Family Contact', '+917725880365')
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
      'e4350097-5c41-4f4b-929c-33eab981d5ae', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'meera.deshmukh65@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Meera Deshmukh","email":"meera.deshmukh65@example.com","role":"PATIENT","phone":"+919861561987","date_of_birth":"1999-02-19","sex":"FEMALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'meera.deshmukh65@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Meera Deshmukh","email":"meera.deshmukh65@example.com","role":"PATIENT","phone":"+919861561987","date_of_birth":"1999-02-19","sex":"FEMALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('e4350097-5c41-4f4b-929c-33eab981d5ae', '1999-02-19', 'FEMALE'::public.sex, 'A-', 'Flat 1040, Building 2, Ghodbunder Road', 'Thane', 'Ghodbunder Road', '421551', 'Family Contact', '+918447705153')
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
      'b7a8841a-588d-49bb-8986-5ca88f1d6ab2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'siddharth.rao21@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Siddharth Rao","email":"siddharth.rao21@example.com","role":"PATIENT","phone":"+919663308645","date_of_birth":"1997-05-12","sex":"MALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'siddharth.rao21@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Siddharth Rao","email":"siddharth.rao21@example.com","role":"PATIENT","phone":"+919663308645","date_of_birth":"1997-05-12","sex":"MALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('b7a8841a-588d-49bb-8986-5ca88f1d6ab2', '1997-05-12', 'MALE'::public.sex, 'A+', 'Flat 1145, Building 5, Balkum', 'Thane', 'Balkum', '411904', 'Family Contact', '+918770680266')
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
      '322a2f19-fb66-4d24-b825-39fb84de2d4e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'nikhil.shah49@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Nikhil Shah","email":"nikhil.shah49@example.com","role":"PATIENT","phone":"+917529233263","date_of_birth":"1964-03-09","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'nikhil.shah49@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Nikhil Shah","email":"nikhil.shah49@example.com","role":"PATIENT","phone":"+917529233263","date_of_birth":"1964-03-09","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('322a2f19-fb66-4d24-b825-39fb84de2d4e', '1964-03-09', 'MALE'::public.sex, 'AB-', 'Flat 543, Building 10, Dadar', 'Mumbai', 'Dadar', '423758', 'Family Contact', '+919188581249')
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
      '2a5a3051-639a-4024-8b52-f2d6ea7cd42f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'varun.nair50@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Varun Nair","email":"varun.nair50@example.com","role":"PATIENT","phone":"+918740410399","date_of_birth":"1966-02-04","sex":"MALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'varun.nair50@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Varun Nair","email":"varun.nair50@example.com","role":"PATIENT","phone":"+918740410399","date_of_birth":"1966-02-04","sex":"MALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('2a5a3051-639a-4024-8b52-f2d6ea7cd42f', '1966-02-04', 'MALE'::public.sex, 'A-', 'Flat 791, Building 3, Manpada', 'Thane', 'Manpada', '406532', 'Family Contact', '+919175989694')
    ON CONFLICT (id) DO UPDATE SET 
      blood_group = EXCLUDED.blood_group,
      address_line = EXCLUDED.address_line,
      area = EXCLUDED.area,
      pincode = EXCLUDED.pincode,
      emergency_contact_name = EXCLUDED.emergency_contact_name,
      emergency_contact_phone = EXCLUDED.emergency_contact_phone;
  