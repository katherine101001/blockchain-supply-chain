import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/typography.dart';

/// Modern circular gauge/progress ring
class CircularGauge extends StatelessWidget {
  const CircularGauge({
    super.key,
    required this.value,
    required this.max,
    this.size = 120,
    this.strokeWidth = 12,
    this.label,
    this.unit,
    this.color,
    this.backgroundColor,
    this.showPercentage = false,
  });

  final double value;
  final double max;
  final double size;
  final double strokeWidth;
  final String? label;
  final String? unit;
  final Color? color;
  final Color? backgroundColor;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final progress = (value / max).clamp(0.0, 1.0);
    final gaugeColor = color ?? context.colors.primary;
    final bgColor = backgroundColor ??
        context.colors.textSecondary.withValues(alpha: 0.1);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(bgColor),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              backgroundColor: Colors.transparent,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                showPercentage
                    ? '${(progress * 100).toStringAsFixed(0)}%'
                    : value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1),
                style: AppTypography.textTheme.headlineSmall?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(height: 2),
                Text(
                  unit!,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
              if (label != null) ...[
                const SizedBox(height: 4),
                Text(
                  label!,
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Half-circle gauge (like speedometer)
class HalfCircleGauge extends StatelessWidget {
  const HalfCircleGauge({
    super.key,
    required this.value,
    required this.max,
    this.size = 150,
    this.strokeWidth = 16,
    this.label,
    this.color,
    this.backgroundColor,
  });

  final double value;
  final double max;
  final double size;
  final double strokeWidth;
  final String? label;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final progress = (value / max).clamp(0.0, 1.0);
    final gaugeColor = color ?? context.colors.primary;
    final bgColor = backgroundColor ??
        context.colors.textSecondary.withValues(alpha: 0.1);

    return CustomPaint(
      size: Size(size, size / 2),
      painter: _HalfCircleGaugePainter(
        progress: progress,
        color: gaugeColor,
        backgroundColor: bgColor,
        strokeWidth: strokeWidth,
        label: label,
        textColor: context.colors.textPrimary,
      ),
    );
  }
}

class _HalfCircleGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final String? label;
  final Color textColor;

  _HalfCircleGaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    this.label,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth / 2;

    // Draw background arc
    paint.color = backgroundColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Draw progress arc
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * progress,
      false,
      paint,
    );

    // Draw label if provided
    if (label != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label!,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (size.width - textPainter.width) / 2,
          size.height - textPainter.height - 8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

