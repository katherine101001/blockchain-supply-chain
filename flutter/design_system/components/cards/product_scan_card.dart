import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/motion.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';
import '../glass/glass_container.dart';
import '../../../features/home/domain/entities/product_scan.dart';

class ProductScanCard extends StatelessWidget {
  final ProductScan scan;
  final VoidCallback? onTap;
  final double? width;

  const ProductScanCard({
    super.key,
    required this.scan,
    this.onTap,
    this.width,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(scan.scannedAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = scan.isVerified
        ? context.colors.success
        : context.colors.warning;

    return Animate(
      effects: [
        FadeEffect(duration: Motion.defaultDuration),
        SlideEffect(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
          duration: Motion.defaultDuration,
        ),
      ],
      child: GlassContainer(
        width: width ?? 260,
        padding: const EdgeInsets.all(AppSpacing.spaceM),
        margin: EdgeInsets.zero,
        borderRadius: AppSpacing.radiusM,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              color: Colors.transparent,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // shrink to content
                children: [
                  /// ───────── META (status + time)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.spaceXS),
                      Text(
                        scan.isVerified ? 'VERIFIED' : 'PENDING',
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                          color: statusColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          fontSize: 11,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceM),

                  /// ───────── PRIMARY CONTENT (icon + SKU)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusS,
                          ),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 24,
                          color: context.colors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.spaceM),
                      Expanded(
                        child: Text(
                          scan.sku,
                          style: AppTypography.textTheme.headlineMedium
                              ?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                                height: 1.05,
                                color: context.colors.textPrimary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceM),

                  /// ───────── CONTEXT (location + arrow)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.spaceXS),
                      Expanded(
                        child: Text(
                          scan.location ?? 'Unknown location',
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            height: 1.2,
                            color: context.colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
