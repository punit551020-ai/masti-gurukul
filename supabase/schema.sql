-- ============================================================================
-- Masti Gurukul — PostgreSQL / Supabase backend schema
-- ============================================================================
-- Target: Supabase hosted Postgres. Paste into the SQL editor (one statement
-- at a time if the editor complains). This file is idempotent: re-running it
-- will not error.
--
-- SECURITY MODEL (read this first)
-- -------------------------------
-- 1. CONTENT (school_classes, boards, subjects, chapters, lessons, resources,
--    tests, test_questions, live_classes, announcements) is READ-ONLY for the
--    student app and shows ONLY PUBLISHED rows:
--      - lessons / resources / tests / live_classes: is_published = true
--      - announcements: is_active = true
--      - test_questions: only visible through their PUBLISHED parent test
--    Unpublished drafts are invisible to the anon key at the DATABASE level
--    (Row Level Security), not merely hidden by app code.
--    (school_classes, boards, subjects, chapters carry no published flag in
--    the Flutter app, so they are readable as plain curriculum structure.)
--
-- 2. WRITES are restricted to a single admin identity, enforced by the
--    database via an allow-list table public.admins + a security-definer
--    function public.is_admin(). Every write policy on content tables is
--    exactly: TO authenticated USING (public.is_admin()) WITH CHECK
--    (public.is_admin()). The app never decides permissions by itself.
--    The 'authenticated' Postgres role is reserved for admin sign-ins until
--    student accounts exist; students today use the anon key only.
--
-- 3. public.admins is locked down completely: no anon access, no
--    authenticated access (a student who somehow has a login CANNOT even
--    read it, and definitely cannot add themselves). Only the dashboard /
--    SQL editor (roles postgres / supabase_admin / service_role) can insert
--    into it. Adding the first admin is the one-time bootstrap at the very
--    bottom of this file.
--
-- 4. STUDENT PROGRESS IS DEVICE-LOCAL. The Flutter app keys bookmarks,
--    recent_views, lesson_progress, test_attempts, test_attempt_answers and
--    downloads by a LOCALLY generated student id (a UUID string, not an
--    auth.uid()) and students sign in with a name only — there is no student
--    authentication. Creating public write policies on these tables would
--    let ANYONE with the anon key insert/read/overwrite rows for an
--    arbitrary student_id. So these tables exist here as a future server-side
--    mirror but are fully walled off from the API: RLS is enabled with ZERO
--    policies and all grants to anon/authenticated are revoked, and they are
--    NOT in the supabase_realtime publication. They become usable only when
--    real student auth exists; until then the app keeps this data in drift
--    on the device. app_settings is intentionally NOT mirrored server-side at
--    all (it only holds the local seed marker and device theme preference).
--
-- NAMING / TYPES
-- --------------
-- Table and column names mirror drift exactly (snake_case; the drift table
-- for classes is named school_classes, which also dodges the reserved word
-- "classes"). Content ids are `text primary key` because the Flutter client
-- generates its own uuid-as-text ids (client-generated ids stay valid).
-- drift Text->text, Int->integer, Real->double precision, Bool->boolean,
-- DateTime->timestamptz.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 0. Extensions
-- ----------------------------------------------------------------------------
-- None required: every id is generated client-side by Flutter (uuid v4 as
-- text), so we never call gen_random_uuid() server-side, and no full-text or
-- extra index types are used. This section is intentionally empty; if you
-- later add server-generated ids, enable pgcrypto from the Supabase
-- dashboard (Extensions page), not here.

-- ----------------------------------------------------------------------------
-- 1. Helper functions
-- ----------------------------------------------------------------------------

