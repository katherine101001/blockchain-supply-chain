import 'package:flutter/material.dart';

/// Raw color palette. These are primitive values and should not be used directly in widgets.
/// Use [AppColorsExtension] via Theme.of(context) instead.
class AppPalette {
  // Brand Colors
  static const Color blue500 = Color(0xFF0A84FF); // Primary
  static const Color purple500 = Color(0xFF5E5CE6); // Secondary
  static const Color red500 = Color(0xFFFF3B30); // Danger
  static const Color orange500 = Color(0xFFFF9500); // Warning
  static const Color green500 = Color(0xFF34C759); // Success
  static const Color sky500 = Color(0xFF5AC8FA); // Info

  // Neutrals (Light)
  static const Color grey50 = Color(0xFFF8F8F8); // Background Light
  static const Color grey900 = Color(0xFF1E1E1E); // Text Primary Light
  static const Color grey600 = Color(0xFF6B6B6B); // Text Secondary Light

  // Neutrals (Dark) - Added for future use
  static const Color black900 = Color(0xFF000000);
  static const Color grey800 = Color(0xFF1C1C1E);
  static const Color grey100 = Color(0xFFF2F2F7);
}
