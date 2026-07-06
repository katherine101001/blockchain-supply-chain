import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';

/// Standardized app button with consistent sizing and styling
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final height = _getHeight(size);
    final padding = _getPadding(size);
    final textStyle = _getTextStyle(context, size);
    final resolvedIconColor = _resolveIconColor(context);
    final iconSize = _iconSize;

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(resolvedIconColor),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: iconSize, color: resolvedIconColor),
          SizedBox(width: size == AppButtonSize.small ? 6 : 8),
        ],
        Text(
          label,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          style: textStyle?.copyWith(height: 1.1),
        ),
      ],
    );

    final button = _buildButton(context, content, padding);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: button,
    );
  }

  double get _iconSize => size == AppButtonSize.small ? 16 : 20;

  Color _resolveIconColor(BuildContext context) {
    if (variant == AppButtonVariant.filled) return Colors.white;
    return context.colors.primary;
  }

  Widget _buildButton(BuildContext context, Widget content, EdgeInsetsGeometry padding) {
    final onPress = isLoading ? null : onPressed;
    switch (variant) {
      case AppButtonVariant.filled:
        return FilledButton(
          onPressed: onPress,
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: context.colors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
          child: content,
        );
      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPress,
          style: OutlinedButton.styleFrom(
            padding: padding,
            foregroundColor: context.colors.primary,
            side: BorderSide(color: context.colors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
          child: content,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: onPress,
          style: TextButton.styleFrom(
            padding: padding,
            foregroundColor: context.colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
          child: content,
        );
    }
  }

  double _getHeight(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceM,
          vertical: AppSpacing.spaceXS,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceL,
          vertical: AppSpacing.spaceXS,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceL,
          vertical: AppSpacing.spaceXS,
        );
    }
  }

  TextStyle? _getTextStyle(BuildContext context, AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );
      case AppButtonSize.medium:
        return AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );
      case AppButtonSize.large:
        return AppTypography.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }
}

enum AppButtonVariant { filled, outlined, text }

enum AppButtonSize { small, medium, large }
