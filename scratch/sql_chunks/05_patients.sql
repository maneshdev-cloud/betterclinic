
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      '088b9e7b-5c17-4e89-b37f-d709bd9c053b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'aarti.iyer15@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Aarti Iyer","email":"aarti.iyer15@example.com","role":"PATIENT","phone":"+918417899293","date_of_birth":"1981-04-08","sex":"FEMALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'aarti.iyer15@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Aarti Iyer","email":"aarti.iyer15@example.com","role":"PATIENT","phone":"+918417899293","date_of_birth":"1981-04-08","sex":"FEMALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('088b9e7b-5c17-4e89-b37f-d709bd9c053b', '1981-04-08', 'FEMALE'::public.sex, 'AB+', 'Flat 916, Building 7, Wagle Estate', 'Thane', 'Wagle Estate', '420282', 'Family Contact', '+919363414620')
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
      '16cc854d-827c-4a36-8653-e5237772f046', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'pranav.kapoor29@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Pranav Kapoor","email":"pranav.kapoor29@example.com","role":"PATIENT","phone":"+919315153164","date_of_birth":"1986-02-15","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'pranav.kapoor29@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Pranav Kapoor","email":"pranav.kapoor29@example.com","role":"PATIENT","phone":"+919315153164","date_of_birth":"1986-02-15","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('16cc854d-827c-4a36-8653-e5237772f046', '1986-02-15', 'MALE'::public.sex, 'O+', 'Flat 1198, Building 7, Worli', 'Mumbai', 'Worli', '401121', 'Family Contact', '+919368117988')
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
      'a575786b-e181-4935-8d89-06a5ad722adb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sunita.joshi56@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Sunita Joshi","email":"sunita.joshi56@example.com","role":"PATIENT","phone":"+917584077170","date_of_birth":"2001-12-17","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'sunita.joshi56@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Sunita Joshi","email":"sunita.joshi56@example.com","role":"PATIENT","phone":"+917584077170","date_of_birth":"2001-12-17","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('a575786b-e181-4935-8d89-06a5ad722adb', '2001-12-17', 'FEMALE'::public.sex, 'AB+', 'Flat 564, Building 8, Andheri', 'Mumbai', 'Andheri', '411302', 'Family Contact', '+917780379668')
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
      '53bfa8d9-f36c-4207-8092-d833c7ccf6df', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'pranav.shah62@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Pranav Shah","email":"pranav.shah62@example.com","role":"PATIENT","phone":"+918786979841","date_of_birth":"1961-02-24","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'pranav.shah62@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Pranav Shah","email":"pranav.shah62@example.com","role":"PATIENT","phone":"+918786979841","date_of_birth":"1961-02-24","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('53bfa8d9-f36c-4207-8092-d833c7ccf6df', '1961-02-24', 'MALE'::public.sex, 'AB+', 'Flat 142, Building 11, Powai', 'Mumbai', 'Powai', '407649', 'Family Contact', '+918749877221')
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
      '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'priya.iyer24@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Priya Iyer","email":"priya.iyer24@example.com","role":"PATIENT","phone":"+918881624401","date_of_birth":"1989-05-15","sex":"FEMALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'priya.iyer24@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Priya Iyer","email":"priya.iyer24@example.com","role":"PATIENT","phone":"+918881624401","date_of_birth":"1989-05-15","sex":"FEMALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '1989-05-15', 'FEMALE'::public.sex, 'A+', 'Flat 293, Building 13, Balkum', 'Thane', 'Balkum', '401092', 'Family Contact', '+917566449402')
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
      '711cde25-d481-4812-bc2b-6770e6881b1d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'swati.kulkarni29@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Swati Kulkarni","email":"swati.kulkarni29@example.com","role":"PATIENT","phone":"+918452065620","date_of_birth":"1968-10-11","sex":"FEMALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'swati.kulkarni29@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Swati Kulkarni","email":"swati.kulkarni29@example.com","role":"PATIENT","phone":"+918452065620","date_of_birth":"1968-10-11","sex":"FEMALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('711cde25-d481-4812-bc2b-6770e6881b1d', '1968-10-11', 'FEMALE'::public.sex, 'A+', 'Flat 158, Building 15, Kurla', 'Mumbai', 'Kurla', '411362', 'Family Contact', '+917761462180')
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
      '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'rohan.deshmukh74@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Rohan Deshmukh","email":"rohan.deshmukh74@example.com","role":"PATIENT","phone":"+919850651362","date_of_birth":"2000-03-16","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'rohan.deshmukh74@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Rohan Deshmukh","email":"rohan.deshmukh74@example.com","role":"PATIENT","phone":"+919850651362","date_of_birth":"2000-03-16","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', '2000-03-16', 'MALE'::public.sex, 'A+', 'Flat 571, Building 7, Dadar', 'Mumbai', 'Dadar', '420714', 'Family Contact', '+918627609977')
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
      '40133434-eb9d-4e89-9fac-130d00f8bd99', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'abhishek.reddy27@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Abhishek Reddy","email":"abhishek.reddy27@example.com","role":"PATIENT","phone":"+919644053838","date_of_birth":"1983-02-28","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'abhishek.reddy27@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Abhishek Reddy","email":"abhishek.reddy27@example.com","role":"PATIENT","phone":"+919644053838","date_of_birth":"1983-02-28","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('40133434-eb9d-4e89-9fac-130d00f8bd99', '1983-02-28', 'MALE'::public.sex, 'B+', 'Flat 287, Building 11, Churchgate', 'Mumbai', 'Churchgate', '423728', 'Family Contact', '+918711696791')
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
      '387eb9a0-71c4-4846-a8b9-e3b30c7b1a90', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'siddharth.iyer32@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Siddharth Iyer","email":"siddharth.iyer32@example.com","role":"PATIENT","phone":"+918413470920","date_of_birth":"2002-06-21","sex":"MALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'siddharth.iyer32@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Siddharth Iyer","email":"siddharth.iyer32@example.com","role":"PATIENT","phone":"+918413470920","date_of_birth":"2002-06-21","sex":"MALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('387eb9a0-71c4-4846-a8b9-e3b30c7b1a90', '2002-06-21', 'MALE'::public.sex, 'B-', 'Flat 127, Building 4, Kasarvadavali', 'Thane', 'Kasarvadavali', '417735', 'Family Contact', '+918735029776')
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
      '651f1079-3801-4852-8b03-d9e272b42ffc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'karan.nair91@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Karan Nair","email":"karan.nair91@example.com","role":"PATIENT","phone":"+919120397687","date_of_birth":"1985-11-28","sex":"MALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'karan.nair91@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Karan Nair","email":"karan.nair91@example.com","role":"PATIENT","phone":"+919120397687","date_of_birth":"1985-11-28","sex":"MALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('651f1079-3801-4852-8b03-d9e272b42ffc', '1985-11-28', 'MALE'::public.sex, 'AB-', 'Flat 361, Building 7, Wagle Estate', 'Thane', 'Wagle Estate', '413962', 'Family Contact', '+919647630116')
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
      'dca33f00-00a3-46cd-ae8b-69f3f612d5ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'kunal.deshmukh73@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Kunal Deshmukh","email":"kunal.deshmukh73@example.com","role":"PATIENT","phone":"+917535237472","date_of_birth":"1972-11-27","sex":"MALE","city":"Thane"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'kunal.deshmukh73@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Kunal Deshmukh","email":"kunal.deshmukh73@example.com","role":"PATIENT","phone":"+917535237472","date_of_birth":"1972-11-27","sex":"MALE","city":"Thane"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('dca33f00-00a3-46cd-ae8b-69f3f612d5ee', '1972-11-27', 'MALE'::public.sex, 'A+', 'Flat 1018, Building 12, Hiranandani Estate', 'Thane', 'Hiranandani Estate', '424754', 'Family Contact', '+919166147665')
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
      '7ff9b795-eb07-40c2-9cc9-568c14f652ec', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'varun.mehta48@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(),
      '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      '{"full_name":"Varun Mehta","email":"varun.mehta48@example.com","role":"PATIENT","phone":"+918872125226","date_of_birth":"1961-07-31","sex":"MALE","city":"Mumbai"}'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET 
      email = 'varun.mehta48@example.com', 
      raw_app_meta_data = '{"provider":"email","providers":["email"],"role":"PATIENT"}'::jsonb,
      raw_user_meta_data = '{"full_name":"Varun Mehta","email":"varun.mehta48@example.com","role":"PATIENT","phone":"+918872125226","date_of_birth":"1961-07-31","sex":"MALE","city":"Mumbai"}'::jsonb;
  

    INSERT INTO public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone)
    VALUES ('7ff9b795-eb07-40c2-9cc9-568c14f652ec', '1961-07-31', 'MALE'::public.sex, 'A+', 'Flat 262, Building 8, Kurla', 'Mumbai', 'Kurla', '411102', 'Family Contact', '+919866781838')
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
  