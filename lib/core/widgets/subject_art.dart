import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The picture drawn on a subject card. Picked from the subject's own name so
/// an admin adding or renaming a subject never needs a code change.
enum SubjectGlyph { math, science, hindi, english, social, generic }

SubjectGlyph glyphForSubject({required String english, required String hindi}) {
  final n = '$english $hindi'.toLowerCase();
  bool has(List<String> words) => words.any(n.contains);
  // Social Science is checked first: its English name also contains "science".
  if (has([
    'social',
    'सामाजिक',
    'history',
    'geography',
    'civics',
    'economics',
  ])) {
    return SubjectGlyph.social;
  }
  if (has(['math', 'गणित', 'geometry', 'algebra'])) return SubjectGlyph.math;
  if (has(['science', 'विज्ञान', 'physics', 'chemistry', 'biology'])) {
    return SubjectGlyph.science;
  }
  if (has(['hindi', 'हिन्दी', 'हिंदी'])) return SubjectGlyph.hindi;
  if (has(['english', 'अंग्रेज़ी', 'अंग्रेजी', 'grammar', 'literature'])) {
    return SubjectGlyph.english;
  }
  return SubjectGlyph.generic;
}

/// A hand-drawn subject picture. Everything is vector so it stays crisp on
/// every screen density and matches the app's brand colour.
class SubjectArt extends StatelessWidget {
  const SubjectArt({
    super.key,
    required this.glyph,
    required this.ink,
    this.size = 34,
  });

  final SubjectGlyph glyph;
  final Color ink;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GlyphPainter(glyph: glyph, ink: ink),
    );
  }
}

