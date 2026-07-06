import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.textInputAction,
    this.onEditingComplete,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.glassBackground,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(color: context.colors.glassBorder),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceM,
                vertical: AppSpacing.spaceM,
              ),
              hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: context.colors.textPrimary,
            ),
            textInputAction: textInputAction,
            onEditingComplete: onEditingComplete,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
          ),
        ),
      ),
    );
  }
}
