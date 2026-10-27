import 'dart:math' show cos, min, pi, sin;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/branding/brand_config.dart';
import '../../core/theme/app_theme.dart';
import '../../state/app_state.dart';
import '../admin/hidden_trigger.dart';

String? validateStudentName(String? raw) {
  final name = (raw ?? '').trim();
  if (name.isEmpty) return 'Please enter your name';
  if (name.length < 2) return 'Name must be at least 2 characters';
  if (name.length > 40) return 'Name must be 40 characters or fewer';
  final allowed = RegExp(r"^[\p{L}\p{M}\s.'\-]+$", unicode: true);
  if (!allowed.hasMatch(name)) {
    return 'Use only letters, spaces, and . \' -';
  }
  return null;
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await context.read<AppState>().startStudent(
        name: _nameController.text.trim(),
      );
    } on Object {
      // The profile write is the first thing this app does with the device's
      // storage. If it fails — disk full, browser storage cleared mid-write —
      // the student must be able to try again instead of staring at a greyed-out
      // button that never re-arms.
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error =
            'Your profile could not be saved on this device. Check the '
            'storage is free, then press the button again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9CCFEE),
              Color(0xFFC8E4F6),
              AppColors.cream,
              AppColors.cream,
            ],
            stops: [0, 0.30, 0.58, 1],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewport) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _BrandBadge(),
                              const SizedBox(height: 14),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Masti ',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'Gurukul',
                                      style: TextStyle(
                                        color: AppColors.saffron,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                BrandConfig.taglineHindi,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 26),
                              TextFormField(
                                controller: _nameController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: BrandConfig.namePlaceholder,
                                  prefixIcon: const Icon(
                                    Icons.person_outline_rounded,
                                    color: AppColors.navy,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                ),
                                validator: validateStudentName,
                                onFieldSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  BrandConfig.nameExample,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFFB3261E),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: _saving ? null : _submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.navy,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: _saving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: AppColors.saffronBright,
                                      ),
                                iconAlignment: IconAlignment.end,
                                label: Text(
                                  _saving
                                      ? 'Starting…'
                                      : BrandConfig.startButton,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Text(
                                BrandConfig.welcomeHint,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const _DividerStar(),
                              const SizedBox(height: 16),
                              Text(
                                'A name is not an identity check. Progress stays on '
                                'this device; accounts come with the backend.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const _BrandFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 236,
        height: 236,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _SunburstPainter()),
            ),
            SizedBox(
              width: 168,
              height: 168,
              child: HiddenAdminTrigger(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withValues(alpha: 0.18),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          BrandConfig.logoFullAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.school_rounded,
                            size: 80,
                            color: AppColors.navy,
                          ),
                        ),
                        // The owner asked that the badge not carry the
                        // "MISSION 2027" line, so that band is covered with a
                        // flourish instead. The logo file itself is unchanged.
                        const CustomPaint(painter: _MissionBandCover()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Covers the "MISSION 2027" lockup of the badge with a clean flourish.
///
/// The circle, the text band and the ring clearance were measured off
/// `assets/brand/logo_full.jpeg`, so the cover follows the badge's own arc and
/// never touches the outer ring, the CLASS 10 banner or the logo file itself.
class _MissionBandCover extends CustomPainter {
  const _MissionBandCover();

  /// Centre and radii of the badge interior, in artwork fractions.
  static const _cx = 0.5023;
  static const _cy = 0.4949;
  static const _rx = 0.4598;
  static const _ry = 0.4748;

  /// First row that carries the MISSION text.
  static const _top = 0.7551;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * _cx, size.height * _cy);
    final bottom = center.dy + size.height * _ry;
    final top = size.height * _top;

    canvas.clipPath(
      Path()..addOval(
        Rect.fromCenter(
          center: center,
          width: size.width * _rx * 2,
          height: size.height * _ry * 2,
        ),
      ),
    );
    canvas.drawRect(
      Rect.fromLTRB(0, top, size.width, bottom),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFEFEFE), Color(0xFFFAF5EC)],
        ).createShader(Rect.fromLTRB(0, top, size.width, bottom)),
    );

    final cy = top + (bottom - top) * 0.55;
    final star = size.width * 0.030;
    final rule = Paint()
      ..color = AppColors.saffron
      ..strokeWidth = size.width * 0.007
      ..strokeCap = StrokeCap.round;
    final leftEnd = center.dx - star * 6.2;
    final rightEnd = center.dx + star * 6.2;
    canvas.drawLine(
      Offset(leftEnd, cy),
      Offset(center.dx - star * 2.4, cy),
      rule,
    );
    canvas.drawLine(
      Offset(center.dx + star * 2.4, cy),
      Offset(rightEnd, cy),
      rule,
    );
    canvas.drawPath(
      _star(center.dx, cy, star * 0.45, star),
      Paint()..color = AppColors.navy,
    );
    canvas.drawPath(
      _star(leftEnd, cy, star * 0.3, star * 0.62),
      Paint()..color = AppColors.saffronBright,
    );
    canvas.drawPath(
      _star(rightEnd, cy, star * 0.3, star * 0.62),
      Paint()..color = AppColors.saffronBright,
    );
  }

  static Path _star(double cx, double cy, double inner, double outer) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? outer : inner;
      final angle = -pi / 2 + i * pi / 5;
      final point = Offset(cx + radius * cos(angle), cy + radius * sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SunburstPainter extends CustomPainter {
  const _SunburstPainter();

  static const _rays = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final shader = const RadialGradient(
      colors: [Color(0xCCFFFFFF), Color(0x00FFFFFF)],
      stops: [0.30, 1],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    for (var i = 0; i < _rays; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * (2 * pi / _rays),
        pi / _rays,
        true,
        Paint()..shader = shader,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DividerStar extends StatelessWidget {
  const _DividerStar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.saffron, thickness: 1.4),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.star_rounded, color: AppColors.navy, size: 18),
        ),
        const Expanded(
          child: Divider(color: AppColors.saffron, thickness: 1.4),
        ),
      ],
    );
  }
}

/// The campus artwork that closes the bottom of the screen.
///
/// This is the only thing drawn here: no vector scene behind it and no
/// translucent layer over it, so the file shows exactly as it is, at full
/// strength. It is the last item in the scrolling column rather than an
/// overlay, so it begins right below the divider and nothing can ever cover
/// the towers or the students. A window too short for the art's own ratio gets
/// a narrower, centred band instead of a cropped one. If the file is missing
/// the band stays empty instead of inventing a picture.
class _BrandFooter extends StatelessWidget {
  const _BrandFooter();

  /// Measured off `assets/brand/welcome_campus.png` (755 x 419).
  static const _artAspect = 755 / 419;

  /// The most of the screen the band may take. Shrinking past this keeps the
  /// whole picture by trading width, which is what a short window needs.
  static const _maxScreenShare = 0.6;

  static double heightFor(double width, double screenHeight) =>
      min(width / _artAspect, screenHeight * _maxScreenShare);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = heightFor(size.width, size.height);
    return SizedBox(
      width: size.width,
      height: height,
      child: Center(
        child: Image.asset(
          'assets/brand/welcome_campus.png',
          width: height * _artAspect,
          height: height,
          fit: BoxFit.fill,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
