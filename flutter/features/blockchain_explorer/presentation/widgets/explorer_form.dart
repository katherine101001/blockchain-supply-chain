import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/buttons/app_button.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/components/inputs/glass_text_field.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../data/datasources/etherscan_url_builder.dart';

class ExplorerForm extends StatefulWidget {
  const ExplorerForm({super.key});

  @override
  State<ExplorerForm> createState() => _ExplorerFormState();
}

class _ExplorerFormState extends State<ExplorerForm> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero Section
        GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.spaceL),
          child: Column(
            children: [
              Icon(
                Icons.travel_explore_outlined,
                size: 48,
                color: context.colors.primary,
              ),
              const SizedBox(height: AppSpacing.spaceM),
              Text(
                'Blockchain Explorer',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.headlineMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceS),
              Text(
                'Verify authenticity and track product journey on the Ethereum Sepolia network.',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.spaceL),

        // Search Section
        GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verify Transaction',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceM),
              GlassTextField(
                controller: controller,
                hintText: 'Enter Transaction Hash (0x...)',
                prefixIcon: Icon(
                  Icons.search,
                  color: context.colors.textSecondary,
                ),
                textInputAction: TextInputAction.search,
                onEditingComplete: _onVerify,
              ),
              const SizedBox(height: AppSpacing.spaceL),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'View on Etherscan',
                  icon: Icons.verified_outlined,
                  onPressed: _onVerify,
                  variant: AppButtonVariant.filled,
                  size: AppButtonSize.large,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.spaceM),

        // Quick Link
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Browse Sepolia Explorer',
            icon: Icons.public,
            onPressed: () {
              final url = 'https://sepolia.etherscan.io';
              context.push(
                '/webview/etherscan',
                extra: {'url': url, 'title': 'Sepolia Explorer'},
              );
            },
            variant: AppButtonVariant.outlined,
            size: AppButtonSize.medium,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onVerify() {
    final txHash = controller.text.trim();
    if (txHash.isNotEmpty) {
      final url = EtherscanUrlBuilder.sepoliaTx(txHash).toString();
      context.push(
        '/webview/etherscan',
        extra: {'url': url, 'title': 'Transaction Details'},
      );
    }
  }
}
