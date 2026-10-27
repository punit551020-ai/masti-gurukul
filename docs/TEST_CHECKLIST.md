# Masti Gurukul — जाँच सूची (Test Checklist)

आख़िरी कॉलम ईमानदारी से बताता है कि **अभी** कितना verify हुआ है:

- ✅ = automated test या इस मशीन पर build/chrome में चलाकर देखा
- 📱 = असली Android फ़ोन पर देखना बाकी ( emulator/test में संभव नहीं था)
- ⏸ = आपके Supabase keys आने के बाद ही चल सकता है

---

## 1. Auto-tests (जो CI की तरह चलते हैं)

```bash
flutter analyze      # No issues found

flutter test         # 128 pass + 6 skip  (बिना .env वाला build: backend compiled नहीं)
flutter test --dart-define-from-file=.env   # 134 pass + 0 skip  (असली .env compiled)
```

कुछ tests केवल एक ही build flavour के बारे में सच कहते हैं, इसलिए वे दूसरे में
स्वयं skip हो जाते हैं — इसलिए दोनों कमांडीं चलाकर देखें कि सब हरे हैं।

| सूट | क्या जाँचता है |
|---|---|
| `test/unit/core_rules_test.dart` | नाम के नियम, YouTube URL allow-list (नकली डोमेन/playlist-only reject) |
| `test/unit/test_grading_test.dart` | MCQ grading: per-question marks, negative marking, unanswered, rounding |
| `test/unit/asset_downloader_test.dart` | PDF download: path traversal refute, https-only, corrupt/empty file पूरा नहीं मानता |
| `test/unit/subject_art_test.dart` | subject के नाम से सही चित्र (Hindi/English दोनों), नए subject पर code बदलने की ज़रूरत नहीं |
| `test/unit/board_subjects_test.dart` | Board अनुसार subject: id बनना, clash reject, board filter, `board_id` का server round-trip |
| `test/unit/resource_upload_test.dart` | PDF upload server तक जाए, rollback (server मना करे तो local row पुरानी), और **सिर्फ़ Title अनिवार्य**: बिना file/link/year वाला row `remote_url: null`, `year_label: null`, `is_published: true` के साथ server तक जाता है; खाली title पर साफ़ message; chapter/test/question के खाली या गलत नंबरों पर वाक्य-जैसे error (raw DB error नहीं) |
| `test/unit/all_classes_test.dart` | **"All Classes"**: student को class list में कभी न दिखे, admin list में पहले विकल्प हो; एक ही subject का chapter/lesson/PDF/test class 6 से 10 सबको मिले; unpublished row किसी को न मिले; class-specific content दूसरी class में न झाँके |
| `test/widget/app_shell_test.dart` | shell + tabs, सभी labels English, admin gate बिना backend बंद, Admin Tests tab, class dropdown में "All Classes" चुनकर title-only file पर "no file attached yet" tag, और **bottom bar में 5 ही tab हैं — "AI Tutor"/"Hacker Ankit AI" का नाम कहीं न मिले, ताकि हटाया गया tab दोबारा वापस न आ पाए** |
| `test/widget/admin_upload_form_test.dart` | **असली bottom-sheet फॉर्म चलाकर**: "Year label" फील्ड form में कहीं नहीं है, "Only the title is needed…" मदद-लाइन है, हर write form में **"Files under: Class 10 · Bihar Board · Science"** banner, खाली title → SnackBar "Title is required.", सिर्फ़ title भरने पर sheet बंद + DB में row, edit करते समय पुराना year सुरक्षित, chapter number खाली छोड़ें तो अगला क्रम, **chapter edit form का "Move this to another subject" picker गलत subject में डाला chapter सही subject में ले जाए** (उसके lesson का video अब सही subject में), test के खाली नंबर → 20 min / 1 mark / 0 negative, और 900 min पर सीमा का message |
| `test/widget/admin_gate_test.dart` | पूरा admin sign-in flow एक नकली gateway से: form दिखे, typed credentials trimmed होकर server तक जाएँ, server मना करे तो panel बंद, खाली field कभी न भेजे जाएँ, 5 गलत try के बाद cool-down। केवल `--dart-define-from-file=.env` वाला build ही इसे चलाता है; असली Supabase तक कुछ नहीं जाता। |
| `test/widget/lesson_player_test.dart` | video player states, ENDED पर auto-advance, "no video" honest state, और **chapter queue अब thumbnail cards है**: "Videos in this chapter (2)" + `VideoCard` की गिनती, चल रहे card पर "Now playing" pill, card दबाने पर वही lesson player में, और auto-advance के बाद pill अगले card पर चला जाए |
| `test/widget/library_pdf_test.dart` | published/unpublished PDF listing, viewer, और **बिना file वाली row ईमानदारी से बोले**: "The file is not here yet" + "बाद में जोड़ी जाएगी" message, बेवजह spinner/PDF viewer न खुले; जिस row में local copy है उसे "missing" न कहा जाए |
| `test/widget/board_subjects_test.dart` | student के subject card और subject page पर "Bihar Board" लेबल |
| `test/widget/test_runner_test.dart` | पूरा attempt UI + countdown खत्म पर auto-submit, DB में persist |
| `test/widget/welcome_screen_test.dart`, `home_video_feed_test.dart` | login screen और home का **unlimited video feed**: published lesson card बने, unpublished कहीं न दिखें, खाली class ईमानदारी से बोले, 40 videos पर grid lazy हो (सबके widget एक साथ नहीं बनते) और scroll करके आख़िरी तक पहुँचा जा सके, 1200 px चौड़ी window में एक लाइन में कई cards, और दूर की card दबाने पर `LessonScreen` + player तुरंत खुले। subject page: अपनी list सिर्फ़ अपनी ("Videos (1)"), और **"Also published for your class"** section बाकी class के videos/PDF उनके असली subject नाम के साथ दिखाए — खाली subject page अब "Nothing published yet" के बजाय वही section दिखाता है |
| `test/widget/stability_error_states_test.dart` | **पहले से screen पर दिखाई हुई data फेल होने पर क्या होता है**: local database पढ़ा न जा पाने पर Library/Classes/Tests अपनी-अपनी offline बात कहते हैं (spin/crash नहीं), retry button दबाने पर कोई uncaught error नहीं, Welcome का "Start Learning" एक फेल होने के बाद दोबारा दबने लायक़ रहता है, server न मिलने पर AppBar में "Offline" badge आता है और good pull पर हट जाता है, realtime event 1.2 s बाद एक ही pull करता है, और admin का delete server मना करे तो SnackBar में message + row ज्यों-की-त्यों |

