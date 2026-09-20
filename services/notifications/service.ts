import type { SupabaseClient } from "@supabase/supabase-js";
import type { Notification } from "@/lib/types/database";
import { pageRange, totalPages } from "@/lib/utils";
import type { SearchResult } from "@/services/doctors/service";

export const NOTIFICATION_PAGE_SIZE = 15;
const RECENT_LIMIT = 8;

export async function listNotifications(
  client: SupabaseClient,
  userId: string,
  page = 1,
  unreadOnly = false
): Promise<SearchResult<Notification>> {
  const { from, to } = pageRange(page, NOTIFICATION_PAGE_SIZE);
  let query = client
    .from("notifications")
    .select("*", { count: "exact" })
    .eq("user_id", userId)
    .order("created_at", { ascending: false });
  if (unreadOnly) query = query.eq("is_read", false);

  const { data, error, count } = await query.range(from, to);
  if (error) throw error;
  const items = (data ?? []) as unknown as Notification[];
  const total = count ?? items.length;
  return {
    items,
    total,
    page,
    pageSize: NOTIFICATION_PAGE_SIZE,
    totalPages: totalPages(total, NOTIFICATION_PAGE_SIZE),
  };
}

export async function getUnreadCount(client: SupabaseClient, userId: string): Promise<number> {
  const { count, error } = await client
    .from("notifications")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId)
    .eq("is_read", false);
  if (error) throw error;
  return count ?? 0;
}

export async function markNotificationRead(
  client: SupabaseClient,
  userId: string,
  notificationId: string
): Promise<void> {
  const { error } = await client
    .from("notifications")
    .update({ is_read: true, read_at: new Date().toISOString() })
    .eq("id", notificationId)
    .eq("user_id", userId);
  if (error) throw error;
}

export async function markAllNotificationsRead(
  client: SupabaseClient,
  userId: string
): Promise<number> {
  const { data, error } = await client
    .from("notifications")
    .update({ is_read: true, read_at: new Date().toISOString() })
    .eq("user_id", userId)
    .eq("is_read", false)
    .select("id");
  if (error) throw error;
  return (data ?? []).length;
}

export { RECENT_LIMIT };
