-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — Migration 00026: Restrict Demo Functions
-- Revoke execution rights from authenticated, anon, and public for
-- purge_synthetic_data() and get_platform_stats(boolean).
-- Only service_role maintains execute privileges.
-- ═══════════════════════════════════════════════════════════════════

-- 1. Revoke execute on purge_synthetic_data()
revoke execute on function public.purge_synthetic_data() from authenticated;
revoke execute on function public.purge_synthetic_data() from anon;
revoke execute on function public.purge_synthetic_data() from public;

-- 2. Revoke execute on get_platform_stats(boolean)
revoke execute on function public.get_platform_stats(boolean) from authenticated;
revoke execute on function public.get_platform_stats(boolean) from anon;
revoke execute on function public.get_platform_stats(boolean) from public;

-- 3. Explicitly confirm service_role keeps execute rights
grant execute on function public.purge_synthetic_data() to service_role;
grant execute on function public.get_platform_stats(boolean) to service_role;
