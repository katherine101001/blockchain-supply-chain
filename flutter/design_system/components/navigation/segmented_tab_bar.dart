import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';

/// Modern segmented control style tab bar
class SegmentedTabBar extends StatelessWidget implements PreferredSizeWidget {
  const SegmentedTabBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<String> tabs;
  final TabController controller;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 0, // align flush to the left edge
        right: AppSpacing.spaceM,
        top: AppSpacing.spaceS,
        bottom: AppSpacing.spaceS,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.glassBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: context.colors.glassBorder, width: 1),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          color: context.colors.primary,
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: context.colors.textSecondary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
        labelPadding: EdgeInsets.zero,
        tabs: tabs
            .map(
              (tab) => Tab(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceM,
                  ),
                  child: Center(
                    child: Text(tab.toUpperCase(), textAlign: TextAlign.center),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
