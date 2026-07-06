import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';
import '../glass/glass_container.dart';

/// Modern metric card with glassmorphism, icon, and optional trend indicator
class ModernMetricCard extends StatelessWidget {
  const ModernMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendColor,
    this.subtitle,
    this.unit,
    this.onTap,
    this.animate = true,
  });

  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? trend; // e.g., "+12%", "-5%"
  final Color? trendColor;
  final String? subtitle;
  final String? unit;
  final VoidCallback? onTap;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? context.colors.primary;
    final effectiveTrendColor = trendColor ?? context.colors.success;

    final card = GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceL),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.spaceS),
                      decoration: BoxDecoration(
                        color: effectiveIconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                      ),
                      child: Icon(icon, color: effectiveIconColor, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.spaceM),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (trend != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spaceS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: effectiveTrendColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                      ),
                      child: Text(
                        trend!,
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: effectiveTrendColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceM),
              Text(
                value,
                style: AppTypography.textTheme.headlineSmall?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _SubtitleOrUnit(subtitle: subtitle, unit: unit),
            ],
          ),
        ),
      ),
    );

    return animate
        ? card.animate().fadeIn(duration: 300.ms).slideY(begin: 0.1)
        : card;
  }
}

class _SubtitleOrUnit extends StatelessWidget {
  const _SubtitleOrUnit({this.subtitle, this.unit});
  final String? subtitle;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final text = subtitle ?? unit;
    if (text == null) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: AppSpacing.spaceXS),
        Text(
          text,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
