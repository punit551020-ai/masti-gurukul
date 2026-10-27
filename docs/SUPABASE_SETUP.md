# Masti Gurukul — Supabase बैकएंड सेटअप (सिर्फ़ 7 स्टेप)

यह गाइद आपके MacBook Air M1 पर चलती है। हर स्टेप पूरा करके अगला करें। कहीं भी अटके तो
स्क्रीनशॉट भेज दें — मैं उसी हिसाब से आगे बताऊँगा।

**क्या मिलेगा:** Class 6–10 के लिए Board अनुसार Subject (जैसे Class 10 → Bihar Board → Science),
YouTube लिंक, PDF, लाइव क्लास, टेस्ट, announcement — Admin पैनल से डालते ही
सभी फ़ोन/लैपटॉप पर अपने आप दिखने लगेंगे। ऐप दोबारा बनाने (rebuild) की ज़रूरत नहीं।

**खर्चा:** Supabase Free Tier = ₹0। कोई कार्ड/सब्सक्रिप्शन इस गाइद में नहीं माँगा जा रहा।

---

## स्टेप 1 — Supabase प्रोजेक्ट बनाएँ (2 मिनट)

1. ब्राउज़र में खोलें: `https://supabase.com/dashboard`
2. Sign in (GitHub या email से)।
3. बाईं ओर **New project** बटन दबाएँ।
4. फ़ॉर्म भरें:
   - **Project name** → `masti-gurukul`
   - **Database password** → कोई मज़बूत पासवर्ड बनाकर Notes ऐप में सेव कर लें (बार-बार चाहिए होगा)।
   - **Region** → `Southeast Asia (Singapore)` चुनें (भारत के सबसे पास)।
5. **Create new project** दबाएँ और 2–3 मिनट इंतज़ार करें जब तक "Project is ready" न दिखे।

---

## स्टेप 2 — दो कीज़ कॉपी करें

1. बाईं ओर नीचे **Project Settings** (गियर आइकन) → **API** खोलें।
2. यहाँ दो चीज़ें दिखेंगी:
   - **Project URL** → `https://xxxxxxxx.supabase.co` जैसा कुछ।
   - **anon public** key → लंबी अजीब सी स्ट्रिंग (इसे `publishable key` भी कहते हैं)।
3. दोनों अलग-अलग क्लिपबोर्ड में कॉपी करें।

> ⚠️ इसी पेज पर **service_role / secret** key भी होता है। उसे **किसी भी हालत में कॉपी न करें** —
> न ऐप में, न `.env` में, न चैट में। वह सिर्फ़ सर्वर का सुपर-पासवर्ड है। हमें उसकी ज़रूरत नहीं।

---

## स्टेप 3 — `.env` फ़ाइल बनाएँ

1. Terminal खोलें (Cmd+Space दबाकर "terminal" टाइप करें, फिर Enter) और ये दो कमांड चलाएँ:

   ```bash
   cd /Users/sonukumar/Documents/Qoder/2026-10-20/c87ff882
   cp .env.example .env
   ```

2. अब `.env` फ़ाइल खोलें:

   ```bash
   code .env        # अगर VS Code है
   open -e .env     # नहीं है तो TextEdit खुल जाएगा
   ```

3. इसमें सिर्फ़ दो लाइनें बदलें (क्वोटेशन मार्क नहीं लगाना):

   ```
   SUPABASE_URL=https://अपनी-रिफ.supabase.co
   SUPABASE_ANON_KEY=अपनी-anon-key-यहाँ
   ```

4. Save करें (Cmd+S)। `.env` गलती से GitHub पर न जाए — यह पहले से `.gitignore` में है, इसलिए सुरक्षित है।

** जाँच:** ठीक-ठाक भरने पर ऐप में Admin पैनल खुलेगा। गलत भरा तो ऐप चलेगा पर Admin पैनल
"backend configured नहीं है" कहकर बंद रहेगा (यह जानबूझकर है, ताकि बिना बैकएंड कोई छात्र एडिट न कर सके)।

---

## स्टेप 4 — डेटाबेस टेबल + सुरक्षा (RLS) लागू करें

1. Supabase dashboard → बाईं ओर **SQL Editor** (⚡ आइकन) → **New query**।
2. अब अपने कंप्यूटर से फ़ाइल खोलें: `supabase/schema.sql` (पूरी कॉपी करें, Cmd+A → Cmd+C)।
3. SQL Editor में पेस्ट करें → **Run** (Cmd+Enter)। ~5–10 सेकंड में "Success. No rows returned" आएगा।
4. नया query खोलें (फिर **New query** दबाएँ) और `supabase/seed.sql` पेस्ट करके Run करें।
   (इससे Class 6–10, Board, Subject की बनावट बनती है — दोबारा चलाने पर कुछ नहीं बिगड़ता।)
