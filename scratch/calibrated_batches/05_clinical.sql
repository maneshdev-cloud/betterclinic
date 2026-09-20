-- Batch 5: Clinical records, Prescriptions, Reviews
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('273aab10-a953-401d-a6c1-fb07151b929d', 'ac3cbd4c-a55b-42fb-b3f5-d3268596b50e', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', 'Routine health checkup', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('273aab10-a953-401d-a6c1-fb07151b929d', '00000000-0000-0000-0000-000000000001', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('273aab10-a953-401d-a6c1-fb07151b929d', '00000000-0000-0000-0000-000000000001', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('0b94a50e-af3d-4331-9520-572a6bc98d66', '273aab10-a953-401d-a6c1-fb07151b929d', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '2026-09-16', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('0b94a50e-af3d-4331-9520-572a6bc98d66', '4dc27138-6db4-4320-a7aa-d4b1819d036e', 'Dolo 650', 'Paracetamol', '650mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('0b94a50e-af3d-4331-9520-572a6bc98d66', '1514f65e-07b1-40a3-8b50-6766b0ccde25', 'Augmentin 625', 'Amoxicillin + Clavulanate', '625mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('0b94a50e-af3d-4331-9520-572a6bc98d66', '00000000-0000-0000-0000-000000000001', 'Dolo 650', '1 tab', '08:00:00', '2026-09-16', '2026-09-16'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('273aab10-a953-401d-a6c1-fb07151b929d', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '2026-09-16'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('00000000-0000-0000-0000-000000000002', '938b2836-9050-4b10-bdbf-979298838f58', '00000000-0000-0000-0000-000000000001', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('00000000-0000-0000-0000-000000000001', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('2103c70b-7b50-46e1-a361-facb7d4c5cd1', '38e36536-dab2-46c0-9c43-42885e19ec05', 'efb76641-e045-4f09-b58a-9f11e3a50b05', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', 'Persistent headache and fever', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('2103c70b-7b50-46e1-a361-facb7d4c5cd1', 'efb76641-e045-4f09-b58a-9f11e3a50b05', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('2103c70b-7b50-46e1-a361-facb7d4c5cd1', 'efb76641-e045-4f09-b58a-9f11e3a50b05', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('18680bd6-9d39-45bc-83e3-e8e59f6b2e8e', '2103c70b-7b50-46e1-a361-facb7d4c5cd1', 'efb76641-e045-4f09-b58a-9f11e3a50b05', '20501482-962c-466c-981b-a6eb6418a97b', 'acd97eae-8230-4091-b374-d725293efd69', '2026-09-03', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('18680bd6-9d39-45bc-83e3-e8e59f6b2e8e', '3d69b7ab-9a32-414d-a430-27077f2d6614', 'Crocin', 'Paracetamol', '500mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('18680bd6-9d39-45bc-83e3-e8e59f6b2e8e', 'f3f9872e-2df9-4eca-aa45-5666f5969f10', 'Azithral 500', 'Azithromycin', '500mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('18680bd6-9d39-45bc-83e3-e8e59f6b2e8e', 'efb76641-e045-4f09-b58a-9f11e3a50b05', 'Crocin', '1 tab', '08:00:00', '2026-09-03', '2026-09-03'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('efb76641-e045-4f09-b58a-9f11e3a50b05', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('3f1b5d05-594d-4d1b-89de-9a1f35a03f19', '6ead15fb-6f25-4455-98bb-4e861dfa076b', 'caafb38e-6580-41d8-b03b-cff74c544c18', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 'Joint pain and stiffness', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('3f1b5d05-594d-4d1b-89de-9a1f35a03f19', 'caafb38e-6580-41d8-b03b-cff74c544c18', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('3f1b5d05-594d-4d1b-89de-9a1f35a03f19', 'caafb38e-6580-41d8-b03b-cff74c544c18', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('b4c83d53-680e-4cb8-b29c-af896dac1675', '3f1b5d05-594d-4d1b-89de-9a1f35a03f19', 'caafb38e-6580-41d8-b03b-cff74c544c18', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', '2026-09-02', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('b4c83d53-680e-4cb8-b29c-af896dac1675', '2f482efd-0f24-4b84-9cba-f65ee6c87d84', 'Combiflam', 'Ibuprofen + Paracetamol', '400mg + 325mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('b4c83d53-680e-4cb8-b29c-af896dac1675', 'ec4d1238-cfda-4d15-983c-1075cfc94bdd', 'Ciproflox 500', 'Ciprofloxacin', '500mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('b4c83d53-680e-4cb8-b29c-af896dac1675', 'caafb38e-6580-41d8-b03b-cff74c544c18', 'Combiflam', '1 tab', '08:00:00', '2026-09-02', '2026-09-02'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('3f1b5d05-594d-4d1b-89de-9a1f35a03f19', 'caafb38e-6580-41d8-b03b-cff74c544c18', '45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', '2026-09-02'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('45406535-0798-4097-b82e-4aa9250370ad', '36b56b48-29ef-43ba-9633-7cf493a8d1a3', 'caafb38e-6580-41d8-b03b-cff74c544c18', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('caafb38e-6580-41d8-b03b-cff74c544c18', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('a16e9673-737d-4fc4-803f-f50ca78f2a1f', '5dc8332a-7afe-4210-8d0a-a23496e5c0a1', '5eb28e9f-a887-4708-969b-9370f092c80f', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'Skin rash and itching', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('a16e9673-737d-4fc4-803f-f50ca78f2a1f', '5eb28e9f-a887-4708-969b-9370f092c80f', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('a16e9673-737d-4fc4-803f-f50ca78f2a1f', '5eb28e9f-a887-4708-969b-9370f092c80f', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('98412cd2-e882-41b9-897e-49322bb642d9', 'a16e9673-737d-4fc4-803f-f50ca78f2a1f', '5eb28e9f-a887-4708-969b-9370f092c80f', '5b6ae2f3-2b8b-4730-b29d-36b4fe8c4ea7', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-08-29', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('98412cd2-e882-41b9-897e-49322bb642d9', '1514f65e-07b1-40a3-8b50-6766b0ccde25', 'Augmentin 625', 'Amoxicillin + Clavulanate', '625mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('98412cd2-e882-41b9-897e-49322bb642d9', 'c67fe46e-22d8-4123-bd9b-7637b0d55998', 'Voveran SR', 'Diclofenac', '100mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('98412cd2-e882-41b9-897e-49322bb642d9', '5eb28e9f-a887-4708-969b-9370f092c80f', 'Augmentin 625', '1 tab', '08:00:00', '2026-08-29', '2026-08-29'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('5eb28e9f-a887-4708-969b-9370f092c80f', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('69df359c-a66f-485e-9c6a-d0b0da768741', '6e217ee2-5ae4-43aa-8616-63a2e8f31717', '3258f3d2-cb78-4178-ad18-35263b42b8cb', '441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'Seasonal cough and throat irritation', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('69df359c-a66f-485e-9c6a-d0b0da768741', '3258f3d2-cb78-4178-ad18-35263b42b8cb', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('69df359c-a66f-485e-9c6a-d0b0da768741', '3258f3d2-cb78-4178-ad18-35263b42b8cb', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('5eeba531-75e0-4457-9555-e0acb77acaca', '69df359c-a66f-485e-9c6a-d0b0da768741', '3258f3d2-cb78-4178-ad18-35263b42b8cb', '441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-08-26', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('5eeba531-75e0-4457-9555-e0acb77acaca', 'f3f9872e-2df9-4eca-aa45-5666f5969f10', 'Azithral 500', 'Azithromycin', '500mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('5eeba531-75e0-4457-9555-e0acb77acaca', '71ecf204-ecce-46d1-a23a-e5cdc906d54a', 'Brufen', 'Ibuprofen', '400mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('5eeba531-75e0-4457-9555-e0acb77acaca', '3258f3d2-cb78-4178-ad18-35263b42b8cb', 'Azithral 500', '1 tab', '08:00:00', '2026-08-26', '2026-08-26'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('69df359c-a66f-485e-9c6a-d0b0da768741', '3258f3d2-cb78-4178-ad18-35263b42b8cb', '441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-08-26'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('441ed391-4f91-41cd-bd33-dd9331fc48ea', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '3258f3d2-cb78-4178-ad18-35263b42b8cb', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('3258f3d2-cb78-4178-ad18-35263b42b8cb', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('124db88a-2179-4ef0-9bc9-4868c80b78b4', '3a02ab05-1708-4045-8222-94def5302c40', '723962c6-03ce-43a8-a62b-e543664f7908', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', 'Blood pressure follow-up', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('124db88a-2179-4ef0-9bc9-4868c80b78b4', '723962c6-03ce-43a8-a62b-e543664f7908', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('124db88a-2179-4ef0-9bc9-4868c80b78b4', '723962c6-03ce-43a8-a62b-e543664f7908', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('549e40a2-2c15-4b01-8cd9-530a5a3166ab', '124db88a-2179-4ef0-9bc9-4868c80b78b4', '723962c6-03ce-43a8-a62b-e543664f7908', 'fd0643dd-b930-4273-b1d5-c105d90b24d2', 'df92c2df-2a04-4841-8f09-712102322244', '2026-08-27', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('549e40a2-2c15-4b01-8cd9-530a5a3166ab', 'ec4d1238-cfda-4d15-983c-1075cfc94bdd', 'Ciproflox 500', 'Ciprofloxacin', '500mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('549e40a2-2c15-4b01-8cd9-530a5a3166ab', '4dc27138-6db4-4320-a7aa-d4b1819d036e', 'Dolo 650', 'Paracetamol', '650mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('549e40a2-2c15-4b01-8cd9-530a5a3166ab', '723962c6-03ce-43a8-a62b-e543664f7908', 'Ciproflox 500', '1 tab', '08:00:00', '2026-08-27', '2026-08-27'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('723962c6-03ce-43a8-a62b-e543664f7908', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('1e9cc8ca-b209-4e7e-9b12-ff6ae1baa7fa', 'fa2534f5-3595-4c11-a18a-906ffe2c6e7c', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', 'Stomach pain and acidity', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('1e9cc8ca-b209-4e7e-9b12-ff6ae1baa7fa', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('1e9cc8ca-b209-4e7e-9b12-ff6ae1baa7fa', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('5fb44291-bfb4-45e7-b958-165acd363fcb', '1e9cc8ca-b209-4e7e-9b12-ff6ae1baa7fa', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', '2026-08-30', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('5fb44291-bfb4-45e7-b958-165acd363fcb', 'c67fe46e-22d8-4123-bd9b-7637b0d55998', 'Voveran SR', 'Diclofenac', '100mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('5fb44291-bfb4-45e7-b958-165acd363fcb', '3d69b7ab-9a32-414d-a430-27077f2d6614', 'Crocin', 'Paracetamol', '500mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('5fb44291-bfb4-45e7-b958-165acd363fcb', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'Voveran SR', '1 tab', '08:00:00', '2026-08-30', '2026-08-30'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('1e9cc8ca-b209-4e7e-9b12-ff6ae1baa7fa', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 'c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', '2026-08-30'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('c47a1fb9-c083-4150-ab17-84bd72037437', '4ec6483a-c258-4aa7-bc53-f9892131ea7b', '8f1a4e44-ea28-428b-ac08-b427d4a26131', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('8f1a4e44-ea28-428b-ac08-b427d4a26131', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('525ff50b-15ea-4ddf-afb6-ffcfd2f65c49', '8c7db953-0622-41e5-8dd9-05e996e90e27', '28aab011-5031-40d8-ae55-f85627a8678a', '5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', 'Chest tightness on exertion', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('525ff50b-15ea-4ddf-afb6-ffcfd2f65c49', '28aab011-5031-40d8-ae55-f85627a8678a', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('525ff50b-15ea-4ddf-afb6-ffcfd2f65c49', '28aab011-5031-40d8-ae55-f85627a8678a', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('62fb7b48-5a8b-4657-af2c-0252bfaed56f', '525ff50b-15ea-4ddf-afb6-ffcfd2f65c49', '28aab011-5031-40d8-ae55-f85627a8678a', '5ece16f9-30c4-4224-846e-2103750ca3d6', 'cd00cde1-1cdc-4452-89c8-44d38cec259e', '2026-09-13', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('62fb7b48-5a8b-4657-af2c-0252bfaed56f', '71ecf204-ecce-46d1-a23a-e5cdc906d54a', 'Brufen', 'Ibuprofen', '400mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('62fb7b48-5a8b-4657-af2c-0252bfaed56f', '2f482efd-0f24-4b84-9cba-f65ee6c87d84', 'Combiflam', 'Ibuprofen + Paracetamol', '400mg + 325mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('62fb7b48-5a8b-4657-af2c-0252bfaed56f', '28aab011-5031-40d8-ae55-f85627a8678a', 'Brufen', '1 tab', '08:00:00', '2026-09-13', '2026-09-13'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('28aab011-5031-40d8-ae55-f85627a8678a', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('1ad675ab-5e22-456c-8774-3bb9fd7ff4d3', '5e1ca5d3-fe29-4ea1-ab8f-698eb6302d43', '1e3839b0-2030-4822-9776-b21ef934420a', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', 'Ear pain and blockage', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('1ad675ab-5e22-456c-8774-3bb9fd7ff4d3', '1e3839b0-2030-4822-9776-b21ef934420a', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('1ad675ab-5e22-456c-8774-3bb9fd7ff4d3', '1e3839b0-2030-4822-9776-b21ef934420a', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('742cf934-0d79-44cd-b7bc-d7c6fc2fe552', '1ad675ab-5e22-456c-8774-3bb9fd7ff4d3', '1e3839b0-2030-4822-9776-b21ef934420a', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-09-07', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('742cf934-0d79-44cd-b7bc-d7c6fc2fe552', '4dc27138-6db4-4320-a7aa-d4b1819d036e', 'Dolo 650', 'Paracetamol', '650mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('742cf934-0d79-44cd-b7bc-d7c6fc2fe552', '1514f65e-07b1-40a3-8b50-6766b0ccde25', 'Augmentin 625', 'Amoxicillin + Clavulanate', '625mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('742cf934-0d79-44cd-b7bc-d7c6fc2fe552', '1e3839b0-2030-4822-9776-b21ef934420a', 'Dolo 650', '1 tab', '08:00:00', '2026-09-07', '2026-09-07'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('1ad675ab-5e22-456c-8774-3bb9fd7ff4d3', '1e3839b0-2030-4822-9776-b21ef934420a', '2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '2026-09-07'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('2b2a1824-59dd-4142-84bd-01b4bc9b64f8', '85f7d784-9926-4bd5-90eb-e7fb86eefabe', '1e3839b0-2030-4822-9776-b21ef934420a', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('1e3839b0-2030-4822-9776-b21ef934420a', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('a877f8e7-a7a9-4d4a-a7d4-53c3ea37b44d', 'e44cc116-472b-413f-b58b-49cb7b62acac', 'b920252a-46f9-4001-b456-fd87298f3069', '5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'Diabetes consultation', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('a877f8e7-a7a9-4d4a-a7d4-53c3ea37b44d', 'b920252a-46f9-4001-b456-fd87298f3069', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('a877f8e7-a7a9-4d4a-a7d4-53c3ea37b44d', 'b920252a-46f9-4001-b456-fd87298f3069', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('2807757d-54e7-4706-a909-f6da657d13a8', 'a877f8e7-a7a9-4d4a-a7d4-53c3ea37b44d', 'b920252a-46f9-4001-b456-fd87298f3069', '5b9b0729-0deb-4ccb-83a8-03f423eb9908', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-08-31', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('2807757d-54e7-4706-a909-f6da657d13a8', '3d69b7ab-9a32-414d-a430-27077f2d6614', 'Crocin', 'Paracetamol', '500mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('2807757d-54e7-4706-a909-f6da657d13a8', 'f3f9872e-2df9-4eca-aa45-5666f5969f10', 'Azithral 500', 'Azithromycin', '500mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('2807757d-54e7-4706-a909-f6da657d13a8', 'b920252a-46f9-4001-b456-fd87298f3069', 'Crocin', '1 tab', '08:00:00', '2026-08-31', '2026-08-31'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('b920252a-46f9-4001-b456-fd87298f3069', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('98dbe3a0-3089-40d8-a635-63e1546adf44', 'e6c1d9f9-46f2-4448-b23e-5cd7bd6c0d0b', '004e7863-d49c-4148-a334-c6094694cebd', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', 'Eye checkup and blurry vision', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('98dbe3a0-3089-40d8-a635-63e1546adf44', '004e7863-d49c-4148-a334-c6094694cebd', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('98dbe3a0-3089-40d8-a635-63e1546adf44', '004e7863-d49c-4148-a334-c6094694cebd', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('d660e750-1170-4361-a043-406b46379f65', '98dbe3a0-3089-40d8-a635-63e1546adf44', '004e7863-d49c-4148-a334-c6094694cebd', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-09', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('d660e750-1170-4361-a043-406b46379f65', '2f482efd-0f24-4b84-9cba-f65ee6c87d84', 'Combiflam', 'Ibuprofen + Paracetamol', '400mg + 325mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('d660e750-1170-4361-a043-406b46379f65', 'ec4d1238-cfda-4d15-983c-1075cfc94bdd', 'Ciproflox 500', 'Ciprofloxacin', '500mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('d660e750-1170-4361-a043-406b46379f65', '004e7863-d49c-4148-a334-c6094694cebd', 'Combiflam', '1 tab', '08:00:00', '2026-09-09', '2026-09-09'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('98dbe3a0-3089-40d8-a635-63e1546adf44', '004e7863-d49c-4148-a334-c6094694cebd', 'd79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-09'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('d79ca1e8-01e0-4e17-bfa5-45bb52e709ed', 'b414fd6a-3853-4a05-af92-9676d226eca1', '004e7863-d49c-4148-a334-c6094694cebd', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('004e7863-d49c-4148-a334-c6094694cebd', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('2852ee3f-4299-4bb1-b002-206188b6525e', '904b78f6-e663-4ba5-adf0-1beeadd821e2', '9a49d610-c854-4d03-87be-1a7dd595214c', 'e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', 'Childhood vaccination consultation', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('2852ee3f-4299-4bb1-b002-206188b6525e', '9a49d610-c854-4d03-87be-1a7dd595214c', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('2852ee3f-4299-4bb1-b002-206188b6525e', '9a49d610-c854-4d03-87be-1a7dd595214c', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('06ffd0e5-f637-4cec-b596-3ff28a5e6ddf', '2852ee3f-4299-4bb1-b002-206188b6525e', '9a49d610-c854-4d03-87be-1a7dd595214c', 'e137680d-ff27-4f5b-93c1-66a96f5d7b06', 'b414fd6a-3853-4a05-af92-9676d226eca1', '2026-09-05', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('06ffd0e5-f637-4cec-b596-3ff28a5e6ddf', '1514f65e-07b1-40a3-8b50-6766b0ccde25', 'Augmentin 625', 'Amoxicillin + Clavulanate', '625mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('06ffd0e5-f637-4cec-b596-3ff28a5e6ddf', 'c67fe46e-22d8-4123-bd9b-7637b0d55998', 'Voveran SR', 'Diclofenac', '100mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('06ffd0e5-f637-4cec-b596-3ff28a5e6ddf', '9a49d610-c854-4d03-87be-1a7dd595214c', 'Augmentin 625', '1 tab', '08:00:00', '2026-09-05', '2026-09-05'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('9a49d610-c854-4d03-87be-1a7dd595214c', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('9c02a2a1-b541-4747-9bae-46537e6b7ad7', 'cec9dce1-17e5-40a4-ae02-7704ef10986a', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', '2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'Routine health checkup', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('9c02a2a1-b541-4747-9bae-46537e6b7ad7', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('9c02a2a1-b541-4747-9bae-46537e6b7ad7', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('1ef1e9f7-ad8e-4afb-bf19-7db6ef3b7482', '9c02a2a1-b541-4747-9bae-46537e6b7ad7', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', '2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-09-06', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('1ef1e9f7-ad8e-4afb-bf19-7db6ef3b7482', 'f3f9872e-2df9-4eca-aa45-5666f5969f10', 'Azithral 500', 'Azithromycin', '500mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('1ef1e9f7-ad8e-4afb-bf19-7db6ef3b7482', '71ecf204-ecce-46d1-a23a-e5cdc906d54a', 'Brufen', 'Ibuprofen', '400mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('1ef1e9f7-ad8e-4afb-bf19-7db6ef3b7482', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 'Azithral 500', '1 tab', '08:00:00', '2026-09-06', '2026-09-06'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('9c02a2a1-b541-4747-9bae-46537e6b7ad7', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', '2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-09-06'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('2fcdd6ce-6ccd-4d48-894f-9fb2fe7d832f', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('e23cc16c-c2b4-46f0-a4d0-42d254b8c58a', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('751a4058-1dca-460e-a820-2b4b61d88ffe', 'eb253747-38c5-40bb-9467-52eed093ec25', '2446e034-e030-4ffb-830f-3dd8d3f10161', '0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', 'Persistent headache and fever', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('751a4058-1dca-460e-a820-2b4b61d88ffe', '2446e034-e030-4ffb-830f-3dd8d3f10161', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('751a4058-1dca-460e-a820-2b4b61d88ffe', '2446e034-e030-4ffb-830f-3dd8d3f10161', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('856656ad-8184-4416-b235-138ec3e5b80b', '751a4058-1dca-460e-a820-2b4b61d88ffe', '2446e034-e030-4ffb-830f-3dd8d3f10161', '0d16308a-d0c3-4b7d-b2ba-c4e44b682a36', 'fbad7bc6-f60d-40a4-a3de-0fe341535341', '2026-09-09', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('856656ad-8184-4416-b235-138ec3e5b80b', 'ec4d1238-cfda-4d15-983c-1075cfc94bdd', 'Ciproflox 500', 'Ciprofloxacin', '500mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('856656ad-8184-4416-b235-138ec3e5b80b', '4dc27138-6db4-4320-a7aa-d4b1819d036e', 'Dolo 650', 'Paracetamol', '650mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('856656ad-8184-4416-b235-138ec3e5b80b', '2446e034-e030-4ffb-830f-3dd8d3f10161', 'Ciproflox 500', '1 tab', '08:00:00', '2026-09-09', '2026-09-09'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('2446e034-e030-4ffb-830f-3dd8d3f10161', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('c8b90e10-c30a-4b89-9390-00f66bf89433', 'da868ff1-b7e6-4a6c-a225-00d521d526c3', 'a78963b2-f214-403d-b977-cf59852f63e9', 'eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 'Joint pain and stiffness', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('c8b90e10-c30a-4b89-9390-00f66bf89433', 'a78963b2-f214-403d-b977-cf59852f63e9', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('c8b90e10-c30a-4b89-9390-00f66bf89433', 'a78963b2-f214-403d-b977-cf59852f63e9', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('7e79f0c6-cce4-41af-a660-3d21bed45811', 'c8b90e10-c30a-4b89-9390-00f66bf89433', 'a78963b2-f214-403d-b977-cf59852f63e9', 'eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', '2026-09-04', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('7e79f0c6-cce4-41af-a660-3d21bed45811', 'c67fe46e-22d8-4123-bd9b-7637b0d55998', 'Voveran SR', 'Diclofenac', '100mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('7e79f0c6-cce4-41af-a660-3d21bed45811', '3d69b7ab-9a32-414d-a430-27077f2d6614', 'Crocin', 'Paracetamol', '500mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('7e79f0c6-cce4-41af-a660-3d21bed45811', 'a78963b2-f214-403d-b977-cf59852f63e9', 'Voveran SR', '1 tab', '08:00:00', '2026-09-04', '2026-09-04'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.follow_ups (consultation_id, patient_id, doctor_id, clinic_id, scheduled_date, reason, instructions, status, is_synthetic)
values ('c8b90e10-c30a-4b89-9390-00f66bf89433', 'a78963b2-f214-403d-b977-cf59852f63e9', 'eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', '2026-09-04'::date + interval '7 days', 'Review recovery and repeat vitals check', 'Visit clinic if fever persists', 'SCHEDULED'::public.follow_up_status, true);
insert into public.reviews (doctor_id, clinic_id, patient_id, rating, title, comment, is_approved, is_synthetic)
values ('eb7699be-2825-4a5e-8d6a-4dcead68ace9', '8c5171bc-eb25-4634-9355-48dab31b3620', 'a78963b2-f214-403d-b977-cf59852f63e9', 5, 'Excellent experience', 'Very courteous doctor and prompt clinic staff. Highly recommended!', true, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('a78963b2-f214-403d-b977-cf59852f63e9', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, chief_complaint, clinical_notes, status, started_at, completed_at, is_synthetic)
values ('1e79d70f-7db4-48ba-a458-7f98c0901164', '77734143-a7cc-43e3-9ac8-2b44851381b6', '730a9ea5-c509-4bab-ba5b-90805528bfa4', '7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', 'Skin rash and itching', 'Patient presented with mild symptoms. Vitals stable. Prescribed symptomatic treatment and advised rest.', 'COMPLETED'::public.consultation_status, now() - interval '2 days', now() - interval '2 days' + interval '20 minutes', true)
on conflict (id) do nothing;
insert into public.diagnoses (consultation_id, patient_id, name, code, is_primary, is_synthetic)
values ('1e79d70f-7db4-48ba-a458-7f98c0901164', '730a9ea5-c509-4bab-ba5b-90805528bfa4', 'Acute upper respiratory infection', 'J06.9', true, true);
insert into public.treatment_plans (consultation_id, patient_id, title, description, instructions, duration_days, is_synthetic)
values ('1e79d70f-7db4-48ba-a458-7f98c0901164', '730a9ea5-c509-4bab-ba5b-90805528bfa4', 'Recovery & Hydration Plan', 'Adequate hydration, steam inhalation, and oral medications for 5 days.', 'Drink warm water and avoid cold beverages.', 5, true);
insert into public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, prescription_date, status, notes, is_synthetic)
values ('80de92f0-b786-4e45-bde3-1cb84cdbb365', '1e79d70f-7db4-48ba-a458-7f98c0901164', '730a9ea5-c509-4bab-ba5b-90805528bfa4', '7496026d-b1d2-47a4-980f-ef44bb82fc68', '6bc30e2a-0730-4edb-bd9d-31281647d8d1', '2026-09-10', 'ACTIVE'::public.prescription_status, 'Take medications after meals. Drink warm water.', true)
on conflict (id) do nothing;
insert into public.prescription_items (prescription_id, medicine_id, medicine_name, generic_name, strength, dose, frequency, duration_days, instructions, food_relation, is_synthetic)
values ('80de92f0-b786-4e45-bde3-1cb84cdbb365', '71ecf204-ecce-46d1-a23a-e5cdc906d54a', 'Brufen', 'Ibuprofen', '400mg', '1 tab', 'BD'::public.prescription_frequency, 5, 'After meals', 'AFTER_FOOD'::public.food_relation, true),
       ('80de92f0-b786-4e45-bde3-1cb84cdbb365', '2f482efd-0f24-4b84-9cba-f65ee6c87d84', 'Combiflam', 'Ibuprofen + Paracetamol', '400mg + 325mg', '1 tab', 'OD'::public.prescription_frequency, 3, 'At bedtime', 'AFTER_FOOD'::public.food_relation, true);
insert into public.medication_schedules (prescription_id, patient_id, medicine_name, dose, time_of_day, start_date, end_date, instructions, food_relation, status, is_synthetic)
values ('80de92f0-b786-4e45-bde3-1cb84cdbb365', '730a9ea5-c509-4bab-ba5b-90805528bfa4', 'Brufen', '1 tab', '08:00:00', '2026-09-10', '2026-09-10'::date + interval '5 days', 'After morning meal', 'AFTER_FOOD'::public.food_relation, 'ACTIVE'::public.medication_schedule_status, true);
insert into public.notifications (user_id, type, title, body, is_read, is_synthetic)
values ('730a9ea5-c509-4bab-ba5b-90805528bfa4', 'PRESCRIPTION_CREATED'::public.notification_type, 'Prescription Ready', 'Your doctor has uploaded your digital prescription.', true, true);
insert into public.ai_conversations (id, patient_id, title, is_synthetic)
values ('82f4bba5-d523-4225-9fe1-0b39cbc7b258', '00000000-0000-0000-0000-000000000001', 'Fever guidance inquiry', true);
insert into public.ai_messages (conversation_id, sender, message, is_synthetic)
values ('82f4bba5-d523-4225-9fe1-0b39cbc7b258', 'USER', 'What should I do if I have a 101F fever?', true),
       ('82f4bba5-d523-4225-9fe1-0b39cbc7b258', 'ASSISTANT', 'Take plenty of fluids, rest, and consult a physician if fever persists over 48 hours or is accompanied by chills or breathing difficulty.', true);
insert into public.emergency_requests (patient_id, emergency_type, status, location_address, is_demo, is_synthetic)
values ('00000000-0000-0000-0000-000000000001', 'AMBULANCE', 'COMPLETED', 'Andheri West, Mumbai', true, true);