-- Generic trigger: keep updated_at honest on every UPDATE. The future sync /
-- delta-fetch layer pulls "rows WHERE updated_at > last_sync"; content tables
-- all carry this column and this trigger.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Admin allow-list check. SECURITY DEFINER + pinned search_path so that the
-- function (running as its owner, which can read the locked-down
-- public.admins table) can answer "is the current JWT user an admin?" for a
-- caller that has NO direct read access to public.admins at all.
-- Only callable by authenticated/logged-in roles; anon is revoked below.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admins a
    where a.user_id = auth.uid()
  );
$$;

-- ----------------------------------------------------------------------------
-- 2. Admin allow-list (the ONLY identity allowed to write content)
-- ----------------------------------------------------------------------------
-- Locked down: no policies are created for anon or authenticated, RLS is
-- enabled, and every grant to anon/authenticated is revoked in section 8
-- — so the Supabase API (PostgREST / realtime) cannot see or touch this
-- table at all. Only the dashboard SQL editor / service_role can INSERT a
-- row here. A student therefore cannot grant themselves admin.
create table if not exists public.admins (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);
comment on table public.admins is
  'Allow-list of auth user ids permitted to write content. Manage ONLY from the dashboard SQL editor or service_role.';

alter table public.admins enable row level security;
-- (Deliberately: zero policies => deny-all for every non-bypassing role.)

-- ----------------------------------------------------------------------------
-- 3. Content tables (curriculum catalogue)
-- ----------------------------------------------------------------------------

create table if not exists public.school_classes (
  id            text primary key,            -- client-generated, e.g. 'class-6'
  level         integer not null check (level between 1 and 12),
  name_hindi    text not null,
  name_english  text not null,
  display_order integer not null default 0,
  updated_at    timestamptz not null default now()
);

create table if not exists public.boards (
  id            text primary key,            -- e.g. 'board-cbse'
  name_hindi    text not null,
  name_english  text not null,
  display_order integer not null default 0,
  updated_at    timestamptz not null default now()
);

create table if not exists public.subjects (
  id            text primary key,            -- e.g. 'sub-class-6-mathematics'
  class_id      text not null references public.school_classes (id) on delete cascade,
  -- Null means the subject belongs to every board (the original seeded list).
  -- A board id pins it to one syllabus, so 'Class 10 Bihar Board Science' can
  -- sit beside the CBSE one without the two mixing.
  board_id      text references public.boards (id) on delete set null,
  name_hindi    text not null,
  name_english  text not null,
  accent_color  text not null default 'F1951A'
                check (accent_color ~* '^[0-9A-F]{6}$'),  -- 6-digit hex, no '#'
  display_order integer not null default 0,
  updated_at    timestamptz not null default now()
);

create table if not exists public.chapters (
  id          text primary key,              -- client-generated uuid text
  subject_id  text not null references public.subjects (id) on delete cascade,
  number      integer not null check (number >= 1),
  title       text not null check (title <> ''),
  title_hindi text not null default '',
  summary     text not null default '',
  updated_at  timestamptz not null default now(),
  -- Mirrors the AdminRepository clash check: one chapter number per subject.
  constraint chapters_unique_number unique (subject_id, number)
);

create table if not exists public.lessons (
  id               text primary key,
  chapter_id       text not null references public.chapters (id) on delete cascade,
  title            text not null check (title <> ''),
  description      text not null default '',
  display_order    integer not null default 0,
  youtube_url      text,
  local_video_path text,
  duration_seconds integer not null default 0 check (duration_seconds >= 0),
  is_published     boolean not null default false,
  updated_at       timestamptz not null default now(),
  -- Mirrors AdminRepository.saveLesson: titles are unique inside a chapter.
  constraint lessons_unique_title unique (chapter_id, title)
);

