import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/components/cards/standard_metric_card.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../../../design_system/components/loading/skeleton_wrapper.dart';
import '../../../../design_system/components/loading/skeleton_card.dart';
import '../../../../design_system/components/buttons/app_button.dart';
import '../../../home/application/home_bloc.dart';
import '../../../home/domain/entities/product_scan.dart';
import '../../../product/data/datasources/product_remote_data_source.dart';
import '../../../product/data/repositories/product_repository_impl.dart';
import '../../../product/domain/entities/product.dart';

class HistoryPageModern extends StatelessWidget {
  const HistoryPageModern({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HistoryContentModern();
  }
}

class _HistoryContentModern extends StatelessWidget {
  const _HistoryContentModern();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final scanCount = state is HomeLoadedState
            ? state.recentScans.length
            : 0;
        final isLoading = state is HomeLoadingState;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: StandardMetricCard(
                      title: 'Total Scans',
                      value: scanCount.toString(),
                      icon: Icons.qr_code_scanner,
                      iconColor: context.colors.primary,
                      height: AppSpacing.metricCardHeight,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceM),
                  Expanded(
                    child: StandardMetricCard(
                      title: 'This Week',
                      value: scanCount.toString(),
                      icon: Icons.calendar_today,
                      iconColor: context.colors.info,
                      height: AppSpacing.metricCardHeight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceL),
              // History list
              if (isLoading)
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spaceM),
                    child: SkeletonWrapper(
                      height: 100,
                      skeleton: const SkeletonCard(),
                    ),
                  ),
                )
              else if (state is HomeLoadedState)
                state.recentScans.isEmpty
                    ? _EmptyHistoryStateModern()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Scans',
                            style: AppTypography.textTheme.titleMedium
                                ?.copyWith(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.spaceL),
                          ...state.recentScans.asMap().entries.map((entry) {
                            final index = entry.key;
                            final scan = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == state.recentScans.length - 1
                                    ? 0
                                    : AppSpacing.spaceL,
                              ),
                              child: _ModernHistoryCard(scan: scan),
                            );
                          }),
                        ],
                      )
              else
                _EmptyHistoryStateModern(),

              const SizedBox(height: 135),
            ],
          ),
        );
      },
    );
  }
}

class _ModernHistoryCard extends StatefulWidget {
  const _ModernHistoryCard({required this.scan});
  final ProductScan scan;

  @override
  State<_ModernHistoryCard> createState() => _ModernHistoryCardState();
}

class _ModernHistoryCardState extends State<_ModernHistoryCard> {
  late final Future<Product?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProductSummary(widget.scan.sku);
  }

  Future<Product?> _fetchProductSummary(String sku) async {
    try {
      final repo = ProductRepositoryImpl(
        remoteDataSource: ProductRemoteDataSourceImpl(),
      );
      return await repo.getProductSummary(sku);
    } catch (_) {
      return null;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    }
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  }

  String _formatLocation(String? location) {
    if (location == null || location.isEmpty) {
      return 'Unknown';
    }

    final parts = location.split(' ');
    if (parts.length >= 2 && parts[0].toLowerCase() == 'warehouse') {
      return parts[1];
    }

    return location.length > 10 ? location.substring(0, 10) : location;
  }

  @override
  Widget build(BuildContext context) {
    final scan = widget.scan;
    final themeColor = scan.isVerified
        ? context.colors.success
        : context.colors.primary;

    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        final product = snapshot.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return GlassContainer(
          borderRadius: AppSpacing.radiusM,
          padding: EdgeInsets.zero, // Padding handled inside for InkWell
          child: InkWell(
            onTap: () => context.push('/product/${scan.sku}'),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 1. THE IDENTIFIER ORB
                  _buildIconOrb(context, themeColor),

                  const SizedBox(width: 16),

                  // 2. PRIMARY CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              scan.sku.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: context.colors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            _buildMiniStatus(context, scan.isVerified),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Dynamic Subtitle Area
                        if (isLoading)
                          _buildLoadingIndicator(context)
                        else if (product != null)
                          Text(
                            '${product.productType} • ${product.availability} in stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // 3. METADATA ROW (Anchor to Bottom)
                        Row(
                          children: [
                            _metadataItem(
                              context,
                              Icons.schedule,
                              _formatTimeAgo(scan.scannedAt),
                            ),
                            const SizedBox(width: 12),
                            _metadataItem(
                              context,
                              Icons.place_outlined,
                              _formatLocation(scan.location),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconOrb(BuildContext context, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.02),
              ],
            ),
          ),
        ),
        Icon(Icons.inventory_2_outlined, color: color, size: 24),
      ],
    );
  }

  Widget _buildMiniStatus(BuildContext context, bool isVerified) {
    final color = isVerified ? context.colors.success : context.colors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        isVerified ? 'VERIFIED' : 'PENDING',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _metadataItem(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: context.colors.textSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: context.colors.textSecondary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: 14,
      width: 14,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        valueColor: AlwaysStoppedAnimation(
          context.colors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _EmptyHistoryStateModern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceXL),
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history, size: 40, color: context.colors.primary),
          ),
          const SizedBox(height: AppSpacing.spaceL),
          Text(
            'No scan history yet',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceS),
          Text(
            'Start scanning products to build your verification history',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceL),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Scan Now',
              icon: Icons.qr_code_scanner,
              onPressed: () => context.push('/scan'),
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
            ),
          ),
        ],
      ),
    );
  }
}
