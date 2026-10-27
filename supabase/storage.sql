-- Masti Gurukul: file storage for PDFs and notes uploaded from the admin panel.
--
-- Run this ONCE in Supabase Dashboard -> SQL editor, after schema.sql.
--
-- Why a bucket at all: when the admin attaches a PDF on their own phone, the
-- bytes live in that phone's storage. A student's phone cannot read them. The
-- file must be uploaded here, and the resource row keeps the public URL in
-- `remote_url`, which is what makes the file appear on every device.
--
-- Public READ is intentional: these are class handouts that any student with the
-- link can open, and a signed URL would expire on an offline phone. Public
-- WRITE is never granted to anyone except the admin allow-list.

insert into storage.buckets (id, name, public)
values ('library', 'library', true)
on conflict (id) do nothing;

-- Drop anything a previous run may have left behind so re-running is safe.
drop policy if exists "library readable" on storage.objects;
drop policy if exists "library admin write" on storage.objects;
drop policy if exists "library admin update" on storage.objects;
drop policy if exists "library admin delete" on storage.objects;

-- Anyone (including a student app with no session) may read a file.
create policy "library readable"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'library');

-- Only an allow-listed admin may put a file here.
create policy "library admin write"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'library' and public.is_admin());

-- Updating an existing object (upsert) and removing one use update/delete.
create policy "library admin update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'library' and public.is_admin())
  with check (bucket_id = 'library' and public.is_admin());

create policy "library admin delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'library' and public.is_admin());

-- Everything else stays denied by default: RLS is on for storage.objects out of
-- the box, and no policy above grants anon or authenticated any other right.
