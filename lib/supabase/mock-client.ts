import {
  MOCK_CLINICS,
  MOCK_DOCTORS,
  MOCK_SPECIALIZATIONS,
  MOCK_APPOINTMENTS,
  DEMO_ACCOUNTS,
} from "@/lib/mock-data";

export interface MockState {
  slots: Record<
    string,
    {
      id: string;
      doctor_id: string;
      clinic_id: string;
      slot_date: string;
      start_time: string;
      end_time: string;
      status: "FREE" | "BOOKED";
      appointment_id?: string;
    }
  >;
  appointments: any[];
  queue_entries: any[];
  queue_events: any[];
  appointment_status_history: any[];
  consultations: any[];
  prescriptions: any[];
  ai_conversations: any[];
  ai_messages: any[];
  emergency_requests: any[];
  medical_history: any[];
  follow_ups: any[];
  user_preferences: any[];
}

function getGlobalMockState(): MockState {
  const g = globalThis as any;
  if (!g.__bc_mock_state) {
    const today = new Date().toISOString().slice(0, 10);
    g.__bc_mock_state = {
      slots: {},
      appointments: JSON.parse(JSON.stringify(MOCK_APPOINTMENTS)),
      queue_entries: [
        {
          id: "q-001",
          token_code: "A-001",
          token_number: 1,
          priority: "NORMAL",
          status: "IN_CONSULTATION",
          clinic_id: MOCK_CLINICS[0].id,
          doctor_id: MOCK_DOCTORS[0].id,
          patient_id: "p-other-1",
          appointment_id: "appt-other-1",
          queue_date: today,
          created_at: new Date(Date.now() - 3600000).toISOString(),
          called_at: new Date(Date.now() - 600000).toISOString(),
          patient: { profile: { full_name: "Rahul Verma" } },
          doctor: { profile: { full_name: MOCK_DOCTORS[0].profile.full_name } },
          appointment: {
            visit_reason: "Fever and mild chest congestion",
            start_time: "10:00:00",
            appointment_type: "SCHEDULED",
          },
        },
        {
          id: "q-002",
          token_code: "A-002",
          token_number: 2,
          priority: "NORMAL",
          status: "CALLED",
          clinic_id: MOCK_CLINICS[0].id,
          doctor_id: MOCK_DOCTORS[0].id,
          patient_id: "p-other-2",
          appointment_id: "appt-other-2",
          queue_date: today,
          created_at: new Date(Date.now() - 3000000).toISOString(),
          called_at: new Date(Date.now() - 120000).toISOString(),
          patient: { profile: { full_name: "Sneha Kapur" } },
          doctor: { profile: { full_name: MOCK_DOCTORS[0].profile.full_name } },
          appointment: {
            visit_reason: "Migraine follow-up",
            start_time: "10:30:00",
            appointment_type: "SCHEDULED",
          },
        },
        {
          id: "q-003",
          token_code: "A-003",
          token_number: 3,
          priority: "NORMAL",
          status: "WAITING",
          clinic_id: MOCK_CLINICS[0].id,
          doctor_id: MOCK_DOCTORS[0].id,
          patient_id: "00000000-0000-0000-0000-000000000010",
          appointment_id: "a5555555-5555-5555-5555-555555555555",
          queue_date: today,
          created_at: new Date(Date.now() - 2400000).toISOString(),
          called_at: null,
          patient: { profile: { full_name: "Rohan Mehta" } },
          doctor: { profile: { full_name: MOCK_DOCTORS[0].profile.full_name } },
          appointment: {
            visit_reason: "Primary health consultation and general wellness checkup",
            start_time: "10:30:00",
            appointment_type: "SCHEDULED",
          },
        },
      ],
      queue_events: [
        {
          id: "qe-1",
          queue_entry_id: "q-003",
          event_type: "CREATED",
          to_status: "WAITING",
          note: "Checked in via web portal",
          created_at: new Date(Date.now() - 2400000).toISOString(),
        },
      ],
      appointment_status_history: [
        {
          id: "ash-1",
          appointment_id: "a1111111-1111-1111-1111-111111111111",
          from_status: null,
          to_status: "BOOKED",
          reason: "Initial booking",
          created_at: new Date(Date.now() - 86400000).toISOString(),
          changed_by: { full_name: "Ananya Sharma" },
        },
        {
          id: "ash-2",
          appointment_id: "a1111111-1111-1111-1111-111111111111",
          from_status: "BOOKED",
          to_status: "CONFIRMED",
          reason: "Slot confirmation",
          created_at: new Date(Date.now() - 3600000 * 12).toISOString(),
          changed_by: { full_name: "Clinic Automated Desk" },
        },
      ],
      consultations: [
        {
          id: "c1",
          appointment_id: "a3333333-3333-3333-3333-333333333333",
          doctor_id: MOCK_DOCTORS[0].id,
          patient_id: "00000000-0000-0000-0000-000000000001",
          symptoms: "Mild cough and fever",
          diagnosis: "Seasonal viral pharyngitis",
          notes: "Rest and hydration recommended.",
          created_at: new Date(Date.now() - 86400000 * 5).toISOString(),
        },
      ],
      prescriptions: [
        {
          id: "p1",
          consultation_id: "c1",
          appointment_id: "a3333333-3333-3333-3333-333333333333",
          doctor_id: MOCK_DOCTORS[0].id,
          patient_id: "00000000-0000-0000-0000-000000000001",
          instructions: "Take with food",
          created_at: new Date(Date.now() - 86400000 * 5).toISOString(),
          doctor: MOCK_DOCTORS[0],
          items: [
            {
              id: "pi1",
              medicine_name: "Amoxicillin 500mg",
              dosage: "1 capsule",
              frequency: "Three times daily",
              duration_days: 5,
            },
            {
              id: "pi2",
              medicine_name: "Paracetamol 650mg",
              dosage: "1 tablet",
              frequency: "As needed for fever",
              duration_days: 3,
            },
          ],
        },
      ],
      ai_conversations: [
        {
          id: "00000000-0000-0000-0003-000000000001",
          patient_id: "00000000-0000-0000-0000-000000000001",
          created_at: new Date().toISOString(),
        },
      ],
      ai_messages: [
        {
          id: "msg-welcome-1",
          conversation_id: "00000000-0000-0000-0003-000000000001",
          role: "ASSISTANT",
          content:
            "Hello Ananya! I am your Better Clinic health assistant. I can help you check your upcoming appointments, active prescriptions, live queue tokens, and follow-ups. What would you like to know?",
          intent: "GREETING",
          used_llm: false,
          is_emergency_override: false,
          created_at: new Date(Date.now() - 3600000).toISOString(),
        },
      ],
      emergency_requests: [
        {
          id: "00000000-0000-0000-0004-000000000001",
          patient_id: "00000000-0000-0000-0000-000000000001",
          description: "Severe asthma shortness of breath and wheezing",
          location_text: "Linking Road, Bandra West, Mumbai",
          status: "RECEIVED",
          is_demo: true,
          created_at: new Date(Date.now() - 1800000).toISOString(),
          received_at: new Date(Date.now() - 1500000).toISOString(),
          acknowledged_at: null,
          closed_at: null,
        },
      ],
      medical_history: [
        {
          id: "mh-1",
          patient_id: "00000000-0000-0000-0000-000000000001",
          record_type: "ALLERGY",
          title: "Penicillin Allergy",
          is_active: true,
        },
        {
          id: "mh-2",
          patient_id: "00000000-0000-0000-0000-000000000001",
          record_type: "CHRONIC_CONDITION",
          title: "Mild Hypertension",
          is_active: true,
        },
      ],
      follow_ups: [
        {
          id: "fu-1",
          appointment_id: "a3333333-3333-3333-3333-333333333333",
          patient_id: "00000000-0000-0000-0000-000000000001",
          doctor_id: MOCK_DOCTORS[0].id,
          clinic_id: MOCK_CLINICS[0].id,
          scheduled_date: new Date(Date.now() + 86400000 * 7).toISOString().slice(0, 10),
          reason: "Post-viral respiratory follow-up and chest check",
          status: "PENDING",
          doctor_name: "Dr. Aarav Deshmukh",
          clinic_name: "City Central Health Clinic",
        },
      ],
      user_preferences: [
        {
          user_id: "00000000-0000-0000-0000-000000000001",
          theme: "system",
          sound_enabled: true,
          notify_appointments: true,
          notify_queue: true,
          notify_prescriptions: true,
          notify_followups: true,
          notify_reminders: true,
          anonymous_reviews: false,
          public_fee: true,
          show_emergency_contact: true,
          ai_assistant_enabled: true,
          ai_response_length: "concise",
        },
      ],
    };
  }
  return g.__bc_mock_state;
}

