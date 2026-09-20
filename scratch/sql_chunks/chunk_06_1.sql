
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