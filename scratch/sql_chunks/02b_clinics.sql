
      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 'Apollo Polyclinic (Colaba)', 'Modern healthcare facility in Colaba, Mumbai offering outpatient and diagnostic care.', 'Shop No. 18, Sector 13, Colaba Road', 'Mumbai', 'Colaba', '424456', '+919822443542', 'contact@apollo-colaba.in', 4.83, 100, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 'APOL495')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'APOL495';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a312e21a-1f7c-46df-a593-15baf99a85d8', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 'United Medical Centre (Kurla)', 'Modern healthcare facility in Kurla, Mumbai offering outpatient and diagnostic care.', 'Shop No. 16, Sector 3, Kurla Road', 'Mumbai', 'Kurla', '410198', '+918825396195', 'contact@united-kurla.in', 4.42, 62, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 'UNIT682')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'UNIT682';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('acf4854e-b4fd-43b1-9c4e-15d2c3003880', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 'Family Medical Centre (Chembur)', 'Modern healthcare facility in Chembur, Mumbai offering outpatient and diagnostic care.', 'Shop No. 6, Sector 19, Chembur Road', 'Mumbai', 'Chembur', '400569', '+919134391624', 'contact@family-chembur.in', 4.83, 79, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 'FAMI739')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'FAMI739';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b02f15c5-8dff-435c-a749-30f268deec03', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'Aarogya Nursing Home (Sion)', 'Modern healthcare facility in Sion, Mumbai offering outpatient and diagnostic care.', 'Shop No. 30, Sector 3, Sion Road', 'Mumbai', 'Sion', '405696', '+918698410207', 'contact@aarogya-sion.in', 4.65, 101, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'AARO612')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'AARO612';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 'Apollo Day Care Centre (Wadala)', 'Modern healthcare facility in Wadala, Mumbai offering outpatient and diagnostic care.', 'Shop No. 17, Sector 1, Wadala Road', 'Mumbai', 'Wadala', '415009', '+919461950823', 'contact@apollo-wadala.in', 4.27, 131, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 'APOL103')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'APOL103';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 'Metro Multispeciality Clinic (Ghodbunder Road)', 'Modern healthcare facility in Ghodbunder Road, Thane offering outpatient and diagnostic care.', 'Shop No. 16, Sector 10, Ghodbunder Road Road', 'Thane', 'Ghodbunder Road', '403827', '+918720018093', 'contact@metro-ghodbunder-road.in', 4.68, 95, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 'METR128')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'METR128';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('80798686-5ecd-47e3-8dfa-334fac68fbe8', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 'Prime Nursing Home (Majiwada)', 'Modern healthcare facility in Majiwada, Thane offering outpatient and diagnostic care.', 'Shop No. 37, Sector 3, Majiwada Road', 'Thane', 'Majiwada', '408053', '+919122066769', 'contact@prime-majiwada.in', 4.87, 91, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 'PRIM194')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'PRIM194';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9c795e23-a828-476e-8c4b-9d855cd3e8bf', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 'Global Multispeciality Clinic (Kasarvadavali)', 'Modern healthcare facility in Kasarvadavali, Thane offering outpatient and diagnostic care.', 'Shop No. 17, Sector 20, Kasarvadavali Road', 'Thane', 'Kasarvadavali', '413512', '+917731832232', 'contact@global-kasarvadavali.in', 4.12, 99, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 'GLOB118')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'GLOB118';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('93fb326b-2edc-4ee6-9608-64409c5babda', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 'MediLife Hospital (Hiranandani Estate)', 'Modern healthcare facility in Hiranandani Estate, Thane offering outpatient and diagnostic care.', 'Shop No. 33, Sector 19, Hiranandani Estate Road', 'Thane', 'Hiranandani Estate', '404636', '+919812755732', 'contact@medilife-hiranandani-estate.in', 4.48, 88, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 'MEDI183')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'MEDI183';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('8111f72e-b4ea-4362-9cf5-ef69a793fd73', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 'Advanced Day Care Centre (Pokhran Road)', 'Modern healthcare facility in Pokhran Road, Thane offering outpatient and diagnostic care.', 'Shop No. 11, Sector 16, Pokhran Road Road', 'Thane', 'Pokhran Road', '417582', '+919560410208', 'contact@advanced-pokhran-road.in', 4.72, 70, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 'ADVA611')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'ADVA611';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 'Apollo Hospital (Wagle Estate)', 'Modern healthcare facility in Wagle Estate, Thane offering outpatient and diagnostic care.', 'Shop No. 19, Sector 3, Wagle Estate Road', 'Thane', 'Wagle Estate', '421889', '+918675108626', 'contact@apollo-wagle-estate.in', 4.58, 130, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 'APOL435')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'APOL435';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 'Aarogya Health Centre (Naupada)', 'Modern healthcare facility in Naupada, Thane offering outpatient and diagnostic care.', 'Shop No. 26, Sector 10, Naupada Road', 'Thane', 'Naupada', '415749', '+919914684092', 'contact@aarogya-naupada.in', 4.57, 35, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 'AARO935')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'AARO935';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 'MediLife Multispeciality Clinic (Manpada)', 'Modern healthcare facility in Manpada, Thane offering outpatient and diagnostic care.', 'Shop No. 31, Sector 5, Manpada Road', 'Thane', 'Manpada', '403987', '+917525277969', 'contact@medilife-manpada.in', 4.53, 25, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 'MEDI309')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'MEDI309';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bd5f1196-97fe-4f16-bb6d-d32f3d3503ad', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 'National Hospital (Balkum)', 'Modern healthcare facility in Balkum, Thane offering outpatient and diagnostic care.', 'Shop No. 15, Sector 5, Balkum Road', 'Thane', 'Balkum', '412025', '+919685853645', 'contact@national-balkum.in', 4.52, 121, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 'NATI460')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'NATI460';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a04ba937-d27c-47e1-aab1-b2140fa4bf4c', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 'United Hospital (Kolshet)', 'Modern healthcare facility in Kolshet, Thane offering outpatient and diagnostic care.', 'Shop No. 35, Sector 3, Kolshet Road', 'Thane', 'Kolshet', '407535', '+919574839194', 'contact@united-kolshet.in', 4.63, 58, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 'UNIT294')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'UNIT294';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('135684f5-efca-43a9-8468-b8e1c5ad7fe7', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      