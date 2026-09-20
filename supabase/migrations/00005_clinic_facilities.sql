-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00005_clinic_facilities.sql
-- Clinic profile "facilities" (e.g. Parking, Pharmacy, Wheelchair
-- access) shown on discovery pages. Idempotent; safe for projects
-- that already ran 00001–00004.
-- ═══════════════════════════════════════════════════════════════════

alter table public.clinics
  add column if not exists facilities text[] not null default '{}';
