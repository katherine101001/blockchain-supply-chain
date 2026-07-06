import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';

/// Mini bar chart for quick visualizations
class MiniBarChart extends StatelessWidget {
  const MiniBarChart({
    super.key,
    required this.values,
    this.max,
    this.height = 60,
    this.barWidth = 8,
    this.spacing = 4,
    this.color,
    this.backgroundColor,
  });

  final List<double> values;
  final double? max;
  final double height;
  final double barWidth;
  final double spacing;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final maxValue = max ?? values.reduce((a, b) => a > b ? a : b);
    final chartColor = color ?? context.colors.primary;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: values.asMap().entries.map((entry) {
          final value = entry.value;
          final barHeight = maxValue > 0 ? (value / maxValue) * height : 0.0;
          return Container(
            margin: EdgeInsets.only(right: entry.key < values.length - 1 ? spacing : 0),
            width: barWidth,
            height: barHeight.clamp(4.0, height),
            decoration: BoxDecoration(
              color: chartColor,
              borderRadius: BorderRadius.circular(barWidth / 2),
            ),
          );
        }).toList(),
      ),
    );
  }
}

