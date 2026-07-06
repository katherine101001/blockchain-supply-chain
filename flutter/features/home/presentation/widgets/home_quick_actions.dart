import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/foundations/motion.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';

class HomeQuickActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onSearch;
  final VoidCallback? onHistory;

  const HomeQuickActions({
    super.key,
    this.isLoading = false,
    this.onSearch,
    this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceXS),
          child: Text(
            'Quick Actions',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceM),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.search_rounded,
                // iconColor: context.colors.primary,
                label: 'Search',
                onTap: onSearch ?? () {},
              ),
            ),
            const SizedBox(width: AppSpacing.spaceM),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.history_rounded,
                // iconColor: context.colors.warning,
                label: 'History',
                onTap: onHistory ?? () => context.push('/history'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    // Adaptive glass background
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.15);

    final borderColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.05);

    // Adaptive icon color: lighter in dark, darker in light
    final iconColor = isDark ? Colors.white.withOpacity(0.85) : colors.primary;

    return Animate(
      effects: [
        FadeEffect(duration: Motion.defaultDuration),
        ScaleEffect(duration: Motion.defaultDuration, curve: Curves.easeOut),
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          splashColor: iconColor.withOpacity(0.2),
          highlightColor: iconColor.withOpacity(0.1),
          child: Container(
            height: 56, // smaller and tidy
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              color: background,
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 26),
                const SizedBox(width: AppSpacing.spaceS),
                Text(
                  label,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
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
