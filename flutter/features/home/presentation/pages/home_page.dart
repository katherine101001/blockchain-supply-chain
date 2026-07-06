import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/cards/scan_action_card.dart';
import '../../../../design_system/components/buttons/app_button.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../application/home_bloc.dart';
import '../../presentation/widgets/home_greeting_card.dart';
import '../../presentation/widgets/dashboard_stats_card.dart';
import '../../presentation/widgets/home_quick_actions.dart';
import '../../presentation/widgets/home_recent_scans.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final recentScans = state is HomeLoadedState ? state.recentScans : null;
        final isLoading = state is HomeLoadingState;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern Greeting Card
              HomeGreetingCard(
                todayScanCount: recentScans == null
                    ? 0
                    : recentScans.where((scan) {
                        final now = DateTime.now();
                        final d = scan.scannedAt;
                        return d.year == now.year &&
                            d.month == now.month &&
                            d.day == now.day;
                      }).length,
                isLoading: isLoading,
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: AppSpacing.spaceL),

              // Dashboard Stats and Quick Actions in a row
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    // Desktop layout: side by side
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: DashboardStatsCard(
                            recentScans: recentScans,
                            isLoading: isLoading,
                          ).animate().fadeIn(delay: 200.ms),
                        ),
                        const SizedBox(width: AppSpacing.spaceL),
                        Expanded(
                          flex: 2,
                          child: HomeQuickActions(
                            isLoading: isLoading,
                            onSearch: () => _showSearchDialog(context),
                            onHistory: () => context.push('/history'),
                          ).animate().fadeIn(delay: 300.ms),
                        ),
                      ],
                    );
                  } else {
                    // Mobile layout: stacked
                    return Column(
                      children: [
                        DashboardStatsCard(
                          recentScans: recentScans,
                          isLoading: isLoading,
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: AppSpacing.spaceL),
                        HomeQuickActions(
                          isLoading: isLoading,
                          onSearch: () => _showSearchDialog(context),
                          onHistory: () => context.push('/history'),
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: AppSpacing.spaceL),

              // Primary Scan CTA
              ScanActionCard(
                onScan: () => context.push('/scan'),
                isLoading: isLoading,
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: AppSpacing.spaceL),

              // Recent Scans Section
              if (recentScans != null && recentScans.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Activity',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/history'),
                      child: Text(
                        'View All',
                        style: AppTypography.textTheme.bodyLarge?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: AppSpacing.spaceS),
                HomeRecentScans(
                  recentScans: recentScans,
                  isLoading: isLoading,
                  showTitle: false,
                ).animate().fadeIn(delay: 600.ms),
              ],

              const SizedBox(height: 135),
            ],
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _SearchDialog());
  }
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog();

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final sku = _controller.text.trim();
    if (sku.isNotEmpty) {
      Navigator.of(context).pop();
      context.push('/product/$sku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spaceL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Product',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceM),
            Text(
              'Enter SKU to search for a product',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceL),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'SKU',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              autofocus: true,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.spaceL),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.spaceM),
                AppButton(
                  label: 'Search',
                  icon: Icons.search,
                  onPressed: _submit,
                  variant: AppButtonVariant.filled,
                  size: AppButtonSize.medium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
