import 'package:flutter/material.dart';
import '../../core/utils/context_extensions.dart';
import '../../design_system/foundations/typography.dart';
import '../../design_system/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if we are currently in dark mode to show the correct icon
    final themeMode = context.watch<ThemeCubit>().state;
    final isDarkMode = themeMode == ThemeMode.dark;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 16,
      title: Text(
        'TRASE',
        style: AppTypography.textTheme.headlineMedium?.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        IconButton(
          // Dark mode shows Sun (to switch to light), Light mode shows Moon (to switch to dark)
          icon: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
        ),
        const SizedBox(width: 8), // Brief padding for the edge
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
