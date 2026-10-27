-- ============================================================================
-- Masti Gurukul — structural seed data
-- ============================================================================
-- Mirrors EXACTLY what CatalogRepository.seedStructureIfEmpty() generates
-- offline in drift: classes 6-10, boards CBSE/ICSE/UP Board, and the same
-- five subjects per class — same ids, same Hindi/English names, same accent
-- colours, same display_order values — so a remote row and the local cache
-- agree byte-for-byte.
--
-- Idempotent: ON CONFLICT (id) DO NOTHING, safe to re-run; it never
-- overwrites admin edits.
--
-- NO content is seeded here (no chapters, lessons, resources, tests, live
-- classes or announcements) — that is admin-created only. A commented-out
-- smoke-test block sits at the bottom if you want to test the pipeline.
--
-- Run this from the dashboard SQL editor AFTER supabase/schema.sql: the
-- editor's role bypasses RLS, and by design the anon/authenticated API roles
-- cannot insert into these tables at all.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Classes (drift: level 6..10, id 'class-<level>', display_order = level)
--
-- 'class-all' is the row behind the admin panel's "All Classes" choice. Content
-- filed under a subject in it reaches every class at once, because
-- CatalogRepository treats it as visible everywhere. Students never see this
-- row: classes() filters it out, so nobody can pick it as their class. Its level
-- is 1 only because the column checks for 1..12 — no screen prints it.
-- ----------------------------------------------------------------------------
insert into public.school_classes (id, level, name_hindi, name_english, display_order) values
  ('class-all', 1, 'सभी कक्षाएं', 'All Classes', 0),
  ('class-6',  6, 'कक्षा 6',  'Class 6',  6),
  ('class-7',  7, 'कक्षा 7',  'Class 7',  7),
  ('class-8',  8, 'कक्षा 8',  'Class 8',  8),
  ('class-9',  9, 'कक्षा 9',  'Class 9',  9),
  ('class-10', 10, 'कक्षा 10', 'Class 10', 10)
on conflict (id) do nothing;

-- ----------------------------------------------------------------------------
-- Boards (ids, names and order exactly as in seedStructureIfEmpty)
-- ----------------------------------------------------------------------------
insert into public.boards (id, name_hindi, name_english, display_order) values
  ('board-cbse', 'सीबीएसई',          'CBSE',     1),
  ('board-icse', 'आईसीएसई',          'ICSE',     2),
  ('board-up',   'उत्तर प्रदेश बोर्ड', 'UP Board', 3),
  ('board-bihar', 'बिहार बोर्ड',      'Bihar Board', 4)
on conflict (id) do nothing;

