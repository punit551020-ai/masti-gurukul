import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/core/utils/youtube_url.dart';
import 'package:masti_gurukul/features/welcome/welcome_screen.dart';

void main() {
  group('validateStudentName', () {
    test('खाली नाम अस्वीकार', () {
      expect(validateStudentName('   '), isNotNull);
    });

    test('1 अक्षर का नाम अस्वीकार', () {
      expect(validateStudentName('A'), isNotNull);
    });

    test('हिंदी और अंग्रेज़ी दोनों नाम स्वीकार', () {
      expect(validateStudentName('राहुल कुमार'), isNull);
      expect(validateStudentName('Rahul Kumar'), isNull);
      expect(validateStudentName("Sha'shank O'Brien"), isNull);
    });

    test('41 अक्षर से ज़्यादा अस्वीकार', () {
      expect(validateStudentName('a' * 41), isNotNull);
    });

    test('संख्या और चिह्न अस्वीकार', () {
      expect(validateStudentName('Rahul123'), isNotNull);
      expect(validateStudentName('<script>'), isNotNull);
    });
  });

  group('YouTubeUrl.parseId', () {
    test('watch URL से id', () {
      expect(
        YouTubeUrl.parseId('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        'dQw4w9WgXcQ',
      );
    });

    test('youtu.be शॉर्ट लिंक', () {
      expect(YouTubeUrl.parseId('https://youtu.be/dQw4w9WgXcQ'), 'dQw4w9WgXcQ');
    });

    test('embed और shorts', () {
      expect(
        YouTubeUrl.parseId('https://www.youtube.com/embed/dQw4w9WgXcQ'),
        'dQw4w9WgXcQ',
      );
      expect(
        YouTubeUrl.parseId('https://www.youtube.com/shorts/dQw4w9WgXcQ'),
        'dQw4w9WgXcQ',
      );
    });

    test('playlist-only लिंक अस्वीकार', () {
      expect(
        YouTubeUrl.parseId('https://www.youtube.com/watch?list=PL123'),
        isNull,
      );
    });

    test('बदनाम/नकली डोमेन अस्वीकार', () {
      expect(
        YouTubeUrl.parseId('https://yout-ube.com/watch?v=dQw4w9WgXcQ'),
        isNull,
      );
      expect(YouTubeUrl.parseId('https://evil.example/v/dQw4w9WgXcQ'), isNull);
      expect(YouTubeUrl.parseId('not a url'), isNull);
    });

    test('गलत लंबाई का id अस्वीकार', () {
      expect(YouTubeUrl.parseId('https://youtu.be/short'), isNull);
    });
  });
}
