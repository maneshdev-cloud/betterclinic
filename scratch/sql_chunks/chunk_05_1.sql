
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
  