export function createMockClient(): any {
  const state = getGlobalMockState();

  const getTableData = (table: string): any[] => {
    switch (table) {
      case "appointments":
        return state.appointments;
      case "queue_entries":
        return state.queue_entries;
      case "queue_events":
        return state.queue_events;
      case "appointment_status_history":
        return state.appointment_status_history;
      case "consultations":
        return state.consultations;
      case "prescriptions":
        return state.prescriptions;
      case "ai_conversations":
        return state.ai_conversations;
      case "ai_messages":
        return state.ai_messages;
      case "emergency_requests":
        return state.emergency_requests;
      case "medical_history":
        return state.medical_history;
      case "follow_ups":
        return state.follow_ups;
      case "user_preferences":
        return state.user_preferences;
      case "specializations":
        return MOCK_SPECIALIZATIONS;
      case "clinics":
        return MOCK_CLINICS.map((clinic) => ({
          ...clinic,
          doctor_clinics: MOCK_DOCTORS.filter((d) =>
            d.clinics.some((c) => c.id === clinic.id)
          ).map((d) => ({ doctor_id: d.id })),
        }));
      case "clinic_hours": {
        const hours: any[] = [];
        for (const clinic of MOCK_CLINICS) {
          for (let day = 0; day <= 6; day++) {
            hours.push({
              clinic_id: clinic.id,
              day_of_week: day,
              opens_at: "08:00:00",
              closes_at: "20:00:00",
              is_closed: day === 0,
            });
          }
        }
        return hours;
      }
      case "doctors":
        return MOCK_DOCTORS.map((d) => ({
          ...d,
          doctor_specializations: d.specializations.map((s) => ({ specialization: s })),
          doctor_clinics: d.clinics.map((c) => ({ clinic: c })),
        }));
      case "doctor_specializations": {
        const docSpecs: any[] = [];
        for (const doc of MOCK_DOCTORS) {
          for (const spec of doc.specializations) {
            docSpecs.push({
              doctor_id: doc.id,
              specialization_id: spec.id,
              specialization: spec,
            });
          }
        }
        return docSpecs;
      }
      case "doctor_clinics": {
        const docClinics: any[] = [];
        for (const doc of MOCK_DOCTORS) {
          for (let i = 0; i < doc.clinics.length; i++) {
            const clinic = doc.clinics[i];
            docClinics.push({
              doctor_id: doc.id,
              clinic_id: clinic.id,
              is_primary: i === 0,
              clinic: clinic,
            });
          }
        }
        return docClinics;
      }
      case "patients":
        return [
          {
            id: "00000000-0000-0000-0000-000000000010",
            date_of_birth: "1998-07-22",
            city: "Mumbai",
            emergency_contact_phone: "+919820099889",
            blood_group: "B+",
          },
          {
            id: "00000000-0000-0000-0000-000000000001",
            date_of_birth: "1994-05-15",
            city: "Mumbai",
            emergency_contact_phone: "+919820011001",
            blood_group: "O+",
          },
        ];
      case "profiles": {
        const accounts = Object.values(DEMO_ACCOUNTS).map((a) => ({
          id: a.id,
          email: a.email,
          full_name: a.fullName,
          role: a.role,
          phone: a.phone,
          avatar_url: a.avatarUrl,
        }));
        for (const doc of MOCK_DOCTORS) {
          if (!accounts.some((a) => a.id === doc.id)) {
            accounts.push({
              id: doc.id,
              email: `${doc.profile.full_name.toLowerCase().replace(/[^a-z0-9]/g, ".")}@betterclinic.app`,
              full_name: doc.profile.full_name,
              role: "DOCTOR",
              phone: "+9198200" + doc.id.slice(-6),
              avatar_url: doc.profile.avatar_url,
            });
          }
        }
        return accounts;
      }
      case "profile_roles":
        return Object.values(DEMO_ACCOUNTS).map((a) => ({
          profile_id: a.id,
          role: a.role,
        }));
      case "doctor_availability": {
        const avail: any[] = [];
        for (const doc of MOCK_DOCTORS) {
          for (const clinic of doc.clinics) {
            for (let day = 0; day <= 6; day++) {
              avail.push({
                doctor_id: doc.id,
                clinic_id: clinic.id,
                day_of_week: day,
                start_time: "09:00:00",
                end_time: "17:00:00",
                break_start: "13:00:00",
                break_end: "14:00:00",
                slot_duration_minutes: 30,
                is_active: true,
              });
            }
          }
        }
        return avail;
      }
      case "reviews":
        return [
          {
            id: "r1",
            doctor_id: MOCK_DOCTORS[0].id,
            patient_id: "00000000-0000-0000-0000-000000000001",
            rating: 5,
            title: "Excellent consultation",
            comment: "Dr. Deshmukh was very thorough and attentive. Highly recommend!",
            created_at: new Date(Date.now() - 86400000 * 3).toISOString(),
            patient: {
              profile: {
                full_name: "Verified Patient",
              },
            },
          },
        ];
      case "notifications":
        return [];
      default:
        return (state as any)[table] || [];
    }
  };

  const createQueryBuilder = (table: string) => {
    let currentData = [...getTableData(table)];

    function getNestedValue(obj: any, path: string): any {
      if (!obj) return undefined;
      if (path === "doctor_clinics.clinic_id") {
        if (Array.isArray(obj.doctor_clinics)) {
          return obj.doctor_clinics.map((dc: any) => dc?.clinic_id || dc?.clinic?.id);
        }
        if (Array.isArray(obj.clinics)) {
          return obj.clinics.map((c: any) => c?.id);
        }
      }
      if (path === "profile.full_name") {
        return obj.profile?.full_name;
      }
      if (path.includes(".")) {
        const parts = path.split(".");
        let cur = obj;
        for (const part of parts) {
          if (cur == null) return undefined;
          cur = cur[part];
        }
        return cur;
      }
      return obj[path];
    }

    const builder: any = {
      select: (_fields?: string, _options?: any) => builder,
      eq: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          if (Array.isArray(v)) return v.some((x: any) => String(x) === String(val));
          if (v !== undefined) return String(v) === String(val);
          return true;
        });
        return builder;
      },
      neq: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return String(v) !== String(val);
        });
        return builder;
      },
      gte: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return v === undefined || v >= val;
        });
        return builder;
      },
      lte: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return v === undefined || v <= val;
        });
        return builder;
      },
      gt: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return v === undefined || v > val;
        });
        return builder;
      },
      lt: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return v === undefined || v < val;
        });
        return builder;
      },
      is: (field: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return v === val;
        });
        return builder;
      },
      not: (field: string, _operator: string, val: any) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          return v !== val;
        });
        return builder;
      },
      or: (_conditions: string) => builder,
      contains: (_field: string, _val: any) => builder,
      overlaps: (_field: string, _val: any) => builder,
      ilike: (field: string, pattern: string) => {
        const query = pattern.replace(/%/g, "").toLowerCase();
        currentData = currentData.filter((item: any) => {
          const val = getNestedValue(item, field);
          if (typeof val === "string") return val.toLowerCase().includes(query);
          return true;
        });
        return builder;
      },
      in: (field: string, vals: any[]) => {
        currentData = currentData.filter((item: any) => {
          const v = getNestedValue(item, field);
          if (Array.isArray(v)) return v.some((x: any) => vals.includes(x));
          return vals.includes(v);
        });
        return builder;
      },
      order: (_field: string, _opts?: any) => builder,
      limit: (n: number) => {
        currentData = currentData.slice(0, n);
        return builder;
      },
      range: (from: number, to: number) => {
        currentData = currentData.slice(from, to + 1);
        return builder;
      },
      single: async () => ({
        data: currentData[0] || null,
        error: null,
      }),
      maybeSingle: async () => ({
        data: currentData[0] || null,
        error: null,
      }),
      insert: (data: any) => {
        const arr = Array.isArray(data) ? data : [data];
        const insertedItems: any[] = [];
        for (const item of arr) {
          const hexSuffix = Date.now().toString(16).slice(-12).padStart(12, "0");
          const itemWithId = {
            id: item.id || `00000000-0000-4000-8000-${hexSuffix}`,
            created_at: new Date().toISOString(),
            ...item,
          };
          insertedItems.push(itemWithId);
          currentData.push(itemWithId);

          // Persist to global state
          if ((state as any)[table]) {
            (state as any)[table].push(itemWithId);
          }
        }
        currentData = insertedItems;
        return builder;
      },
      update: (data: any) => {
        // Mutate in currentData and state
        for (const item of currentData) {
          Object.assign(item, data);
        }
        return builder;
      },
      delete: () => {
        if ((state as any)[table]) {
          const idsToDelete = new Set(currentData.map((d: any) => d.id));
          (state as any)[table] = (state as any)[table].filter((item: any) => !idsToDelete.has(item.id));
        }
        currentData = [];
        return builder;
      },
      then: (resolve: (val: any) => void) => {
        resolve({
          data: currentData,
          error: null,
          count: currentData.length,
        });
      },
    };
    return builder;
  };

  return {
    from: (table: string) => createQueryBuilder(table),
    rpc: async (fn: string, args?: any) => {
      if (fn === "get_platform_stats") {
        return {
          data: {
            patients_count: 125,
            doctors_count: 18,
            clinics_count: 4,
            appointments_today: 12,
            active_tokens_today: 9,
          },
          error: null,
        };
      }
      if (fn === "get_user_privacy_flags") {
        return { data: [{ show_emergency_contact: true, public_fee: true }], error: null };
      }
      if (fn === "get_app_env") {
        return { data: "demo", error: null };
      }
      if (fn === "create_emergency_request") {
        const hexSuffix = Date.now().toString(16).slice(-12).padStart(12, "0");
        const reqId = `00000000-0000-4000-8000-${hexSuffix}`;
        const newReq = {
          id: reqId,
          patient_id: "00000000-0000-0000-0000-000000000001",
          description: args?.p_description || "Emergency triage request",
          location_text: args?.p_location_text || "Mumbai",
          status: "CREATED",
          is_demo: true,
          created_at: new Date().toISOString(),
          received_at: null,
          acknowledged_at: null,
          closed_at: null,
        };
        state.emergency_requests.unshift(newReq);
        return { data: { id: reqId, status: "CREATED" }, error: null };
      }
      if (fn === "advance_emergency_request_demo") {
        const req = state.emergency_requests[0];
        const nextStatus =
          req?.status === "CREATED"
            ? "RECEIVED"
            : req?.status === "RECEIVED"
              ? "ACKNOWLEDGED"
              : "CLOSED";
        if (req) {
          req.status = nextStatus;
          if (nextStatus === "RECEIVED") req.received_at = new Date().toISOString();
          if (nextStatus === "ACKNOWLEDGED") req.acknowledged_at = new Date().toISOString();
          if (nextStatus === "CLOSED") req.closed_at = new Date().toISOString();
        }
        return { data: { status: nextStatus }, error: null };
      }
      if (fn === "ensure_slots") {
        const doctorId = args?.p_doctor || MOCK_DOCTORS[0].id;
        const clinicId = args?.p_clinic || MOCK_CLINICS[0].id;
        const dateStr = args?.p_date || new Date().toISOString().slice(0, 10);

        const slotTimes = [
          ["09:00:00", "09:30:00"],
          ["09:30:00", "10:00:00"],
          ["10:00:00", "10:30:00"],
          ["10:30:00", "11:00:00"],
          ["11:00:00", "11:30:00"],
          ["11:30:00", "12:00:00"],
          ["14:00:00", "14:30:00"],
          ["14:30:00", "15:00:00"],
          ["15:00:00", "15:30:00"],
          ["15:30:00", "16:00:00"],
          ["16:00:00", "16:30:00"],
          ["16:30:00", "17:00:00"],
        ];

        const slots = slotTimes.map(([start, end], idx) => {
          const slotKey = `${doctorId}_${clinicId}_${dateStr}_${start}`;
          if (!state.slots[slotKey]) {
            // Generate stable UUID
            const dateHex = dateStr.replace(/-/g, "").slice(-4);
            const idxHex = (idx + 1).toString(16).padStart(4, "0");
            const docHex = doctorId.replace(/-/g, "").slice(-8);
            const slotId = `00000000-${dateHex}-4000-8000-${docHex}${idxHex}`;

            state.slots[slotKey] = {
              id: slotId,
              doctor_id: doctorId,
              clinic_id: clinicId,
              slot_date: dateStr,
              start_time: start,
              end_time: end,
              status: "FREE",
            };
            state.slots[slotId] = state.slots[slotKey];
          }

          const s = state.slots[slotKey];
          return {
            id: s.id,
            start_time: s.start_time,
            end_time: s.end_time,
            status: s.status,
          };
        });

        return { data: slots, error: null };
      }
      if (fn === "book_appointment") {
        const slotId = args?.p_slot_id;
        const slot = state.slots[slotId];

        if (slot && slot.status === "BOOKED") {
          return {
            data: null,
            error: {
              message: "That time was just booked by someone else — please pick another slot",
            },
          };
        }

        // Mark the slot as BOOKED!
        if (slot) {
          slot.status = "BOOKED";
        }

        const doctorId = slot?.doctor_id || MOCK_DOCTORS[0].id;
        const clinicId = slot?.clinic_id || MOCK_CLINICS[0].id;
        const apptDate = slot?.slot_date || new Date().toISOString().slice(0, 10);
        const startTime = slot?.start_time || "10:30:00";
        const endTime = slot?.end_time || "11:00:00";

        const docObj = MOCK_DOCTORS.find((d) => d.id === doctorId) || MOCK_DOCTORS[0];
        const clinicObj = MOCK_CLINICS.find((c) => c.id === clinicId) || MOCK_CLINICS[0];

        const hexSuffix = Date.now().toString(16).slice(-12).padStart(12, "0");
        const apptId = `00000000-0000-4000-8000-${hexSuffix}`;

        const newAppt = {
          id: apptId,
          patient_id: "00000000-0000-0000-0000-000000000001",
          doctor_id: docObj.id,
          clinic_id: clinicObj.id,
          slot_id: slotId,
          appointment_number: `APT-2026-${Math.floor(1000 + Math.random() * 9000)}`,
          appointment_date: apptDate,
          start_time: startTime,
          end_time: endTime,
          status: "CONFIRMED",
          appointment_type: "SCHEDULED",
          type: "IN_PERSON",
          consultation_fee: docObj.consultation_fee,
          visit_reason: args?.p_visit_reason || "Consultation",
          notes: null,
          cancellation_reason: null,
          patient: {
            profile: {
              full_name: "Ananya Sharma",
            },
          },
          doctor: {
            qualification: docObj.qualification,
            consultation_fee: docObj.consultation_fee,
            profile: { full_name: docObj.profile.full_name },
          },
          clinic: {
            name: clinicObj.name,
            city: clinicObj.city,
            area: clinicObj.area,
          },
        };

        state.appointments.unshift(newAppt);

        state.appointment_status_history.unshift({
          id: `ash-${Date.now()}`,
          appointment_id: apptId,
          from_status: null,
          to_status: "CONFIRMED",
          reason: "Online booking confirmed",
          created_at: new Date().toISOString(),
          changed_by: { full_name: "Ananya Sharma" },
        });

        if (slot) {
          slot.appointment_id = apptId;
        }

        return { data: { id: apptId }, error: null };
      }
      if (fn === "check_in_appointment") {
        const apptId = args?.p_appointment_id;
        const appt = state.appointments.find((a: any) => a.id === apptId);

        const tokenNum = state.queue_entries.length + 1;
        const tokenCode = `A-${String(tokenNum).padStart(3, "0")}`;

        if (appt) {
          appt.status = "WAITING";
        }

        const queueEntryId = `q-${Date.now()}`;
        const newQueueEntry = {
          id: queueEntryId,
          token_code: tokenCode,
          token_number: tokenNum,
          priority: "NORMAL",
          status: "WAITING",
          clinic_id: appt?.clinic_id || MOCK_CLINICS[0].id,
          doctor_id: appt?.doctor_id || MOCK_DOCTORS[0].id,
          patient_id: "00000000-0000-0000-0000-000000000001",
          appointment_id: apptId,
          queue_date: new Date().toISOString().slice(0, 10),
          created_at: new Date().toISOString(),
          called_at: null,
          patient: { profile: { full_name: "Ananya Sharma" } },
          doctor: {
            profile: {
              full_name: appt?.doctor?.profile?.full_name || MOCK_DOCTORS[0].profile.full_name,
            },
          },
          appointment: {
            visit_reason: appt?.visit_reason || "General Consultation",
            start_time: appt?.start_time || "10:30:00",
            appointment_type: "SCHEDULED",
          },
        };

        state.queue_entries.push(newQueueEntry);

        state.queue_events.push({
          id: `qe-${Date.now()}`,
          queue_entry_id: queueEntryId,
          event_type: "CREATED",
          to_status: "WAITING",
          note: "Checked in via web portal",
          created_at: new Date().toISOString(),
        });

        return { data: { token_code: tokenCode }, error: null };
      }
      if (fn === "create_walk_in") {
        const tokenNum = state.queue_entries.length + 1;
        const tokenCode = `W-${String(tokenNum).padStart(3, "0")}`;
        const queueEntryId = `q-${Date.now()}`;

        state.queue_entries.push({
          id: queueEntryId,
          token_code: tokenCode,
          token_number: tokenNum,
          priority: args?.p_priority || "NORMAL",
          status: "WAITING",
          clinic_id: args?.p_clinic_id || MOCK_CLINICS[0].id,
          doctor_id: args?.p_doctor_id || MOCK_DOCTORS[0].id,
          patient_id: args?.p_patient_id || "00000000-0000-0000-0000-000000000001",
          appointment_id: null,
          queue_date: new Date().toISOString().slice(0, 10),
          created_at: new Date().toISOString(),
          called_at: null,
          patient: { profile: { full_name: "Walk-in Patient" } },
          doctor: { profile: { full_name: MOCK_DOCTORS[0].profile.full_name } },
          appointment: {
            visit_reason: args?.p_visit_reason || "Walk-in visit",
            start_time: "Now",
            appointment_type: "WALK_IN",
          },
        });

        return { data: { token_code: tokenCode }, error: null };
      }
      if (fn === "queue_call_next") {
        const clinicId = args?.p_clinic_id;
        const doctorId = args?.p_doctor_id;

        const nextWaiting = state.queue_entries.find(
          (q: any) =>
            q.status === "WAITING" &&
            (!doctorId || q.doctor_id === doctorId) &&
            (!clinicId || q.clinic_id === clinicId)
        );

        if (!nextWaiting) {
          return { data: null, error: null };
        }

        nextWaiting.status = "CALLED";
        nextWaiting.called_at = new Date().toISOString();

        if (nextWaiting.appointment_id) {
          const appt = state.appointments.find((a: any) => a.id === nextWaiting.appointment_id);
          if (appt) appt.status = "CALLED";
        }

        state.queue_events.push({
          id: `qe-${Date.now()}`,
          queue_entry_id: nextWaiting.id,
          event_type: "CALLED",
          to_status: "CALLED",
          note: "Token called by physician",
          created_at: new Date().toISOString(),
        });

        return { data: { token_code: nextWaiting.token_code }, error: null };
      }
      if (fn === "queue_call_specific") {
        const entryId = args?.p_queue_entry_id;
        const entry = state.queue_entries.find((q: any) => q.id === entryId);
        if (entry) {
          entry.status = "CALLED";
          entry.called_at = new Date().toISOString();
          if (entry.appointment_id) {
            const appt = state.appointments.find((a: any) => a.id === entry.appointment_id);
            if (appt) appt.status = "CALLED";
          }
          state.queue_events.push({
            id: `qe-${Date.now()}`,
            queue_entry_id: entry.id,
            event_type: "CALLED",
            to_status: "CALLED",
            note: "Token called by doctor",
            created_at: new Date().toISOString(),
          });
        }
        return { data: { success: true }, error: null };
      }
      if (fn === "start_consultation") {
        const apptId = args?.p_appointment_id;
        const appt = state.appointments.find((a: any) => a.id === apptId);
        const consultId = `c-${Date.now()}`;

        if (appt) {
          appt.status = "IN_CONSULTATION";
        }
        const qEntry = state.queue_entries.find((q: any) => q.appointment_id === apptId);
        if (qEntry) {
          qEntry.status = "IN_CONSULTATION";
        }

        state.consultations.push({
          id: consultId,
          appointment_id: apptId,
          doctor_id: appt?.doctor_id || MOCK_DOCTORS[0].id,
          patient_id: appt?.patient_id || "00000000-0000-0000-0000-000000000001",
          symptoms: appt?.visit_reason || "Consultation in progress",
          diagnosis: "Clinical evaluation",
          notes: "Patient consultation commenced.",
          created_at: new Date().toISOString(),
        });

        return { data: { id: consultId }, error: null };
      }
      if (
        fn === "reschedule_appointment" ||
        fn === "cancel_appointment" ||
        fn === "queue_recall" ||
        fn === "queue_return_to_waiting" ||
        fn === "queue_skip" ||
        fn === "queue_resume" ||
        fn === "queue_set_priority"
      ) {
        return { data: { success: true }, error: null };
      }
      return { data: null, error: null };
    },
    auth: {
      getUser: async () => ({ data: { user: null }, error: null }),
      signInWithPassword: async () => ({ data: { user: null, session: null }, error: null }),
      signUp: async () => ({ data: { user: null, session: null }, error: null }),
      signOut: async () => ({ error: null }),
      onAuthStateChange: () => ({ data: { subscription: { unsubscribe: () => {} } } }),
    },
  };
}
