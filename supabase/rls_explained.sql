-- ============================================================================
-- Masti Gurukul — RLS policy audit sheet (plain English)
-- ============================================================================
-- This file restates EVERY policy from supabase/schema.sql (sections 7-11),
-- each preceded by one plain-English sentence saying WHO can do WHAT and
-- WHY, so a beginner can audit the security model by reading top to bottom.
--
-- It is also executable: every statement matches schema.sql exactly and is
-- preceded by DROP POLICY IF EXISTS, so running this file after schema.sql
-- is a harmless no-op re-creation, and running it on its own (after the
-- table/grant sections of schema.sql) produces the identical policy set.
-- There are NO extra or missing policies compared to schema.sql.
--
-- Vocabulary for the audit:
--   * "anon"       = anyone holding the app's public anon key — i.e. every
--                    student, including attackers who extracted the key.
--   * "authenticated" = a logged-in auth user. Today that ONLY happens for
--                    the admin (students sign in with a name, no account).
--   * is_admin()   = "this logged-in user's id is on the public.admins
--                    allow-list" — a list only the dashboard SQL editor
--                    can add to.
--   * USING   = which existing rows this command may touch.
--   * WITH CHECK = what the new/updated row values must satisfy.
-- ============================================================================

-- ============================================================================
-- DENY-ALL BY CONSTRUCTION (these tables have ENABLE RLS but deliberately
-- ZERO policies, plus revoked grants — nothing in the API can read or write
-- them; only the dashboard / service_role can):
--
--   public.admins            => nobody in the API may read or write the
--     admin allow-list, so a student can never discover it or add themselves;
--     only the SQL editor bootstrap at the bottom of schema.sql changes it.
--
--   public.students, public.bookmarks, public.recent_views,
--   public.lesson_progress, public.downloads, public.test_attempts,
--   public.test_attempt_answers
--     => student progress is DEVICE-LOCAL until real student authentication
--     exists; with a client-chosen student_id, any public write policy would
--     let one student read/overwrite everyone's progress, so we expose none.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- CURRICULUM STRUCTURE — readable by every student, writable by admins only
-- ----------------------------------------------------------------------------

-- school_classes: any anon key holder may read the class list because the
-- home screen must show classes 6-10 before any content is published.
drop policy if exists school_classes_read on public.school_classes;
create policy school_classes_read on public.school_classes
  for select to anon using (true);

-- school_classes: a logged-in admin may read every class (not just any
-- filtered subset) because the admin panel manages the whole list.
drop policy if exists school_classes_admin_read on public.school_classes;
create policy school_classes_admin_read on public.school_classes
  for select to authenticated using (public.is_admin());

-- school_classes: only a logged-in user on the admins allow-list may add a
-- new class, and the new row must pass the same admin check.
drop policy if exists school_classes_write on public.school_classes;
create policy school_classes_write on public.school_classes
  for insert to authenticated with check (public.is_admin());

-- school_classes: only an allow-listed admin may edit an existing class row,
-- and the saved values must also pass the admin check.
drop policy if exists school_classes_write_update on public.school_classes;
create policy school_classes_write_update on public.school_classes
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- school_classes: only an allow-listed admin may delete a class (children
-- such as subjects then cascade away, so no orphan rows are possible).
drop policy if exists school_classes_write_delete on public.school_classes;
create policy school_classes_write_delete on public.school_classes
  for delete to authenticated using (public.is_admin());

-- boards: any anon key holder may read the board list (CBSE/ICSE/UP) because
-- the onboarding screen shows it to every student.
drop policy if exists boards_read on public.boards;
create policy boards_read on public.boards
  for select to anon using (true);

-- boards: a logged-in admin may read all boards for the admin panel.
drop policy if exists boards_admin_read on public.boards;
create policy boards_admin_read on public.boards
  for select to authenticated using (public.is_admin());

-- boards: only an allow-listed admin may create a board.
drop policy if exists boards_write on public.boards;
create policy boards_write on public.boards
  for insert to authenticated with check (public.is_admin());

-- boards: only an allow-listed admin may edit a board, with checked values.
drop policy if exists boards_write_update on public.boards;
create policy boards_write_update on public.boards
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- boards: only an allow-listed admin may delete a board.
drop policy if exists boards_write_delete on public.boards;
create policy boards_write_delete on public.boards
  for delete to authenticated using (public.is_admin());

-- subjects: any anon key holder may read the per-class subject list because
-- the class home screen needs it even with zero published lessons.
drop policy if exists subjects_read on public.subjects;
create policy subjects_read on public.subjects
  for select to anon using (true);

-- subjects: a logged-in admin may read all subjects.
drop policy if exists subjects_admin_read on public.subjects;
create policy subjects_admin_read on public.subjects
  for select to authenticated using (public.is_admin());

