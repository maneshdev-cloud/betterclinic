insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data) values
('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo-patient@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Sharma","role":"PATIENT","date_of_birth":"1994-08-14","sex":"MALE","city":"Mumbai"}'::jsonb),
('8b1371af-f849-4a9a-baad-8aca5537a6f4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sunita.malhotra1@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sunita Malhotra","role":"PATIENT","date_of_birth":"1990-03-24","sex":"FEMALE","city":"Thane"}'::jsonb),
('fc993a40-1352-4f83-8137-a7cc7a87cade', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sneha.patel2@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sneha Patel","role":"PATIENT","date_of_birth":"1998-09-10","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('3198214c-28e6-4f70-a35e-f32e638bfa98', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aarav.verma3@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Verma","role":"PATIENT","date_of_birth":"2003-12-28","sex":"MALE","city":"Thane"}'::jsonb),
('5409916a-5a91-4153-b75d-f09d05e0f0d3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.siddharth.deshmukh4@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Siddharth Deshmukh","role":"PATIENT","date_of_birth":"2004-02-09","sex":"MALE","city":"Thane"}'::jsonb),
('273814d7-f717-4cf4-b48d-7b365e070f7e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.amit.verma5@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Amit Verma","role":"PATIENT","date_of_birth":"1971-01-12","sex":"MALE","city":"Navi Mumbai"}'::jsonb),
('821c1a50-a35b-4908-b1e4-0b151a7caeac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.neha.kapoor6@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Neha Kapoor","role":"PATIENT","date_of_birth":"1986-05-24","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('dc77a594-6094-4cfd-b59f-39dd05cce495', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.kunal.deshmukh7@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Kunal Deshmukh","role":"PATIENT","date_of_birth":"1994-04-19","sex":"MALE","city":"Mumbai"}'::jsonb),
('0768e19b-6893-493a-b63b-342bb994f9d1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rahul.patel8@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rahul Patel","role":"PATIENT","date_of_birth":"1976-06-26","sex":"MALE","city":"Mumbai"}'::jsonb),
('997803b4-42b8-4e2b-839d-d92b2345f70a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sameer.nair9@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sameer Nair","role":"PATIENT","date_of_birth":"1964-01-12","sex":"MALE","city":"Pune"}'::jsonb),
('fbbbfaca-0a19-42d4-bb71-71761729b90d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.nikhil.kulkarni10@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Nikhil Kulkarni","role":"PATIENT","date_of_birth":"1988-10-11","sex":"MALE","city":"Thane"}'::jsonb),
('d8ed7244-51d2-4c37-a462-98290c35c67e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rhea.joshi11@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rhea Joshi","role":"PATIENT","date_of_birth":"1986-08-30","sex":"FEMALE","city":"Mumbai"}'::jsonb),
('234028c9-11d7-41a4-9a0d-403fbd90a5aa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.arjun.joshi12@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Arjun Joshi","role":"PATIENT","date_of_birth":"1990-02-25","sex":"MALE","city":"Navi Mumbai"}'::jsonb),
('5e0cb7aa-d7e2-42e8-a87d-c508cfe0fbad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.karan.kapoor13@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Karan Kapoor","role":"PATIENT","date_of_birth":"1971-12-18","sex":"MALE","city":"Mumbai"}'::jsonb),
('f9ea4be0-27fb-46f3-a1a8-c1839e419c4c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pranav.shah14@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pranav Shah","role":"PATIENT","date_of_birth":"1963-03-31","sex":"MALE","city":"Navi Mumbai"}'::jsonb),
('dbf4cecd-3db5-4040-9bdd-3dbb8f307a89', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rohan.sharma15@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rohan Sharma","role":"PATIENT","date_of_birth":"1990-06-11","sex":"MALE","city":"Pune"}'::jsonb),
('8da40304-eea3-42cb-b8df-c516b4e5bbd4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pranav.deshmukh16@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pranav Deshmukh","role":"PATIENT","date_of_birth":"2011-12-24","sex":"MALE","city":"Mumbai"}'::jsonb),
('97409ee5-94dc-43de-b792-9333b6fd2313', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aarti.shah17@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarti Shah","role":"PATIENT","date_of_birth":"1996-12-31","sex":"FEMALE","city":"Pune"}'::jsonb),
('65a3f505-0fd9-449e-9dd6-e6fd674ff053', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sameer.shah18@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sameer Shah","role":"PATIENT","date_of_birth":"1989-04-29","sex":"MALE","city":"Pune"}'::jsonb),
('ff94a230-bd9c-43a9-b7a0-2f6a9e91ef40', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.meera.malhotra19@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Meera Malhotra","role":"PATIENT","date_of_birth":"1960-10-25","sex":"FEMALE","city":"Pune"}'::jsonb),
('9529b452-32f3-47bd-af20-8eab28fe8077', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.karan.kulkarni20@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Karan Kulkarni","role":"PATIENT","date_of_birth":"1999-05-04","sex":"MALE","city":"Mumbai"}'::jsonb),
('98a4a8c6-7221-4a74-a01a-9e9499ce7605', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rohan.joshi21@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rohan Joshi","role":"PATIENT","date_of_birth":"1985-07-06","sex":"MALE","city":"Pune"}'::jsonb),
('22285d42-0b5b-4446-afd0-b3a64590cf57', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sneha.pillai22@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sneha Pillai","role":"PATIENT","date_of_birth":"2005-06-04","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('13b19ae3-5f14-429d-9fbb-aa64b8031369', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.kunal.patel23@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Kunal Patel","role":"PATIENT","date_of_birth":"2003-07-14","sex":"MALE","city":"Mumbai"}'::jsonb),
('6a813809-2198-4c92-a561-fa2498e09d3f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aarav.deshmukh24@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarav Deshmukh","role":"PATIENT","date_of_birth":"2000-11-11","sex":"MALE","city":"Thane"}'::jsonb),
('b584b924-1520-48bd-a86e-d37e63036924', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.shreya.reddy25@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Shreya Reddy","role":"PATIENT","date_of_birth":"1980-10-21","sex":"FEMALE","city":"Thane"}'::jsonb),
('177a52f9-05dc-418a-b1fe-35b3a815399d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.vikram.deshmukh26@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Vikram Deshmukh","role":"PATIENT","date_of_birth":"1961-08-01","sex":"MALE","city":"Pune"}'::jsonb),
('c1ea1340-8cd7-411d-90c9-a90e9938e6b2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rahul.reddy27@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rahul Reddy","role":"PATIENT","date_of_birth":"2007-08-25","sex":"MALE","city":"Thane"}'::jsonb),
('88af0bcf-e1ed-4f75-8f71-8a4ef6a22763', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.aarti.iyer28@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Aarti Iyer","role":"PATIENT","date_of_birth":"1997-03-08","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('444453bc-312e-4ed4-9b47-b8c30bd75889', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.shreya.iyer29@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Shreya Iyer","role":"PATIENT","date_of_birth":"1963-11-20","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('c1869983-eaed-4a1a-8c39-fc42b0b07c77', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sameer.kulkarni30@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sameer Kulkarni","role":"PATIENT","date_of_birth":"1972-03-18","sex":"MALE","city":"Mumbai"}'::jsonb),
('4d119d75-0c34-47d9-ac4f-87339df3045c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.neha.malhotra31@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Neha Malhotra","role":"PATIENT","date_of_birth":"2006-04-16","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('65483775-84e2-45c3-bc95-a9b867ea13b3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.vikram.nair32@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Vikram Nair","role":"PATIENT","date_of_birth":"2001-09-07","sex":"MALE","city":"Navi Mumbai"}'::jsonb),
('ab2a0bd4-e19c-4044-86fc-3277327e8605', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.deepa.deshmukh33@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Deepa Deshmukh","role":"PATIENT","date_of_birth":"2006-03-12","sex":"FEMALE","city":"Pune"}'::jsonb),
('1563173f-6ac5-47a4-aa7c-1b0eb089e2d0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rahul.nair34@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rahul Nair","role":"PATIENT","date_of_birth":"2000-11-10","sex":"MALE","city":"Mumbai"}'::jsonb),
('67a601ba-9c7d-4bb2-aa0a-62625065c867', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.sameer.verma35@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Sameer Verma","role":"PATIENT","date_of_birth":"1965-05-28","sex":"MALE","city":"Pune"}'::jsonb),
('af28ebfc-d153-4e8f-8bce-870d1f15847a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.vikram.shah36@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Vikram Shah","role":"PATIENT","date_of_birth":"2005-04-05","sex":"MALE","city":"Thane"}'::jsonb),
('60f02880-c2e8-423a-a931-cb71ac64d511', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.siddharth.gupta37@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Siddharth Gupta","role":"PATIENT","date_of_birth":"2006-05-12","sex":"MALE","city":"Thane"}'::jsonb),
('622a59c7-a707-4196-854d-11ec526668cb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.rhea.patel38@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Rhea Patel","role":"PATIENT","date_of_birth":"1960-12-12","sex":"FEMALE","city":"Mumbai"}'::jsonb),
('3116601f-6704-4c82-8c0a-3001df0251ca', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.gaurav.rao39@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Gaurav Rao","role":"PATIENT","date_of_birth":"1988-07-03","sex":"MALE","city":"Mumbai"}'::jsonb),
('77261b21-841c-48f3-9f1f-9db6cf0a64ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.kavita.kapoor40@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Kavita Kapoor","role":"PATIENT","date_of_birth":"1973-01-18","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('0a01e398-e276-4823-99eb-d8a01b47dcb6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.divya.joshi41@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Divya Joshi","role":"PATIENT","date_of_birth":"1998-12-18","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('3d003b6f-24ab-496e-b196-ba629494f0bc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.divya.shah42@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Divya Shah","role":"PATIENT","date_of_birth":"1972-07-12","sex":"FEMALE","city":"Mumbai"}'::jsonb),
('f788574c-c5b8-4ea1-8fed-e3476c7b5975', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.meera.sharma43@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Meera Sharma","role":"PATIENT","date_of_birth":"2001-05-31","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('780108dd-1649-4594-ae5d-f88b0e2df580', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.siddharth.sharma44@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Siddharth Sharma","role":"PATIENT","date_of_birth":"1997-03-16","sex":"MALE","city":"Thane"}'::jsonb),
('f08ef0f6-5a33-4452-9670-29908d095b13', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.amit.kulkarni45@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Amit Kulkarni","role":"PATIENT","date_of_birth":"1995-04-07","sex":"MALE","city":"Pune"}'::jsonb),
('85ab7552-09c7-4962-a5f9-4bf4dace13ec', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pooja.deshmukh46@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pooja Deshmukh","role":"PATIENT","date_of_birth":"1995-01-13","sex":"FEMALE","city":"Mumbai"}'::jsonb),
('824ceea7-636e-48a8-b0b2-bfb03ddd71ae', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.nikhil.kapoor47@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Nikhil Kapoor","role":"PATIENT","date_of_birth":"2009-01-10","sex":"MALE","city":"Pune"}'::jsonb),
('077a7b5b-fe54-4ba2-afc4-2feba5c39f0f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pranav.shah48@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pranav Shah","role":"PATIENT","date_of_birth":"1981-08-18","sex":"MALE","city":"Pune"}'::jsonb),
('58997b2e-7131-4bdb-be36-a651ec2cd5b1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.neha.iyer49@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Neha Iyer","role":"PATIENT","date_of_birth":"1979-12-23","sex":"FEMALE","city":"Thane"}'::jsonb),
('c67950a4-9042-44ac-a803-a6ac44403b26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.isha.pillai50@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Isha Pillai","role":"PATIENT","date_of_birth":"1980-01-10","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('a5c411a5-6c8a-46f9-8386-8ece5057a25c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pranav.kapoor51@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pranav Kapoor","role":"PATIENT","date_of_birth":"1988-01-19","sex":"MALE","city":"Thane"}'::jsonb),
('411af5df-afd3-40b2-a90a-415ada74659c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.kavita.sharma52@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Kavita Sharma","role":"PATIENT","date_of_birth":"2002-09-22","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('9f516081-73de-48fd-bd12-1cfe5e5a2427', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.tanvi.reddy53@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Tanvi Reddy","role":"PATIENT","date_of_birth":"2011-12-30","sex":"FEMALE","city":"Pune"}'::jsonb),
('49d947fd-0889-4621-8b91-ed9a1d42f300', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.ananya.gupta54@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Ananya Gupta","role":"PATIENT","date_of_birth":"1971-12-11","sex":"FEMALE","city":"Navi Mumbai"}'::jsonb),
('0f776b4d-7647-42e6-b381-1eff1e83fefe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.pooja.verma55@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Pooja Verma","role":"PATIENT","date_of_birth":"1987-10-07","sex":"FEMALE","city":"Mumbai"}'::jsonb),
('7c08f0db-3104-4bf0-8eb1-48bd9cd29eb3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.tanvi.pillai56@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Tanvi Pillai","role":"PATIENT","date_of_birth":"1994-02-25","sex":"FEMALE","city":"Thane"}'::jsonb),
('8d54c37a-1d70-4143-bd95-105f99c2b0c9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.siddharth.gupta57@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Siddharth Gupta","role":"PATIENT","date_of_birth":"1961-03-01","sex":"MALE","city":"Pune"}'::jsonb),
('ab26e0b6-3a07-45b8-b303-7c82257ad717', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.isha.nair58@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Isha Nair","role":"PATIENT","date_of_birth":"2000-11-06","sex":"FEMALE","city":"Mumbai"}'::jsonb),
('7375c51c-f903-40e1-b5ea-936e04e4ff4e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patient.siddharth.pillai59@betterclinic.app', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', now(), now(), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"full_name":"Siddharth Pillai","role":"PATIENT","date_of_birth":"1970-10-05","sex":"MALE","city":"Thane"}'::jsonb)
on conflict (id) do update set email = excluded.email;

update public.profiles set is_synthetic = true where id in ('00000000-0000-0000-0000-000000000001','8b1371af-f849-4a9a-baad-8aca5537a6f4','fc993a40-1352-4f83-8137-a7cc7a87cade','3198214c-28e6-4f70-a35e-f32e638bfa98','5409916a-5a91-4153-b75d-f09d05e0f0d3','273814d7-f717-4cf4-b48d-7b365e070f7e','821c1a50-a35b-4908-b1e4-0b151a7caeac','dc77a594-6094-4cfd-b59f-39dd05cce495','0768e19b-6893-493a-b63b-342bb994f9d1','997803b4-42b8-4e2b-839d-d92b2345f70a','fbbbfaca-0a19-42d4-bb71-71761729b90d','d8ed7244-51d2-4c37-a462-98290c35c67e','234028c9-11d7-41a4-9a0d-403fbd90a5aa','5e0cb7aa-d7e2-42e8-a87d-c508cfe0fbad','f9ea4be0-27fb-46f3-a1a8-c1839e419c4c','dbf4cecd-3db5-4040-9bdd-3dbb8f307a89','8da40304-eea3-42cb-b8df-c516b4e5bbd4','97409ee5-94dc-43de-b792-9333b6fd2313','65a3f505-0fd9-449e-9dd6-e6fd674ff053','ff94a230-bd9c-43a9-b7a0-2f6a9e91ef40','9529b452-32f3-47bd-af20-8eab28fe8077','98a4a8c6-7221-4a74-a01a-9e9499ce7605','22285d42-0b5b-4446-afd0-b3a64590cf57','13b19ae3-5f14-429d-9fbb-aa64b8031369','6a813809-2198-4c92-a561-fa2498e09d3f','b584b924-1520-48bd-a86e-d37e63036924','177a52f9-05dc-418a-b1fe-35b3a815399d','c1ea1340-8cd7-411d-90c9-a90e9938e6b2','88af0bcf-e1ed-4f75-8f71-8a4ef6a22763','444453bc-312e-4ed4-9b47-b8c30bd75889','c1869983-eaed-4a1a-8c39-fc42b0b07c77','4d119d75-0c34-47d9-ac4f-87339df3045c','65483775-84e2-45c3-bc95-a9b867ea13b3','ab2a0bd4-e19c-4044-86fc-3277327e8605','1563173f-6ac5-47a4-aa7c-1b0eb089e2d0','67a601ba-9c7d-4bb2-aa0a-62625065c867','af28ebfc-d153-4e8f-8bce-870d1f15847a','60f02880-c2e8-423a-a931-cb71ac64d511','622a59c7-a707-4196-854d-11ec526668cb','3116601f-6704-4c82-8c0a-3001df0251ca','77261b21-841c-48f3-9f1f-9db6cf0a64ee','0a01e398-e276-4823-99eb-d8a01b47dcb6','3d003b6f-24ab-496e-b196-ba629494f0bc','f788574c-c5b8-4ea1-8fed-e3476c7b5975','780108dd-1649-4594-ae5d-f88b0e2df580','f08ef0f6-5a33-4452-9670-29908d095b13','85ab7552-09c7-4962-a5f9-4bf4dace13ec','824ceea7-636e-48a8-b0b2-bfb03ddd71ae','077a7b5b-fe54-4ba2-afc4-2feba5c39f0f','58997b2e-7131-4bdb-be36-a651ec2cd5b1','c67950a4-9042-44ac-a803-a6ac44403b26','a5c411a5-6c8a-46f9-8386-8ece5057a25c','411af5df-afd3-40b2-a90a-415ada74659c','9f516081-73de-48fd-bd12-1cfe5e5a2427','49d947fd-0889-4621-8b91-ed9a1d42f300','0f776b4d-7647-42e6-b381-1eff1e83fefe','7c08f0db-3104-4bf0-8eb1-48bd9cd29eb3','8d54c37a-1d70-4143-bd95-105f99c2b0c9','ab26e0b6-3a07-45b8-b303-7c82257ad717','7375c51c-f903-40e1-b5ea-936e04e4ff4e');
update public.profile_roles set is_synthetic = true where profile_id in ('00000000-0000-0000-0000-000000000001','8b1371af-f849-4a9a-baad-8aca5537a6f4','fc993a40-1352-4f83-8137-a7cc7a87cade','3198214c-28e6-4f70-a35e-f32e638bfa98','5409916a-5a91-4153-b75d-f09d05e0f0d3','273814d7-f717-4cf4-b48d-7b365e070f7e','821c1a50-a35b-4908-b1e4-0b151a7caeac','dc77a594-6094-4cfd-b59f-39dd05cce495','0768e19b-6893-493a-b63b-342bb994f9d1','997803b4-42b8-4e2b-839d-d92b2345f70a','fbbbfaca-0a19-42d4-bb71-71761729b90d','d8ed7244-51d2-4c37-a462-98290c35c67e','234028c9-11d7-41a4-9a0d-403fbd90a5aa','5e0cb7aa-d7e2-42e8-a87d-c508cfe0fbad','f9ea4be0-27fb-46f3-a1a8-c1839e419c4c','dbf4cecd-3db5-4040-9bdd-3dbb8f307a89','8da40304-eea3-42cb-b8df-c516b4e5bbd4','97409ee5-94dc-43de-b792-9333b6fd2313','65a3f505-0fd9-449e-9dd6-e6fd674ff053','ff94a230-bd9c-43a9-b7a0-2f6a9e91ef40','9529b452-32f3-47bd-af20-8eab28fe8077','98a4a8c6-7221-4a74-a01a-9e9499ce7605','22285d42-0b5b-4446-afd0-b3a64590cf57','13b19ae3-5f14-429d-9fbb-aa64b8031369','6a813809-2198-4c92-a561-fa2498e09d3f','b584b924-1520-48bd-a86e-d37e63036924','177a52f9-05dc-418a-b1fe-35b3a815399d','c1ea1340-8cd7-411d-90c9-a90e9938e6b2','88af0bcf-e1ed-4f75-8f71-8a4ef6a22763','444453bc-312e-4ed4-9b47-b8c30bd75889','c1869983-eaed-4a1a-8c39-fc42b0b07c77','4d119d75-0c34-47d9-ac4f-87339df3045c','65483775-84e2-45c3-bc95-a9b867ea13b3','ab2a0bd4-e19c-4044-86fc-3277327e8605','1563173f-6ac5-47a4-aa7c-1b0eb089e2d0','67a601ba-9c7d-4bb2-aa0a-62625065c867','af28ebfc-d153-4e8f-8bce-870d1f15847a','60f02880-c2e8-423a-a931-cb71ac64d511','622a59c7-a707-4196-854d-11ec526668cb','3116601f-6704-4c82-8c0a-3001df0251ca','77261b21-841c-48f3-9f1f-9db6cf0a64ee','0a01e398-e276-4823-99eb-d8a01b47dcb6','3d003b6f-24ab-496e-b196-ba629494f0bc','f788574c-c5b8-4ea1-8fed-e3476c7b5975','780108dd-1649-4594-ae5d-f88b0e2df580','f08ef0f6-5a33-4452-9670-29908d095b13','85ab7552-09c7-4962-a5f9-4bf4dace13ec','824ceea7-636e-48a8-b0b2-bfb03ddd71ae','077a7b5b-fe54-4ba2-afc4-2feba5c39f0f','58997b2e-7131-4bdb-be36-a651ec2cd5b1','c67950a4-9042-44ac-a803-a6ac44403b26','a5c411a5-6c8a-46f9-8386-8ece5057a25c','411af5df-afd3-40b2-a90a-415ada74659c','9f516081-73de-48fd-bd12-1cfe5e5a2427','49d947fd-0889-4621-8b91-ed9a1d42f300','0f776b4d-7647-42e6-b381-1eff1e83fefe','7c08f0db-3104-4bf0-8eb1-48bd9cd29eb3','8d54c37a-1d70-4143-bd95-105f99c2b0c9','ab26e0b6-3a07-45b8-b303-7c82257ad717','7375c51c-f903-40e1-b5ea-936e04e4ff4e');

insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('00000000-0000-0000-0000-000000000001', '1994-08-14', 'MALE'::public.sex, 'O+', 'Flat 402, Lotus Heights, Andheri West', 'Mumbai', 'Andheri', '400053', 'Family Member', '+919636302276', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('8b1371af-f849-4a9a-baad-8aca5537a6f4', '1990-03-24', 'FEMALE'::public.sex, 'AB+', 'Flat 715, Tower B, Manpada', 'Thane', 'Manpada', '405707', 'Family Member', '+919134898053', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('fc993a40-1352-4f83-8137-a7cc7a87cade', '1998-09-10', 'FEMALE'::public.sex, 'O+', 'Flat 721, Tower C, Belapur', 'Navi Mumbai', 'Belapur', '403174', 'Family Member', '+918462930317', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('3198214c-28e6-4f70-a35e-f32e638bfa98', '2003-12-28', 'MALE'::public.sex, 'O+', 'Flat 757, Tower C, Manpada', 'Thane', 'Manpada', '408010', 'Family Member', '+918682356120', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('5409916a-5a91-4153-b75d-f09d05e0f0d3', '2004-02-09', 'MALE'::public.sex, 'O-', 'Flat 534, Tower C, Kasarvadavali', 'Thane', 'Kasarvadavali', '410705', 'Family Member', '+918893750937', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('273814d7-f717-4cf4-b48d-7b365e070f7e', '1971-01-12', 'MALE'::public.sex, 'A-', 'Flat 889, Tower B, Nerul', 'Navi Mumbai', 'Nerul', '402038', 'Family Member', '+918889074496', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('821c1a50-a35b-4908-b1e4-0b151a7caeac', '1986-05-24', 'FEMALE'::public.sex, 'O+', 'Flat 1028, Tower A, Panvel', 'Navi Mumbai', 'Panvel', '403963', 'Family Member', '+919919857287', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('dc77a594-6094-4cfd-b59f-39dd05cce495', '1994-04-19', 'MALE'::public.sex, 'O+', 'Flat 510, Tower B, Dadar', 'Mumbai', 'Dadar', '403434', 'Family Member', '+919869451559', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('0768e19b-6893-493a-b63b-342bb994f9d1', '1976-06-26', 'MALE'::public.sex, 'O+', 'Flat 522, Tower B, Powai', 'Mumbai', 'Powai', '401704', 'Family Member', '+919548898800', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('997803b4-42b8-4e2b-839d-d92b2345f70a', '1964-01-12', 'MALE'::public.sex, 'B-', 'Flat 352, Tower A, Viman Nagar', 'Pune', 'Viman Nagar', '407646', 'Family Member', '+918699452037', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('fbbbfaca-0a19-42d4-bb71-71761729b90d', '1988-10-11', 'MALE'::public.sex, 'O+', 'Flat 698, Tower A, Kasarvadavali', 'Thane', 'Kasarvadavali', '405324', 'Family Member', '+918413980729', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('d8ed7244-51d2-4c37-a462-98290c35c67e', '1986-08-30', 'FEMALE'::public.sex, 'AB+', 'Flat 349, Tower A, Bandra', 'Mumbai', 'Bandra', '406130', 'Family Member', '+918642503622', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('234028c9-11d7-41a4-9a0d-403fbd90a5aa', '1990-02-25', 'MALE'::public.sex, 'B+', 'Flat 638, Tower B, Panvel', 'Navi Mumbai', 'Panvel', '400222', 'Family Member', '+918647065632', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('5e0cb7aa-d7e2-42e8-a87d-c508cfe0fbad', '1971-12-18', 'MALE'::public.sex, 'O+', 'Flat 330, Tower B, Andheri', 'Mumbai', 'Andheri', '400491', 'Family Member', '+918416223644', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('f9ea4be0-27fb-46f3-a1a8-c1839e419c4c', '1963-03-31', 'MALE'::public.sex, 'AB+', 'Flat 317, Tower B, Kharghar', 'Navi Mumbai', 'Kharghar', '410333', 'Family Member', '+918492658069', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('dbf4cecd-3db5-4040-9bdd-3dbb8f307a89', '1990-06-11', 'MALE'::public.sex, 'A+', 'Flat 234, Tower C, Hinjewadi', 'Pune', 'Hinjewadi', '403494', 'Family Member', '+919677007094', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('8da40304-eea3-42cb-b8df-c516b4e5bbd4', '2011-12-24', 'MALE'::public.sex, 'B-', 'Flat 296, Tower B, Chembur', 'Mumbai', 'Chembur', '406945', 'Family Member', '+918480053743', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('97409ee5-94dc-43de-b792-9333b6fd2313', '1996-12-31', 'FEMALE'::public.sex, 'AB-', 'Flat 946, Tower C, Kothrud', 'Pune', 'Kothrud', '404859', 'Family Member', '+918652007208', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('65a3f505-0fd9-449e-9dd6-e6fd674ff053', '1989-04-29', 'MALE'::public.sex, 'A-', 'Flat 937, Tower C, Viman Nagar', 'Pune', 'Viman Nagar', '403297', 'Family Member', '+917774934354', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('ff94a230-bd9c-43a9-b7a0-2f6a9e91ef40', '1960-10-25', 'FEMALE'::public.sex, 'O-', 'Flat 228, Tower C, Aundh', 'Pune', 'Aundh', '401280', 'Family Member', '+919920539891', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('9529b452-32f3-47bd-af20-8eab28fe8077', '1999-05-04', 'MALE'::public.sex, 'AB+', 'Flat 1134, Tower A, Chembur', 'Mumbai', 'Chembur', '403445', 'Family Member', '+918823589395', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('98a4a8c6-7221-4a74-a01a-9e9499ce7605', '1985-07-06', 'MALE'::public.sex, 'O-', 'Flat 322, Tower B, Baner', 'Pune', 'Baner', '402273', 'Family Member', '+919579443207', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('22285d42-0b5b-4446-afd0-b3a64590cf57', '2005-06-04', 'FEMALE'::public.sex, 'O-', 'Flat 972, Tower B, Panvel', 'Navi Mumbai', 'Panvel', '404318', 'Family Member', '+919875546162', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('13b19ae3-5f14-429d-9fbb-aa64b8031369', '2003-07-14', 'MALE'::public.sex, 'B-', 'Flat 705, Tower C, Dadar', 'Mumbai', 'Dadar', '400805', 'Family Member', '+919629423214', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('6a813809-2198-4c92-a561-fa2498e09d3f', '2000-11-11', 'MALE'::public.sex, 'A-', 'Flat 601, Tower C, Majiwada', 'Thane', 'Majiwada', '406743', 'Family Member', '+919762889206', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('b584b924-1520-48bd-a86e-d37e63036924', '1980-10-21', 'FEMALE'::public.sex, 'A+', 'Flat 309, Tower C, Vartak Nagar', 'Thane', 'Vartak Nagar', '408148', 'Family Member', '+919391917356', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('177a52f9-05dc-418a-b1fe-35b3a815399d', '1961-08-01', 'MALE'::public.sex, 'A+', 'Flat 822, Tower B, Baner', 'Pune', 'Baner', '402302', 'Family Member', '+917567050501', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('c1ea1340-8cd7-411d-90c9-a90e9938e6b2', '2007-08-25', 'MALE'::public.sex, 'O+', 'Flat 351, Tower B, Manpada', 'Thane', 'Manpada', '409312', 'Family Member', '+919398506706', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('88af0bcf-e1ed-4f75-8f71-8a4ef6a22763', '1997-03-08', 'FEMALE'::public.sex, 'A-', 'Flat 995, Tower B, Kharghar', 'Navi Mumbai', 'Kharghar', '402319', 'Family Member', '+919766351555', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('444453bc-312e-4ed4-9b47-b8c30bd75889', '1963-11-20', 'FEMALE'::public.sex, 'A-', 'Flat 1170, Tower C, Nerul', 'Navi Mumbai', 'Nerul', '404805', 'Family Member', '+918817408266', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('c1869983-eaed-4a1a-8c39-fc42b0b07c77', '1972-03-18', 'MALE'::public.sex, 'A+', 'Flat 870, Tower A, Andheri', 'Mumbai', 'Andheri', '409517', 'Family Member', '+919810078725', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('4d119d75-0c34-47d9-ac4f-87339df3045c', '2006-04-16', 'FEMALE'::public.sex, 'O-', 'Flat 783, Tower B, Belapur', 'Navi Mumbai', 'Belapur', '406125', 'Family Member', '+919624078611', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('65483775-84e2-45c3-bc95-a9b867ea13b3', '2001-09-07', 'MALE'::public.sex, 'A-', 'Flat 836, Tower C, Panvel', 'Navi Mumbai', 'Panvel', '409718', 'Family Member', '+919667372992', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('ab2a0bd4-e19c-4044-86fc-3277327e8605', '2006-03-12', 'FEMALE'::public.sex, 'A+', 'Flat 687, Tower B, Baner', 'Pune', 'Baner', '407077', 'Family Member', '+918455460100', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('1563173f-6ac5-47a4-aa7c-1b0eb089e2d0', '2000-11-10', 'MALE'::public.sex, 'AB-', 'Flat 584, Tower C, Bandra', 'Mumbai', 'Bandra', '405652', 'Family Member', '+919711715431', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('67a601ba-9c7d-4bb2-aa0a-62625065c867', '1965-05-28', 'MALE'::public.sex, 'AB-', 'Flat 138, Tower A, Aundh', 'Pune', 'Aundh', '408264', 'Family Member', '+918769900924', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('af28ebfc-d153-4e8f-8bce-870d1f15847a', '2005-04-05', 'MALE'::public.sex, 'B+', 'Flat 595, Tower A, Majiwada', 'Thane', 'Majiwada', '404514', 'Family Member', '+919754289641', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('60f02880-c2e8-423a-a931-cb71ac64d511', '2006-05-12', 'MALE'::public.sex, 'O-', 'Flat 989, Tower C, Naupada', 'Thane', 'Naupada', '406369', 'Family Member', '+917797280228', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('622a59c7-a707-4196-854d-11ec526668cb', '1960-12-12', 'FEMALE'::public.sex, 'O+', 'Flat 937, Tower C, Andheri', 'Mumbai', 'Andheri', '403429', 'Family Member', '+918462002372', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('3116601f-6704-4c82-8c0a-3001df0251ca', '1988-07-03', 'MALE'::public.sex, 'AB+', 'Flat 1002, Tower A, Borivali', 'Mumbai', 'Borivali', '403449', 'Family Member', '+918786369556', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('77261b21-841c-48f3-9f1f-9db6cf0a64ee', '1973-01-18', 'FEMALE'::public.sex, 'O+', 'Flat 691, Tower B, Nerul', 'Navi Mumbai', 'Nerul', '406015', 'Family Member', '+917558443609', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('0a01e398-e276-4823-99eb-d8a01b47dcb6', '1998-12-18', 'FEMALE'::public.sex, 'O-', 'Flat 1033, Tower C, Vashi', 'Navi Mumbai', 'Vashi', '403121', 'Family Member', '+919528961885', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('3d003b6f-24ab-496e-b196-ba629494f0bc', '1972-07-12', 'FEMALE'::public.sex, 'AB+', 'Flat 194, Tower A, Bandra', 'Mumbai', 'Bandra', '403709', 'Family Member', '+919868567358', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('f788574c-c5b8-4ea1-8fed-e3476c7b5975', '2001-05-31', 'FEMALE'::public.sex, 'B+', 'Flat 685, Tower A, Belapur', 'Navi Mumbai', 'Belapur', '404664', 'Family Member', '+919652799481', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('780108dd-1649-4594-ae5d-f88b0e2df580', '1997-03-16', 'MALE'::public.sex, 'B+', 'Flat 598, Tower A, Ghodbunder Road', 'Thane', 'Ghodbunder Road', '410277', 'Family Member', '+918690374388', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('f08ef0f6-5a33-4452-9670-29908d095b13', '1995-04-07', 'MALE'::public.sex, 'A-', 'Flat 119, Tower B, Baner', 'Pune', 'Baner', '406111', 'Family Member', '+919717831828', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('85ab7552-09c7-4962-a5f9-4bf4dace13ec', '1995-01-13', 'FEMALE'::public.sex, 'AB+', 'Flat 742, Tower B, Powai', 'Mumbai', 'Powai', '405854', 'Family Member', '+918699378168', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('824ceea7-636e-48a8-b0b2-bfb03ddd71ae', '2009-01-10', 'MALE'::public.sex, 'O-', 'Flat 258, Tower B, Aundh', 'Pune', 'Aundh', '405261', 'Family Member', '+918762834898', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('077a7b5b-fe54-4ba2-afc4-2feba5c39f0f', '1981-08-18', 'MALE'::public.sex, 'B-', 'Flat 151, Tower A, Viman Nagar', 'Pune', 'Viman Nagar', '400459', 'Family Member', '+919814135266', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('58997b2e-7131-4bdb-be36-a651ec2cd5b1', '1979-12-23', 'FEMALE'::public.sex, 'O-', 'Flat 313, Tower C, Ghodbunder Road', 'Thane', 'Ghodbunder Road', '409671', 'Family Member', '+918461922988', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('c67950a4-9042-44ac-a803-a6ac44403b26', '1980-01-10', 'FEMALE'::public.sex, 'B+', 'Flat 468, Tower B, Kharghar', 'Navi Mumbai', 'Kharghar', '407036', 'Family Member', '+919123621449', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('a5c411a5-6c8a-46f9-8386-8ece5057a25c', '1988-01-19', 'MALE'::public.sex, 'A-', 'Flat 344, Tower A, Majiwada', 'Thane', 'Majiwada', '400377', 'Family Member', '+919722984388', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('411af5df-afd3-40b2-a90a-415ada74659c', '2002-09-22', 'FEMALE'::public.sex, 'AB-', 'Flat 861, Tower B, Vashi', 'Navi Mumbai', 'Vashi', '401382', 'Family Member', '+917779734732', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('9f516081-73de-48fd-bd12-1cfe5e5a2427', '2011-12-30', 'FEMALE'::public.sex, 'AB+', 'Flat 1126, Tower B, Viman Nagar', 'Pune', 'Viman Nagar', '404041', 'Family Member', '+918662572130', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('49d947fd-0889-4621-8b91-ed9a1d42f300', '1971-12-11', 'FEMALE'::public.sex, 'O+', 'Flat 693, Tower C, Kharghar', 'Navi Mumbai', 'Kharghar', '401544', 'Family Member', '+919780706631', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('0f776b4d-7647-42e6-b381-1eff1e83fefe', '1987-10-07', 'FEMALE'::public.sex, 'A+', 'Flat 223, Tower C, Juhu', 'Mumbai', 'Juhu', '408334', 'Family Member', '+918654281064', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('7c08f0db-3104-4bf0-8eb1-48bd9cd29eb3', '1994-02-25', 'FEMALE'::public.sex, 'O-', 'Flat 597, Tower C, Vartak Nagar', 'Thane', 'Vartak Nagar', '401495', 'Family Member', '+919743702878', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('8d54c37a-1d70-4143-bd95-105f99c2b0c9', '1961-03-01', 'MALE'::public.sex, 'A-', 'Flat 827, Tower A, Baner', 'Pune', 'Baner', '407832', 'Family Member', '+918860142510', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('ab26e0b6-3a07-45b8-b303-7c82257ad717', '2000-11-06', 'FEMALE'::public.sex, 'B-', 'Flat 860, Tower A, Borivali', 'Mumbai', 'Borivali', '402196', 'Family Member', '+919837394825', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;
insert into public.patients (id, date_of_birth, sex, blood_group, address_line, city, area, pincode, emergency_contact_name, emergency_contact_phone, is_synthetic)
values ('7375c51c-f903-40e1-b5ea-936e04e4ff4e', '1970-10-05', 'MALE'::public.sex, 'O+', 'Flat 243, Tower A, Naupada', 'Thane', 'Naupada', '403656', 'Family Member', '+917567067736', true)
on conflict (id) do update set
  blood_group = excluded.blood_group,
  address_line = excluded.address_line,
  area = excluded.area,
  pincode = excluded.pincode,
  emergency_contact_name = excluded.emergency_contact_name,
  emergency_contact_phone = excluded.emergency_contact_phone,
  is_synthetic = true;

insert into public.medical_history (patient_id, record_type, title, description, is_active, is_synthetic) values
('00000000-0000-0000-0000-000000000001', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('8b1371af-f849-4a9a-baad-8aca5537a6f4', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('5409916a-5a91-4153-b75d-f09d05e0f0d3', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('821c1a50-a35b-4908-b1e4-0b151a7caeac', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('dc77a594-6094-4cfd-b59f-39dd05cce495', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('0768e19b-6893-493a-b63b-342bb994f9d1', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('d8ed7244-51d2-4c37-a462-98290c35c67e', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('8da40304-eea3-42cb-b8df-c516b4e5bbd4', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('65a3f505-0fd9-449e-9dd6-e6fd674ff053', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('22285d42-0b5b-4446-afd0-b3a64590cf57', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('13b19ae3-5f14-429d-9fbb-aa64b8031369', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('6a813809-2198-4c92-a561-fa2498e09d3f', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('c1ea1340-8cd7-411d-90c9-a90e9938e6b2', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('622a59c7-a707-4196-854d-11ec526668cb', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('3d003b6f-24ab-496e-b196-ba629494f0bc', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('780108dd-1649-4594-ae5d-f88b0e2df580', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('85ab7552-09c7-4962-a5f9-4bf4dace13ec', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('824ceea7-636e-48a8-b0b2-bfb03ddd71ae', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('077a7b5b-fe54-4ba2-afc4-2feba5c39f0f', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('a5c411a5-6c8a-46f9-8386-8ece5057a25c', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('411af5df-afd3-40b2-a90a-415ada74659c', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('9f516081-73de-48fd-bd12-1cfe5e5a2427', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('ab26e0b6-3a07-45b8-b303-7c82257ad717', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true),
('7375c51c-f903-40e1-b5ea-936e04e4ff4e', 'ALLERGY'::public.medical_history_type, 'Penicillin Sensitivity', 'Mild skin rash reported in 2021', true, true);
