import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';
import '../glass/glass_container.dart';

class MiniActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const MiniActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spaceS,
        horizontal: AppSpacing.spaceM,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: context.colors.textPrimary),
              const SizedBox(width: AppSpacing.spaceS),
              Text(
                label,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