-- subjects: only an allow-listed admin may create a subject.
drop policy if exists subjects_write on public.subjects;
create policy subjects_write on public.subjects
  for insert to authenticated with check (public.is_admin());

-- subjects: only an allow-listed admin may edit a subject (e.g. rename or
-- change the accent colour), with checked values.
drop policy if exists subjects_write_update on public.subjects;
create policy subjects_write_update on public.subjects
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- subjects: only an allow-listed admin may delete a subject (its chapters,
-- lessons, resources, tests, questions and live classes cascade away).
drop policy if exists subjects_write_delete on public.subjects;
create policy subjects_write_delete on public.subjects
  for delete to authenticated using (public.is_admin());

-- chapters: any anon key holder may read the chapter list of a subject
-- because syllabus structure is public even before lessons exist.
drop policy if exists chapters_read on public.chapters;
create policy chapters_read on public.chapters
  for select to anon using (true);

-- chapters: a logged-in admin may read all chapters, including brand-new
-- drafts, to run the admin chapter tree.
drop policy if exists chapters_admin_read on public.chapters;
create policy chapters_admin_read on public.chapters
  for select to authenticated using (public.is_admin());

-- chapters: only an allow-listed admin may create a chapter.
drop policy if exists chapters_write on public.chapters;
create policy chapters_write on public.chapters
  for insert to authenticated with check (public.is_admin());

