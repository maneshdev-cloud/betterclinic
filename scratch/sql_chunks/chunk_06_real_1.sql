
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('8922898f-cd9e-4305-b52b-0c32be06edb0', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('9d1053b0-5c6e-45df-8ca4-b2c3a14b5aa1', '088b9e7b-5c17-4e89-b37f-d709bd9c053b', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '8922898f-cd9e-4305-b52b-0c32be06edb0', 'SCHEDULED', 'IN_CONSULTATION', '2026-09-17', '09:00:00', '09:15:00', 'Chronic hypertension and monthly blood pressure follow-up')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
  VALUES ('9d1053b0-5c6e-45df-8ca4-b2c3a14b5aa1', '088b9e7b-5c17-4e89-b37f-d709bd9c053b', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'APP')
  ON CONFLICT (appointment_id) DO NOTHING;

  INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
  VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', '00000000-0000-0000-0000-000000000002', '088b9e7b-5c17-4e89-b37f-d709bd9c053b', '9d1053b0-5c6e-45df-8ca4-b2c3a14b5aa1', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION')
  ON CONFLICT (appointment_id) DO NOTHING;


  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('6877ad8d-017c-4702-ab70-8a6ca9ff769e', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('28a5815f-362a-4982-8512-64d4febfe040', '16cc854d-827c-4a36-8653-e5237772f046', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '6877ad8d-017c-4702-ab70-8a6ca9ff769e', 'SCHEDULED', 'WAITING', '2026-09-17', '09:15:00', '09:30:00', 'Skin rash and allergic dry dermatitis')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
  VALUES ('28a5815f-362a-4982-8512-64d4febfe040', '16cc854d-827c-4a36-8653-e5237772f046', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'APP')
  ON CONFLICT (appointment_id) DO NOTHING;

  INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
  VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', '00000000-0000-0000-0000-000000000002', '16cc854d-827c-4a36-8653-e5237772f046', '28a5815f-362a-4982-8512-64d4febfe040', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING')
  ON CONFLICT (appointment_id) DO NOTHING;


  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('beaa2413-3843-409e-93aa-6a4f224ae9dd', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:30:00', '09:45:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
  VALUES ('12ac2f28-db76-45b0-9f54-4cd1ab712fb5', '361dd8a5-1392-44a6-b682-4306ebbf5836', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'beaa2413-3843-409e-93aa-6a4f224ae9dd', 'SCHEDULED', 'WAITING', '2026-09-17', '09:30:00', '09:45:00', 'Routine general health checkup and seasonal flu consultation')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
  VALUES ('12ac2f28-db76-45b0-9f54-4cd1ab712fb5', '361dd8a5-1392-44a6-b682-4306ebbf5836', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'APP')
  ON CONFLICT (appointment_id) DO NOTHING;

  INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
  VALUES ('a923ac40-1961-4256-b903-4cffc4464ad4', '00000000-0000-0000-0000-000000000002', '361dd8a5-1392-44a6-b682-4306ebbf5836', '12ac2f28-db76-45b0-9f54-4cd1ab712fb5', '2026-09-17', 3, 'T003', 'NORMAL', 'WAITING')
  ON CONFLICT (appointment_id) DO NOTHING;


    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('369b70be-7877-481d-bda2-cc46bc52bf58', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('b4911381-1f2a-4c17-a93b-5f3c49ec343c', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('0365a909-1e03-454a-a813-9242422c4f53', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('8bb36477-b9fd-4134-89f5-42e9a346e327', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('e7036882-62ea-45e7-b474-9ab572210ec7', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('eafface2-c71f-475a-8fc6-7cdb17d633fd', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('1667899f-9807-4828-acb8-643263e3d03b', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('e8d32930-fa90-4463-9f0f-6e66535f9694', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:30:00', '11:45:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('ca0cb7c0-492b-4e43-b19b-3f64510d2226', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '11:45:00', '12:00:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('aec67f93-1b7b-466c-93fb-250cd5b0f2f4', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:00:00', '14:15:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('1ac18ff0-1403-41db-a853-2fdbf66f81c0', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:15:00', '14:30:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('9c1e44a2-76c3-4e38-a4f3-a4392fef4ac6', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:30:00', '14:45:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('2b4728a5-69e1-4780-8b35-88503c25d850', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '14:45:00', '15:00:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('828735eb-7ad5-4c7c-909f-a6f2fa5af424', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:00:00', '15:15:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('2b86628c-76c2-4978-8835-898f3cf81607', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:15:00', '15:30:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('b00e4000-6292-45d2-af02-90a160e8f53e', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:30:00', '15:45:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('4464445a-61e4-40e7-8db3-fc03cd809e71', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-17', '15:45:00', '16:00:00', 'FREE')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('e9561432-cc25-4686-bc15-6d45a999f46e', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('b3d45315-baaa-4c47-bce2-5f8c782e8dd0', 'a575786b-e181-4935-8d89-06a5ad722adb', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'e9561432-cc25-4686-bc15-6d45a999f46e', 'SCHEDULED', 'IN_CONSULTATION', '2026-09-17', '09:00:00', '09:15:00', 'Routine checkup and consultation')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('b3d45315-baaa-4c47-bce2-5f8c782e8dd0', 'a575786b-e181-4935-8d89-06a5ad722adb', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', '040d22e0-4981-4b50-a339-696906276686', 'a575786b-e181-4935-8d89-06a5ad722adb', 'b3d45315-baaa-4c47-bce2-5f8c782e8dd0', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION')
    ON CONFLICT (appointment_id) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('a2016706-c309-4b4f-aae9-f19fde257720', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('ef554171-49a8-4a69-8425-9632a810033b', '53bfa8d9-f36c-4207-8092-d833c7ccf6df', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'a2016706-c309-4b4f-aae9-f19fde257720', 'SCHEDULED', 'WAITING', '2026-09-17', '09:15:00', '09:30:00', 'Evaluation and prescription renewal')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('ef554171-49a8-4a69-8425-9632a810033b', '53bfa8d9-f36c-4207-8092-d833c7ccf6df', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('9defe45b-25a6-4d52-adc3-8082c8a8f56f', '040d22e0-4981-4b50-a339-696906276686', '53bfa8d9-f36c-4207-8092-d833c7ccf6df', 'ef554171-49a8-4a69-8425-9632a810033b', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING')
    ON CONFLICT (appointment_id) DO NOTHING;
  

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('5b0c41bd-f5aa-4715-b810-7a58ace84759', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('039d1bbd-e239-41e5-ac19-ab95e6ea6f90', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('3533cddb-74e6-4dfc-9e8d-2c8c951935c0', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('795fd1e3-f54f-4834-a2d3-0de8877a5a93', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('2e7c0b01-6fdf-470b-a9bd-31e9d5dc6488', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('168084fd-fb0f-41b4-aeee-f1aea1beb080', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('f7369404-4f6a-4638-92ae-b78afd247ef5', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('a47eca89-6e85-4d5f-a73d-bd237a98c533', '040d22e0-4981-4b50-a339-696906276686', '9defe45b-25a6-4d52-adc3-8082c8a8f56f', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('91e7d42d-dcf0-4150-baa0-172057f4096c', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('6055d6c6-8794-402e-ab2c-162d2823072b', '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '91e7d42d-dcf0-4150-baa0-172057f4096c', 'SCHEDULED', 'IN_CONSULTATION', '2026-09-17', '09:00:00', '09:15:00', 'Routine checkup and consultation')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('6055d6c6-8794-402e-ab2c-162d2823072b', '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', '438d6569-0c7a-40ae-909c-53c46e69827d', '6a86b9e5-56db-44c1-b67e-8dd92fd0cc56', '6055d6c6-8794-402e-ab2c-162d2823072b', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION')
    ON CONFLICT (appointment_id) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('f71ec88f-d5e1-43e8-adaf-74dc0b823ef4', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('c0353b43-88c2-4bc6-9096-3a529a4c2963', '711cde25-d481-4812-bc2b-6770e6881b1d', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 'f71ec88f-d5e1-43e8-adaf-74dc0b823ef4', 'SCHEDULED', 'WAITING', '2026-09-17', '09:15:00', '09:30:00', 'Evaluation and prescription renewal')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('c0353b43-88c2-4bc6-9096-3a529a4c2963', '711cde25-d481-4812-bc2b-6770e6881b1d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('274970a3-9522-4dbe-9d41-cc2e32b184ca', '438d6569-0c7a-40ae-909c-53c46e69827d', '711cde25-d481-4812-bc2b-6770e6881b1d', 'c0353b43-88c2-4bc6-9096-3a529a4c2963', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING')
    ON CONFLICT (appointment_id) DO NOTHING;
  

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('24c2f9e1-b556-492e-ba0f-997ca51dc120', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('f41a5483-9cda-404b-802d-14839b00dcf6', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('21043e14-dc5e-4535-aa01-bcfc9b924a79', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('a856010d-dc49-40c3-80c4-993aa071af17', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('1fd422af-de80-4575-9a14-bcada2c47d03', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('a1a3fe25-572b-42a4-907f-6d807ebd9386', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('71639a52-c6f5-4a3a-8687-c91ff8ab0c87', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('e0b10359-a866-4d0e-a8b9-7e86cb5db014', '438d6569-0c7a-40ae-909c-53c46e69827d', '274970a3-9522-4dbe-9d41-cc2e32b184ca', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('476e8a5d-cd07-4cd1-9a9c-162ea3d177de', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:00:00', '09:15:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('caf5e3d1-6792-421a-aa5a-042b1580be2d', '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '476e8a5d-cd07-4cd1-9a9c-162ea3d177de', 'SCHEDULED', 'IN_CONSULTATION', '2026-09-17', '09:00:00', '09:15:00', 'Routine checkup and consultation')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('caf5e3d1-6792-421a-aa5a-042b1580be2d', '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '6d5f7b1c-dea0-4964-afed-3cfd0dc31ea7', 'caf5e3d1-6792-421a-aa5a-042b1580be2d', '2026-09-17', 1, 'T001', 'NORMAL', 'IN_CONSULTATION')
    ON CONFLICT (appointment_id) DO NOTHING;
  

    INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
    VALUES ('61372c51-9a7e-4aab-90c1-9397fbdf9530', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:15:00', '09:30:00', 'BOOKED')
    ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

    INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason)
    VALUES ('02d530f9-f18f-4145-aae3-0dd2dbd183e9', '40133434-eb9d-4e89-9fac-130d00f8bd99', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '61372c51-9a7e-4aab-90c1-9397fbdf9530', 'SCHEDULED', 'WAITING', '2026-09-17', '09:15:00', '09:30:00', 'Evaluation and prescription renewal')
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.check_ins (appointment_id, patient_id, clinic_id, method)
    VALUES ('02d530f9-f18f-4145-aae3-0dd2dbd183e9', '40133434-eb9d-4e89-9fac-130d00f8bd99', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'APP')
    ON CONFLICT (appointment_id) DO NOTHING;

    INSERT INTO public.queue_entries (clinic_id, doctor_id, patient_id, appointment_id, queue_date, token_number, token_code, priority, status)
    VALUES ('88e85be0-2235-4bf6-a389-0ae62ceabb8d', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '40133434-eb9d-4e89-9fac-130d00f8bd99', '02d530f9-f18f-4145-aae3-0dd2dbd183e9', '2026-09-17', 2, 'T002', 'NORMAL', 'WAITING')
    ON CONFLICT (appointment_id) DO NOTHING;
  

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('b42cbf36-f600-459b-8fa9-3d69b3e73f14', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:30:00', '09:45:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('120e5df3-54c5-4781-a90a-a46a11ca4348', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '09:45:00', '10:00:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('49aac9de-cefe-4180-bcad-a0e49b1c89bd', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:00:00', '10:15:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('bc43b1e9-1922-4213-8ec9-9bfa02bb6258', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:15:00', '10:30:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('5ff2fa3e-c868-42a1-bc70-2dcbeee34188', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:30:00', '10:45:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('9df2cd42-88ef-4f1e-a7de-a21d4cd70d7d', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '10:45:00', '11:00:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('039fdb50-c40a-40c2-b3a0-69811c4c2644', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '11:00:00', '11:15:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    

      INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
      VALUES ('16d9c107-2d9b-466a-a99f-425660a88b88', 'cfaf24a4-6ef5-45f3-98e8-31d340a6e9d7', '88e85be0-2235-4bf6-a389-0ae62ceabb8d', '2026-09-17', '11:15:00', '11:30:00', 'FREE')
      ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;
    