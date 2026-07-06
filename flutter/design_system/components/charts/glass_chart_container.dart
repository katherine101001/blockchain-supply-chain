import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../glass/glass_container.dart';

/// Container for charts with glassmorphism styling
class GlassChartContainer extends StatelessWidget {
  const GlassChartContainer({
    super.key,
    required this.child,
    this.title,
    this.height,
    this.padding,
  });

  final Widget child;
  final String? title;
  final double? height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? const EdgeInsets.all(AppSpacing.spaceM);

    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: effectivePadding,
      // height: height,
      margin: EdgeInsets.zero, // Remove margin for charts
      child: height != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceM),
                ],
                Flexible(
                  child: SizedBox(
                    height:
                        (height! -
                                effectivePadding.top -
                                effectivePadding.bottom -
                                (title != null ? 50 : 0))
                            .clamp(0.0, double.infinity),
                    child: child,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceM),
                ],
                Expanded(child: child),
              ],
            ),
    );
  }
}
