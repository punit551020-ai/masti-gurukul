import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/core/widgets/subject_art.dart';

void main() {
  group('glyphForSubject', () {
    // "Social Science" contains the word "science", so it used to get the flask.
    test('Social Science wins over the science keyword', () {
      expect(
        glyphForSubject(english: 'Social Science', hindi: 'सामाजिक विज्ञान'),
        SubjectGlyph.social,
      );
    });

    test('each seeded subject gets its own picture', () {
      const seeded = {
        'Mathematics': SubjectGlyph.math,
        'Science': SubjectGlyph.science,
        'Hindi': SubjectGlyph.hindi,
        'English': SubjectGlyph.english,
        'Social Science': SubjectGlyph.social,
      };
      for (final entry in seeded.entries) {
        expect(
          glyphForSubject(english: entry.key, hindi: ''),
          entry.value,
          reason: entry.key,
        );
      }
    });

    test('Hindi names work even without an English name', () {
      expect(glyphForSubject(english: '', hindi: 'गणित'), SubjectGlyph.math);
      expect(
        glyphForSubject(english: '', hindi: 'अंग्रेज़ी'),
        SubjectGlyph.english,
      );
    });

    test('unknown subjects fall back to the book', () {
      expect(
        glyphForSubject(english: 'Yoga', hindi: 'योग'),
        SubjectGlyph.generic,
      );
    });
  });
}