## 2. Builds (इस मशीन पर)

| आउटपुट | कमांड | स्थिति |
|---|---|---|
| Web | `flutter build web --release` | ✅ बनी थी (`build/web`) |
| APK | `flutter build apk --release` | नीचे नोट देखें |
| AAB | `flutter build appbundle --release` | keystore बनने के बाद ही Play-Store-签名 होगी |

> **ज़रूरी:** जब तक `android/key.properties` + `.jks` नहीं बनते, AAB debug key से sign होती है और
> Play Store उसे स्वीकार नहीं करेगा। यह docs/BUILD_ANDROID.md हिस्सा B है। "Play Store पर डाल दिया"
> वाला दावा तब तक नहीं किया जा रहा जब तक release न हो।

## 3. Student features — manual

| # | जाँच | कैसे | स्थिति |
|---|---|---|---|
| 1 | नाम से शुरू (कोई password नहीं) + "यह identity verification नहीं है" note | होम पर नाम डालें | ✅ |
| 2 | Class चुनने → Subjects → Chapters → Lessons | tabs + drawer | ✅ |
| 3 | YouTube lesson in-app चले, video खत्म → auto next | lesson खोलें | ✅ web में (native player events) |
| 4 | YouTube के अलावा कोई भी URL lesson में न चले | Admin में `vimeo.com` डालकर save → reject message | ✅ |
| 5 | PDF list + viewer + "download" बटन | Library | ✅ widget tests |
| 6 | PDF download progress/retry/remove | Downloads tab | 📱 |
| 7 | **Offline**: download के बाद flight mode पर PDF खुले | फ़ोन | 📱 |
| 8 | MCQ test: timer, palette, mark-for-review, submit, result, explanation | Tests tab | ✅ widget test |
| 9 | Test का best score + progress screen में attempts | दोबारा test दें | ✅ unit+widget |
| 10 | Bookmarks + progress locally persist | lesson देखें, ऐप बंद-खोलें | ✅ |
| 11 | Announcements सिर्फ़ active + अपने class की | drawer | ✅ |
| 12 | **AI Tutor ("Hacker Ankit AI") ऐप में कहीं न रहे** (27-10-2026 को हटाया गया): bottom bar में 5 tab (Home, Classes, Tests, Downloads, Profile), drawer/UI text में "AI" का कोई option नहीं, कोई Gemini/TTS/mic/camera call नहीं | bottom bar + drawer गिनें; Help screen पढ़ें; `grep -ri "gemini\|tutor" lib` खाली आए | ✅ widget test + code grep ; पुरानी फ़ाइलें backup में |
| 13 | कोई नकली statistic/button नहीं | हर button दबाकर देखें | ✅ code review |
| 13b | इंटरनेट बंद → ऊपर "Offline" दिखे, पुराना content पढ़ने में आए, badge दबाएँ तो दोबारा try | फ़ोन पर flight mode | ✅ widget test (नकली gateway) + 📱 असली फ़ोन बाकी |
| 13c | Local database खराब/भरा हो → screen क्रैश न हो, अपनी offline बात कहे | browser में IndexedDB delete करके ऐप खोलें | ✅ widget test |
| 13d | Home का video feed **unlimited responsive grid**: कोई "सिर्फ़ 4-5" की limit नहीं, फ़ोन पर 2 column, laptop पर अधिक, नीचे scroll पर पुराने-नए सब दिखें, card तुरंत player खोले | web पर खोलें (10 videos publish करके देखें), फिर Chrome छोटा/बड़ा करके column बदलते देखें | ✅ widget test (40 videos, wide window, late card) ; 📱 असली फ़ोन पर scroll feel बाकी |
| 13e | **हर जगह video = thumbnail card, text link कहीं नहीं**: subject page, chapter page, lesson का "Videos in this chapter" queue, और home का "Recently viewed" — सब home जैसी ही cards; जिस lesson में video ही नहीं है वही ईमानदारी से text row ("No video is attached to this lesson yet.") रखता है, नकली thumbnail कहीं नहीं | Classes → subject → chapter → lesson खोलें; home पर कुछ videos देखकर लौटें | ✅ widget tests (lesson queue + home feed) ; search में video rows हैं ही नहीं (library search सिर्फ़ PDF), इसलिए वहाँ कुछ बदलने की ज़रूरत नहीं |
| 13f | **खाली subject में भी content दिखे**: किसी ऐसे subject को खोलें जिसमें admin ने कुछ डाला ही नहीं (जैसे Class 10 Social Science/Science) → नीचे **"Also published for your class"** में उस class के सारे published videos और PDFs आ जाएँ, हर item पर उसका असली subject नाम | web :8100 → Class 10 → Social Science; फिर Admin Panel → कोई chapter/lesson/file खोलें → "Files under:" line पढ़ें और chapter के "Move this to another subject" से गलत subject वाला chapter सही subject में डालें | ✅ widget tests ; ⚠️ असली database में 5 videos सिर्फ़ Mathematics / Sanskrit / General में पड़े हैं (2026-10-27 probe) — panel से move किए बिना Social Science का अपना video नहीं दिखेगा |

