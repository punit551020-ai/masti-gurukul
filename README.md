# Masti Gurukul — मस्ती गुरुकुल

> *Vidya Dadati Vinayam* · Learn • Grow • Succeed · सीखो • बढ़ो • सफल बनो

Class 6–10 के लिए एक असली, cross-platform education app — **एक ही Flutter codebase** से
Android (APK/AAB) और वेब दोनों, एक ही Supabase backend, offline downloads, और एक hidden
Admin panel।

---

## एक नज़र में

| | |
|---|---|
| तकनीक | Flutter 3.47 · Dart 3.13 · drift (SQLite) · provider · Supabase (Auth + Postgres + RLS + Storage + Realtime) |
| प्लेटफ़ॉर्म | Android (APK + Play Store AAB) और Web — एक ही कोड |
| छात्र लॉगिन | सिर्फ़ नाम से (कोई email/password नहीं) — स्क्रीन पर साफ़-साफ़ लिखा है कि यह identity verification नहीं है |
| बनावट | Class → Board → Subject → Chapter → Lesson |
| कंटेंट | YouTube embed (सिर्फ़ official player, कोई download/बैपास नहीं), PDF/notes, live class links, MCQ tests, announcements |
| Admin | लोगो पर 3 बार टैप → Supabase Auth email+password → server-side RLS तय करता है कि लिख सकता है या नहीं |
| Content management | Admin → Class + Board चुनकर नया Subject, YouTube lesson, PDF upload (`library` bucket)। Class dropdown में **All Classes (सभी कक्षाएं)** भी है — उसमें डाला कंटेंट Class 6-10 सबको दिखता है। Upload फॉर्म में **सिर्फ़ Title अनिवार्य** (Description/Link/Chapter छोड़ सकते हैं), "Year label" हटा दिया गया है। Publish के तुरंत बाद realtime से हर डिवाइस पर पहुँचने के लिए `supabase/update_2026_10_26_all_classes.sql` **चुका है** (2026-10-27 probe से पुष्टि) — अब सिर्फ़ `supabase/storage.sql` SQL Editor में चलाना बाकी है, वरना PDF के bytes server पर नहीं जाएँगे (docs/SUPABASE_SETUP.md स्टेप 4) |
| Offline | PDF/notes फ़ोन में download, progress/bookmarks device-local |

## चलाएँ

```bash
flutter pub get
cp .env.example .env        # अपना Supabase URL + anon key डालें (docs/SUPABASE_SETUP.md)
flutter run -d chrome --dart-define-from-file=.env
```

`.env` के बिना भी चलता है — तब सिर्फ़ उसी डिवाइस का seed किया हुआ structure दिखेगा और Admin
पैनल बंद रहेगा (जानबूझकर: कोई backend नहीं = कोई write access नहीं)।

## ज़रूरी दस्तावेज़

| फ़ाइल | क्या |
|---|---|
| [docs/SUPABASE_SETUP.md](docs/SUPABASE_SETUP.md) | 7 स्टेप में backend: project बनाना → schema → admin UID → जाँच |
| [docs/BUILD_ANDROID.md](docs/BUILD_ANDROID.md) | APK/AAB बनाना, upload key, Play Store पर जाने का तरीक़ा |
| [docs/TEST_CHECKLIST.md](docs/TEST_CHECKLIST.md) | हर feature की manual जाँच सूची + क्या अभी untested है |
| [supabase/schema.sql](supabase/schema.sql) | Tables + grants + RLS policies (समझा हुआ comments के साथ) |
| [supabase/seed.sql](supabase/seed.sql) | Class/Board/Subject की बनावट (offline seed से मेल खाती है; सिर्फ़ `class-all` row server पर है, क्योंकि ऐप उसे खुद बनाता है) |
| [supabase/storage.sql](supabase/storage.sql) | `library` bucket (PDF/notes) + admin-only write |
| [supabase/update_2026_10_23_bihar_board.sql](supabase/update_2026_10_23_bihar_board.sql) | चला-हुआ project आगे बढ़ाने के लिए एक बार: `subjects.board_id`, Bihar Board, bucket, realtime publication |
| [supabase/update_2026_10_26_all_classes.sql](supabase/update_2026_10_26_all_classes.sql) | एक बार चलाएँ: `class-all` row (All Classes), `resources_has_file_or_link` हटाना (सिर्फ़ Title अपलोड), 9 tables realtime publication में दोबारा |

