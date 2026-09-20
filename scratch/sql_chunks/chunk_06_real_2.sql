
  -- Past Appointment
  INSERT INTO public.appointment_slots (id, doctor_id, clinic_id, slot_date, start_time, end_time, status)
  VALUES ('e848fde6-b32f-4bf3-9a24-5ff01cc4803c', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-10', '10:00:00', '10:15:00', 'BOOKED')
  ON CONFLICT (doctor_id, clinic_id, slot_date, start_time) DO NOTHING;

  INSERT INTO public.appointments (id, patient_id, doctor_id, clinic_id, slot_id, appointment_type, status, appointment_date, start_time, end_time, visit_reason, notes)
  VALUES ('86ccabf5-1260-41c9-a6ae-28079efbdff6', '361dd8a5-1392-44a6-b682-4306ebbf5836', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', 'e848fde6-b32f-4bf3-9a24-5ff01cc4803c', 'SCHEDULED', 'COMPLETED', '2026-09-10', '10:00:00', '10:15:00', 'Persistent dry cough and mild fever', 'Patient advised to complete 5-day course and rest.')
  ON CONFLICT (id) DO NOTHING;

  -- Past Consultation
  INSERT INTO public.consultations (id, appointment_id, patient_id, doctor_id, clinic_id, consultation_date, chief_complaint, symptoms, examination_findings, diagnosis, treatment_plan, follow_up_date, vitals)
  VALUES (
    'cab4113f-f670-4a12-8c2c-60eea55f56e7', '86ccabf5-1260-41c9-a6ae-28079efbdff6', '361dd8a5-1392-44a6-b682-4306ebbf5836', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4', '2026-09-10',
    'Dry cough for 3 days, low-grade fever, sore throat',
    'Throat irritation, dry cough aggravated at night, mild fatigue',
    'Pharyngeal erythema present. Lungs clear to auscultation bilaterally. No lymphadenopathy.',
    'Acute viral pharyngitis with mild upper respiratory tract infection',
    'Hydration, steam inhalation twice daily, oral antipyretic SOS, warm saline gargles.',
    '2026-09-17',
    '{"bp_systolic": 120, "bp_diastolic": 80, "heart_rate": 74, "temperature": 99.1, "spo2": 98, "weight_kg": 70}'::jsonb
  ) ON CONFLICT (id) DO NOTHING;

  -- Past Prescription
  INSERT INTO public.prescriptions (id, consultation_id, patient_id, doctor_id, clinic_id, notes)
  VALUES (
    'bc49a76f-5761-41f1-91f3-f73961a6bdb3', 'cab4113f-f670-4a12-8c2c-60eea55f56e7', '361dd8a5-1392-44a6-b682-4306ebbf5836', '00000000-0000-0000-0000-000000000002', 'a923ac40-1961-4256-b903-4cffc4464ad4',
    'Take medications after meals with plenty of water. Avoid cold beverages.'
  ) ON CONFLICT (id) DO NOTHING;

  -- Prescription Items (referencing valid medicines from 01_reference.sql)
  INSERT INTO public.prescription_items (prescription_id, medicine_id, custom_medicine_name, dosage, frequency, duration, instructions)
  SELECT 
    'bc49a76f-5761-41f1-91f3-f73961a6bdb3',
    id,
    null,
    '500mg',
    '1-0-1',
    '5 days',
    'Take after meals'
  FROM public.medicines
  WHERE name ILIKE '%Paracetamol%' OR name ILIKE '%Crocin%'
  LIMIT 1
  ON CONFLICT DO NOTHING;

  INSERT INTO public.prescription_items (prescription_id, medicine_id, custom_medicine_name, dosage, frequency, duration, instructions)
  SELECT 
    'bc49a76f-5761-41f1-91f3-f73961a6bdb3',
    id,
    null,
    '10mg',
    '0-0-1',
    '5 days',
    'Take before sleep'
  FROM public.medicines
  WHERE name ILIKE '%Cetirizine%' OR name ILIKE '%Montair%'
  LIMIT 1
  ON CONFLICT DO NOTHING;