## 4. Admin + security — manual

| # | जाँच | कैसे | स्थिति |
|---|---|---|---|
| 14 | 3 टैप के बिना admin入口 कहीं दिखे ही नहीं | nav/drawer खंगालें | ✅ |
| 15 | बिना backend के panel नहीं खुलता | `.env` हटाकर चलाएँ → snackbar | ✅ widget test |
| 16 | गलत email/password → server मना करे | Supabase में गलत पासवर्ड | ✅ widget test (नकली gateway) + live probe; असली गलत-पासवर्ड अज़माया नहीं |
| 17 | 5 गलत try के बाद 60 s cool-down | बार-बार गलत डालें | ✅ widget test (छठा try server तक नहीं जाता) |
| 18 | student के anon key से write reject | `curl` से insert try करें → 401/permission denied | ✅ live 2026-10-24: anon POST `lessons` व `resources` → 401 `42501 permission denied`; कोई row नहीं लिखी गई (2026-10-26 को दोबारा जाँचा: वही नतीजा) |
| 19 | `public.admins` API से पढ़ने/लिखने की छूट नहीं | dashboard → REST `select` try | ✅ live 2026-10-24: anon SELECT `admins` → 401 `42501` |
| 20 | Published ↔ Draft तुरंत student पर दिखे/छिपे | Publish toggle + दूसरा device | ✅ code + widget test (realtime event → 1.2 s बाद pull); ⏸ live 2-device जाँच बाकी |
| 21 | PDF bucket public-read + admin-only-write | browser में URL, फिर anon upload try | ⚠️ live जाँच 2026-10-27: `GET /storage/v1/bucket/library` → अब भी 404 "Bucket not found" ⇒ `supabase/storage.sql` **अभी नहीं चला**; जब तक न चले PDF/notes अपलोड server पर नहीं जाएगा (code साफ़ message दिखाता है) |
| 22 | Sign out से session खत्म | panel के बंद होते ही Supabase Auth signOut | ✅ code (2026-10-24: `AdminHomeScreen.dispose` अब silent sign-out करता है) |
| 22b | **कोई दूसरा Auth user panel न खोल सके** | Dashboard में sign-ups ON रखकर अपना account बनाएँ → admin email/password की जगह **उस** account से sign in → "This account is not the admin of this school…" आना चाहिए, panel नहीं | ⏸ (2026-10-24 में code + `rpc/is_admin` लाइव check जोड़े; आपकी verification बाकी) |
| 22c | Public sign-ups OFF (Play build के लिए) | Dashboard → Authentication → Sign In / Up | ⏸ |
| 22d | App bootstrap fail हो तो साफ़ message, काला स्क्रीन नहीं | `.env` गलत URL के साथ चलाकर देखें | ✅ code (2026-10-24: `main()` ने bootstrap try/catch + `_FailureApp`) |
| 23 | Admin → Class + Board → ➕ से नया Subject बनता है | Bihar Board चुनकर "Science" बनाएँ | ✅ widget+unit test, ⏸ live |
| 24 | उसी नाम का subject दूसरे Board के लिए बन सके, पर एक ही Board में दोबारा न बने | clash message देखें | ✅ unit test |
| 25 | Student के subject card + subject page पर Board का नाम दिखे | Classes tab, shared subject पर लेबल न आये | ✅ widget test |
| 26 | Resources → **Choose a file** → PDF server पर जाए और URL resource पर बसे | असली Supabase bucket चाहिए | ⏸ |
| 27 | अपलोड फेल हो तो admin को साफ़ message मिले, चुप नहीं | bucket न बनने पर try करें | ✅ code + unit test |
| 28 | Android पर अपलोड के साथ फ़ोन में भी कॉपी रहे (offline) | फ़ोन | 📱 |
| 29 | **अब सिर्फ़ Title अनिवार्य**: Description/Link/Chapter सब खाली छोड़कर "Save file" → row तुरंत बने | Admin → Files → ➕ → सिर्फ़ title | ✅ widget+unit test; ✅ **live server पर भी चल चुका है** (2026-10-27 probe: बिना-file वाली published `resources` row server पर मौजूद, और `class-all` भी) — सिर्फ़ असली PDF bytes के लिए `storage.sql` बाकी है |
| 30 | फॉर्म में "Year label" कहीं न दिखे; edit करते समय पुराना year न मिटे | Files → ➕ / ✏️ | ✅ widget test |
| 31 | Class dropdown में **All Classes** (सभी कक्षाएं) पहले विकल्प के रूप में हो, student की class list में न हो | Admin panel + student का class chooser | ✅ unit+widget test; 📱 live: पहले वह SQL फ़ाइल चलाएँ |
| 32 | All Classes में publish किया PDF/video/test Class 6-10 सबको दिखे | एक shared subject बनाकर 6 कक्षाओं में switch करके देखें | ✅ unit test (local DB); ⏸ live |

