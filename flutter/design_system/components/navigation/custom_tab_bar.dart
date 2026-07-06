import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';

/// Professional tab bar with consistent sizing and smooth transitions
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({super.key, required this.tabs, required this.controller});

  final List<String> tabs;
  final TabController controller;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceM,
        vertical: AppSpacing.spaceS,
      ),
      decoration: BoxDecoration(
        color: context.colors.glassBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: context.colors.glassBorder, width: 1),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: false,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          color: context.colors.primary.withValues(alpha: 0.15),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: context.colors.primary,
        unselectedLabelColor: context.colors.textSecondary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
        labelPadding: EdgeInsets.zero,
        tabs: tabs
            .map(
              (tab) => Tab(
                height: 40,
                child: Center(child: Text(tab, textAlign: TextAlign.center)),
              ),
            )
            .toList(),
      ),
    );
  }
}
