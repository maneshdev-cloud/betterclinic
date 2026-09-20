import type { Metadata } from "next";
import { requireRole } from "@/services/auth/service";
import { NotificationsView } from "@/components/notifications/notifications-view";

export const metadata: Metadata = { title: "Notifications" };

export default async function StaffNotificationsPage({
  searchParams,
}: {
  searchParams: Record<string, string | string[] | undefined>;
}) {
  const user = await requireRole(["RECEPTIONIST"], "/staff/notifications");
  return <NotificationsView userId={user.id} basePath="/staff/notifications" searchParams={searchParams} />;
}
