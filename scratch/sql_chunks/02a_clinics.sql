
      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 'Sai Polyclinic (Andheri)', 'Modern healthcare facility in Andheri, Mumbai offering outpatient and diagnostic care.', 'Shop No. 2, Sector 7, Andheri Road', 'Mumbai', 'Andheri', '419335', '+918445541654', 'contact@sai-andheri.in', 4.83, 35, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 'SAI970')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'SAI970';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 'Elite Nursing Home (Bandra)', 'Modern healthcare facility in Bandra, Mumbai offering outpatient and diagnostic care.', 'Shop No. 36, Sector 1, Bandra Road', 'Mumbai', 'Bandra', '424214', '+918789639845', 'contact@elite-bandra.in', 4.33, 144, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 'ELIT310')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'ELIT310';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('50f2fd47-2f9d-4c97-acc9-af5021fe2279', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 'Metro Hospital (Borivali)', 'Modern healthcare facility in Borivali, Mumbai offering outpatient and diagnostic care.', 'Shop No. 10, Sector 7, Borivali Road', 'Mumbai', 'Borivali', '404074', '+917742907759', 'contact@metro-borivali.in', 4.58, 50, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 'METR152')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'METR152';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('0edfc0fe-7703-4de8-817f-d35bd39e082a', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 'LifeLine Polyclinic (Dadar)', 'Modern healthcare facility in Dadar, Mumbai offering outpatient and diagnostic care.', 'Shop No. 30, Sector 3, Dadar Road', 'Mumbai', 'Dadar', '408409', '+919348229311', 'contact@lifeline-dadar.in', 4.42, 107, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 'LIFE211')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'LIFE211';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('edab5373-01f2-4df1-825e-14099f589ae8', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 'City Care Polyclinic (Goregaon)', 'Modern healthcare facility in Goregaon, Mumbai offering outpatient and diagnostic care.', 'Shop No. 6, Sector 1, Goregaon Road', 'Mumbai', 'Goregaon', '407707', '+919870904672', 'contact@city-care-goregaon.in', 4.37, 38, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 'CITY480')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'CITY480';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('177234ab-513d-4eeb-846f-84f768cc3f21', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 'CarePoint Hospital (Juhu)', 'Modern healthcare facility in Juhu, Mumbai offering outpatient and diagnostic care.', 'Shop No. 30, Sector 18, Juhu Road', 'Mumbai', 'Juhu', '400371', '+917559312916', 'contact@carepoint-juhu.in', 4.41, 73, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 'CARE252')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'CARE252';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('06165788-d672-4bcc-a5bb-2bb81f8889bf', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'Aarogya Diagnostic Centre (Kandivali)', 'Modern healthcare facility in Kandivali, Mumbai offering outpatient and diagnostic care.', 'Shop No. 21, Sector 18, Kandivali Road', 'Mumbai', 'Kandivali', '424437', '+917512895388', 'contact@aarogya-kandivali.in', 4.85, 137, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'AARO238')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'AARO238';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 'Star Medical Centre (Malad)', 'Modern healthcare facility in Malad, Mumbai offering outpatient and diagnostic care.', 'Shop No. 32, Sector 1, Malad Road', 'Mumbai', 'Malad', '415622', '+918726772198', 'contact@star-malad.in', 4.87, 106, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 'STAR197')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'STAR197';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('16181d96-9229-48ed-96e4-5673a5118844', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 'Sai Day Care Centre (Mulund)', 'Modern healthcare facility in Mulund, Mumbai offering outpatient and diagnostic care.', 'Shop No. 17, Sector 4, Mulund Road', 'Mumbai', 'Mulund', '424101', '+917740585922', 'contact@sai-mulund.in', 4.77, 145, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 'SAI664')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'SAI664';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b71cbebd-b233-42ae-9986-0e6666386a26', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 'Galaxy Hospital & Research Centre (Powai)', 'Modern healthcare facility in Powai, Mumbai offering outpatient and diagnostic care.', 'Shop No. 35, Sector 3, Powai Road', 'Mumbai', 'Powai', '423609', '+917515865524', 'contact@galaxy-powai.in', 4.17, 117, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 'GALA450')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'GALA450';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('6bcb5f55-5297-4dcb-9066-58c174d45013', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 'CarePoint Multispeciality Clinic (Thane Road)', 'Modern healthcare facility in Thane Road, Mumbai offering outpatient and diagnostic care.', 'Shop No. 29, Sector 5, Thane Road Road', 'Mumbai', 'Thane Road', '422098', '+918193420759', 'contact@carepoint-thane-road.in', 4.43, 26, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 'CARE759')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'CARE759';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('bbb1f407-cf97-4d6c-9e96-1ae68e61d620', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 'Aarogya Polyclinic (Vile Parle)', 'Modern healthcare facility in Vile Parle, Mumbai offering outpatient and diagnostic care.', 'Shop No. 38, Sector 18, Vile Parle Road', 'Mumbai', 'Vile Parle', '413283', '+919760877725', 'contact@aarogya-vile-parle.in', 4.68, 99, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 'AARO293')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'AARO293';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 'CarePoint Diagnostic Centre (Worli)', 'Modern healthcare facility in Worli, Mumbai offering outpatient and diagnostic care.', 'Shop No. 37, Sector 8, Worli Road', 'Mumbai', 'Worli', '416864', '+919946397808', 'contact@carepoint-worli.in', 4.27, 107, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 'CARE386')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'CARE386';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('163e11eb-66ca-47cb-9a8b-7a6bfc6bbb09', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 'CarePoint Medical Centre (Churchgate)', 'Modern healthcare facility in Churchgate, Mumbai offering outpatient and diagnostic care.', 'Shop No. 4, Sector 12, Churchgate Road', 'Mumbai', 'Churchgate', '407110', '+917595853898', 'contact@carepoint-churchgate.in', 4.41, 44, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 'CARE223')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'CARE223';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('d9b6df45-8fb6-4147-adef-b2f7f354e8e8', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

      INSERT INTO public.clinics (id, name, description, address_line, city, area, pincode, contact_phone, contact_email, avg_rating, review_count, is_active, facilities)
      VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 'Modern Nursing Home (Lower Parel)', 'Modern healthcare facility in Lower Parel, Mumbai offering outpatient and diagnostic care.', 'Shop No. 25, Sector 2, Lower Parel Road', 'Mumbai', 'Lower Parel', '424059', '+918634403551', 'contact@modern-lower-parel.in', 4.33, 61, true, ARRAY['Pharmacy','Waiting Lounge','Wi-Fi','Wheelchair Access','Card Payments']::text[])
      ON CONFLICT (id) DO NOTHING;
    

      INSERT INTO public.clinic_invite_codes (clinic_id, code)
      VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 'MODE314')
      ON CONFLICT (clinic_id) DO UPDATE SET code = 'MODE314';
    

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 0, '09:00:00', '13:00:00', true)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 1, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 2, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 3, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 4, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 5, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      

        INSERT INTO public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed)
        VALUES ('52cf3065-6234-4b0d-ba6b-cf33ea26639b', 6, '08:30:00', '20:30:00', false)
        ON CONFLICT (clinic_id, day_of_week) DO NOTHING;
      