## फ़ोल्डर की बनावट

```
lib/
  core/        brand, theme, YouTube URL allow-list, backend config
  data/
    local/     drift database + tables (छात्र का सारा data यहीं से पढ़ता है)
    remote/    ContentGateway (interface) + SupabaseContentGateway + row mappers
    repositories/ catalog, students, downloads, tests, admin (writes), sync
  state/       AppState — bootstrap, selected class, theme, sync status, contentVersion
  navigation/  app shell (5 tabs + drawer)
  features/    home · classes · library · live · tests · downloads · progress
               profile · announcements · admin · help
               (ai/ = Hacker Ankit AI 27-10-2026 को हटाया गया; फ़ाइलें project के बाहर backup में)
test/
  unit/        rules: name validation, YouTube allow-list, grading, downloader
  widget/      shell + lesson player + test runner + library/PDF
```

## कैसे काम करता है "upload करते ही सब पर दिखे"

1. Admin panel में save → पहले local drift row, फिर Supabase को वही row (`upsert`)।
   Supabase reject करे तो local row वापस पुरानी हालत में लौट आती है — device और server कभी
   अलग-अलग नहीं रहते।
2. दूसरे devices realtime channel (`masti-gurukul-content`) पर change सुनते हैं → 1.2 s debounce
   के बाद published rows दोबारा pull होती हैं → `AppState.contentVersion` बढ़ता है → खुली हुई
   screens अपने आप re-query करती हैं। rebuild नहीं, app बंद-खोलने की ज़रूरत नहीं।
3. Offline device: जो पहले sync था वह दिखता है; नेट न होने पर honest message
   ("saved on this device") — कोई नकली loading नहीं।

## Admin security — असली ताला कहाँ है

- App में कहीं भी admin password/pin **हार्डकोड नहीं** है (पुराना local PIN फ़ाइल हटा दी गई है)।
- Admin पैनल का दरवाज़ा (3 टैप) सिर्फ़ **छिपाता** है; authorise कुछ नहीं करता।
- असली जाँच: Supabase Auth session + `public.admins` allow-list + RLS write policies
  (`to authenticated using (public.is_admin())`)।
- `anon` role के पास content tables पर **insert/update/delete grant ही नहीं** है, RLS से पहले ही
  request reject हो जाती है।
- PDF bucket `library`: पढ़ना सबको, लिखना सिर्फ़ allow-listed admin को।
- `.env` में सिर्फ़ public anon key — यही design है; असली secret (`service_role`) कभी project में
  नहीं आता। Student progress tables API से पूरी तरह बाहर हैं (कोई policy नहीं)।

## ईमानी से क्या नहीं / अब तक verify नहीं हुआ

- **Real device पर offline अभी test नहीं हुआ** — emulator/test पार हैं, पर Play Store से पहले एक
  असली Android फ़ोन पर flight-mode test ज़रूर करें (checklist में # Offline सेक्शन)।
- **Publish = Release नहीं:** जब तक AAB Play Store पर release न हो, "published" दावा नहीं किया
  जा रहा।
- **AI Tutor ("Hacker Ankit AI") 27-10-2026 को पूरी तरह हटा दिया गया**: bottom bar का tab, दोनों
  स्क्रीन, Gemini call, TTS/mic/camera — सब। पुरानी फ़ाइलें project के बाहर
  `~/Documents/Qoder/ai-tutor-removed-2026-10-27/` में रखी हैं, इसलिए वापस लानी हो तो एक command
  से आ जाएँगी।
- कोई भी आँकड़ा/स्टैटिस्टिक नकली नहीं है — progress screen सिर्फ़ वही दिखाती है जो device पर सच में
  हुआ है।

## License/branding

`assets/brand/` में आपके भेजे हुए logo/reference images ही इस्तेमाल हैं; कोई नया logo generate
नहीं किया गया। PW/Disha जैसी कोई copy नहीं — नाम, रंग, content सब अलग।
