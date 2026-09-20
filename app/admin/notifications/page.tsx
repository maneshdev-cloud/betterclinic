import type { Metadata } from "next";
import { requireRole } from "@/services/auth/service";
import { NotificationsView } from "@/components/notifications/notifications-view";

export const metadata: Metadata = { title: "Notifications" };

export default async function AdminNotificationsPage({
  searchParams,
}: {
  searchParams: Record<string, string | string[] | undefined>;
}) {
  const user = await requireRole(["CLINIC_ADMIN"], "/admin/notifications");
  return <NotificationsView userId={user.id} basePath="/admin/notifications" searchParams={searchParams} />;
}