5. तीसरा query खोलें और `supabase/storage.sql` पेस्ट करके Run करें। (PDF/notes अपलोड के लिए बकेट।)

कुल चार फ़ाइलें, इसी क्रम में: **schema.sql → seed.sql → storage.sql** और चला-हुआ project हो तो
**update_2026_10_26_all_classes.sql** (स्टेप 4क/4ख देखें)।

---

## स्टेप 4क — पहले से चला प्रोजेक्ट? बस यह एक फ़ाइल (एक बार)

आपका प्रोजेक्ट पहले से चालू है और schema.sql पुराने version पर है, तो **board_id** कॉलम कभी नहीं
बनेगा (schema.sql `create table if not exists` इस्तेमाल करता है — मौजूदा टेबल छूती ही नहीं)।
इसलिए एक बार यह चलाएँ:

1. Supabase dashboard → **SQL Editor** (⚡) → **New query**।
2. अपने कंप्यूटर से फ़ाइल खोलें: `supabase/update_2026_10_23_bihar_board.sql` (Cmd+A → Cmd+C)।
3. पेस्ट करें → **Run** (Cmd+Enter)। "Success. No rows returned" आना ठीक है।
4. जाँच के लिए फ़ाइल के आख़िर में दिए गए 4 `select` कमेंट खोलकर चलाएँ:
   - पहला → `board_id` की एक पंक्ति आनी चाहिए।
   - दूसरा → 4 boards: CBSE, ICSE, UP Board, **Bihar Board**।
   - तीसरा → `library` बकेट।
   - चौथा → publication में 9 tables (subjects/boards/chapters/school_classes शामिल)।

यह फ़ाइल दोबारा चलाने पर भी कुछ नहीं बिगड़ती, और आपकी मौजूदा 25 subjects में से कोई row बदलती नहीं।

> इसी फ़ाइल में वो statement भी है जो **नया Subject जोड़ने पर छात्रों के खुले ऐप तक तुरंत
> पहुँचाता है** (realtime publication)। यह न लगाने पर नया subject छात्र को सिर्फ़ ऐप दोबारा
> खोलने पर दिखेगा।

---

## स्टेप 4ख — "All Classes" + सिर्फ़ Title अपलोड (एक बार चलाएँ)

26 अक्तूबर 2026 के सुधारों (क्लास dropdown में **All Classes**, और अपलोड फॉर्म में सिर्फ़
**Title** अनिवार्य) के लिए यह एक फ़ाइल ज़रूरी है — कोड के बिना नहीं, बस इस SQL के बिना server
नई बातें स्वीकार नहीं करेगा।

1. Supabase dashboard → **SQL Editor** (⚡) → **New query**।
2. फ़ाइल खोलें: `supabase/update_2026_10_26_all_classes.sql` (Cmd+A → Cmd+C)।
3. पेस्ट करें → **Run** (Cmd+Enter)। "Success. No rows returned" आना ठीक है।
4. फ़ाइल तीन ही काम करती है, सब दोबारा चलाने सुरक्षित (idempotent):
   - `school_classes` में `class-all` row जोड़ती है (यह नहीं हुआ तो All Classes में subject बनाना
     server पर FK टकराकर reject होगा)।
   - `resources_has_file_or_link` check हटाती है (यह नहीं हटा तो बिना file/link सिर्फ़-title वाला
     resource save नहीं होगा)।
   - सभी 9 content tables को `supabase_realtime` publication में दोबारा डालती है (यह नहीं हुआ तो
     Publish दबाने पर छात्रों को content ऐप दोबारा खोलने तक नहीं दिखेगा)।
5. जाँच: फ़ाइल के आख़िर में दिए `select` कमेंट खोलकर चलाएँ — पहला `class-all` दिखाए, दूसरा
   publication की tables गिनती 9 बताए।

> `class-all` सिर्फ़ Admin panel dropdown में दिखता है; छात्रों की class list उसे कभी नहीं दिखाती,
> इसलिए कोई गलती से "All Classes" अपना class चुन नहीं सकता।

---

## स्टेप 5 — अपना Admin अकाउंट बनाएँ

1. Dashboard → बाईं ओर **Authentication** → **Users** → **Add user**.
2. भरें:
   - **Email** → अपना असली email (जो आप Admin पैनल में लॉगिन करने के लिए इस्तेमाल करेंगे)
   - **Password** → एक मज़बूत पासवर्ड (Notes में सेव करें)
   - **Auto Confirm User** ✅ टिक ज़रूर लगाएँ, वरना लॉगिन नहीं होगा।
