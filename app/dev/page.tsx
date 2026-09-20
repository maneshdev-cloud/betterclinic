import "server-only";
import type { Metadata } from "next";
import { getPlatformStats, isHideDemoEnabled } from "@/lib/demo";
import { HideDemoToggle } from "@/components/dev/hide-demo-toggle";
import { DeleteDemoDialog } from "@/components/dev/delete-demo-dialog";
import { AppEnvCard } from "@/components/dev/app-env-card";
import { StorageMetricsCard } from "@/components/dev/storage-metrics-card";
import { AppointmentsMetrics } from "@/components/dev/appointments-metrics";
import { SignupsCard } from "@/components/dev/signups-card";
import { TopEntitiesCard } from "@/components/dev/top-entities-card";
import { DataBreakdownTable } from "@/components/dev/data-breakdown-table";

export const metadata: Metadata = {
  title: "Developer Admin Panel — Better Clinic",
};

export const dynamic = "force-dynamic";

export default async function DevAdminPage() {
  const hideDemo = isHideDemoEnabled();
  const stats = await getPlatformStats(hideDemo);
  const appEnv = process.env.NEXT_PUBLIC_APP_ENV || "demo";

  const tableBreakdowns = stats.table_breakdowns || {};
  const signupsByRole = stats.signups_by_role || {
    total: 0,
    patient: 0,
    doctor: 0,
    receptionist: 0,
    clinic_admin: 0,
  };
  const signupsOverTime = stats.signups_over_time || [];
  const appointmentsSummary = stats.appointments_summary || {
    total: 0,
    completed: 0,
    cancelled: 0,
    no_show: 0,
    active: 0,
  };
  const topClinics = stats.top_clinics || [];
  const topDoctors = stats.top_doctors || [];
  const sizePretty = stats.database_size_pretty || "15 MB";
  const sizeBytes = stats.database_size_bytes || 15846547;
  const tableCount = Object.keys(tableBreakdowns).length;

  return (
    <div className="space-y-8 pb-12">
      {/* Top Banner & Primary Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-2 border-b border-slate-800/80">
        <div>
          <h1 className="text-2xl font-black tracking-tight text-white">
            Developer Admin & Platform Analytics
          </h1>
          <p className="text-xs text-slate-400 mt-1">
            Restricted root-level operator dashboard &bull; Access allowlisted to{" "}
            <span className="text-cyan-400 font-mono font-medium">{process.env.DEVELOPER_EMAIL}</span>
          </p>
        </div>

        <div className="flex items-center space-x-3">
          <DeleteDemoDialog />
        </div>
      </div>

      {/* Global Toggle: Hide Demo Data Platform-wide */}
      <HideDemoToggle initialHideDemo={hideDemo} />

      {/* Deploy-time Environment Policy */}
      <AppEnvCard appEnv={appEnv} />

      {/* Storage & Cloud Database Snapshot */}
      <StorageMetricsCard
        sizePretty={sizePretty}
        sizeBytes={sizeBytes}
        tableCount={tableCount}
      />

      {/* Appointments Platform-wide Metrics */}
      <AppointmentsMetrics summary={appointmentsSummary} />

      {/* User Signups & Trends */}
      <SignupsCard signupsByRole={signupsByRole} signupsOverTime={signupsOverTime} />

      {/* Most Active Entities */}
      <TopEntitiesCard topClinics={topClinics} topDoctors={topDoctors} />

      {/* Synthetic vs Real Table Row Auditing */}
      <DataBreakdownTable breakdowns={tableBreakdowns} />
    </div>
  );
}
