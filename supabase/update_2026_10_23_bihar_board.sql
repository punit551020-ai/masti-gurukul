-- ============================================================================
-- Masti Gurukul — update for an already-running project (Bihar Board + storage)
-- ============================================================================
-- supabase/schema.sql uses `create table if not exists`, so on a project that
-- ran it before this change the subjects table simply stays as it was and the
-- new column never appears. Run this file ONCE in Supabase Dashboard -> SQL
-- editor to bring an existing project up to date. It is not needed for a brand
-- new project that runs schema.sql, storage.sql and seed.sql from scratch.
--
-- Everything here is idempotent: re-running changes nothing and cannot lose
-- content. No existing subject row is touched.
--
-- What it does:
--   1. Gives each subject an optional board. A subject with no board belongs to
--      every board, which is exactly what the 25 rows seeded so far mean.
--   2. Adds Bihar Board to the board list.
--   3. Creates the public "library" bucket for PDF uploads, if it is missing.
--      (storage.sql is the annotated version of the same two statements; both
--      are safe to run in any order.)
--   4. Lets realtime carry subject/board/chapter/class changes, so a new
--      Bihar Board subject reaches an open student app immediately.
--
-- After this, the admin panel can file content under
-- Class 10 -> Bihar Board -> <subject> and attach PDFs that reach every phone.
-- ============================================================================

-- 1. Subjects may now carry a board. Nullable, so the existing list is
--    unaffected and no back-fill is required.
alter table public.subjects
  add column if not exists board_id text
  references public.boards (id) on delete set null;

-- The student and admin queries both ask for one class, filtered by board.
create index if not exists idx_subjects_class_board_order
  on public.subjects (class_id, board_id, display_order);

-- 2. Bihar Board, matching CatalogRepository.seedStructureIfEmpty() and
--    supabase/seed.sql exactly: same id, same spellings, display_order 4.
insert into public.boards (id, name_hindi, name_english, display_order) values
  ('board-bihar', 'बिहार बोर्ड', 'Bihar Board', 4)
on conflict (id) do nothing;

-- 3. The bucket the admin's PDF upload lands in. Public read is intentional -
--    these are class handouts, and a signed URL would expire on an offline
--    phone. Writing is gated by public.is_admin() in supabase/storage.sql.
insert into storage.buckets (id, name, public)
values ('library', 'library', true)
on conflict (id) do nothing;

-- 4. Realtime for the curriculum list itself.
--
--    schema.sql puts lessons, resources, tests, live_classes and announcements
--    in the supabase_realtime publication, because those are the rows students
--    watch. But a new subject or board has to broadcast too: without it, an
--    admin who creates "Class 10 -> Bihar Board -> Science" is left with a
--    subject that only shows up on a student's next app start. The app already
--    listens for these tables and answers any message with one full re-pull, so
--    this is the missing half of that.
--
--    Reading is still decided by the row-level security policies - a broadcast
--    only says "something changed", and the client then asks for what it is
--    allowed to see.
do $$
declare
  t text;
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    create publication supabase_realtime;
  end if;
  foreach t in array array['school_classes', 'boards', 'subjects', 'chapters']
  loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end;
$$;

-- ----------------------------------------------------------------------------
-- Check the work. Expected: one row for board_id, 4 boards, 1 bucket.
--
--   select column_name from information_schema.columns
--     where table_schema = 'public' and table_name = 'subjects'
--     and column_name = 'board_id';
--
--   select id, name_english from public.boards order by display_order;
--
--   select id, public from storage.buckets where id = 'library';
--
--   select tablename from pg_publication_tables
--     where pubname = 'supabase_realtime' order by tablename;
--   -- expected: announcements, boards, chapters, live_classes, lessons,
--   --           resources, school_classes, subjects, tests
--
-- If the storage policies have never been applied to this project, run
-- supabase/storage.sql as well - the bucket alone would let anyone upload.
-- ----------------------------------------------------------------------------