3. **Create user** दबाएँ।
4. User लिस्ट में अभी बने user पर क्लिक करें → **UID** (जैसे `3f2a…-…`) दिखेगा → **Copy** करें।

---

## स्टेप 6 — उस UID को "admin" घोषित करें (सबसे ज़रूरी स्टेप)

RLS के बिना यह काम नहीं करेगा: Supabase API को यह बताना होगा कि आपकी UID वाला अकाउंट लिखने का
अधिकार रखता है।

1. SQL Editor → **New query**।
2. यह एक ही statement पेस्ट करें, और `अपनी-UID-यहाँ` की जगह चरण 5 की कॉपी की गई UID डालें:

   ```sql
   insert into public.admins (user_id)
   values ('अपनी-UID-यहाँ'::uuid)
   on conflict do nothing;
   ```

3. **Run** दबाएँ।
4. जाँच: नया query → `select * from public.admins;` → चलाएँ → आपकी एक पंक्ति दिखनी चाहिए।

> `public.admins` में सिर्फ़ Dashboard (या service_role) लिख सकता है — ऐप/API कभी नहीं। इसलिए
> कोई छात्र खुद को admin नहीं बना सकता। जब तक यह स्टेप न करें, कोई (आप भी) कंटेंट नहीं बदल सकता।

---

## स्टेप 7 — ऐप चलाकर जाँचें

Terminal में, प्रोजेक्ट फ़ोल्डर से अंदर:

```bash
cd /Users/sonukumar/Documents/Qoder/2026-10-20/c87ff882
flutter run -d chrome --dart-define-from-file=.env
```

1. ऐप खुलने के बाद **नीचे/साइड में "Class 6"** चुनें।
2. **Admin पैनल खोलने का तरीक़ा:** होम स्क्रीन के ऊपर बाएँ कोने के ब्रांड लोगो पर **तीन बार
   जल्दी-जल्दी** टैप करें (1.2 सेकंड के अंदर)।
3. "Admin sign in" डिअलॉग खोलेगा → स्टेप 5 का **email + password** डालें → **Sign in**।
4. Admin पैनल → **Lessons** → नया lesson:
   - Title, YouTube URL (जैसे `https://www.youtube.com/watch?v=abcd1234`) डालें।
   - **Publish** ✅ करके Save करें।
5. अब दूसरे टैब/डिवाइस पर ऐप खोलें: lesson अपने आप दिखेगा (कुछ सेकंड में — realtime + auto sync)।
   दोबारा rebuild कुछ नहीं करना।

**Android पर जाँच:** फ़ोन USB से जोड़ें → `flutter run --dart-define-from-file=.env`

---

## रोज़ का इस्तेमाल (आपके लिए)

| करना क्या है | कहाँ |
|---|---|
| नया Subject (जैसे Class 10 → Bihar Board → Science) | Admin → Subjects → **Class** और **Board** चुनें → ➕ icon → नाम + रंग → Save |
| YouTube वीडियो जोड़ना | Admin → Lessons → Add lesson (सिर्फ़ `youtube.com` / `youtu.be` URL स्वीकार) |
| PDF/नोट्स जोड़ना | Admin → Resources → **Choose a file** → फ़ाइल चुनें → Publish ✅ → Save |
| लाइव क्लास | Admin → Live classes → join link + समय |
| ऑनलाइन टेस्ट (MCQ) | Admin → Tests → Questions जोड़ें → **Publish** |
| Announcement | Admin → Announcements → Active ✅ |
| छात्र से छिपाना | उसी स्क्रीन पर Publish/Active बंद करके Save |

**PDF अपलोड कैसे चलता है:** फ़ाइल सुपabase के `library` बकेट में जाती है और उसका public URL
Resource row पर सेव होता है — इसलिए छात्रों को वो PDF हर डिवाइस पर दिखता है (ऐप update की ज़रूरत
नहीं)। Android फ़ोन पर उसी समय एक कॉपी ऐप के अपने folder में भी रहती है, जिससे वो PDF offline भी
खुलता है। Website पर browser कोई फ़ाइल अपने पास नहीं रख सकता, इसलिए वहाँ सिर्फ़ server कॉपी बनती है।

**Class 10 → Bihar Board → Science** पर वीडियो/PDF डालने का पूरा तरीक़ा:
1. Admin पैनल खोलें (लोगो पर तीन बार टैप) → email + password से sign in।
2. ऊपर **Class** में "Class 10", **Board** में "Bihar Board" चुनें।
3. ➕ दबाकर subject बनाएँ: English name `Science`, Hindi name `विज्ञान`, रंग चुनें → Save।
   (छात्रों को subject card पर "Bihar Board" की लेबल दिखेगी।)
