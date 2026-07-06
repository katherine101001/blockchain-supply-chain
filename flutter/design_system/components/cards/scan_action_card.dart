import 'package:flutter/material.dart';
import '../../../core/utils/context_extensions.dart';
import '../../foundations/spacing.dart';
import '../../foundations/typography.dart';
import '../glass/glass_container.dart';
import '../loading/skeleton_wrapper.dart';
import '../loading/skeleton_card.dart';

class ScanActionCard extends StatelessWidget {
  final VoidCallback onScan;
  final bool isLoading;

  const ScanActionCard({
    super.key,
    required this.onScan,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SkeletonWrapper(height: 220, skeleton: const SkeletonCard());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background gradient & subtle glow
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  context.colors.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                center: Alignment.center,
                radius: 0.7,
              ),
            ),
          ),
        ),

        // Glassmorphic card
        GlassContainer(
          borderRadius: AppSpacing.radiusM,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onScan,
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              splashColor: context.colors.primary.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spaceXXL,
                  horizontal: AppSpacing.spaceXL,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated glowing QR button
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.spaceL),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            context.colors.primary.withValues(alpha: 0.8),
                            context.colors.secondary.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.primary.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: context.colors.secondary.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 35,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceL),
                    // Title
                    Text(
                      'Scan Product',
                      style: AppTypography.textTheme.headlineMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.spaceS),
                    // Subtitle
                    Text(
                      'Verify authenticity & track the supply chain',
                      style: AppTypography.textTheme.bodyLarge?.copyWith(
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.spaceM),
                    // Call-to-action hint
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spaceM,
                        vertical: AppSpacing.spaceS,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                      ),
                      child: Text(
                        'Tap to scan',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
