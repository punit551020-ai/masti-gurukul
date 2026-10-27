import 'package:flutter/material.dart';

import '../branding/brand_config.dart';
import '../theme/app_theme.dart';

/// Brand artwork that degrades quietly: if the asset is missing or fails to
/// decode (for example a build that predates the asset), a plain icon is shown
/// instead of the framework's red error box.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.height, this.fullBadge = false});

  final double height;
  final bool fullBadge;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      fullBadge ? BrandConfig.logoFullAsset : BrandConfig.logoEmblemAsset,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          Icon(Icons.school_rounded, size: height, color: AppColors.navy),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null && !wasSynchronouslyLoaded) {
          return SizedBox(height: height);
        }
        return child;
      },
    );
  }
}
