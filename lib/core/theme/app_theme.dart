import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const saffron = Color(0xFFF1951A);
  static const saffronBright = Color(0xFFFF9000);
  static const navy = Color(0xFF091B71);
  static const navyDeep = Color(0xFF050F45);
  static const red = Color(0xFFB20308);
  static const green = Color(0xFF1B7A3D);
  static const cream = Color(0xFFFFF8EE);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const textLight = Color(0xFF1A1C22);
  static const textOnDark = Color(0xFFF3F5FF);
}

/// Reads the `accentColor` column, which is stored as a bare RGB hex string.
Color colorFromHex(String hex) {
  final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16) ?? 0xF1951A;
  return Color(0xFF000000 | value);
}

class AppTypography {
  const AppTypography._();

  static const devanagariFallback = <String>['NotoSansDevanagari'];
}

ThemeData buildLightTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.navy,
    brightness: Brightness.light,
    primary: AppColors.navy,
    secondary: AppColors.saffron,
    surface: AppColors.surfaceLight,
  );
  return _base(scheme).copyWith(scaffoldBackgroundColor: AppColors.cream);
}

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.saffron,
    brightness: Brightness.dark,
    primary: AppColors.saffronBright,
    secondary: AppColors.navy,
  );
  return _base(scheme)
      .copyWith(scaffoldBackgroundColor: const Color(0xFF0B1020));
}

ThemeData _base(ColorScheme scheme) {
  final isDark = scheme.brightness == Brightness.dark;
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamilyFallback: AppTypography.devanagariFallback,
      bodyColor: isDark ? AppColors.textOnDark : AppColors.textLight,
      displayColor: isDark ? AppColors.textOnDark : AppColors.textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamilyFallback: AppTypography.devanagariFallback,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamilyFallback: AppTypography.devanagariFallback,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 66,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamilyFallback: AppTypography.devanagariFallback,
        ),
      ),
    ),
  );
}