-- chapters: only an allow-listed admin may edit a chapter, and the unique
-- (subject_id, number) constraint (mirroring the app's clash check) blocks
-- duplicate chapter numbers even if a client bug tries one.
drop policy if exists chapters_write_update on public.chapters;
create policy chapters_write_update on public.chapters
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- chapters: only an allow-listed admin may delete a chapter (lessons and
-- tests cascade; resources are detached, exactly like deleteChapter does).
drop policy if exists chapters_write_delete on public.chapters;
create policy chapters_write_delete on public.chapters
  for delete to authenticated using (public.is_admin());

-- ----------------------------------------------------------------------------
-- PUBLISHED CONTENT — anon sees published rows ONLY; admins see everything
-- ----------------------------------------------------------------------------

-- lessons: a student holding the anon key may read ONLY lessons whose
-- is_published is true, so unpublished drafts are invisible at the database
-- level, not just hidden by the app.
drop policy if exists lessons_read on public.lessons;
create policy lessons_read on public.lessons
  for select to anon using (is_published);

-- lessons: a logged-in admin may read every lesson, published or not,
-- because the admin panel lists drafts.
drop policy if exists lessons_admin_read on public.lessons;
create policy lessons_admin_read on public.lessons
  for select to authenticated using (public.is_admin());

-- lessons: only an allow-listed admin may create a lesson (it starts
-- unpublished by default).
drop policy if exists lessons_write on public.lessons;
create policy lessons_write on public.lessons
  for insert to authenticated with check (public.is_admin());

-- lessons: only an allow-listed admin may edit a lesson — including flipping
-- is_published, which is the publish/unpublish button in the admin panel.
drop policy if exists lessons_write_update on public.lessons;
create policy lessons_write_update on public.lessons
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- lessons: only an allow-listed admin may delete a lesson.
drop policy if exists lessons_write_delete on public.lessons;
create policy lessons_write_delete on public.lessons
  for delete to authenticated using (public.is_admin());

-- resources: a student holding the anon key may read ONLY published
-- resources, so draft notes/PDFs never leak through the library screen.
drop policy if exists resources_read on public.resources;
create policy resources_read on public.resources
  for select to anon using (is_published);

-- resources: a logged-in admin may read every resource including drafts.
drop policy if exists resources_admin_read on public.resources;
create policy resources_admin_read on public.resources
  for select to authenticated using (public.is_admin());

-- resources: only an allow-listed admin may create a resource; CHECK
-- constraints additionally refuse rows with a bad kind or no file/link.
drop policy if exists resources_write on public.resources;
create policy resources_write on public.resources
  for insert to authenticated with check (public.is_admin());

-- resources: only an allow-listed admin may edit a resource, including
-- publishing/unpublishing it.
drop policy if exists resources_write_update on public.resources;
create policy resources_write_update on public.resources
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- resources: only an allow-listed admin may delete a resource.
drop policy if exists resources_write_delete on public.resources;
create policy resources_write_delete on public.resources
  for delete to authenticated using (public.is_admin());

-- tests: a student holding the anon key may read ONLY published tests, so
-- a test being authored is invisible.
drop policy if exists tests_read on public.tests;
create policy tests_read on public.tests
  for select to anon using (is_published);

-- tests: a logged-in admin may read every test including drafts.
drop policy if exists tests_admin_read on public.tests;
create policy tests_admin_read on public.tests
  for select to authenticated using (public.is_admin());

-- tests: only an allow-listed admin may create a test; CHECK constraints
-- refuse non-positive time limits or marks.
drop policy if exists tests_write on public.tests;
create policy tests_write on public.tests
  for insert to authenticated with check (public.is_admin());

-- tests: only an allow-listed admin may edit a test, including publishing.
drop policy if exists tests_write_update on public.tests;
create policy tests_write_update on public.tests
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- tests: only an allow-listed admin may delete a test (its questions
-- cascade away, mirroring deleteTest's transaction).
drop policy if exists tests_write_delete on public.tests;
create policy tests_write_delete on public.tests
  for delete to authenticated using (public.is_admin());

-- test_questions: a student holding the anon key may read a question ONLY
-- when its parent test is published — the table itself has no published
-- flag, so visibility is inherited from public.tests.
drop policy if exists test_questions_read on public.test_questions;
create policy test_questions_read on public.test_questions
  for select to anon
  using (
    exists (
      select 1 from public.tests t
      where t.id = test_questions.test_id
        and t.is_published
    )
  );

-- test_questions: a logged-in admin may read every question, even for an
-- unpublished test they are still writing.
drop policy if exists test_questions_admin_read on public.test_questions;
create policy test_questions_admin_read on public.test_questions
  for select to authenticated using (public.is_admin());

-- test_questions: only an allow-listed admin may add a question; CHECK
-- constraints force correct_option to A/B/C/D and marks to be positive.
drop policy if exists test_questions_write on public.test_questions;
create policy test_questions_write on public.test_questions
  for insert to authenticated with check (public.is_admin());

-- test_questions: only an allow-listed admin may edit a question.
drop policy if exists test_questions_write_update on public.test_questions;
create policy test_questions_write_update on public.test_questions
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- test_questions: only an allow-listed admin may delete a question.
drop policy if exists test_questions_write_delete on public.test_questions;
create policy test_questions_write_delete on public.test_questions
  for delete to authenticated using (public.is_admin());

-- live_classes: a student holding the anon key may read ONLY published
-- live classes, so an unannounced session is invisible.
drop policy if exists live_classes_read on public.live_classes;
create policy live_classes_read on public.live_classes
  for select to anon using (is_published);

-- live_classes: a logged-in admin may read every live class including
-- unpublished ones.
drop policy if exists live_classes_admin_read on public.live_classes;
create policy live_classes_admin_read on public.live_classes
  for select to authenticated using (public.is_admin());

-- live_classes: only an allow-listed admin may schedule a live class;
-- CHECK constrains status to SCHEDULED/LIVE/ENDED/CANCELLED.
drop policy if exists live_classes_write on public.live_classes;
create policy live_classes_write on public.live_classes
  for insert to authenticated with check (public.is_admin());

-- live_classes: only an allow-listed admin may edit a live class — status
-- transitions and publishing included.
drop policy if exists live_classes_write_update on public.live_classes;
create policy live_classes_write_update on public.live_classes
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- live_classes: only an allow-listed admin may delete a live class.
drop policy if exists live_classes_write_delete on public.live_classes;
create policy live_classes_write_delete on public.live_classes
  for delete to authenticated using (public.is_admin());

-- announcements: a student holding the anon key may read ONLY active
-- announcements, so a retired or not-yet-ready notice is invisible.
drop policy if exists announcements_read on public.announcements;
create policy announcements_read on public.announcements
  for select to anon using (is_active);

-- announcements: a logged-in admin may read every announcement including
-- deactivated ones.
drop policy if exists announcements_admin_read on public.announcements;
create policy announcements_admin_read on public.announcements
  for select to authenticated using (public.is_admin());

-- announcements: only an allow-listed admin may post an announcement;
-- CHECK constrains priority to NORMAL/URGENT.
drop policy if exists announcements_write on public.announcements;
create policy announcements_write on public.announcements
  for insert to authenticated with check (public.is_admin());

-- announcements: only an allow-listed admin may edit or deactivate an
-- announcement.
drop policy if exists announcements_write_update on public.announcements;
create policy announcements_write_update on public.announcements
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- announcements: only an allow-listed admin may delete an announcement.
drop policy if exists announcements_write_delete on public.announcements;
create policy announcements_write_delete on public.announcements
  for delete to authenticated using (public.is_admin());

-- ============================================================================
-- AUDIT SHORTCUT: run this to list every policy currently in the database
-- and eyeball it against this file.
-- ============================================================================
-- select schemaname, tablename, policyname, permissive, roles, cmd,
--        qual::text as using_expr, with_check::text as with_check_expr
-- from pg_policies
-- where schemaname = 'public'
-- order by tablename, policyname;
