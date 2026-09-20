-- Batch 4: 30 Appointments
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('63f599f7-0859-4f8a-9c70-bd7d214a8d62', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '2026-09-16', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('ac3cbd4c-a55b-42fb-b3f5-d3268596b50e', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '63f599f7-0859-4f8a-9c70-bd7d214a8d62', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-16', '10:00:00', '10:30:00', 'Routine health checkup', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('ac3cbd4c-a55b-42fb-b3f5-d3268596b50e', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('7c923a5a-5085-4e7e-a719-5721a6209c78', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', '2026-09-03', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('38e36536-dab2-46c0-9c43-42885e19ec05', 'efb76641-e045-4f09-b58a-9f11e3a50b05', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', '7c923a5a-5085-4e7e-a719-5721a6209c78', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-03', '10:00:00', '10:30:00', 'Persistent headache and fever', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('38e36536-dab2-46c0-9c43-42885e19ec05', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('ac83bdf7-cda2-410d-b281-0bf8b9b92633', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', '2026-09-02', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('6ead15fb-6f25-4455-98bb-4e861dfa076b', 'caafb38e-6580-41d8-b03b-cff74c544c18', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 'ac83bdf7-cda2-410d-b281-0bf8b9b92633', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-02', '10:00:00', '10:30:00', 'Joint pain and stiffness', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('6ead15fb-6f25-4455-98bb-4e861dfa076b', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('20292961-1a5a-48a9-a7ae-8cf3f2789f9d', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-08-29', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('5dc8332a-7afe-4210-8d0a-a23496e5c0a1', '5eb28e9f-a887-4708-969b-9370f092c80f', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '20292961-1a5a-48a9-a7ae-8cf3f2789f9d', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-08-29', '10:00:00', '10:30:00', 'Skin rash and itching', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('5dc8332a-7afe-4210-8d0a-a23496e5c0a1', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('30d6e575-03e1-403d-999b-656d2ca54523', '441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-08-26', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('6e217ee2-5ae4-43aa-8616-63a2e8f31717', '3258f3d2-cb78-4178-ad18-35263b42b8cb', '441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '30d6e575-03e1-403d-999b-656d2ca54523', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-08-26', '10:00:00', '10:30:00', 'Seasonal cough and throat irritation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('6e217ee2-5ae4-43aa-8616-63a2e8f31717', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('db74066b-8f0d-419f-ae57-6f16598dd01e', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', '2026-08-27', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('3a02ab05-1708-4045-8222-94def5302c40', '723962c6-03ce-43a8-a62b-e543664f7908', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 'db74066b-8f0d-419f-ae57-6f16598dd01e', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-08-27', '10:00:00', '10:30:00', 'Blood pressure follow-up', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('3a02ab05-1708-4045-8222-94def5302c40', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('d76437d7-f1dc-4df4-b56d-01a4c5763fb7', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', '2026-08-30', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('fa2534f5-3595-4c11-a18a-906ffe2c6e7c', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 'd76437d7-f1dc-4df4-b56d-01a4c5763fb7', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-08-30', '10:00:00', '10:30:00', 'Stomach pain and acidity', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('fa2534f5-3595-4c11-a18a-906ffe2c6e7c', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('b713f0cb-f8dd-4224-a2c2-16f4e97341b1', '5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', '2026-09-13', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('8c7db953-0622-41e5-8dd9-05e996e90e27', '28aab011-5031-40d8-ae55-f85627a8678a', '5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 'b713f0cb-f8dd-4224-a2c2-16f4e97341b1', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-13', '10:00:00', '10:30:00', 'Chest tightness on exertion', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('8c7db953-0622-41e5-8dd9-05e996e90e27', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('c4d9a9c3-b954-46cb-947a-ed8d06b1da13', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-09-07', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('5e1ca5d3-fe29-4ea1-ab8f-698eb6302d43', '1e3839b0-2030-4822-9776-b21ef934420a', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'c4d9a9c3-b954-46cb-947a-ed8d06b1da13', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-07', '10:00:00', '10:30:00', 'Ear pain and blockage', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('5e1ca5d3-fe29-4ea1-ab8f-698eb6302d43', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('50dbfd63-9527-44cf-bf68-a23ee299c972', '5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-08-31', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('e44cc116-472b-413f-b58b-49cb7b62acac', 'b920252a-46f9-4001-b456-fd87298f3069', '5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '50dbfd63-9527-44cf-bf68-a23ee299c972', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-08-31', '10:00:00', '10:30:00', 'Diabetes consultation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('e44cc116-472b-413f-b58b-49cb7b62acac', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('57e5bb86-a921-4591-a010-957c1089ba26', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-09', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('e6c1d9f9-46f2-4448-b23e-5cd7bd6c0d0b', '004e7863-d49c-4148-a334-c6094694cebd', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '57e5bb86-a921-4591-a010-957c1089ba26', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-09', '10:00:00', '10:30:00', 'Eye checkup and blurry vision', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('e6c1d9f9-46f2-4448-b23e-5cd7bd6c0d0b', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('73a4c065-7e70-472b-9a26-2b9e94ef7257', 'e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-05', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('904b78f6-e663-4ba5-adf0-1beeadd821e2', '9a49d610-c854-4d03-87be-1a7dd595214c', 'e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', '73a4c065-7e70-472b-9a26-2b9e94ef7257', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-05', '10:00:00', '10:30:00', 'Childhood vaccination consultation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('904b78f6-e663-4ba5-adf0-1beeadd821e2', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('cad0b5d4-8122-4f10-a543-56f85366c27a', '2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-09-06', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('cec9dce1-17e5-40a4-ae02-7704ef10986a', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', '2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'cad0b5d4-8122-4f10-a543-56f85366c27a', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-06', '10:00:00', '10:30:00', 'Routine health checkup', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('cec9dce1-17e5-40a4-ae02-7704ef10986a', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('ef5deb14-39db-4388-8224-910270b3cd41', '0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', '2026-09-09', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('eb253747-38c5-40bb-9467-52eed093ec25', '2446e034-e030-4ffb-830f-3dd8d3f10161', '0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 'ef5deb14-39db-4388-8224-910270b3cd41', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-09', '10:00:00', '10:30:00', 'Persistent headache and fever', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('eb253747-38c5-40bb-9467-52eed093ec25', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('6250042f-4258-431d-b2ef-ea3fe64ad00b', 'eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', '2026-09-04', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('da868ff1-b7e6-4a6c-a225-00d521d526c3', 'a78963b2-f214-403d-b977-cf59852f63e9', 'eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', '6250042f-4258-431d-b2ef-ea3fe64ad00b', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-04', '10:00:00', '10:30:00', 'Joint pain and stiffness', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('da868ff1-b7e6-4a6c-a225-00d521d526c3', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('cc8d65e2-f9df-4b27-b854-c1cd608cd7b1', '7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-09-10', '10:00:00', '10:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('77734143-a7cc-43e3-9ac8-2b44851381b6', '730a9ea5-c509-4bab-ba5b-90805528bfa4', '7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'cc8d65e2-f9df-4b27-b854-c1cd608cd7b1', 'SCHEDULED', 'COMPLETED'::public.appointment_status, '2026-09-10', '10:00:00', '10:30:00', 'Skin rash and itching', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('77734143-a7cc-43e3-9ac8-2b44851381b6', 'BOOKED', 'COMPLETED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('e371e955-88d4-4aed-ac2f-a16a1aa4fa14', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', '2026-09-07', '11:00:00', '11:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('2619ec78-82c8-46dd-8fbd-b1b61f27c51a', 'bd006633-930c-4e21-a494-358efacb415d', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 'e371e955-88d4-4aed-ac2f-a16a1aa4fa14', 'SCHEDULED', 'CANCELLED'::public.appointment_status, '2026-09-07', '11:00:00', '11:30:00', 'Patient requested cancellation due to travel', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('2619ec78-82c8-46dd-8fbd-b1b61f27c51a', 'BOOKED', 'CANCELLED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('4ced6568-3c90-4d8a-973e-53c0c9366afc', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-14', '11:00:00', '11:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('3b46e7a0-3c92-4a65-b8dd-0543b059d8cb', 'd1946453-a5ec-4dfa-861a-661fec5c3b71', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '4ced6568-3c90-4d8a-973e-53c0c9366afc', 'SCHEDULED', 'CANCELLED'::public.appointment_status, '2026-09-14', '11:00:00', '11:30:00', 'Patient requested cancellation due to travel', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('3b46e7a0-3c92-4a65-b8dd-0543b059d8cb', 'BOOKED', 'CANCELLED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('7094ce82-3c50-46c0-a3ea-7493115fe0d7', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', '2026-09-03', '11:00:00', '11:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('fcafb427-ff2b-4dce-823c-4691ac9195bc', '4120622b-cb28-4946-aa92-f9751e225716', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', '7094ce82-3c50-46c0-a3ea-7493115fe0d7', 'SCHEDULED', 'CANCELLED'::public.appointment_status, '2026-09-03', '11:00:00', '11:30:00', 'Patient requested cancellation due to travel', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('fcafb427-ff2b-4dce-823c-4691ac9195bc', 'BOOKED', 'CANCELLED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('9da6e2db-4a1a-49f2-be59-db82baac1161', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '2026-09-13', '14:00:00', '14:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('c71145b4-2141-4e5b-b0c8-bc8c5eae3dd6', '176934c2-6a44-44fd-8f74-97ded4f49dc2', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '9da6e2db-4a1a-49f2-be59-db82baac1161', 'SCHEDULED', 'NO_SHOW'::public.appointment_status, '2026-09-13', '14:00:00', '14:30:00', 'Routine consultation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('c71145b4-2141-4e5b-b0c8-bc8c5eae3dd6', 'BOOKED', 'NO_SHOW'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('c21efbf1-7d98-4622-9d78-c8809c69bbaa', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '2026-09-17', '11:00:00', '11:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('00d40949-333a-4e0d-a5e5-4832ca08a811', '685dd87e-f83f-4ef4-a56d-aa869052ae17', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 'c21efbf1-7d98-4622-9d78-c8809c69bbaa', 'SCHEDULED', 'CHECKED_IN'::public.appointment_status, '2026-09-17', '11:00:00', '11:30:00', 'Seasonal cough and throat irritation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('00d40949-333a-4e0d-a5e5-4832ca08a811', 'BOOKED', 'CHECKED_IN'::public.appointment_status, true);
insert into public.check_ins (appointment_id, patient_id, clinic_id, check_in_time, status, is_synthetic)
values ('00d40949-333a-4e0d-a5e5-4832ca08a811', '685dd87e-f83f-4ef4-a56d-aa869052ae17', '938b2836-9050-4b10-bdbf-979298838f58', now() - interval '30 minutes', 'COMPLETED', true)
on conflict do nothing;
insert into public.queue_entries (id, clinic_id, doctor_id, appointment_id, patient_id, token_number, status, is_synthetic)
values ('f076f95a-f2a5-4d0f-92c2-c5dd6c77568d', '938b2836-9050-4b10-bdbf-979298838f58', '00000000-0000-0000-0000-000000000002', '00d40949-333a-4e0d-a5e5-4832ca08a811', '685dd87e-f83f-4ef4-a56d-aa869052ae17', 8, 'CHECKED_IN'::public.queue_status, true)
on conflict do nothing;
insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, note, is_synthetic)
values ('f076f95a-f2a5-4d0f-92c2-c5dd6c77568d', 'CALLED'::public.queue_event_type, 'WAITING'::public.queue_status, 'CALLED'::public.queue_status, 'Patient called into examination room', true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('e81d7579-c7d7-4962-97a6-273967b6d24d', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', '2026-09-17', '12:00:00', '12:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('3c0c673b-df68-43dd-b01b-ec943be6ef82', '89512172-c2ef-4d75-99e2-491498e1b438', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 'e81d7579-c7d7-4962-97a6-273967b6d24d', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '12:00:00', '12:30:00', 'Blood pressure follow-up', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('3c0c673b-df68-43dd-b01b-ec943be6ef82', 'BOOKED', 'IN_CONSULTATION'::public.appointment_status, true);
insert into public.check_ins (appointment_id, patient_id, clinic_id, check_in_time, status, is_synthetic)
values ('3c0c673b-df68-43dd-b01b-ec943be6ef82', '89512172-c2ef-4d75-99e2-491498e1b438', 'acd97eae-8230-4091-b374-d725293efd69', now() - interval '30 minutes', 'COMPLETED', true)
on conflict do nothing;
insert into public.queue_entries (id, clinic_id, doctor_id, appointment_id, patient_id, token_number, status, is_synthetic)
values ('e83b1045-c7a4-4b3c-87b8-082fdb27c69e', 'acd97eae-8230-4091-b374-d725293efd69', '20501482-962c-466c-981b-a6eb6418a97b', '3c0c673b-df68-43dd-b01b-ec943be6ef82', '89512172-c2ef-4d75-99e2-491498e1b438', 15, 'IN_CONSULTATION'::public.queue_status, true)
on conflict do nothing;
insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, note, is_synthetic)
values ('e83b1045-c7a4-4b3c-87b8-082fdb27c69e', 'CALLED'::public.queue_event_type, 'WAITING'::public.queue_status, 'CALLED'::public.queue_status, 'Patient called into examination room', true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('77d8139b-3640-42a9-af45-3ff440b95500', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', '2026-09-17', '13:00:00', '13:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('4b2a46c6-d63f-4ebe-836e-4cd06a41f025', '4269078d-2025-4f83-a955-707f0bec0724', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', '77d8139b-3640-42a9-af45-3ff440b95500', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '13:00:00', '13:30:00', 'Stomach pain and acidity', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('4b2a46c6-d63f-4ebe-836e-4cd06a41f025', 'BOOKED', 'WAITING'::public.appointment_status, true);
insert into public.check_ins (appointment_id, patient_id, clinic_id, check_in_time, status, is_synthetic)
values ('4b2a46c6-d63f-4ebe-836e-4cd06a41f025', '4269078d-2025-4f83-a955-707f0bec0724', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', now() - interval '30 minutes', 'COMPLETED', true)
on conflict do nothing;
insert into public.queue_entries (id, clinic_id, doctor_id, appointment_id, patient_id, token_number, status, is_synthetic)
values ('23c4499a-0fc2-40d4-8418-bbfc58ebcfe3', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', '45406535-0798-4097-b82e-4aa9250370ad', '4b2a46c6-d63f-4ebe-836e-4cd06a41f025', '4269078d-2025-4f83-a955-707f0bec0724', 7, 'WAITING'::public.queue_status, true)
on conflict do nothing;
insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, note, is_synthetic)
values ('23c4499a-0fc2-40d4-8418-bbfc58ebcfe3', 'CALLED'::public.queue_event_type, 'WAITING'::public.queue_status, 'CALLED'::public.queue_status, 'Patient called into examination room', true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('a7635744-c864-48ee-89f4-987c2eaa592a', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-09-17', '14:00:00', '14:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('3d3e3405-856f-41d4-88bf-ff6c61278612', '5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'a7635744-c864-48ee-89f4-987c2eaa592a', 'SCHEDULED', 'CHECKED_IN'::public.appointment_status, '2026-09-17', '14:00:00', '14:30:00', 'Chest tightness on exertion', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('3d3e3405-856f-41d4-88bf-ff6c61278612', 'BOOKED', 'CHECKED_IN'::public.appointment_status, true);
insert into public.check_ins (appointment_id, patient_id, clinic_id, check_in_time, status, is_synthetic)
values ('3d3e3405-856f-41d4-88bf-ff6c61278612', '5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', now() - interval '30 minutes', 'COMPLETED', true)
on conflict do nothing;
insert into public.queue_entries (id, clinic_id, doctor_id, appointment_id, patient_id, token_number, status, is_synthetic)
values ('228322cb-f2dd-4d70-a162-9d508532ea41', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '3d3e3405-856f-41d4-88bf-ff6c61278612', '5b3d283a-1e02-46d9-b63d-f4b42c3ab4d6', 10, 'CHECKED_IN'::public.queue_status, true)
on conflict do nothing;
insert into public.queue_events (queue_entry_id, event_type, from_status, to_status, note, is_synthetic)
values ('228322cb-f2dd-4d70-a162-9d508532ea41', 'CALLED'::public.queue_event_type, 'WAITING'::public.queue_status, 'CALLED'::public.queue_status, 'Patient called into examination room', true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('83897b95-37f1-4c59-aab8-436aa0b1ee67', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', '2026-09-26', '15:00:00', '15:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('1d28a023-76e5-4214-b9d3-8fe640d6ba24', '214eaaa0-d604-4c9e-9eaa-c89fdc40aca3', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', '83897b95-37f1-4c59-aab8-436aa0b1ee67', 'SCHEDULED', 'BOOKED'::public.appointment_status, '2026-09-26', '15:00:00', '15:30:00', 'Stomach pain and acidity', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('1d28a023-76e5-4214-b9d3-8fe640d6ba24', 'BOOKED', 'BOOKED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('f70b584a-41d3-4ff6-bd07-d4f03bec7129', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', '2026-09-19', '15:00:00', '15:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('1de32673-1d00-4762-8113-daa53c474202', '11adc1bc-ae6d-4d2e-ab7e-d2bfab7def3a', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 'f70b584a-41d3-4ff6-bd07-d4f03bec7129', 'SCHEDULED', 'CONFIRMED'::public.appointment_status, '2026-09-19', '15:00:00', '15:30:00', 'Chest tightness on exertion', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('1de32673-1d00-4762-8113-daa53c474202', 'BOOKED', 'CONFIRMED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('55ee9ec1-0535-490d-a8ca-a264908493b1', '5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', '2026-09-18', '15:00:00', '15:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('1126a9c7-8a4c-4be7-b3be-efb21d4d4d92', '338ea150-f146-4f11-b771-3bb44f35ebcc', '5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', '55ee9ec1-0535-490d-a8ca-a264908493b1', 'SCHEDULED', 'BOOKED'::public.appointment_status, '2026-09-18', '15:00:00', '15:30:00', 'Ear pain and blockage', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('1126a9c7-8a4c-4be7-b3be-efb21d4d4d92', 'BOOKED', 'BOOKED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('be347950-f929-48cc-bb5c-5d1d7ba9efca', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-09-27', '15:00:00', '15:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('af53188d-7e39-49be-b978-dbeba3f86fe8', 'e030eba9-cee9-41d8-9bbb-c5009dda1ed6', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'be347950-f929-48cc-bb5c-5d1d7ba9efca', 'SCHEDULED', 'CONFIRMED'::public.appointment_status, '2026-09-27', '15:00:00', '15:30:00', 'Diabetes consultation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('af53188d-7e39-49be-b978-dbeba3f86fe8', 'BOOKED', 'CONFIRMED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('8a006ca6-1eca-46c1-a731-5ad07965f329', '5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-09-26', '15:00:00', '15:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('c98c5a2e-1918-4bdb-92d5-df7fb4d13edb', 'ad2ef999-0a20-477d-967d-14dd28dac2e2', '5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '8a006ca6-1eca-46c1-a731-5ad07965f329', 'SCHEDULED', 'BOOKED'::public.appointment_status, '2026-09-26', '15:00:00', '15:30:00', 'Eye checkup and blurry vision', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('c98c5a2e-1918-4bdb-92d5-df7fb4d13edb', 'BOOKED', 'BOOKED'::public.appointment_status, true);
insert into public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status, is_synthetic)
values ('538809da-53dc-413a-a5cc-eee917660a72', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-20', '15:00:00', '15:30:00', 'BOOKED', true)
on conflict do nothing;
insert into public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, booked_at, is_synthetic)
values ('86eca757-27f8-438a-8012-b508d182fc90', 'c3ea3ace-8725-4017-ba5b-ca817ad4c57e', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '538809da-53dc-413a-a5cc-eee917660a72', 'SCHEDULED', 'BOOKED'::public.appointment_status, '2026-09-20', '15:00:00', '15:30:00', 'Childhood vaccination consultation', now() - interval '2 days', true)
on conflict (id) do nothing;
insert into public.appointment_status_history (appointment_id, from_status, to_status, is_synthetic)
values ('86eca757-27f8-438a-8012-b508d182fc90', 'BOOKED', 'BOOKED'::public.appointment_status, true);
