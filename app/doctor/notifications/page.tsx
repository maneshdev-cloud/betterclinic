import type { Metadata } from "next";
import { requireRole } from "@/services/auth/service";
import { NotificationsView } from "@/components/notifications/notifications-view";

export const metadata: Metadata = { title: "Notifications" };

export default async function DoctorNotificationsPage({
  searchParams,
}: {
  searchParams: Record<string, string | string[] | undefined>;
}) {
  const user = await requireRole(["DOCTOR"], "/doctor/notifications");
  return <NotificationsView userId={user.id} basePath="/doctor/notifications" searchParams={searchParams} />;
}
