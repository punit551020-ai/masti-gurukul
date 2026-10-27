-- ============================================================================
-- Masti Gurukul — update for an already-running project (All Classes + simpler
-- admin saves)
-- ============================================================================
-- Run this ONCE in Supabase Dashboard -> SQL editor -> Run. It is safe to run
-- twice: every statement is idempotent and no existing row is changed or
-- deleted.
--
-- What it does:
--   1. Adds the 'class-all' row that stands behind the admin panel's new
--      "All Classes" choice. Without it the panel can still file content there
--      on this device, but the server would refuse the subject because
--      subjects.class_id has to point at a real class.
--   2. Lets a resource be saved with only a title. The old check insisted on a
--      file path or a link, so a half-finished entry was refused by the server.
--      The app now shows such a row to students as "The file is not here yet".
--   3. Re-states the realtime publication, including the curriculum tables
--      (school_classes, boards, subjects, chapters), so a publish reaches an
--      open student app without a restart. Nothing here removes content.
--
-- After this, the owner can pick "All Classes", type only a title, and press
-- Save — and every class from 6 to 10 sees the row as soon as it is published.
-- ============================================================================

-- 1. The shared class. display_order 0 keeps it above Class 6 in any list;
--    level 1 is a placeholder, because the column checks for 1..12 and no
--    screen ever prints it. CatalogRepository.classes() hides this row from
--    students, so it cannot be chosen as somebody's class.
insert into public.school_classes (id, level, name_hindi, name_english, display_order)
values ('class-all', 1, 'सभी कक्षाएं', 'All Classes', 0)
on conflict (id) do nothing;

-- 2. A title-only resource is now allowed. The check is dropped, not widened,
--    because the app's own guard for it was removed too (AdminRepository
--    .saveResource). The columns stay exactly as they were: a missing link is
--    simply null, and the student's screen says so instead of showing a blank
--    page.
alter table public.resources
  drop constraint if exists resources_has_file_or_link;

-- 3. Realtime. schema.sql puts the five student tables in the publication and
--    update_2026_10_23_bihar_board.sql adds the four curriculum ones; this is
--    the same loop again so a project that missed either half ends up correct.
--    Reading is still decided by row-level security — a broadcast only says
--    "something changed", and each device then asks for what it may see.
do $$
declare
  t text;
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    create publication supabase_realtime;
  end if;
  foreach t in array array[
    'lessons', 'resources', 'tests', 'live_classes', 'announcements',
    'school_classes', 'boards', 'subjects', 'chapters'
  ]
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
-- Check the work. Expected answers are on the right of each line.
--
--   select id, name_english from public.school_classes order by display_order;
--   -- class-all / All Classes first, then class-6 ... class-10
--
--   select count(*) from pg_constraint
--     where conname = 'resources_has_file_or_link';
--   -- 0
--
--   select tablename from pg_publication_tables
--     where pubname = 'supabase_realtime' order by tablename;
--   -- announcements, boards, chapters, live_classes, lessons, resources,
--   -- school_classes, subjects, tests
--
-- If PDF uploads still fail, run supabase/storage.sql — the "library" bucket
-- without those policies is the one thing that lets anyone write to it.
-- ----------------------------------------------------------------------------
