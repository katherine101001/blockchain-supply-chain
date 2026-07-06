import 'package:flutter/material.dart';
import '../foundations/colors/app_palette.dart';
import '../foundations/typography.dart';
import 'app_colors_extension.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppPalette.blue500,
    scaffoldBackgroundColor: AppPalette.grey50,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppPalette.grey900),
    ),
    textTheme: AppTypography.textTheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    extensions: <ThemeExtension<dynamic>>[AppColorsExtension.light],
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppPalette.blue500,
    scaffoldBackgroundColor: AppPalette.grey900,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: AppTypography.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    extensions: <ThemeExtension<dynamic>>[AppColorsExtension.dark],
  );
}
