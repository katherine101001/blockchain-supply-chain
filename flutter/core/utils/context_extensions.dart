import 'package:flutter/material.dart';
import '../../design_system/theme/app_colors_extension.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  AppColorsExtension get colors => theme.extension<AppColorsExtension>()!;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
