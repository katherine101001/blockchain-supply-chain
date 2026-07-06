import 'package:flutter/material.dart';
import '../foundations/colors/app_palette.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color danger;
  final Color warning;
  final Color success;
  final Color info;

  // Glassmorphism
  final Color glassBackground;
  final Color glassBorder;
  final Color glassBlur;
  final Color shadow;

  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.danger,
    required this.warning,
    required this.success,
    required this.info,
    required this.glassBackground,
    required this.glassBorder,
    required this.glassBlur,
    required this.shadow,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? danger,
    Color? warning,
    Color? success,
    Color? info,
    Color? glassBackground,
    Color? glassBorder,
    Color? glassBlur,
    Color? shadow,
  }) {
    return AppColorsExtension(
      primary: _or(primary, this.primary),
      secondary: _or(secondary, this.secondary),
      background: _or(background, this.background),
      textPrimary: _or(textPrimary, this.textPrimary),
      textSecondary: _or(textSecondary, this.textSecondary),
      danger: _or(danger, this.danger),
      warning: _or(warning, this.warning),
      success: _or(success, this.success),
      info: _or(info, this.info),
      glassBackground: _or(glassBackground, this.glassBackground),
      glassBorder: _or(glassBorder, this.glassBorder),
      glassBlur: _or(glassBlur, this.glassBlur),
      shadow: _or(shadow, this.shadow),
    );
  }

  static T _or<T>(T? value, T fallback) => value ?? fallback;

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassBlur: Color.lerp(glassBlur, other.glassBlur, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }

  // Define Light Theme Colors
  static final light = AppColorsExtension(
    primary: AppPalette.blue500,
    secondary: AppPalette.purple500,
    background: AppPalette.grey50,
    textPrimary: AppPalette.grey900,
    textSecondary: AppPalette.grey600,
    danger: AppPalette.red500,
    warning: AppPalette.orange500,
    success: AppPalette.green500,
    info: AppPalette.sky500,
    glassBackground: Colors.white.withValues(alpha: 0.2),
    glassBorder: Colors.white.withValues(alpha: 0.15),
    glassBlur: Colors.white.withValues(alpha: 0.08),
    shadow: Colors.black.withValues(alpha: 0.05),
  );

  // Define Dark Theme Colors
  static final dark = AppColorsExtension(
    primary: const Color.fromARGB(255, 78, 199, 255),
    secondary: AppPalette.purple500,
    background: AppPalette.grey900,
    textPrimary: Colors.white,
    textSecondary:
        AppPalette.grey100, // Lighter grey for better contrast in dark mode
    danger: AppPalette.red500,
    warning: AppPalette.orange500,
    success: AppPalette.green500,
    info: AppPalette.sky500,
    glassBackground: Colors.white.withValues(
      alpha: 0.08,
    ), // More visible glass effect
    glassBorder: Colors.white.withValues(alpha: 0.15),
    glassBlur: Colors.black.withValues(alpha: 0.2),
    shadow: Colors.black.withValues(alpha: 0.4),
  );
}
