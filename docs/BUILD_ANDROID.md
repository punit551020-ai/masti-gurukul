# Masti Gurukul — Android (APK / AAB) और वेब बिल्ड

आपके MacBook Air M1 के लिए। दो हिस्से: **(A)** तुरंत टेस्ट करने योग्य फ़ाइल बनाना,
**(B)** Play Store में डालने योग्य फ़ाइल बनाना।

प्रोजेक्ट फ़ोल्डर (हर कमांड यहीं से चलाएँ):

```bash
cd /Users/sonukumar/Documents/Qoder/2026-10-20/c87ff882
```

---

## हिस्सा A — रिलीज़ APK (फ़ोन में डालकर जाँचने के लिए)

> 📦 **डिस्क स्पेस:** बिल्ड से पहले `df -h .` से जगह देख लें — कम से कम **10 GB खाली** चाहिए।
> पहली बार Android NDK download होता है (~2 GB), फिर Gradle cache और `build/` फ़ोल्डर ~3–4 GB
> लेते हैं। जगह कम हो तो: `flutter clean` (सिर्फ़ प्रोजेक्ट का `build/` हटता है, source नहीं)।
>
> नोट: इस मशीन पर 2026-10-20 को emulator के system images हटा दिए गए थे (8 GB जगह बचाने के लिए)।
> इससे APK/AAB बिल्ड पर असर नहीं पड़ता, पर emulator दोबारा चलाने के लिए Android Studio में
> Device Manager → उस device पर ⋮ → Edit → Download दिखाएगा।

1. जाँच कि सब ठीक है:

   ```bash
   flutter doctor
   ```

   `Android toolchain` और `Chrome` पर ✅ होना चाहिए।

2. Supabase से जुड़ा बिल्ड (आपकी `.env` फ़ाइल के साथ):

   ```bash
   flutter build apk --release --dart-define-from-file=.env
   ```

   बिना `.env` के भी बनेगा, पर तब Admin पैनल बंद रहेगा और कंटेंट सिर्फ़ इसी डिवाइस का दिखेगा:

   ```bash
   flutter build apk --release
   ```

3. फ़ाइल यहाँ मिलेगी:

   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

4. फ़ोन में डालना: फ़ोन से USB केबल जोड़ें → फ़ोन में **Developer options → USB debugging** ON →

   ```bash
   flutter install
   ```

---

## हिस्सा B — Play Store के लिए AAB (यह ध्यान से करना है)

Play Store **AAB** माँगता है और **अपनी upload key** से sign की गई फ़ाइल माँगता है।
अभी `flutter build appbundle` जो बनाता है वह **debug key** से sign है — वह Play Store पर
चलेगा नहीं। इसलिए पहले एक बार keystore बना लें।

### 1. Keystore एक बार बनाएँ (2 मिनट)

```bash
cd android
keytool -genkey -v -keystore masti-gurukul-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias masti_gurukul
cd ..
```

- पासवर्ड माँगेगा: **याद रखने वाला** डालें (Notes ऐप में सेव करें)।
- यह `.jks` फ़ाइल कभी गिट पर नहीं जाएगी और कभी किसी को नहीं देंगे।

### 2. `key.properties` बनाएँ

```bash
cp android/key.properties.example android/key.properties
open -e android/key.properties
```

चार मान भरें (storeFile का नाम वैसा ही रखें क्योंकि यह `android/` फ़ोल्डर के सापेक्ष है)।

### 3. AAB बनाएँ

```bash
flutter build appbundle --release --dart-define-from-file=.env
```

फ़ाइल: `build/app/outputs/bundle/release/app-release.aab`
(`build.gradle.kts` अपने आप `key.properties` देखकर इसी से sign करेगा; न हो तो debug sign करेगा।)

### 4. Play Console (इसमें पैसा लगता है — आपके कहने पर ही करेंगे)

- एक बार की फीस: **$25**। मैंने कुछ नहीं खरीदा। जब आप कहेंगे तब ही यह स्टेप शुरू करेंगे।
- वहाँ **Create app** → नाम `Masti Gurukul` → AAB अपलोड करें → Store listing भरें।
- **App Signing by Google** ON रखें; upload key वही `.jks` है जो हमने बनाई (Google उसे रोलिंग कर सकता है,
  इसलिए `.jks` का बैकअप अवश्य रखें)।

---

## वेब बिल्ड

```bash
flutter build web --release --dart-define-from-file=.env
```

फ़ाइलें: `build/web/` (किसी भी static होस्ट पर डाल दें — Netlify, Vercel, Cloudflare Pages)।

> वेब पर native PDF viewer नहीं चलता (वहाँ फ़ाइल browser के viewer/iframe में खुलती है) और YouTube
> वही embed है जो Android में है। कोई भी असली फ़ंक्शन छिपा नहीं गया है — जो बटन दिखता है वह काम करता है।

---

## ऐप में कौन-कौन से पर्मिशन हैं (AndroidManifest)

`android/app/src/main/AndroidManifest.xml` में सिर्फ़ यही एक है:

| पर्मिशन | क्यों |
|---|---|
| `INTERNET` | Supabase से कंटेंट खींचने और realtime sync के लिए |

माइक/कैमरा का कोई पर्मिशन नहीं है — "AI Tutor" 27-10-2026 को हटाने के बाद कोई feature उन्हें
माँगता ही नहीं (`RECORD_AUDIO` और camera `uses-feature` manifest से हटा दिए गए हैं)। बाहरी
स्टोरेज में कुछ नहीं लिखा जाता — downloads ऐप के अपने private फ़ोल्डर में सेव होते हैं, इसलिए
फ़ोन की अन्य फ़ाइलें सुरक्षित रहती हैं।

## अक्सर दिखने वाले एरर

- `No space left on device` → `flutter clean` चलाएँ, फिर browser/Downloads से जगह खाली करें।
- `Gradle download failed` → इंटरनेट कनेक्शन देखें; फिर दोबारा `flutter build` चलाएँ (आधी-अधूरी
  डाउनलोड `~/.gradle/wrapper/dists` में होती है)।
- `Signing config not found` → `android/key.properties` का पाथ गलत है; `storeFile` को `android/`
  फ़ोल्डर के सापेक्ष रखें।
- Play Store says "signed with debug key" → मतलब keystore कॉन्फ़िग नहीं पकड़ा: ऊपर का हिस्सा B दोबारा करें।
- `Release app bundle failed to strip debug symbols from native libraries` → यह Flutter का **जाँच
  वाला हिस्सा** है, बिल्ड का नहीं। यह तब दिखता है जब SDK में `build-tools` संस्करण Android Studio
  के `apkanalyzer` से मेल नहीं खाता (इस मशीन पर 36.0.0 है, tool 37.0.0 ढूँढ रहा है)।
  `.aab` फिर भी बनकर तैयार होती है और native libraries असल में stripped होती हैं — जाँच:
  `unzip -l build/app/outputs/bundle/release/app-release.aab | grep libflutter` से साइज़ ~12 MB
  दिखे तो stripped है (unstripped ~100 MB होता है)। फिर भी यह warning Play Store के लिए ठीक नहीं,
  इसलिए Android Studio → SDK Manager → SDK Tools → **Show Package Details** → Android SDK Build-Tools
  में `37.0.0` tick करके Install करें, और `flutter build appbundle --release` दोबारा चलाएँ।
