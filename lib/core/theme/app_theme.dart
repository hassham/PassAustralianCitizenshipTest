import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF0D47A1);
  static const secondary = Color(0xFF0091EA);
  static const success = Color(0xFF2E7D32);
  static const accent = Color(0xFFFF8F00);
  static const error = Color(0xFFE53935);
  static const surface = Color(0xFFF5F7FA);
  static const ink = Color(0xFF0A2458);
  static const mutedInk = Color(0xFF60759B);
  static const outline = Color(0xFFD8E2F0);
  static const darkSurface = Color(0xFF07111F);
  static const darkCard = Color(0xFF0D1D2D);
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? const Color(0xFF7EB6FF) : AppColors.primary,
      onPrimary: isDark ? const Color(0xFF002D68) : Colors.white,
      primaryContainer: isDark
          ? const Color(0xFF123A68)
          : const Color(0xFFDCEAFF),
      onPrimaryContainer: isDark
          ? const Color(0xFFD6E7FF)
          : AppColors.ink,
      secondary: isDark ? const Color(0xFF62C3FF) : AppColors.secondary,
      secondaryContainer: isDark
          ? const Color(0xFF073F61)
          : const Color(0xFFDDF3FF),
      onSecondaryContainer: isDark
          ? const Color(0xFFD2EEFF)
          : const Color(0xFF00344F),
      tertiary: isDark ? const Color(0xFFFFB74D) : AppColors.accent,
      tertiaryContainer: isDark
          ? const Color(0xFF553100)
          : const Color(0xFFFFE9C4),
      error: isDark ? const Color(0xFFFF8A86) : AppColors.error,
      errorContainer: isDark
          ? const Color(0xFF5D1A1A)
          : const Color(0xFFFFE1DF),
      surface: isDark ? AppColors.darkSurface : AppColors.surface,
      onSurface: isDark ? const Color(0xFFF0F5FC) : AppColors.ink,
      surfaceContainerLow: isDark
          ? AppColors.darkCard
          : Colors.white,
      surfaceContainer: isDark
          ? const Color(0xFF112537)
          : const Color(0xFFEEF3F9),
      outline: isDark ? const Color(0xFF40546D) : AppColors.outline,
      outlineVariant: isDark
          ? const Color(0xFF293C51)
          : const Color(0xFFE6EDF6),
    );

    final baseTextTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
    ).textTheme;
    final textTheme = baseTextTheme.copyWith(
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.45),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: isDark ? const Color(0xFFB5C5D8) : AppColors.mutedInk,
        height: 1.4,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: scheme.outlineVariant,
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.45),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: isDark
              ? const Color(0xFF9BC7FF)
              : AppColors.primary,
          side: BorderSide(color: scheme.primary),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark
              ? const Color(0xFF9BC7FF)
              : AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        indicatorColor: isDark
            ? const Color(0xFF164C84)
            : const Color(0xFFD9EAFF),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : isDark
                ? const Color(0xFF9AAFC4)
                : AppColors.mutedInk,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : isDark
                ? const Color(0xFF9AAFC4)
                : AppColors.mutedInk,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.success : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.success : null,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.secondary,
        linearTrackColor: Color(0xFFDDE8F4),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? const Color(0xFF17314A)
            : AppColors.ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      focusColor: scheme.primary.withValues(alpha: 0.22),
    );
  }

  static ThemeData get highContrast => _build(
    Brightness.light,
  ).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF003478),
      contrastLevel: 1,
    ),
  );
}