-- ----------------------------------------------------------------------------
-- Subjects (id = 'sub-<classId>-<lowercase english name, spaces -> dashes>',
-- display_order 1..5 in the app's list order, accent colours as in Dart)
-- ----------------------------------------------------------------------------

-- Class 6
insert into public.subjects (id, class_id, name_hindi, name_english, accent_color, display_order) values
  ('sub-class-6-mathematics',    'class-6', 'गणित',            'Mathematics',    'F1951A', 1),
  ('sub-class-6-science',        'class-6', 'विज्ञान',          'Science',        '1B7A3D', 2),
  ('sub-class-6-hindi',          'class-6', 'हिन्दी',           'Hindi',          'B20308', 3),
  ('sub-class-6-english',        'class-6', 'अंग्रेज़ी',        'English',        '091B71', 4),
  ('sub-class-6-social-science', 'class-6', 'सामाजिक विज्ञान', 'Social Science', '7A4A9E', 5)
on conflict (id) do nothing;

-- Class 7
insert into public.subjects (id, class_id, name_hindi, name_english, accent_color, display_order) values
  ('sub-class-7-mathematics',    'class-7', 'गणित',            'Mathematics',    'F1951A', 1),
  ('sub-class-7-science',        'class-7', 'विज्ञान',          'Science',        '1B7A3D', 2),
  ('sub-class-7-hindi',          'class-7', 'हिन्दी',           'Hindi',          'B20308', 3),
  ('sub-class-7-english',        'class-7', 'अंग्रेज़ी',        'English',        '091B71', 4),
  ('sub-class-7-social-science', 'class-7', 'सामाजिक विज्ञान', 'Social Science', '7A4A9E', 5)
on conflict (id) do nothing;

-- Class 8
insert into public.subjects (id, class_id, name_hindi, name_english, accent_color, display_order) values
  ('sub-class-8-mathematics',    'class-8', 'गणित',            'Mathematics',    'F1951A', 1),
  ('sub-class-8-science',        'class-8', 'विज्ञान',          'Science',        '1B7A3D', 2),
  ('sub-class-8-hindi',          'class-8', 'हिन्दी',           'Hindi',          'B20308', 3),
  ('sub-class-8-english',        'class-8', 'अंग्रेज़ी',        'English',        '091B71', 4),
  ('sub-class-8-social-science', 'class-8', 'सामाजिक विज्ञान', 'Social Science', '7A4A9E', 5)
on conflict (id) do nothing;

-- Class 9
insert into public.subjects (id, class_id, name_hindi, name_english, accent_color, display_order) values
  ('sub-class-9-mathematics',    'class-9', 'गणित',            'Mathematics',    'F1951A', 1),
  ('sub-class-9-science',        'class-9', 'विज्ञान',          'Science',        '1B7A3D', 2),
  ('sub-class-9-hindi',          'class-9', 'हिन्दी',           'Hindi',          'B20308', 3),
  ('sub-class-9-english',        'class-9', 'अंग्रेज़ी',        'English',        '091B71', 4),
  ('sub-class-9-social-science', 'class-9', 'सामाजिक विज्ञान', 'Social Science', '7A4A9E', 5)
on conflict (id) do nothing;

-- Class 10
insert into public.subjects (id, class_id, name_hindi, name_english, accent_color, display_order) values
  ('sub-class-10-mathematics',    'class-10', 'गणित',            'Mathematics',    'F1951A', 1),
  ('sub-class-10-science',        'class-10', 'विज्ञान',          'Science',        '1B7A3D', 2),
  ('sub-class-10-hindi',          'class-10', 'हिन्दी',           'Hindi',          'B20308', 3),
  ('sub-class-10-english',        'class-10', 'अंग्रेज़ी',        'English',        '091B71', 4),
  ('sub-class-10-social-science', 'class-10', 'सामाजिक विज्ञान', 'Social Science', '7A4A9E', 5)
on conflict (id) do nothing;

-- ----------------------------------------------------------------------------
-- Quick verification (structure only; expect 5 / 3 / 25 rows)
-- ----------------------------------------------------------------------------
-- select count(*) as classes    from public.school_classes;
-- select count(*) as boards     from public.boards;
-- select count(*) as subjects   from public.subjects;

-- ============================================================================
-- OPTIONAL SMOKE-TEST CONTENT — DELIBERATELY COMMENTED OUT, NOT LIVE SEED.
-- Uncomment ONLY if you want to prove the read/realtime pipeline end to end.
-- These rows are invented placeholders; delete them right after testing so
-- they never ship to students.
-- ============================================================================
--
-- insert into public.chapters (id, subject_id, number, title, title_hindi, summary)
-- values ('smoke-chapter-0001', 'sub-class-6-mathematics', 1, 'Smoke test chapter', 'स्मोक टेस्ट', 'Delete after testing')
-- on conflict (id) do nothing;
--
-- insert into public.lessons (id, chapter_id, title, description, display_order, youtube_url, duration_seconds, is_published)
-- values ('smoke-lesson-00001', 'smoke-chapter-0001', 'Smoke test lesson', '', 1, null, 0, true)
-- on conflict (id) do nothing;
--
-- -- then, as anon, select * from lessons  => the published lesson should appear;
-- -- flip is_published to false => the row must vanish for anon (RLS proof).
--
-- delete from public.lessons   where id = 'smoke-lesson-00001';
-- delete from public.chapters  where id = 'smoke-chapter-0001';