4. अब वही subject चुनें → Lessons tab → ➕ → YouTube URL + title → Publish ✅ → Save।
5. Resources tab → ➕ → **Choose a file** से PDF चुनें → title → Publish ✅ → Save।
6. छात्र वाला डिवाइस/टैब खुला हो तो 1–2 सेकंड में नया content दिख जाएगा।

## अगर कुछ नहीं दिख रहा

- **"No backend is configured"** → `.env` में गलत/खाली मान। स्टेप 3 दोबारा देखें (https:// ज़रूरी है, और
  URL में पोर्ट `:8000` नहीं होना चाहिए)।
- **Sign in reject** ("Invalid login credentials") → Authentication → Users में **Auto Confirm User**
  चेक करें, या पासवर्ड दोबारा सेट करें।
- **Login हो गया पर Save नहीं होता / "permission denied"** → स्टेप 6 का `insert into public.admins`
  नहीं चला, या UID गलत है। जाँच query चलाएँ।
- **PDF अपलोड फेल** ("The file could not be stored on the server") → स्टेप 4 का `storage.sql` नहीं
  चला, यानी bucket `library` नहीं बना (या उसकी policy नहीं लगी)। Storage → Buckets में `library`
  दिखे तो policy दोबारा लगाएँ; न दिखे तो `storage.sql` + स्टेप 4क की फ़ाइल चलाएँ।
- **अपलोड में "Your admin session ended"** → Admin पैनल से Sign out करके दोबारा sign in करें।
- **नया Subject छात्र को तुरंत नहीं दिख रहा** → स्टेप 4क की फ़ाइल नहीं चली (realtime publication में
  `subjects` नहीं है)। फ़ाइल दोबारा चलाएँ — बस, कोई rebuild नहीं।
- **"All Classes" में Subject/Chapter save करते ही error** → स्टेप 4ख की
  `update_2026_10_26_all_classes.sql` नहीं चली, इसलिए `school_classes` में `class-all` row नहीं है
  और Postgres foreign key टकराता है। फ़ाइल चलाएँ, फिर Admin panel में Pull-to-refresh करके दोबारा
  save करें।
- **सिर्फ़ Title भरकर "Save file" पर मना** → वही 4ख फ़ाइल: उसका
  `resources_has_file_or_link` check server पर अभी मौजूद है।
- **Publish on करते ही student की खुली screen पर नहीं आया** → 4ख फ़ाइल का realtime वाला हिस्सा
  चलाएँ (9 tables publication में हों), और जाँचें कि student का ऐप offline badge पर अटा न हो।
- **पुराना content दिख रहा है** → Student ऐप में Pull-to-refresh (ऊपर से नीचे खींचें) या ऐप बंद-खोलें;
  sync अपने आप होता है, और पहली बार में थोड़े सेकंड लग सकते हैं।

## सुरक्षा — जो जानबूझकर ऐसा किया गया है

- Admin पैनल का ट्रिगर (तीन टैप) सिर्फ़ **दरवाज़ा छिपाता है**, ताला नहीं। असली ताला Supabase Auth
  + RLS है: आपकी session token के बिना हर write request डेटाबेस रद्द कर देता है।
- ऐप में कोई पासवर्ड/पिन हार्डकोड नहीं है। शुरू में जो local PIN फ़ाइल थी (`admin_pin.dart`) वह
  **पूरी तरह हटा दी गई है** — अब उसे ढूँढ़ने की ज़रूरत नहीं, project में कहीं नहीं है।
- `.env` सिर्फ़ build time पर `--dart-define-from-file` से अंदर जाता है; गिट में नहीं, ब्राउज़र के
  source में भी नहीं (anon key वैसे भी public है — RLS ही असली नियंत्रण है)।
- छात्रों का progress और bookmarks सिर्फ़ उनके अपने फ़ोन में रहते हैं: डेटाबेस की
  `students`, `lesson_progress`, `test_attempts` वगैरह टेबलों पर कोई policy नहीं है, इसलिए API
  से वहाँ कोई अंदर नहीं जा सकता।

---

## Play Store से पहले — hardening (2026-10-24 की audit)

यह हिस्सा **ज़रूरी** है। इसमें 3 चीज़ें हैं: 2 SQL लाइनें, 1 dashboard setting, और कोड में जो बदला
  गया वह।

### 1. `is_admin()` अब anon के लिए भी बंद होना चाहिए

