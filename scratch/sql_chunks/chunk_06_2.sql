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