create table if not exists public.resources (
  id              text primary key,
  subject_id      text not null references public.subjects (id) on delete cascade,
  chapter_id      text references public.chapters (id) on delete set null,
                  -- 'set null' mirrors AdminRepository.deleteChapter, which
                  -- detaches resources from the chapter before deleting it.
  title           text not null check (title <> ''),
  description     text not null default '',
  kind            text not null
                  check (kind in ('NOTES', 'PDF', 'WORKSHEET', 'PREVIOUS_YEAR_PAPER')),
  year_label      integer check (year_label is null or (year_label >= 1990 and year_label <= 2100)),
  local_file_path text,
  remote_url      text,
  file_size_bytes integer not null default 0 check (file_size_bytes >= 0),
  is_published    boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  -- Mirrors the resource clash check: same subject + title + kind is one row.
  constraint resources_unique_subject_title_kind unique (subject_id, title, kind)
);

create table if not exists public.tests (
  id                 text primary key,
  chapter_id         text not null references public.chapters (id) on delete cascade,
  title              text not null check (title <> ''),
  time_limit_minutes integer not null default 20 check (time_limit_minutes > 0),
  marks_per_question double precision not null default 1.0 check (marks_per_question > 0),
  negative_marking   double precision not null default 0.0 check (negative_marking >= 0),
  is_published       boolean not null default false,
  updated_at         timestamptz not null default now()
);

create table if not exists public.test_questions (
  id             text primary key,
  test_id        text not null references public.tests (id) on delete cascade,
  prompt         text not null check (prompt <> ''),
  option_a       text not null,
  option_b       text not null,
  option_c       text not null,
  option_d       text not null,
  correct_option text not null check (correct_option in ('A', 'B', 'C', 'D')),
  explanation    text not null default '',
  marks          double precision not null default 1.0 check (marks > 0),
  display_order  integer not null default 0,
  updated_at     timestamptz not null default now()
);

create table if not exists public.live_classes (
  id              text primary key,
  subject_id      text not null references public.subjects (id) on delete cascade,
  title           text not null check (title <> ''),
  description     text not null default '',
  status          text not null
                  check (status in ('SCHEDULED', 'LIVE', 'ENDED', 'CANCELLED')),
  scheduled_start timestamptz not null,
  actual_start    timestamptz,
  actual_end      timestamptz,
  youtube_url     text,
  is_published    boolean not null default false,
  updated_at      timestamptz not null default now(),
  -- Mirrors AdminRepository.saveLiveClass clash check: same title + start time.
  constraint live_classes_unique_schedule unique (title, scheduled_start)
);

create table if not exists public.announcements (
  id           text primary key,
  title        text not null check (title <> ''),
  body         text not null check (body <> ''),
  class_id     text references public.school_classes (id) on delete set null,
  priority     text not null default 'NORMAL'
               check (priority in ('NORMAL', 'URGENT')),
  is_active    boolean not null default true,
  published_at timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  -- Mirrors AdminRepository.saveAnnouncement: announcement titles are unique.
  constraint announcements_unique_title unique (title)
);

-- ----------------------------------------------------------------------------
-- 4. Student progress tables — DEVICE-LOCAL, walled off from the API
-- ----------------------------------------------------------------------------
-- DECISION: progress stays on the device until real student authentication
-- exists. These tables mirror the drift schema for a future server sync, but:
--   * RLS is enabled with ZERO policies  => every non-bypass role is denied.
--   * all grants to anon/authenticated are revoked (section 8)
--     => they do not even appear in the PostgREST API for the anon key.
--   * they are NOT added to supabase_realtime (section 11).
-- No anon write policy is created anywhere for these tables — with a
-- client-generated student_id and no student login, such a policy would let
-- anyone read and overwrite everyone else's progress.
create table if not exists public.students (
  id           text primary key,             -- local uuid string, NOT auth.uid()
  display_name text not null,
  class_id     text references public.school_classes (id) on delete set null,
  avatar_emoji text not null default '🎓',
  theme_mode   text not null default 'system'
               check (theme_mode in ('light', 'dark', 'system')),
  created_at   timestamptz not null default now(),
  last_seen_at timestamptz not null default now()
);

