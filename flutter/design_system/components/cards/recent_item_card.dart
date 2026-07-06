import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/motion.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';
import '../glass/glass_container.dart';

class RecentItemCard extends StatelessWidget {
  final String sku;
  final VoidCallback? onTap;

  const RecentItemCard({super.key, required this.sku, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: Motion.defaultDuration),
        SlideEffect(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
          duration: Motion.defaultDuration,
        ),
      ],
      child: GlassContainer(
        width: 220,
        borderRadius: AppSpacing.radiusM,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.spaceM, // comfortable vertical padding
          horizontal: AppSpacing.spaceM, // standard horizontal padding
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            child: Column(
              mainAxisSize: MainAxisSize.min, // let column wrap content
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // balanced spacing
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2,
                  color: context.colors.primary,
                  size: 32, // slightly bigger for visual hierarchy
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spaceS,
                    ),
                    child: Text(
                      sku,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.colors.primary,
                  size: 24, // slightly bigger for balance
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
