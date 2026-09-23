-- Migration 00031: AI Emergency Override Logging
-- Add dedicated flag to ai_messages to audit and monitor emergency-override triggers

alter table public.ai_messages
  add column if not exists is_emergency_override boolean not null default false;

create index if not exists idx_ai_messages_emergency
  on public.ai_messages (is_emergency_override)
  where is_emergency_override = true;
