import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import 'glass_container.dart';

class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Add bottom padding to avoid the system navigation bar (home indicator)
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.spaceM,
        right: AppSpacing.spaceM,
        bottom: AppSpacing.spaceM + bottomPadding,
      ),
      child: GlassContainer(
        // We use the adaptive GlassContainer we just fixed
        borderRadius: AppSpacing.radiusM,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.spaceS,
          horizontal: AppSpacing.spaceS, // Reduced slightly for better spacing
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                // Secret Sauce: A very subtle highlight for the selected tab
                color: isSelected
                    ? context.colors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              ),
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spaceS,
                    horizontal: AppSpacing.spaceM,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon animation or scale can go here
                      IconTheme(
                        data: IconThemeData(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.textSecondary,
                          size: 24,
                        ),
                        child: isSelected ? item.activeIcon : item.icon,
                      ),
                      const SizedBox(height: 4),
                      if (item.label != null)
                        Text(
                          item.label!,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 10, // Slightly smaller for nav bars
                            color: isSelected
                                ? context.colors.primary
                                : context.colors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