create table if not exists public.bookmarks (
  student_id  text not null references public.students (id) on delete cascade,
  target_kind text not null
              check (target_kind in ('LESSON', 'RESOURCE', 'TEST', 'LIVE_CLASS')),
  target_id   text not null,
  created_at  timestamptz not null default now(),
  primary key (student_id, target_kind, target_id)
);

create table if not exists public.recent_views (
  student_id  text not null references public.students (id) on delete cascade,
  target_kind text not null
              check (target_kind in ('LESSON', 'RESOURCE', 'TEST', 'LIVE_CLASS')),
  target_id   text not null,
  viewed_at   timestamptz not null default now(),
  primary key (student_id, target_kind, target_id)
);

create table if not exists public.lesson_progress (
  student_id text not null references public.students (id) on delete cascade,
  lesson_id  text not null references public.lessons (id) on delete cascade,
  percent    double precision not null default 0.0 check (percent >= 0.0 and percent <= 100.0),
  completed  boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (student_id, lesson_id)
);

create table if not exists public.downloads (
  id               text primary key,
  student_id       text not null references public.students (id) on delete cascade,
  resource_id      text not null references public.resources (id) on delete cascade,
  local_path       text,
  total_bytes      integer not null default 0 check (total_bytes >= 0),
  downloaded_bytes integer not null default 0 check (downloaded_bytes >= 0),
  status           text not null
                   check (status in ('QUEUED', 'RUNNING', 'COMPLETE', 'FAILED')),
  last_error       text,
  updated_at       timestamptz not null default now()
);

create table if not exists public.test_attempts (
  id                text primary key,
  test_id           text not null references public.tests (id) on delete cascade,
  student_id        text not null references public.students (id) on delete cascade,
  score             double precision not null,
  total_marks       double precision not null check (total_marks >= 0),
  correct_count     integer not null check (correct_count >= 0),
  wrong_count       integer not null check (wrong_count >= 0),
  unanswered_count  integer not null default 0 check (unanswered_count >= 0),
  time_spent_seconds integer not null default 0 check (time_spent_seconds >= 0),
  submitted_at      timestamptz not null default now()
);

create table if not exists public.test_attempt_answers (
  attempt_id      text not null references public.test_attempts (id) on delete cascade,
  question_id     text not null references public.test_questions (id) on delete cascade,
  selected_option text check (selected_option is null or selected_option in ('A', 'B', 'C', 'D')),
  is_correct      boolean not null default false,
  primary key (attempt_id, question_id)
);

-- app_settings is intentionally NOT mirrored server-side: it only stores the
-- local seed marker ('catalog_seeded_v1') and the device theme preference.
-- It never belongs in the shared backend.

-- ----------------------------------------------------------------------------
-- 5. Indexes for the actual access patterns in the Flutter repositories
-- ----------------------------------------------------------------------------
create index if not exists idx_subjects_class_order
  on public.subjects (class_id, display_order);

create index if not exists idx_chapters_subject_number
  on public.chapters (subject_id, number);           -- covered by unique too

create index if not exists idx_lessons_chapter_order
  on public.lessons (chapter_id, display_order);

create index if not exists idx_lessons_published
  on public.lessons (is_published) where is_published;

create index if not exists idx_resources_subject_published_created
  on public.resources (subject_id, is_published, created_at desc);

create index if not exists idx_resources_chapter
  on public.resources (chapter_id);

create index if not exists idx_resources_year_label
  on public.resources (year_label) where year_label is not null;

create index if not exists idx_tests_chapter_published
  on public.tests (chapter_id, is_published);

create index if not exists idx_test_questions_test_order
  on public.test_questions (test_id, display_order);

create index if not exists idx_live_classes_published_start
  on public.live_classes (is_published, scheduled_start);

create index if not exists idx_live_classes_subject_start
  on public.live_classes (subject_id, scheduled_start desc);

create index if not exists idx_announcements_class_published
  on public.announcements (class_id, published_at desc);

