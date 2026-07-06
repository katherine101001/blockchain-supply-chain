import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../../../design_system/components/loading/skeleton_wrapper.dart';
import '../../../../design_system/components/loading/skeleton_card.dart';
import '../../domain/entities/product_scan.dart';

class QuickActionsCard extends StatelessWidget {
  final VoidCallback onScan;
  final VoidCallback onHistory;
  final VoidCallback onSearch;
  final List<ProductScan>? recentScans;
  final bool isLoading;

  const QuickActionsCard({
    super.key,
    required this.onScan,
    required this.onHistory,
    required this.onSearch,
    this.recentScans,
    this.isLoading = false,
  });

  bool get hasRecentScans => recentScans != null && recentScans!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 140,
        child: SkeletonWrapper(skeleton: SkeletonCard()),
      );
    }

    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceM),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan',
                  color: context.colors.primary,
                  onTap: onScan,
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: _ActionButton(
                  icon: Icons.search,
                  label: 'Search',
                  color: context.colors.info,
                  onTap: onSearch,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: _ActionButton(
                  icon: Icons.history,
                  label: 'History',
                  color: hasRecentScans
                      ? context.colors.success
                      : context.colors.textSecondary,
                  onTap: onHistory,
                  badge: hasRecentScans ? recentScans!.length.toString() : null,
                ),
              ),
            ],
          ),
          if (hasRecentScans) ...[
            const SizedBox(height: AppSpacing.spaceM),
            Container(
              padding: const EdgeInsets.all(AppSpacing.spaceS),
              decoration: BoxDecoration(
                color: context.colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 16,
                    color: context.colors.success,
                  ),
                  const SizedBox(width: AppSpacing.spaceS),
                  Expanded(
                    child: Text(
                      '${recentScans!.length} recent scans available',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: context.colors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;
  final String? badge;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spaceM,
                horizontal: AppSpacing.spaceS,
              ),
              decoration: BoxDecoration(
                color: isPrimary
                    ? color.withValues(alpha: 0.1)
                    : color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: isPrimary
                    ? Border.all(color: color.withValues(alpha: 0.3))
                    : null,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 24, color: color),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTypography.textTheme.bodyLarge?.copyWith(
                          color: color,
                          fontWeight: isPrimary
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (badge != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge!,
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
        .animate(target: isPrimary ? 1 : 0)
        .scaleXY(
          begin: 1.0,
          end: isPrimary ? 1.05 : 1.0,
          duration: 200.ms,
          curve: Curves.easeInOut,
        );
  }
}