## 5. Supabase live — आपके 2 keys आने के बाद (⏸ वाला सब)

1. `docs/SUPABASE_SETUP.md` के स्टेप (चला-हुआ project हो तो स्टेप 4क की एक फ़ाइल ज़रूरी)।
2. Admin lesson बनाकर publish → दूसरी विंडो में 1-2 s में दिखे (realtime)।
3. Admin offline होकर save → server reject → local row पुरानी हालत में लौटे (rollback test)।
4. Student device offline → "saved on this device" message, पुराना content दिखे।
5. Admin → Class 10 → Bihar Board → ➕ → नया subject → student की खुली विंडो में ~2 s में tile +
   "Bihar Board" लेबल दिखे (realtime publication का जाँच)।
6. Admin → Resources → PDF चुनें → Publish → server से आया URL ब्राउज़र में खोलकर दिखे, और
   student उसी PDF को खोल सके।

## Known limits (छिपा नहीं गया)

- Student progress अभी device-local है: `students/lesson_progress/test_attempts` टेबलों पर कोई RLS
  policy नहीं इसलिए API से पढ़ा/लिखा नहीं जा सकता — student-auth बनने तक यह design है।
- Web पर PDF native viewer नहीं (browser viewer), Android/iOS में native viewer।
- Live class: सिर्फ़ join link + समय; in-app attendance/record कुछ नहीं है।
- AI "Hacker Ankit" / "AI Tutor" **27-10-2026 को feature से पूरी तरह हटा दिया गया है** — bottom
  bar का tab, दोनों स्क्रीन, Gemini call, read-aloud, mic/camera, `supabase/functions/ai-tutor`,
  और `.env` के `GEMINI_API_KEY` / `TUTOR_PROXY_URL` getters सब। पुरानी फ़ाइलें project के बाहर
  `~/Documents/Qoder/ai-tutor-removed-2026-10-27/` में हैं, इसलिए वापस लाने लायक़ बची हैं।
  app_shell test अब tab की गिनती 5 जाँचता है और नाम में "AI Tutor" न मिलने की कसम खाता है।
