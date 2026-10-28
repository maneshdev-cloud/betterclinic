import { describe, it, expect } from "vitest";
import { searchDoctors } from "@/services/doctors/service";
import { createMockClient } from "@/lib/supabase/mock-client";
import { DEMO_DOCTORS, getDemoDoctorAccount } from "@/lib/mock-data";

describe("Doctor Specialization Filter & Demo Login Engine", () => {
  const client = createMockClient();

  it("filters doctors by specialization name 'Orthopedics'", async () => {
    const result = await searchDoctors(client, {
      specialization: "Orthopedics",
      q: "",
      city: "",
      availableToday: false,
      acceptingPatients: false,
      sort: "rating",
      page: 1,
    });

    expect(result.items.length).toBe(1);
    expect(result.total).toBe(1);
    expect(result.items[0].profile?.full_name).toBe("Dr. Divya Deshmukh");
    expect(result.items[0].specializations.some((s) => s.name === "Orthopedics")).toBe(true);
  });

  it("filters doctors by specialization UUID", async () => {
    const result = await searchDoctors(client, {
      specialization: "333c7946-d872-4130-8e3c-dbb8824ae653",
      q: "",
      city: "",
      availableToday: false,
      acceptingPatients: false,
      sort: "rating",
      page: 1,
    });

    expect(result.items.length).toBe(1);
    expect(result.items[0].profile?.full_name).toBe("Dr. Divya Deshmukh");
  });

  it("filters doctors by Cardiology", async () => {
    const result = await searchDoctors(client, {
      specialization: "Cardiology",
      q: "",
      city: "",
      availableToday: false,
      acceptingPatients: false,
      sort: "rating",
      page: 1,
    });

    expect(result.items.length).toBe(1);
    expect(result.items[0].profile?.full_name).toBe("Dr. Rajesh Kulkarni");
  });

  it("returns all doctors when specialization is empty", async () => {
    const result = await searchDoctors(client, {
      specialization: "",
      q: "",
      city: "",
      availableToday: false,
      acceptingPatients: false,
      sort: "rating",
      page: 1,
    });

    expect(result.items.length).toBeGreaterThanOrEqual(9);
  });

  it("provides demo accounts for all available demo doctors", () => {
    expect(DEMO_DOCTORS.length).toBeGreaterThanOrEqual(9);

    const orthoDoc = DEMO_DOCTORS.find((d) => d.specialization === "Orthopedics");
    expect(orthoDoc).toBeDefined();
    expect(orthoDoc?.name).toBe("Dr. Divya Deshmukh");

    const account = getDemoDoctorAccount(orthoDoc?.id);
    expect(account.fullName).toBe("Dr. Divya Deshmukh");
    expect(account.role).toBe("DOCTOR");
    expect(account.specialization).toBe("Orthopedics");
  });
});
