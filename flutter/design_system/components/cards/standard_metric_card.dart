import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../glass/glass_container.dart';

class StandardMetricCard extends StatelessWidget {
  const StandardMetricCard({
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
    this.height = 110,
    this.valueFontSize = 28,
    this.animate = true,
  });

  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final Color? trendColor;
  final String? subtitle;
  final String? unit;
  final VoidCallback? onTap;
  final double height;
  final double valueFontSize;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final themeColor = iconColor ?? context.colors.primary;

    final card = GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceM),
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Row(
            children: [
              // --- ICON DESIGN: GLOWING ORB ---
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow / Shadow
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // Inner Gradient Disk
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          themeColor.withValues(alpha: 0.25),
                          themeColor.withValues(alpha: 0.05),
                        ],
                      ),
                      border: Border.all(
                        color: themeColor.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, color: themeColor, size: 24),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // --- DATA DESIGN: CLEAN TYPOGRAPHY ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title.toUpperCase(),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: context.colors.textSecondary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            value,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: valueFontSize,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                              height: 1.1,
                            ),
                          ),
                          if (unit != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              unit!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trend != null || subtitle != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (trend != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (trendColor ?? context.colors.success)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                trend!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: trendColor ?? context.colors.success,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (subtitle != null)
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  subtitle!,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: context.colors.textSecondary
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return animate
        ? card.animate().fadeIn(duration: 400.ms).slideX(begin: 0.05)
        : card;
  }
}
