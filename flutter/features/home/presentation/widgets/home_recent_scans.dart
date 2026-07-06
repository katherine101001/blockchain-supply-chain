import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/cards/product_scan_card.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../../../design_system/components/loading/skeleton_wrapper.dart';
import '../../../../design_system/components/loading/skeleton_card.dart';
import '../../domain/entities/product_scan.dart';

class HomeRecentScans extends StatelessWidget {
  final List<ProductScan>? recentScans;
  final bool isLoading;
  final bool showTitle;

  const HomeRecentScans({
    super.key,
    this.recentScans,
    this.isLoading = false,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show skeletons for recent scans
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            SkeletonWrapper(
              height: 28,
              skeleton: const SkeletonCard(),
            ), // title
            const SizedBox(height: AppSpacing.spaceM),
          ],
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.spaceM),
              itemBuilder: (_, __) => SkeletonWrapper(
                // width: 220,
                height: 160,
                skeleton: const SkeletonCard(),
              ),
            ),
          ),
        ],
      );
    }

    final scans = recentScans ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            'Recent Scans',
            style: AppTypography.textTheme.headlineMedium?.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceM),
        ],
        SizedBox(
          height: 160,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth < 360
                  ? constraints.maxWidth * 0.8
                  : 240.0;
              return scans.isEmpty
                  ? _EmptyState()
                  : _RecentScansList(
                      recentScans: scans,
                      cardWidth: cardWidth.clamp(180.0, 260.0),
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentScansList extends StatelessWidget {
  final List<ProductScan> recentScans;
  final double cardWidth;

  const _RecentScansList({required this.recentScans, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recentScans.length,
      itemBuilder: (context, index) {
        final scan = recentScans[index];
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.spaceM),
          child: ProductScanCard(
            scan: scan,
            width: cardWidth,
            onTap: () {
              // Navigate to fast view when tapping a recent scan
              GoRouter.of(context).push('/product/${scan.sku}');
            },
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: 220,
      borderRadius: AppSpacing.radiusM,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 40, color: context.colors.textSecondary),
              const SizedBox(height: AppSpacing.spaceM),
              Text(
                'No scans yet.\nTap "Scan QR Code" to get started!',
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spaceM),
              GlassContainer(
                borderRadius: AppSpacing.radiusM,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spaceM,
                    horizontal: AppSpacing.spaceL,
                  ),
                  child: Text(
                    'Scan Now',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      // Using primary because it's an action inside glass
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
