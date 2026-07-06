import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/buttons/app_button.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';

/// Intermediate page shown right after scan/search.
/// It lets the user acknowledge the product is real before entering the details page.
class ProductRealNoticePage extends StatelessWidget {
  const ProductRealNoticePage({super.key, required this.sku});

  final String sku;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spaceL),
            child: GlassContainer(
              borderRadius: AppSpacing.radiusM,
              padding: const EdgeInsets.all(AppSpacing.spaceL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: context.colors.success,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.spaceS),
                      Expanded(
                        child: Text(
                          'This product is REAL',
                          style: AppTypography.textTheme.titleLarge?.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spaceS),
                  Text(
                    'Tap below to view the product page.',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceM),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Know more about the product',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        context.push('/product/$sku');
                      },
                      variant: AppButtonVariant.filled,
                      size: AppButtonSize.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceS),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.exit_to_app,
                        color: context.colors.textSecondary,
                      ),
                      label: Text(
                        'Exit',
                        style: AppTypography.textTheme.labelLarge?.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