create index if not exists idx_announcements_active
  on public.announcements (is_active, published_at desc);

-- ----------------------------------------------------------------------------
-- 6. updated_at triggers (for the future sync/delta-fetch layer)
-- ----------------------------------------------------------------------------
drop trigger if exists trg_school_classes_updated_at on public.school_classes;
create trigger trg_school_classes_updated_at
  before update on public.school_classes
  for each row execute function public.set_updated_at();

drop trigger if exists trg_boards_updated_at on public.boards;
create trigger trg_boards_updated_at
  before update on public.boards
  for each row execute function public.set_updated_at();

drop trigger if exists trg_subjects_updated_at on public.subjects;
create trigger trg_subjects_updated_at
  before update on public.subjects
  for each row execute function public.set_updated_at();

drop trigger if exists trg_chapters_updated_at on public.chapters;
create trigger trg_chapters_updated_at
  before update on public.chapters
  for each row execute function public.set_updated_at();

drop trigger if exists trg_lessons_updated_at on public.lessons;
create trigger trg_lessons_updated_at
  before update on public.lessons
  for each row execute function public.set_updated_at();

drop trigger if exists trg_resources_updated_at on public.resources;
create trigger trg_resources_updated_at
  before update on public.resources
  for each row execute function public.set_updated_at();

drop trigger if exists trg_tests_updated_at on public.tests;
create trigger trg_tests_updated_at
  before update on public.tests
  for each row execute function public.set_updated_at();

drop trigger if exists trg_test_questions_updated_at on public.test_questions;
create trigger trg_test_questions_updated_at
  before update on public.test_questions
  for each row execute function public.set_updated_at();

drop trigger if exists trg_live_classes_updated_at on public.live_classes;
create trigger trg_live_classes_updated_at
  before update on public.live_classes
  for each row execute function public.set_updated_at();

drop trigger if exists trg_announcements_updated_at on public.announcements;
create trigger trg_announcements_updated_at
  before update on public.announcements
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- 7. Row Level Security — enable everywhere
-- ----------------------------------------------------------------------------
alter table public.admins                enable row level security;  -- again, harmless; zero policies
alter table public.school_classes        enable row level security;
alter table public.boards                enable row level security;
alter table public.subjects              enable row level security;
alter table public.chapters              enable row level security;
alter table public.lessons               enable row level security;
alter table public.resources             enable row level security;
alter table public.tests                 enable row level security;
alter table public.test_questions        enable row level security;
alter table public.live_classes          enable row level security;
alter table public.announcements         enable row level security;
alter table public.students              enable row level security;  -- zero policies => deny-all
alter table public.bookmarks             enable row level security;
alter table public.recent_views          enable row level security;
alter table public.lesson_progress       enable row level security;
alter table public.downloads             enable row level security;
alter table public.test_attempts         enable row level security;
alter table public.test_attempt_answers  enable row level security;

-- ----------------------------------------------------------------------------
-- 8. Grants
-- ----------------------------------------------------------------------------
-- Supabase's default privileges hand anon/authenticated EVERYTHING on new
-- public tables, so we revoke first and then grant exactly what is needed.
-- (RLS is still the primary gate; these grants are the second lock.)

-- admins: nobody in the API touches it. Dashboard / service_role only.
revoke all on public.admins from anon, authenticated;

-- is_admin(): logged-in users may call it (it reads admins as definer).
-- anon may NOT (it has no chance of being an admin anyway; revoke keeps the
-- attack surface at zero).
-- Note the `from public`: Postgres grants EXECUTE on a new function to the
-- catch-all PUBLIC role by default, and revoking only the named `anon` role left
-- that grant standing — measured live on 2026-10-24, an anon key called
-- POST /rest/v1/rpc/is_admin and got HTTP 200 `false`. PUBLIC covers anon too, so
-- this line is the one that actually closes it.
revoke execute on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated, service_role;