Live probe (2026-10-24): `POST /rest/v1/rpc/is_admin` **anon key से 200 `false` लौटाया**।
Postgres नई function पर EXECUTE डिफ़ॉल्ट रूप से `PUBLIC` को दे देता है, और schema में revoke सिर्फ़
`anon` role पर था — `PUBLIC` anon को भी कवर करता है, इसलिए वह revoke अधूरा था। SQL Editor में चलाएँ:

```sql
revoke execute on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated, service_role;
```

### 2. Admin sign-in अब server से "हाँ" पूछता है (कोड में बदलाव)

पहले `isAdminSignedIn` का मतलब था "कोई भी Supabase session"। Supabase में sign-up चालू हो तो कोई भी
छात्र अपना अकाउंट बनाकर "Admin sign in" फ़ॉर्म में **अपना ही** email/password डालकर पूरा Admin panel
खोल सकता था (लिख न पाता, पर draft content देख लेता)। अब [supabase_content_gateway.dart](../lib/data/remote/supabase_content_gateway.dart)
sign-in के बाद server से `is_admin()` पूछता है; "no" पर session तुरंत.signOut हो जाता है और panel नहीं
खुलता। साथ ही **panel बंद होते ही sign-out** हो जाता है, इसलिए अगली बार फिर password पूछा जाएगा —
यह design है, bug नहीं।

इस बदलाव के बाद **अपनी जाँच ज़रूर करें**:

- Dashboard → **Authentication → Policies / Sign In / Up** → **Allow new users to sign in (sign-ups)**
  को **OFF** कर दें (Play Store वाले build के लिए)।
- एक बार खुद sign in होकर देखें — panel खुलना चाहिए।
- एक दूसरा Auth user बनाएँ, उसे `public.admins` में **न** डालें, और उससे sign in करके देखें:
  message आना चाहिए *"This account is not the admin of this school…"* और panel नहीं खुलना चाहिए।
  (फिर उस test user को delete कर दें।)

### 3. बिहार बोर्ड का board id मिलाएँ

Live (2026-10-24): `boards` में Bihar Board की id **`bihar_board`** (display_order 0) है, जबकि ऐप का
seed/`catalog_repository.dart` **`board-bihar`** (order 4) बनाता है, और **किसी भी subject का
`board_id` खाली** है (`subjects?board_id=not.is.null` → `[]`)। मतलब "Board = Bihar Board" फ़िल्टर
छात्र को खाली दिखेगा, भले lessons published हों। SQL Editor में:

```sql
-- server पर जो row है उसी id को रखना है, क्योंकि subjects/lessons उसी से जुड़ेंगे
select id, name_english, display_order from public.boards order by display_order;
```

फिर दो में से एक: (a) Admin panel में हर subject को सही Board से दोबारा जोड़ें, या (b) server की id
को ऐप के नाम पर लाएँ:

```sql
update public.boards set display_order = 4 where id = 'bihar_board';
-- subjects को board से जोड़ें (जो subject Bihar Board का है):
update public.subjects set board_id = 'bihar_board'
 where id in ('sub-class-10-mathematics' /* अपने ids यहाँ */);
```

### 4. बचे हुए checks

- `supabase/storage.sql` अभी भी नहीं चला — 2026-10-27 को फिर नापा: `GET /storage/v1/bucket/library`
  → **404** ⇒ PDF अपलोड असमर्थ (YouTube lessons के लिए ज़रूरी नहीं)। यह **इस project का आख़िरी बचा
  SQL कदम** है।
- स्टेप 4ख की `update_2026_10_26_all_classes.sql` **चुकी है** (2026-10-27 probe: `school_classes`
  में `class-all` मौजूद, और बिना-file वाली published `resources` row server पर टिकी है — पुराना
  `resources_has_file_or_link` check होता तो वह row save ही नहीं होती)। उसे दोबारा चलाने की ज़रूरत
  नहीं है।
- Realtime publication REST API से पढ़ी नहीं जा सकती, इसलिए "चली है या नहीं" code से साबित नहीं
  होता। जाँच: Admin panel में कोई lesson publish करें और दूसरे browser window (या Incognito) में
  खोला student ऐप 1-2 s में उसे दिखा दे — दिख जाए तो publication सही है।
- AI Tutor ("Hacker Ankit AI") 27-10-2026 को ऐप से हटा दिया गया है, इसलिए इस project में कोई
  Gemini key, `TUTOR_PROXY_URL` या `ai-tutor` Edge Function की ज़रूरत नहीं है — Supabase पर
  functions deploy करना launch से पहले का काम नहीं है।
