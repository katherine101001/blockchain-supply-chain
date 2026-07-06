import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/utils/context_extensions.dart';

class SkeletonWrapper extends StatelessWidget {
  final Widget skeleton;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const SkeletonWrapper({
    super.key,
    required this.skeleton,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height ?? 0,
          maxHeight: height ?? double.infinity,
        ),
        child: Skeletonizer(
          enabled: true,
          effect: ShimmerEffect(
            baseColor: context.colors.glassBackground.withAlpha(51),
            highlightColor: context.colors.glassBackground.withAlpha(26),
            duration: const Duration(milliseconds: 1800),
          ),
          child: skeleton,
        ),
      ),
    );
  }
}