/// A colourful, tappable subject tile used on Home and in the Classes tab.
///
/// The UI stays English, so [nameHindi] is only used to pick the picture.
/// [board] is the board name for a subject that belongs to one syllabus; a
/// shared subject passes null and shows no badge.
class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.nameEnglish,
    required this.nameHindi,
    required this.colorHex,
    required this.onTap,
    this.width,
    this.board,
  });

  final String nameEnglish;
  final String nameHindi;
  final String colorHex;
  final VoidCallback onTap;
  final double? width;
  final String? board;

  @override
  Widget build(BuildContext context) {
    final accent = colorFromHex(colorHex);
    final glyph = glyphForSubject(english: nameEnglish, hindi: nameHindi);
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.22),
                  accent.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(color: accent.withValues(alpha: 0.42)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.30)),
                  ),
                  child: Center(
                    child: SubjectArt(glyph: glyph, ink: accent, size: 30),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameEnglish,
                        // A board badge shares this row, so the name gives up
                        // its second line instead of overflowing the tile.
                        maxLines: board == null ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (board != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            board!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: accent.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  const _GlyphPainter({required this.glyph, required this.ink});

  final SubjectGlyph glyph;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    switch (glyph) {
      case SubjectGlyph.math:
        _paintMath(canvas, size);
      case SubjectGlyph.science:
        _paintScience(canvas, size);
      case SubjectGlyph.hindi:
        _paintLetter(canvas, size, 'अ', fontFamily: 'NotoSansDevanagari');
      case SubjectGlyph.english:
        _paintBlocks(canvas, size);
      case SubjectGlyph.social:
        _paintGlobe(canvas, size);
      case SubjectGlyph.generic:
        _paintBook(canvas, size);
    }
  }

  Paint _stroke(Size s, {double weight = 0.055}) => Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = s.width * weight
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  /// Compass and set square.
  void _paintMath(Canvas canvas, Size s) {
    final st = _stroke(s);
    final hinge = Offset(s.width * 0.42, s.height * 0.16);
    canvas.drawCircle(hinge, s.width * 0.075, Paint()..color = ink);
    canvas.drawLine(hinge, Offset(s.width * 0.20, s.height * 0.78), st);
    canvas.drawLine(hinge, Offset(s.width * 0.62, s.height * 0.78), st);
    canvas.drawArc(
      Rect.fromCircle(center: hinge, radius: s.width * 0.65),
      1.26,
      0.65,
      false,
      st,
    );

    final square = Path()
      ..moveTo(s.width * 0.64, s.height * 0.90)
      ..lineTo(s.width * 0.94, s.height * 0.90)
      ..lineTo(s.width * 0.94, s.height * 0.54)
      ..close();
    canvas.drawPath(square, st);
  }

  /// Conical flask with liquid and bubbles, plus one electron orbit.
  void _paintScience(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final body = Path()
      ..moveTo(w * 0.40, h * 0.14)
      ..lineTo(w * 0.40, h * 0.38)
      ..lineTo(w * 0.16, h * 0.80)
      ..quadraticBezierTo(w * 0.13, h * 0.90, w * 0.24, h * 0.90)
      ..lineTo(w * 0.76, h * 0.90)
      ..quadraticBezierTo(w * 0.87, h * 0.90, w * 0.84, h * 0.80)
      ..lineTo(w * 0.60, h * 0.38)
      ..lineTo(w * 0.60, h * 0.14);
    final liquid = Path()
      ..moveTo(w * 0.303, h * 0.55)
      ..lineTo(w * 0.697, h * 0.55)
      ..lineTo(w * 0.84, h * 0.80)
      ..quadraticBezierTo(w * 0.87, h * 0.90, w * 0.76, h * 0.90)
      ..lineTo(w * 0.24, h * 0.90)
      ..quadraticBezierTo(w * 0.13, h * 0.90, w * 0.16, h * 0.80)
      ..close();

    canvas.drawPath(liquid, Paint()..color = ink.withValues(alpha: 0.20));
    canvas.drawPath(body, _stroke(s, weight: 0.05));
    canvas.drawLine(
      Offset(w * 0.33, h * 0.14),
      Offset(w * 0.67, h * 0.14),
      _stroke(s, weight: 0.05),
    );
    final bubble = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03;
    canvas.drawCircle(Offset(w * 0.40, h * 0.70), w * 0.045, bubble);
    canvas.drawCircle(Offset(w * 0.55, h * 0.64), w * 0.030, bubble);
    canvas.drawCircle(Offset(w * 0.49, h * 0.80), w * 0.024, bubble);
  }

  /// Three alphabet blocks.
  void _paintBlocks(Canvas canvas, Size s) {
    const letters = ['A', 'B', 'C'];
    final box = s.width * 0.30;
    final offsets = [
      Offset(s.width * 0.06, s.height * 0.44),
      Offset(s.width * 0.35, s.height * 0.14),
      Offset(s.width * 0.64, s.height * 0.52),
    ];
    for (var i = 0; i < offsets.length; i++) {
      final rect = offsets[i] & Size.square(box);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(box * 0.22));
      canvas.drawRRect(rrect, Paint()..color = ink.withValues(alpha: 0.14));
      canvas.drawRRect(rrect, _stroke(s, weight: 0.04));
      _paintLetter(
        canvas,
        Size.square(box),
        letters[i],
        scale: 0.62,
        origin: rect.center - Offset(box * 0.5, box * 0.5),
      );
    }
  }

  /// Globe with meridians and latitude lines.
  void _paintGlobe(Canvas canvas, Size s) {
    final st = _stroke(s, weight: 0.05);
    final c = s.center(Offset.zero);
    final r = s.width * 0.38;
    canvas.drawCircle(c, r, st);
    canvas.drawOval(
      Rect.fromLTWH(c.dx - r * 0.42, c.dy - r, r * 0.84, r * 2),
      st,
    );
    canvas.drawLine(Offset(c.dx, c.dy - r), Offset(c.dx, c.dy + r), st);
    for (final t in const [-0.55, 0.55]) {
      final half = r * math.sqrt(1 - t * t);
      canvas.drawLine(
        Offset(c.dx - half, c.dy + r * t),
        Offset(c.dx + half, c.dy + r * t),
        st,
      );
    }
    canvas.drawLine(Offset(c.dx - r, c.dy), Offset(c.dx + r, c.dy), st);
  }

  /// Open book, used for any subject without its own picture.
  void _paintBook(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final st = _stroke(s, weight: 0.05);
    final left = Path()
      ..moveTo(w * 0.50, h * 0.28)
      ..cubicTo(w * 0.38, h * 0.17, w * 0.18, h * 0.18, w * 0.08, h * 0.23)
      ..lineTo(w * 0.08, h * 0.76)
      ..cubicTo(w * 0.20, h * 0.71, w * 0.39, h * 0.72, w * 0.50, h * 0.82);
    final right = Path()
      ..moveTo(w * 0.50, h * 0.28)
      ..cubicTo(w * 0.62, h * 0.17, w * 0.82, h * 0.18, w * 0.92, h * 0.23)
      ..lineTo(w * 0.92, h * 0.76)
      ..cubicTo(w * 0.80, h * 0.71, w * 0.61, h * 0.72, w * 0.50, h * 0.82);
    canvas.drawPath(left, st);
    canvas.drawPath(right, st);
    canvas.drawLine(Offset(w * 0.50, h * 0.28), Offset(w * 0.50, h * 0.82), st);
  }

  void _paintLetter(
    Canvas canvas,
    Size s,
    String text, {
    double scale = 0.74,
    Offset origin = Offset.zero,
    String? fontFamily,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: s.height * scale,
          height: 1.0,
          fontWeight: FontWeight.w800,
          color: ink,
          fontFamily: fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin +
          Offset(
            (s.width - painter.width) / 2,
            (s.height - painter.height) / 2,
          ),
    );
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.ink != ink;
}
