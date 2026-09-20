-- ═══════════════════════════════════════════════════════════════════
-- BETTER CLINIC — 00004_storage.sql
-- Supabase Storage: one public-read "avatars" bucket. Uploads are
-- limited to each user's own folder (/{user_id}/...) with a 1 MB cap
-- and image-only mime types. No sensitive clinical documents are
-- stored — by design. Idempotent.
-- ═══════════════════════════════════════════════════════════════════

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars', 'avatars', true, 1048576,
  array['image/png','image/jpeg','image/webp']
)
on conflict (id) do update
  set public = true,
      file_size_limit = 1048576,
      allowed_mime_types = array['image/png','image/jpeg','image/webp'];

drop policy if exists "bc_avatars_read" on storage.objects;
create policy "bc_avatars_read" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'avatars');

drop policy if exists "bc_avatars_insert_own_folder" on storage.objects;
create policy "bc_avatars_insert_own_folder" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "bc_avatars_update_own_folder" on storage.objects;
create policy "bc_avatars_update_own_folder" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "bc_avatars_delete_own_folder" on storage.objects;
create policy "bc_avatars_delete_own_folder" on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
