
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('380131e3-d7b6-4474-aa02-d610ebf81c6d', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:00:00', '11:15:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('114c4e7d-309c-4138-89d5-8e9930b6f439', '361dd8a5-1392-44a6-b682-4306ebbf5836', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '380131e3-d7b6-4474-aa02-d610ebf81c6d', 'SCHEDULED', 'CONFIRMED', '2026-09-17', '11:00:00', '11:15:00', 'Routine general health checkup and seasonal flu consultation')
  ON CONFLICT (id) DO NOTHING;


        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('528521cb-1fe2-458c-a3b5-8571a167600b', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('b7ec3dd1-eb7c-42d1-9b36-06d79b47bebf', '361dd8a5-1392-44a6-b682-4306ebbf5836', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '528521cb-1fe2-458c-a3b5-8571a167600b', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Follow-up for chronic hypertension and blood pressure review')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('b7ec3dd1-eb7c-42d1-9b36-06d79b47bebf', '361dd8a5-1392-44a6-b682-4306ebbf5836', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', '00000000-0000-0000-0000-000000000002', '361dd8a5-1392-44a6-b682-4306ebbf5836', 'b7ec3dd1-eb7c-42d1-9b36-06d79b47bebf', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('52d3d7fa-9c8a-44cc-a065-eae96d85935c', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('93645b6b-6f80-42b4-9e79-a34150564078', '088b9e7b-5c17-4e89-b37f-d709bd9c053b', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '52d3d7fa-9c8a-44cc-a065-eae96d85935c', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Skin rash and dry skin itchiness')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('93645b6b-6f80-42b4-9e79-a34150564078', '088b9e7b-5c17-4e89-b37f-d709bd9c053b', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', '00000000-0000-0000-0000-000000000002', '088b9e7b-5c17-4e89-b37f-d709bd9c053b', '93645b6b-6f80-42b4-9e79-a34150564078', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('cf3a1f9b-42df-4ab6-a559-6f249c12b1ff', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2587e7df-1535-4f7b-b296-ea8948f14c35', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('5b484602-d755-4df0-b99e-f9120d8d412a', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d6b5cf05-01f2-4fe7-b2ee-cbf1724efac3', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a0a69d32-5026-4aed-a9cc-387d3f991110', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('78d529b3-c6d0-4c22-b2f4-b2dfdcd768bf', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1c001491-f0cf-4a1d-93ea-749038e4aeaf', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('6888c0ff-2455-4475-81f5-39bf7530d363', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('aaede940-50f1-4c7a-8ac3-dbbb67fed576', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('7a343283-9f12-450c-abb2-6d0010aa23b7', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e45769d3-3948-467f-b62a-8598dd33e8d6', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('5886d6e3-b79c-475d-9d44-568783205274', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9718fddf-a178-437f-8947-e118bafadc8d', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('5ce21dcf-2b76-4cdd-bc2c-e3cd4514ed15', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('f18e79a9-4f6b-4ea1-9a8c-158272785701', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a380c4ac-b41a-4a09-85ff-4611be4c1592', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3da91ba7-6a2d-49f2-bd8d-588727ce33af', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('75331436-5732-4b9c-88f5-ac57d7ca2f1a', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1a8cc062-0db5-4d25-a9b4-1a699796117b', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('3e73390d-f489-42a7-999a-c44c5a2c4a2b', '16cc854d-827c-4a36-8653-e5237772f046', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '1a8cc062-0db5-4d25-a9b4-1a699796117b', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Follow-up for chronic hypertension and blood pressure review')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('3e73390d-f489-42a7-999a-c44c5a2c4a2b', '16cc854d-827c-4a36-8653-e5237772f046', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', '47114570-6168-4d2f-9d20-712e7abcb1c5', '16cc854d-827c-4a36-8653-e5237772f046', '3e73390d-f489-42a7-999a-c44c5a2c4a2b', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('deaf1a92-f4c9-4019-8369-88d246727392', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('3905cf0c-93d1-428b-bd65-be796dbdd82e', 'a575786b-e181-4935-8d89-06a5ad722adb', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'deaf1a92-f4c9-4019-8369-88d246727392', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Joint pain and stiffness in the morning')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('3905cf0c-93d1-428b-bd65-be796dbdd82e', 'a575786b-e181-4935-8d89-06a5ad722adb', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', '47114570-6168-4d2f-9d20-712e7abcb1c5', 'a575786b-e181-4935-8d89-06a5ad722adb', '3905cf0c-93d1-428b-bd65-be796dbdd82e', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2a96d651-28a8-4736-9811-044acf7b6710', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('ce5abb6e-7e08-478d-81b0-35e4e7d07bc6', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('7abce8a2-7594-4c30-81a3-1c3a41dff8cb', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('aee3f36f-5bbe-4532-9c91-50e414d5bd67', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a7be78c9-033f-483b-9d17-bd86023c5ee7', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('4844897d-fff2-4b5b-bcf1-f53c1d3e34cd', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('6b638333-e938-4ce1-8ceb-c53e3a21a23d', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('8b82e4bc-b673-49cf-957a-854b17ed0170', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('f57145fa-4260-4f61-b8ad-3b2910a5fc61', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('5009efc5-a7c9-4cc0-a4b2-452e94cedebc', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('838e1e00-7648-42bd-bbc1-816cea59fb6b', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1cdaefeb-f11c-4eed-a902-3a8b4e1c2188', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('082fee30-1e1a-4238-b412-1ddfd252118d', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1ce0d770-8816-4ebb-9a88-e58a4c5bb618', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d267ebd8-bebf-459c-9cad-c58e4f50b9f5', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('be0398e9-3f10-4704-97de-323b7ac19bf3', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('80db573c-63e5-49b9-8bbd-0dfa921b7021', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9e0e0066-1dcb-4a35-8c72-bc27820ac890', '47114570-6168-4d2f-9d20-712e7abcb1c5', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('dafeb7ef-ade9-41c2-8e6c-26c472ebabbe', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('6caf65de-a16a-4fcb-9fb9-6cb93cf84c77', '53bfa8d9-f36c-4207-8092-d833c7ccf6df', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 'dafeb7ef-ade9-41c2-8e6c-26c472ebabbe', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Joint pain and stiffness in the morning')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('6caf65de-a16a-4fcb-9fb9-6cb93cf84c77', '53bfa8d9-f36c-4207-8092-d833c7ccf6df', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', '21110055-1611-482d-b539-5b2ad11e0da6', '53bfa8d9-f36c-4207-8092-d833c7ccf6df', '6caf65de-a16a-4fcb-9fb9-6cb93cf84c77', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('00d72361-b405-479e-a313-2a06de8a7be4', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('5e0c7113-222a-4332-ab52-c0e13c8e20a5', '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '00d72361-b405-479e-a313-2a06de8a7be4', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Mild chest discomfort during exertion — preliminary evaluation')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('5e0c7113-222a-4332-ab52-c0e13c8e20a5', '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', '21110055-1611-482d-b539-5b2ad11e0da6', '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '5e0c7113-222a-4332-ab52-c0e13c8e20a5', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('fa0cdd1a-4524-4c61-927c-0c97c1d2a7cc', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('60579328-cac8-458c-9229-7e19d72364a5', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('fa8b2f0e-d515-4e5e-a2be-06f3245688a0', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2d97239f-65c2-45c0-9a6e-b5fdbe992f14', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('b348e01e-1e75-4a5c-84a1-29e6809be719', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('5d6c399c-5a3f-4289-8b62-8ce2e74ea85a', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1a46f643-cf46-4fe3-baee-ffefa1408d38', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1c843c6b-7a16-4985-8d7e-5a61e18d59c1', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e1ed6d14-3a3b-40ee-8c39-62c22074bb2c', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d11ce794-9db6-4175-9892-b85af1c89322', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('fb034973-2e80-449c-b0d6-075f671c8da6', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9af0be0e-070f-4f51-bb89-0a1b88c91155', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('33d6b035-6f58-47a4-9294-1af52978a766', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('0b72e3ee-7c15-4292-99cb-b5708afc18d5', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e77281ed-ee4e-4f85-a375-9ee865a402ca', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2e276b7e-0e18-40bd-b888-cd349157a6e0', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d3df29d0-f2fa-4f4e-8082-fa918ea26556', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a69172b1-a0f4-48e8-8a07-8476de904840', '21110055-1611-482d-b539-5b2ad11e0da6', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('4a577a87-82ce-4fcf-a1cd-b5e492a4a0bf', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('78050d80-9467-4e8e-aee0-700023975b6c', '711cde25-d481-4812-bc2b-6770e6881b1d', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '4a577a87-82ce-4fcf-a1cd-b5e492a4a0bf', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Seasonal allergies, sneezing, and sore throat')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('78050d80-9467-4e8e-aee0-700023975b6c', '711cde25-d481-4812-bc2b-6770e6881b1d', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '711cde25-d481-4812-bc2b-6770e6881b1d', '78050d80-9467-4e8e-aee0-700023975b6c', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('23e1dd8e-bb45-4000-af9d-6d90e7c5dc32', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('6c862f0c-60b4-4805-809a-9d00b54d33be', '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '23e1dd8e-bb45-4000-af9d-6d90e7c5dc32', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Persistent headache and mild fever for two days')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('6c862f0c-60b4-4805-809a-9d00b54d33be', '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', '6c862f0c-60b4-4805-809a-9d00b54d33be', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9efe8977-f533-46c4-b503-f42597fb0933', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('480ab3f4-d01a-4227-80a1-4c321dd9b9f7', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a836e129-fcef-4c07-a9c5-19e47225627f', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('47953421-54a2-4d67-a878-6c1d0cd5600b', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('450c6144-494a-4d5c-a5c4-3a4635d05e69', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('49921a0d-1f40-47a8-8c05-ff486a4507fe', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e012a198-d3dd-4e23-aa02-34fdbf662cd6', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('949a3baf-f82e-4346-bcd6-7d178b0f7248', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('63f1491d-f083-42c3-bf64-0995ad7c1f65', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d2b7484e-ec62-4c43-be3b-5a629a3b4b92', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('30e6cdf0-53f1-4628-958d-a3bef2d4c908', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a292174e-020b-400e-8142-7b452b4a1aa0', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('202d6ff9-92ff-4e38-b226-e88d239fc87a', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e93c2a9d-0e70-4fe6-825e-25846aa45786', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('7f0bb764-0965-4681-81b5-1923e74ceb00', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('71d7920a-2bd2-469d-89d6-3ced80fdfcc9', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9b0efa52-6a13-44eb-b8ac-976e7208dd32', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('59e72c45-a859-4a55-bdd4-0a601b56f846', '351cc204-b20f-408a-9ff9-f1f0e49a8956', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1a210dc1-acbe-4e08-bc09-b7dcbcad70c9', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('dd1224f7-e3c2-44dc-97c4-762fcb0c6e22', '40133434-eb9d-4e89-9fac-130d00f8bd99', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '1a210dc1-acbe-4e08-bc09-b7dcbcad70c9', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Mild chest discomfort during exertion — preliminary evaluation')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('dd1224f7-e3c2-44dc-97c4-762fcb0c6e22', '40133434-eb9d-4e89-9fac-130d00f8bd99', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', '40133434-eb9d-4e89-9fac-130d00f8bd99', 'dd1224f7-e3c2-44dc-97c4-762fcb0c6e22', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('4af46af4-805d-4d32-9892-59113662fb81', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('d7e0f913-e453-4d7c-b068-8a9f0c72a7de', '387eb9a0-71c4-4846-a8b9-e3b30c7b1a90', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '4af46af4-805d-4d32-9892-59113662fb81', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Annual general health checkup and lipid screening')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('d7e0f913-e453-4d7c-b068-8a9f0c72a7de', '387eb9a0-71c4-4846-a8b9-e3b30c7b1a90', 'b9c5ff36-4ef4-441e-b442-775663d8652a', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('b9c5ff36-4ef4-441e-b442-775663d8652a', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', '387eb9a0-71c4-4846-a8b9-e3b30c7b1a90', 'd7e0f913-e453-4d7c-b068-8a9f0c72a7de', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c52d36f6-f322-4f16-8251-d1c58e519dd9', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('77bb3caf-66ac-49be-b10e-cef25eb2ab48', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('baa5e44a-0adb-433c-861d-b9d48a6e19c7', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('917765c6-41d1-4fb6-95a6-6d1219baf189', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('17f3e836-f724-4066-850f-615cb5c1193f', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('dd2b9192-20b5-4437-8958-1033bd63bab4', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e858a5ca-2e57-4144-8681-e33cd8f8c7b7', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3ce9c35b-a8fa-4b1c-966d-e5489748603e', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('59c42b1c-1cfe-43a0-88cf-cc7abbcf63c2', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c600f8c6-f824-4def-9dd3-1ddbef83c20e', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('33274dd7-2795-464b-b9a1-e7312ce22fa7', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('fbeb6629-a69e-499f-93cc-47c6a6cee318', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c849ba38-5ecd-4d55-99b4-29f569368e7f', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('4bdb7143-b5b4-4047-9a8c-58757765c2ed', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('8031ef8a-517b-47ea-8a95-aa31598f3490', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9b18296d-802f-467a-8459-b31a18f49db4', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9251d4c1-083b-4aff-a935-730fedb92b20', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('fe6ed6b7-88e9-4d7a-9068-2c6c4416acb7', '78cbec1d-28e6-4079-8eaa-0c2e6b40b359', 'b9c5ff36-4ef4-441e-b442-775663d8652a', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('dfefb21b-b8d6-4cb1-a3c0-ad70baffe6c2', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('9f7e44d1-7e88-4b56-ac70-5a20e560dced', '651f1079-3801-4852-8b03-d9e272b42ffc', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 'dfefb21b-b8d6-4cb1-a3c0-ad70baffe6c2', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Annual general health checkup and lipid screening')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('9f7e44d1-7e88-4b56-ac70-5a20e560dced', '651f1079-3801-4852-8b03-d9e272b42ffc', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', '071feecb-1470-47cd-b078-a9db91d7a69d', '651f1079-3801-4852-8b03-d9e272b42ffc', '9f7e44d1-7e88-4b56-ac70-5a20e560dced', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2a31f210-80ff-43d9-b6cd-d7e3de1e41c8', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('96a92203-91de-44c3-be52-78c082051fef', 'dca33f00-00a3-46cd-ae8b-69f3f612d5ee', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2a31f210-80ff-43d9-b6cd-d7e3de1e41c8', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Follow-up for chronic hypertension and blood pressure review')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('96a92203-91de-44c3-be52-78c082051fef', 'dca33f00-00a3-46cd-ae8b-69f3f612d5ee', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('b75a94a9-eb46-4308-a3ee-2276bf0ae432', '071feecb-1470-47cd-b078-a9db91d7a69d', 'dca33f00-00a3-46cd-ae8b-69f3f612d5ee', '96a92203-91de-44c3-be52-78c082051fef', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('abb7b71b-b7f1-49fe-be1a-2c8cf1a0274d', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('f05f5b42-dd0e-40fe-8baf-e629ac7676a8', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('79d0ef8d-04b6-49fd-9ad6-ee5c673f744e', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d6de51a8-2e28-4421-9ab6-840ba47201e1', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('ff4360ef-7432-4960-b000-9a112e2ed519', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a4153732-93c0-495f-8a2d-dd4a616bc39c', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3119f8de-535c-41e7-b879-1413bf29a4b2', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1d3af964-1b67-4263-85ee-845d1736b87d', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c7a4bb85-9ca9-4309-a68c-e70cc036cbda', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('cd3577d9-b43b-4dc2-bbba-bc8c1c4e1736', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('047a1ad3-26e1-4efb-b891-6e2592790095', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d71dcbdc-a1e1-4c34-8d18-067e6b60d4b3', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3b4d057e-2087-42b7-9cf1-0c612d23388f', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c1badeea-c512-4ef4-bda9-8987ce38903a', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('b70e81d8-2c9f-4cc5-a28a-6caac6c78509', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('415b16c4-692f-4d0c-a4c5-17627dd5e707', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2aaa85db-27b4-4ef2-9907-ba4300291e75', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('00bd73c7-4a06-48f3-9d15-25d7e32c8835', '071feecb-1470-47cd-b078-a9db91d7a69d', 'b75a94a9-eb46-4308-a3ee-2276bf0ae432', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('86892cbf-4cd2-4dc8-aec1-48ac19552aea', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('99a550a3-82a6-442e-9b63-885b7375de48', '7ff9b795-eb07-40c2-9cc9-568c14f652ec', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '86892cbf-4cd2-4dc8-aec1-48ac19552aea', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Skin rash and dry skin itchiness')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('99a550a3-82a6-442e-9b63-885b7375de48', '7ff9b795-eb07-40c2-9cc9-568c14f652ec', 'e36436e7-563f-4696-a061-c137ca91a8e0', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', '28bc6247-1601-44aa-8acf-065cfbb14d2e', '7ff9b795-eb07-40c2-9cc9-568c14f652ec', '99a550a3-82a6-442e-9b63-885b7375de48', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('eb4822b8-6e21-470f-83f6-c90e7cd540e3', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('2d10d0f5-4a32-4a7c-9571-fc3b951f0545', 'd1b088f2-4e19-4c87-8313-9749c9caca04', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', 'eb4822b8-6e21-470f-83f6-c90e7cd540e3', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Annual general health checkup and lipid screening')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('2d10d0f5-4a32-4a7c-9571-fc3b951f0545', 'd1b088f2-4e19-4c87-8313-9749c9caca04', 'e36436e7-563f-4696-a061-c137ca91a8e0', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('e36436e7-563f-4696-a061-c137ca91a8e0', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'd1b088f2-4e19-4c87-8313-9749c9caca04', '2d10d0f5-4a32-4a7c-9571-fc3b951f0545', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('97c7737d-3760-4787-922e-8834e8d1643f', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3e4232d7-48a1-4a99-b4db-2a1601903bec', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('869d228e-970f-469b-a4b8-dac1f60035bb', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c9aa62cb-ffb2-4ac6-8f27-340e96ce830f', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('95091b76-d89e-4ff7-bab3-bfe62711e820', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('85c3edb7-35e6-4872-ba6e-d1524d6bca46', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3592365c-74a3-414f-871e-391d586648a6', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('f18087a7-44bb-4042-9c2d-372d40cd12ed', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d75f1d4f-984a-4360-ad1f-73916a386479', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('438ae549-41a1-49b9-bb8f-2a493ee08e3b', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1bda2de7-4704-405a-a7b3-7558d7cda05c', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e5428a1b-03a5-4035-a62c-fef44bdc259d', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('92fdc8a1-5be7-4517-872a-3bcfe94296e6', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2759fa26-ed22-4ac1-a476-4d809db7602f', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('0d24b1ef-6ad7-4dfa-9b61-b4a70c3abf06', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('e05cf545-d5e2-4c0d-8c08-9b41074e94b5', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('39f671fa-b8f2-4df8-895f-73a3126b62df', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3374084b-5541-4b58-9531-4a799a73296f', '28bc6247-1601-44aa-8acf-065cfbb14d2e', 'e36436e7-563f-4696-a061-c137ca91a8e0', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('fc393e19-7a82-4f26-8b20-0a3504b91a30', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('84fa4a0d-06d5-43bd-9ea7-de9a4aa73081', '65fd5d79-2034-4490-bc6e-6472d4d908d3', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 'fc393e19-7a82-4f26-8b20-0a3504b91a30', 'SCHEDULED', 'IN_CONSULTATION'::public.appointment_status, '2026-09-17', '09:00:00', '09:15:00', 'Persistent headache and mild fever for two days')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('84fa4a0d-06d5-43bd-9ea7-de9a4aa73081', '65fd5d79-2034-4490-bc6e-6472d4d908d3', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 'c752c13a-eae5-440b-bd29-2827b8ef812a', '65fd5d79-2034-4490-bc6e-6472d4d908d3', '84fa4a0d-06d5-43bd-9ea7-de9a4aa73081', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('2d5ca43e-e8bb-4b35-9f0f-61e635c454a8', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

        INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
        VALUES ('3be51246-4952-4501-b82e-e5d90c050957', 'baa1a141-b344-43ca-a31d-c1412db9ca5d', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2d5ca43e-e8bb-4b35-9f0f-61e635c454a8', 'SCHEDULED', 'WAITING'::public.appointment_status, '2026-09-17', '09:15:00', '09:30:00', 'Follow-up for chronic hypertension and blood pressure review')
        ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
        VALUES ('3be51246-4952-4501-b82e-e5d90c050957', 'baa1a141-b344-43ca-a31d-c1412db9ca5d', 'ec931301-ad5c-4e14-9c3e-ea0332475701', 'APP')
        ON CONFLICT (appointment_id) DO NOTHING;

        INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
        VALUES ('ec931301-ad5c-4e14-9c3e-ea0332475701', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'baa1a141-b344-43ca-a31d-c1412db9ca5d', '3be51246-4952-4501-b82e-e5d90c050957', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING'::public.queue_status)
        ON CONFLICT (appointment_id) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('ed9dd782-a8f6-4897-9626-c60d3d5cb774', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('c7719386-8536-4806-99fc-27416f690dce', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('155cccbe-bd48-4612-b3b7-7c63689e870c', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('994c4d8c-24cd-44dc-bfdd-dcae001bac4d', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('0c8dbb92-c19c-4296-97b6-f4476d619ac3', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('41e70cdc-1520-4342-b1a9-f66d9f2c1f81', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('1182a077-1d52-429d-b7dd-d3dd4fb133ba', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('a505a2e3-ed20-45b4-b627-0254f1a16bbb', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('3f702f69-0bb5-4afa-9dcd-9dd938bb7d1a', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('d1c9e89e-49bf-429a-b57d-4fbc59e6273a', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('26be77d2-0daf-4f0c-be0c-363d1375228b', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('cfa7c740-dd99-4c51-887e-41769c8ace28', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('866c5e71-1505-4966-ab29-39657df7613a', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9be21cee-95c6-4e49-bb84-b6c00683f766', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('93fbaee6-e790-4d48-8324-21edb1738be6', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('73059450-b7f9-4ee5-8126-9b29ef375638', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('9b5b673e-156f-45df-9fd8-3c979d9def02', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      

        INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
        VALUES ('51677bde-6f15-473b-b748-4073e18d00d4', 'c752c13a-eae5-440b-bd29-2827b8ef812a', 'ec931301-ad5c-4e14-9c3e-ea0332475701', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
        ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
      