- Board-wise subject का code + SQL **live project पर चला हुआ है** (2026-10-26 probe: `boards` में
  `bihar_board`, Class 10 subjects पर `board_id`)। चला हुआ नाम `bihar_board` है, seed का
  `board-bihar` अलग candidate है — admin नया subject बनाते समय dropdown से ही चुनें।
- PDF/notes वाला `library` bucket **अब भी नहीं बना** — 2026-10-27 को दोबारा नापा:
  `GET /storage/v1/bucket/library` → **404 "Bucket not found"** ⇒ `supabase/storage.sql` SQL Editor
  में run करना ज़रूरी है, वरना admin का चुना हुआ PDF server तक नहीं जाएगा।
  **इसका असर पहले से दिख रहा है:** live `resources` की 3 rows published हैं पर तीनों में
  `remote_url = null` — यानी owner ने फ़ाइल चुनी तो (`file_size_bytes` में 382683 दर्ज है) पर bucket
  न होने से bytes कहीं नहीं गए, और छात्र को "The file is not here yet" दिखता है।
- "All Classes" + सिर्फ़-Title अपलोड वाली `supabase/update_2026_10_26_all_classes.sql` **चुका है** —
  2026-10-27 के probe से दो अलग-अलग सबूत: (a) `school_classes` में अब `class-all` मौजूद है,
  (b) server पर एक ऐसी `resources` row मौजूद है जिसमें न `remote_url` है न कोई link, और वह save हो
  गई — यह तभी संभव है जब पुराना `resources_has_file_or_link` check हट चुका हो।
  (c) `subj-all-general` का `class_id = class-all` भी server पर दिखता है।
  **बाक़ी सिर्फ़ `storage.sql` है।** Realtime publication REST से पढ़ी नहीं जा सकती, इसलिए वह
  अब भी "अनदेखा" है — जाँचने का एकमात्र तरीक़ा: admin panel से publish करके दूसरे browser/window
  में 1-2 s में आना देखें।
- `test_questions` realtime publication में जान-बूझकर नहीं है: सवाल उस test के साथ pull होते हैं,
  इसलिए publish किए test के questions ~1-2 s में आ जाते हैं, पर question-only edit पर अलग event नहीं।