-- Content: anon + authenticated may SELECT (RLS filters to published rows).
grant select on public.school_classes, public.boards, public.subjects,
                public.chapters, public.lessons, public.resources,
                public.tests, public.test_questions, public.live_classes,
                public.announcements
  to anon, authenticated;

-- Content: no INSERT/UPDATE/DELETE privilege for anon at all (students use
-- the anon key; the database rejects every write from it before RLS even
-- runs).
revoke insert, update, delete
  on public.school_classes, public.boards, public.subjects,
     public.chapters, public.lessons, public.resources,
     public.tests, public.test_questions, public.live_classes,
     public.announcements
  from anon;

-- Admin writes come from the 'authenticated' role (an admin is a signed-up
-- auth user), so DML privileges for authenticated are granted here; the RLS
-- write policies in section 10 are what actually restrict those writes to
-- callers public.is_admin() accepts.
grant insert, update, delete
  on public.school_classes, public.boards, public.subjects,
     public.chapters, public.lessons, public.resources,
     public.tests, public.test_questions, public.live_classes,
     public.announcements
  to authenticated;

-- Progress tables + students: completely out of the API. No select, no
-- insert, nothing, for anon or authenticated. Device-local until student
-- auth exists (see section 4).
revoke all on public.students, public.bookmarks, public.recent_views,
              public.lesson_progress, public.downloads,
              public.test_attempts, public.test_attempt_answers
  from anon, authenticated;

-- ----------------------------------------------------------------------------
-- 9. Policies — content READ (published rows only)
-- ----------------------------------------------------------------------------

-- school_classes / boards / subjects / chapters: curriculum structure, the
-- app browses it before anything is published, so anon reads everything.
drop policy if exists school_classes_read on public.school_classes;
create policy school_classes_read on public.school_classes
  for select to anon using (true);

drop policy if exists school_classes_admin_read on public.school_classes;
create policy school_classes_admin_read on public.school_classes
  for select to authenticated using (public.is_admin());

drop policy if exists boards_read on public.boards;
create policy boards_read on public.boards
  for select to anon using (true);

drop policy if exists boards_admin_read on public.boards;
create policy boards_admin_read on public.boards
  for select to authenticated using (public.is_admin());

drop policy if exists subjects_read on public.subjects;
create policy subjects_read on public.subjects
  for select to anon using (true);

drop policy if exists subjects_admin_read on public.subjects;
create policy subjects_admin_read on public.subjects
  for select to authenticated using (public.is_admin());

drop policy if exists chapters_read on public.chapters;
create policy chapters_read on public.chapters
  for select to anon using (true);

drop policy if exists chapters_admin_read on public.chapters;
create policy chapters_admin_read on public.chapters
  for select to authenticated using (public.is_admin());

-- lessons / resources / tests / live_classes: only published rows for anon.
drop policy if exists lessons_read on public.lessons;
create policy lessons_read on public.lessons
  for select to anon using (is_published);

drop policy if exists lessons_admin_read on public.lessons;
create policy lessons_admin_read on public.lessons
  for select to authenticated using (public.is_admin());

drop policy if exists resources_read on public.resources;
create policy resources_read on public.resources
  for select to anon using (is_published);

drop policy if exists resources_admin_read on public.resources;
create policy resources_admin_read on public.resources
  for select to authenticated using (public.is_admin());

drop policy if exists tests_read on public.tests;
create policy tests_read on public.tests
  for select to anon using (is_published);

drop policy if exists tests_admin_read on public.tests;
create policy tests_admin_read on public.tests
  for select to authenticated using (public.is_admin());

