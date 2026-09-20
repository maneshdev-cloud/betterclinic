-- Batch 1: Clinics
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 'Sai Care Polyclinic (Andheri)', 'Mumbai', 'Andheri', '400491', 'Shop No. 1, Galaxy Complex, Andheri Main Road', '+918768024404', 'contact@saicarepolyclinic-andheri.in', 4.49, 64, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 'SAI119', 'DOC-SAI119', 'ADM-SAI119', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('938b2836-9050-4b10-bdbf-979298838f58', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 'Aarogya Health Hub (Ghodbunder Road)', 'Thane', 'Ghodbunder Road', '401820', 'Shop No. 25, Galaxy Complex, Ghodbunder Road Main Road', '+919825031936', 'contact@aarogyahealthhub-ghodbunderroad.in', 4.69, 34, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 'AARO789', 'DOC-AARO789', 'ADM-AARO789', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('8c5171bc-eb25-4634-9355-48dab31b3620', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'Metro Multispeciality Clinic (Kharghar)', 'Navi Mumbai', 'Kharghar', '409102', 'Shop No. 25, Galaxy Complex, Kharghar Main Road', '+919938407024', 'contact@metromultispecialityclinic-kharghar.in', 4.31, 68, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'METR636', 'DOC-METR636', 'ADM-METR636', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('85f7d784-9926-4bd5-90eb-e7fb86eefabe', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 'LifeLine Family Clinic (Hinjewadi)', 'Pune', 'Hinjewadi', '403224', 'Shop No. 14, Galaxy Complex, Hinjewadi Main Road', '+917743722754', 'contact@lifelinefamilyclinic-hinjewadi.in', 4.28, 71, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 'LIFE849', 'DOC-LIFE849', 'ADM-LIFE849', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('9ae5c640-7396-468f-93c5-f50f917e3bd7', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 'Apex Diagnostic & Medical Centre (Dadar)', 'Mumbai', 'Dadar', '408930', 'Shop No. 21, Galaxy Complex, Dadar Main Road', '+919613762191', 'contact@apexdiagnosticmedicalcentre-dadar.in', 4.84, 17, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 'APEX293', 'DOC-APEX293', 'ADM-APEX293', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cf2d9d96-47cc-47da-8645-76b95437dbc9', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 'City Health Clinic (Manpada)', 'Thane', 'Manpada', '400315', 'Shop No. 14, Galaxy Complex, Manpada Main Road', '+919746807259', 'contact@cityhealthclinic-manpada.in', 4.32, 51, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 'CITY203', 'DOC-CITY203', 'ADM-CITY203', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('cd00cde1-1cdc-4452-89c8-44d38cec259e', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 'Prana Wellness Clinic (Nerul)', 'Navi Mumbai', 'Nerul', '404686', 'Shop No. 17, Galaxy Complex, Nerul Main Road', '+919545611909', 'contact@pranawellnessclinic-nerul.in', 4.59, 76, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 'PRAN382', 'DOC-PRAN382', 'ADM-PRAN382', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('b414fd6a-3853-4a05-af92-9676d226eca1', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 'Apollo Day Care (Viman Nagar)', 'Pune', 'Viman Nagar', '408610', 'Shop No. 5, Galaxy Complex, Viman Nagar Main Road', '+919914170103', 'contact@apollodaycare-vimannagar.in', 4.21, 62, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 'APOL908', 'DOC-APOL908', 'ADM-APOL908', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('df92c2df-2a04-4841-8f09-712102322244', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 'CarePoint Polyclinic (Malad)', 'Mumbai', 'Malad', '402553', 'Shop No. 25, Galaxy Complex, Malad Main Road', '+918898823368', 'contact@carepointpolyclinic-malad.in', 4.71, 33, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 'CARE869', 'DOC-CARE869', 'ADM-CARE869', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('4ec6483a-c258-4aa7-bc53-f9892131ea7b', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 'National Health Clinic (Kasarvadavali)', 'Thane', 'Kasarvadavali', '401260', 'Shop No. 23, Galaxy Complex, Kasarvadavali Main Road', '+918846870953', 'contact@nationalhealthclinic-kasarvadavali.in', 4.33, 26, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 'NATI259', 'DOC-NATI259', 'ADM-NATI259', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('d86cc362-5187-429c-a416-eac441608cc5', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 'Sanjeevani Care Clinic (Vashi)', 'Navi Mumbai', 'Vashi', '404490', 'Shop No. 4, Galaxy Complex, Vashi Main Road', '+919666523399', 'contact@sanjeevanicareclinic-vashi.in', 4.75, 56, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 'SANJ775', 'DOC-SANJ775', 'ADM-SANJ775', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('36b56b48-29ef-43ba-9633-7cf493a8d1a3', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 'Shree Multispeciality Clinic (Baner)', 'Pune', 'Baner', '410655', 'Shop No. 11, Galaxy Complex, Baner Main Road', '+917758870702', 'contact@shreemultispecialityclinic-baner.in', 4.34, 69, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 'SHRE953', 'DOC-SHRE953', 'ADM-SHRE953', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('dbe200d4-b174-4d97-bc9e-e7cfdfe142d7', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 'Noble Diagnostic Centre (Borivali)', 'Mumbai', 'Borivali', '405786', 'Shop No. 24, Galaxy Complex, Borivali Main Road', '+919940182763', 'contact@noblediagnosticcentre-borivali.in', 4.14, 38, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 'NOBL718', 'DOC-NOBL718', 'ADM-NOBL718', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fbad7bc6-f60d-40a4-a3de-0fe341535341', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 'Pinnacle Health Clinic (Ghodbunder Road)', 'Thane', 'Ghodbunder Road', '405684', 'Shop No. 6, Galaxy Complex, Ghodbunder Road Main Road', '+918763762094', 'contact@pinnaclehealthclinic-ghodbunderroad.in', 4.29, 64, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 'PINN215', 'DOC-PINN215', 'ADM-PINN215', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('acd97eae-8230-4091-b374-d725293efd69', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'Spandana Polyclinic (Panvel)', 'Navi Mumbai', 'Panvel', '405787', 'Shop No. 14, Galaxy Complex, Panvel Main Road', '+918673155174', 'contact@spandanapolyclinic-panvel.in', 4.62, 81, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'SPAN643', 'DOC-SPAN643', 'ADM-SPAN643', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('6bc30e2a-0730-4edb-bd9d-31281647d8d1', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 'Suraksha Medical Clinic (Kothrud)', 'Pune', 'Kothrud', '410937', 'Shop No. 14, Galaxy Complex, Kothrud Main Road', '+918769218412', 'contact@surakshamedicalclinic-kothrud.in', 4.36, 67, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 'SURA507', 'DOC-SURA507', 'ADM-SURA507', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('c9d6e74a-3499-46df-bd17-1e55e07d3b2c', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 'MedLife Health Care (Juhu)', 'Mumbai', 'Juhu', '403110', 'Shop No. 24, Galaxy Complex, Juhu Main Road', '+917791434504', 'contact@medlifehealthcare-juhu.in', 4.72, 39, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 'MEDL516', 'DOC-MEDL516', 'ADM-MEDL516', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('fff82ccc-2a0b-48f6-9edb-d70192574b6d', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinics (id, name, city, area, pincode, address_line, contact_phone, contact_email, avg_rating, review_count, is_active, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 'Dhanvantari Clinic (Manpada)', 'Thane', 'Manpada', '408634', 'Shop No. 20, Galaxy Complex, Manpada Main Road', '+919397703904', 'contact@dhanvantariclinic-manpada.in', 4.57, 34, true, true)
on conflict (id) do nothing;
insert into public.clinic_invite_codes (clinic_id, code, doctor_code, admin_claim_code, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 'DHAN674', 'DOC-DHAN674', 'ADM-DHAN674', true)
on conflict (clinic_id) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 0, '08:30:00', '20:30:00', true, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 1, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 2, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 3, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 4, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 5, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
insert into public.clinic_hours (clinic_id, day_of_week, opens_at, closes_at, is_closed, is_synthetic)
values ('3731a04a-1227-4a0b-9130-fcb73c286474', 6, '08:30:00', '20:30:00', false, true)
on conflict (clinic_id, day_of_week) do nothing;