-- test_questions has no published flag of its own: a question is visible to
-- anon exactly when its parent test is published (the subquery on tests runs
-- under tests' own RLS, which for anon is the is_published filter).
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

drop policy if exists test_questions_admin_read on public.test_questions;
create policy test_questions_admin_read on public.test_questions
  for select to authenticated using (public.is_admin());

drop policy if exists live_classes_read on public.live_classes;
create policy live_classes_read on public.live_classes
  for select to anon using (is_published);

drop policy if exists live_classes_admin_read on public.live_classes;
create policy live_classes_admin_read on public.live_classes
  for select to authenticated using (public.is_admin());

-- announcements: 'is_active' is the visibility switch in the Flutter app.
drop policy if exists announcements_read on public.announcements;
create policy announcements_read on public.announcements
  for select to anon using (is_active);

drop policy if exists announcements_admin_read on public.announcements;
create policy announcements_admin_read on public.announcements
  for select to authenticated using (public.is_admin());

-- ----------------------------------------------------------------------------
-- 10. Policies — content WRITE (admin allow-list only)
-- ----------------------------------------------------------------------------
-- Identical shape on every content table, exactly as required:
--   for insert/update/delete to authenticated
--   using (public.is_admin()) with check (public.is_admin())
-- USING filters the rows you may touch; WITH CHECK validates new values, so
-- an admin UPDATE cannot smuggle in a rule-breaking row either.

drop policy if exists school_classes_write on public.school_classes;
create policy school_classes_write on public.school_classes
  for insert to authenticated with check (public.is_admin());
drop policy if exists school_classes_write_update on public.school_classes;
create policy school_classes_write_update on public.school_classes
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists school_classes_write_delete on public.school_classes;
create policy school_classes_write_delete on public.school_classes
  for delete to authenticated using (public.is_admin());

drop policy if exists boards_write on public.boards;
create policy boards_write on public.boards
  for insert to authenticated with check (public.is_admin());
drop policy if exists boards_write_update on public.boards;
create policy boards_write_update on public.boards
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists boards_write_delete on public.boards;
create policy boards_write_delete on public.boards
  for delete to authenticated using (public.is_admin());

drop policy if exists subjects_write on public.subjects;
create policy subjects_write on public.subjects
  for insert to authenticated with check (public.is_admin());
drop policy if exists subjects_write_update on public.subjects;
create policy subjects_write_update on public.subjects
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists subjects_write_delete on public.subjects;
create policy subjects_write_delete on public.subjects
  for delete to authenticated using (public.is_admin());

drop policy if exists chapters_write on public.chapters;
create policy chapters_write on public.chapters
  for insert to authenticated with check (public.is_admin());
drop policy if exists chapters_write_update on public.chapters;
create policy chapters_write_update on public.chapters
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists chapters_write_delete on public.chapters;
create policy chapters_write_delete on public.chapters
  for delete to authenticated using (public.is_admin());

drop policy if exists lessons_write on public.lessons;
create policy lessons_write on public.lessons
  for insert to authenticated with check (public.is_admin());
drop policy if exists lessons_write_update on public.lessons;
create policy lessons_write_update on public.lessons
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists lessons_write_delete on public.lessons;
create policy lessons_write_delete on public.lessons
  for delete to authenticated using (public.is_admin());

drop policy if exists resources_write on public.resources;
create policy resources_write on public.resources
  for insert to authenticated with check (public.is_admin());
drop policy if exists resources_write_update on public.resources;
create policy resources_write_update on public.resources
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists resources_write_delete on public.resources;
create policy resources_write_delete on public.resources
  for delete to authenticated using (public.is_admin());

drop policy if exists tests_write on public.tests;
create policy tests_write on public.tests
  for insert to authenticated with check (public.is_admin());
drop policy if exists tests_write_update on public.tests;
create policy tests_write_update on public.tests
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists tests_write_delete on public.tests;
create policy tests_write_delete on public.tests
  for delete to authenticated using (public.is_admin());

drop policy if exists test_questions_write on public.test_questions;
create policy test_questions_write on public.test_questions
  for insert to authenticated with check (public.is_admin());
drop policy if exists test_questions_write_update on public.test_questions;
create policy test_questions_write_update on public.test_questions
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists test_questions_write_delete on public.test_questions;
create policy test_questions_write_delete on public.test_questions
  for delete to authenticated using (public.is_admin());

drop policy if exists live_classes_write on public.live_classes;
create policy live_classes_write on public.live_classes
  for insert to authenticated with check (public.is_admin());
drop policy if exists live_classes_write_update on public.live_classes;
create policy live_classes_write_update on public.live_classes
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists live_classes_write_delete on public.live_classes;
create policy live_classes_write_delete on public.live_classes
  for delete to authenticated using (public.is_admin());

drop policy if exists announcements_write on public.announcements;
create policy announcements_write on public.announcements
  for insert to authenticated with check (public.is_admin());
drop policy if exists announcements_write_update on public.announcements;
create policy announcements_write_update on public.announcements
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists announcements_write_delete on public.announcements;
create policy announcements_write_delete on public.announcements
  for delete to authenticated using (public.is_admin());

-- NO policies on admins / students / bookmarks / recent_views /
-- lesson_progress / downloads / test_attempts / test_attempt_answers:
-- enabled RLS + zero policies + revoked grants = deny everything through the
-- API. Only the dashboard SQL editor / service_role can touch these.

-- ----------------------------------------------------------------------------
-- 11. Realtime
-- ----------------------------------------------------------------------------
-- Students receive a realtime message when a content row is INSERTED or
-- CHANGED — but the RLS SELECT policy above still decides what they can
-- actually READ BACK: a message for an unpublished lesson simply does not
-- resolve to that row for the anon key. Only content tables are added to the
-- publication. test_questions is intentionally excluded — its
-- visibility depends on the parent test and it has no own flag; the app
-- fetches questions over REST when a test is opened.
--
-- school_classes, boards, subjects and chapters are in the publication as
-- well: the app answers any realtime message with one full re-pull, so a new
-- subject created in the admin panel reaches a student who already has the app
-- open instead of waiting for the next start.
--
-- The publication already exists on Supabase; create it only if missing and
-- add tables idempotently.
do $$
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    create publication supabase_realtime;
  end if;
end;
$$;

-- REPLICA IDENTITY FULL lets realtime broadcast old values on UPDATE/DELETE.
alter table public.lessons       replica identity full;
alter table public.resources     replica identity full;
alter table public.tests         replica identity full;
alter table public.live_classes  replica identity full;
alter table public.announcements replica identity full;

do $$
declare
  t text;
begin
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
-- 12. ONE-TIME ADMIN BOOTSTRAP — CLEARLY SEPARATED, RUN LAST, RUN ONCE
-- ----------------------------------------------------------------------------
-- HOW TO BECOME THE ADMIN:
--   1. Create your admin auth user (Supabase dashboard -> Authentication ->
--      Add user, or via the app's admin sign-up flow) so an auth.users row
--      exists for you.
--   2. Open Authentication -> Users and copy YOUR user's UUID.
--   3. Copy the statement below, replace <PASTE-YOUR-AUTH-USER-ID-HERE>
--      with that UUID, and run ONLY that statement in the SQL editor.
-- It is idempotent (ON CONFLICT DO NOTHING => safe to run twice) and it is
-- the ONLY supported way into public.admins: the API itself cannot write
-- there (no grants, no policies — see section 3/8).
-- Until this runs with a real UUID, NOBODY (not even you) can write content
-- through the API. The statement is deliberately commented out because the
-- placeholder is not a valid UUID; uncomment and fill it — never commit a
-- real uuid into this file.
--
-- insert into public.admins (user_id)
-- values ('<PASTE-YOUR-AUTH-USER-ID-HERE>'::uuid)
-- on conflict do nothing;
-- ----------------------------------------------------------------------------
-- END OF SCHEMA.
-- ----------------------------------------------------------------------------
