import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/components/cards/standard_metric_card.dart';
import '../../../../design_system/components/charts/glass_chart_container.dart';
import '../../../../design_system/components/charts/circular_gauge.dart';
import '../../../../design_system/components/buttons/app_button.dart';
import '../../../../design_system/components/navigation/segmented_tab_bar.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../application/bloc/product_full_cubit.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/trace_log.dart';

class ProductFullDetailPageRefined extends StatelessWidget {
  const ProductFullDetailPageRefined({
    super.key,
    required this.sku,
    this.verifyOnOpen = false,
  });

  final String sku;
  final bool verifyOnOpen;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProductRepository>(
      create: (_) => ProductRepositoryImpl(
        remoteDataSource: ProductRemoteDataSourceImpl(),
      ),
      child: BlocProvider<ProductFullCubit>(
        create: (context) {
          final cubit = ProductFullCubit(context.read<ProductRepository>());
          cubit.load(sku).then((_) {
            if (verifyOnOpen) {
              cubit.verifyOnChain(sku);
            }
          });
          return cubit;
        },
        child: DefaultTabController(
          length: 6,
          child: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);
              return Scaffold(
                backgroundColor: context.colors.background,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text('TRASE'),
                  bottom: SegmentedTabBar(
                    controller: tabController,
                    tabs: const [
                      'Overview',
                      'Sales',
                      'Inventory',
                      'Quality',
                      'Logistics',
                      'Trace',
                    ],
                  ),
                ),
                body: BlocBuilder<ProductFullCubit, ProductFullState>(
                  builder: (context, state) {
                    if (state is ProductFullLoading ||
                        state is ProductFullInitial) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: context.colors.primary,
                        ),
                      );
                    }

                    if (state is ProductFullError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.spaceL),
                          child: GlassContainer(
                            borderRadius: AppSpacing.radiusM,
                            padding: const EdgeInsets.all(
                              AppSpacing.spaceL * 1.5,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: context.colors.danger,
                                ),
                                const SizedBox(height: AppSpacing.spaceM),
                                Text(
                                  'Unable to load product',
                                  style: AppTypography.textTheme.titleLarge
                                      ?.copyWith(
                                        color: context.colors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.spaceS),
                                Text(
                                  state.message,
                                  style: AppTypography.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: context.colors.textSecondary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final loaded = state as ProductFullLoaded;
                    final product = loaded.product;

                    return TabBarView(
                      children: [
                        _OverviewTabRefined(
                          product: product,
                          sku: sku,
                          verified: loaded.verified,
                          isVerifying: loaded.isVerifying,
                          recordHash: loaded.verified
                              ? product.recordHash
                              : null,
                          transactionHash:
                              loaded.verified && loaded.traceLogs.isNotEmpty
                                  ? loaded.traceLogs.last.txHash
                                  : null,
                          onVerify: () => context
                              .read<ProductFullCubit>()
                              .verifyOnChain(sku),
                        ),
                        _SalesTabRefined(product: product),
                        _InventoryTabRefined(product: product),
                        _QualityTabRefined(product: product),
                        _LogisticsTabRefined(product: product),
                        _TraceTabRefined(
                          traceLogs: loaded.traceLogs,
                          verified: loaded.verified,
                          isVerifying: loaded.isVerifying,
                          onVerify: () => context
                              .read<ProductFullCubit>()
                              .verifyOnChain(sku),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Overview Tab - Clean hero section
class _OverviewTabRefined extends StatelessWidget {
  const _OverviewTabRefined({
    required this.product,
    required this.sku,
    required this.verified,
    required this.isVerifying,
    this.recordHash,
    this.transactionHash,
    required this.onVerify,
  });

  final dynamic product;
  final String sku;
  final bool verified;
  final bool isVerifying;
  final String? recordHash;
  final String? transactionHash;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spaceM,
        AppSpacing.spaceM,
        AppSpacing.spaceM,
        AppSpacing.spaceM + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Card - Fixed padding
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceL),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                // SKU Badge - Large and prominent
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceL,
                    vertical: AppSpacing.spaceM,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary.withValues(alpha: 0.2),
                        context.colors.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    border: Border.all(
                      color: context.colors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    sku.toUpperCase(),
                    style: AppTypography.textTheme.titleLarge?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceL),
                // Product Type - Secondary info
                Text(
                  product.productType.toUpperCase(),
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: context.colors.textSecondary,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceS),
                // Price - Very large and prominent
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RM',
                      style: AppTypography.textTheme.titleLarge?.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.price.toStringAsFixed(2),
                      style: AppTypography.textTheme.headlineLarge?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceL),
                // Info Pills - Fixed height
                Row(
                  children: [
                    Expanded(
                      child: _InfoPill(
                        icon: Icons.store,
                        label: 'Supplier',
                        value: product.supplierName,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceM),
                    Expanded(
                      child: _InfoPill(
                        icon: Icons.access_time,
                        label: 'Lead Time',
                        value: '${product.leadTimes} days',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceM),
          _VerificationCardRefined(
            verified: verified,
            isVerifying: isVerifying,
            recordHash: recordHash,
            transactionHash: transactionHash,
            onVerify: onVerify,
          ),
          const SizedBox(height: AppSpacing.spaceL),
        ],
      ),
    );
  }
}

class _VerificationCardRefined extends StatelessWidget {
  const _VerificationCardRefined({
    required this.verified,
    required this.isVerifying,
    this.recordHash,
    this.transactionHash,
    required this.onVerify,
  });

  final bool verified;
  final bool isVerifying;
  final String? recordHash;
  final String? transactionHash;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceL),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VerificationHeader(verified: verified),
          const SizedBox(height: AppSpacing.spaceL),
          _VerificationInfoBox(verified: verified),
          const SizedBox(height: AppSpacing.spaceM),
          _VerifyButton(
            verified: verified,
            isVerifying: isVerifying,
            onVerify: onVerify,
          ),
          if (recordHash != null) ...[
            const SizedBox(height: AppSpacing.spaceM),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.spaceM),
            _RecordHashDisplay(recordHash: recordHash!),
            if (transactionHash != null) ...[
              const SizedBox(height: AppSpacing.spaceM),
              _TransactionHashDisplay(transactionHash: transactionHash!),
            ],
          ],
        ],
      ),
    );
  }
}

class _VerificationHeader extends StatelessWidget {
  const _VerificationHeader({required this.verified});
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: verified
                ? context.colors.success.withValues(alpha: 0.15)
                : context.colors.textSecondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            verified ? Icons.verified_rounded : Icons.verified_outlined,
            color: verified ? context.colors.success : context.colors.textSecondary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blockchain Verification',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                verified ? 'Verified on-chain' : 'Not verified yet',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerificationInfoBox extends StatelessWidget {
  const _VerificationInfoBox({required this.verified});
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      decoration: BoxDecoration(
        color: verified
            ? context.colors.success.withValues(alpha: 0.05)
            : context.colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: verified
              ? context.colors.success.withValues(alpha: 0.2)
              : context.colors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            verified ? Icons.info_outline_rounded : Icons.lightbulb_outline_rounded,
            color: verified ? context.colors.success : context.colors.primary,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.spaceS),
          Expanded(
            child: Text(
              verified
                  ? 'This product has been verified on the blockchain. All records are authentic and tamper-proof.'
                  : 'Verify this product on-chain to confirm its integrity and authenticity.',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textPrimary,
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  const _VerifyButton({
    required this.verified,
    required this.isVerifying,
    required this.onVerify,
  });
  final bool verified;
  final bool isVerifying;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        label: isVerifying
            ? 'Verifying...'
            : verified
            ? 'Re-verify on Blockchain'
            : 'Verify on Blockchain',
        icon: verified ? Icons.refresh : Icons.verified_user,
        onPressed: isVerifying ? null : onVerify,
        isLoading: isVerifying,
        variant: AppButtonVariant.filled,
        size: AppButtonSize.medium,
      ),
    );
  }
}

class _RecordHashDisplay extends StatelessWidget {
  const _RecordHashDisplay({required this.recordHash});
  final String recordHash;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.fingerprint_rounded, color: context.colors.primary, size: 18),
            const SizedBox(width: AppSpacing.spaceS),
            Text(
              'Record Hash',
              style: AppTypography.textTheme.titleSmall?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceM),
        Container(
          padding: const EdgeInsets.all(AppSpacing.spaceM),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(color: context.colors.glassBorder, width: 1),
          ),
          child: SelectableText(
            recordHash,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: context.colors.textPrimary,
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionHashDisplay extends StatelessWidget {
  const _TransactionHashDisplay({required this.transactionHash});
  final String transactionHash;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: context.colors.primary, size: 18),
            const SizedBox(width: AppSpacing.spaceS),
            Text(
              'Transaction Hash',
              style: AppTypography.textTheme.titleSmall?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Tooltip(
              message: 'Copy',
              child: IconButton(
                icon: Icon(Icons.copy_rounded, color: context.colors.textSecondary, size: 18),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: transactionHash));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceM),
        Container(
          padding: const EdgeInsets.all(AppSpacing.spaceM),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(color: context.colors.glassBorder, width: 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              transactionHash,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textPrimary,
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceS),
        Text(
          'Paste into Sepolia Etherscan to verify.',
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: context.colors.textSecondary,
            fontSize: 12,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      decoration: BoxDecoration(
        color: context.colors.glassBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: context.colors.glassBorder, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.colors.primary, size: 20),
          const SizedBox(height: AppSpacing.spaceS),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: AppTypography.textTheme.labelSmall?.copyWith(
                color: context.colors.textSecondary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Sales Tab - Consistent metric cards and chart
class _SalesTabRefined extends StatelessWidget {
  const _SalesTabRefined({required this.product});

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    // Generate consistent chart data
    final monthlyData = List.generate(
      6,
      (i) => FlSpot(
        i.toDouble(),
        (product.numProductsSold / 6 * (i + 1) * 0.8 + (i * 50)).toDouble(),
      ),
    );
    // The curve is monotonically increasing, so its last point is the peak.
    // Add 20% headroom so the line never clips against the top border.
    final chartMaxY =
        (monthlyData.last.y * 1.2).clamp(1.0, double.infinity).toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metric Cards - Fixed height
          Row(
            children: [
              Expanded(
                child: StandardMetricCard(
                  title: 'Units Sold',
                  value: product.numProductsSold.toString(),
                  icon: Icons.shopping_cart,
                  iconColor: context.colors.primary,
                  trend: '+12%',
                  trendColor: context.colors.success,
                  height: AppSpacing.metricCardHeight,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: StandardMetricCard(
                  title: 'Revenue',
                  value: 'RM ${product.revenueGenerated.toStringAsFixed(0)}',
                  icon: Icons.attach_money,
                  iconColor: context.colors.success,
                  trend: '+8%',
                  trendColor: context.colors.success,
                  height: AppSpacing.metricCardHeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceL),
          // Chart - Fixed height with proper constraints
          GlassChartContainer(
            title: 'Sales Trend',
            height: AppSpacing.chartHeightMedium,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartHeight = constraints.maxHeight.clamp(
                  0.0,
                  double.infinity,
                );
                final chartWidth = constraints.maxWidth.clamp(
                  0.0,
                  double.infinity,
                );

                return SizedBox(
                  height: chartHeight,
                  width: chartWidth,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: context.colors.textSecondary.withValues(
                              alpha: 0.1,
                            ),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 18,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  'M${value.toInt() + 1}',
                                  style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            interval: chartMaxY / 4,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: context.colors.textSecondary.withValues(
                            alpha: 0.1,
                          ),
                          width: 1,
                        ),
                      ),
                      minX: 0,
                      maxX: 5,
                      minY: 0,
                      maxY: chartMaxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: monthlyData,
                          isCurved: true,
                          color: context.colors.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: context.colors.primary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.spaceL),
          // Insights - Consistent padding
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                      ),
                      child: Icon(
                        Icons.insights_rounded,
                        color: context.colors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceM),
                    Text(
                      'Key Insights',
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceM),
                _InsightRow(
                  icon: Icons.people,
                  label: 'Primary Buyers',
                  value: product.customerDemographics,
                ),
                const SizedBox(height: AppSpacing.spaceS),
                _InsightRow(
                  icon: Icons.shopping_bag,
                  label: 'Avg Order Size',
                  value: '${product.orderQuantities} units',
                ),
                const SizedBox(height: AppSpacing.spaceS),
                _InsightRow(
                  icon: Icons.schedule,
                  label: 'Lead Time',
                  value: '${product.leadTimes} days',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusS),
          ),
          child: Icon(icon, color: context.colors.primary, size: 16),
        ),
        const SizedBox(width: AppSpacing.spaceS),
        Expanded(
          child: Text(
            label,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Inventory Tab - Consistent gauges and metrics
class _InventoryTabRefined extends StatelessWidget {
  const _InventoryTabRefined({required this.product});

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    // Use availability (actual stock count) for health status,
    // consistent with the fast-view page logic.
    // >50 = Healthy, >10 = Watch, else At Risk
    final availability = product.availability;

    String statusLabel;
    Color statusColor;
    IconData statusIcon;

    if (availability > 50) {
      statusLabel = 'Healthy';
      statusColor = context.colors.success;
      statusIcon = Icons.check_circle;
    } else if (availability > 10) {
      statusLabel = 'Watch';
      statusColor = context.colors.warning;
      statusIcon = Icons.warning;
    } else {
      statusLabel = 'At Risk';
      statusColor = context.colors.danger;
      statusIcon = Icons.error;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Gauge - Fixed size
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceL),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Text(
                  'Stock Level',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceL),
                CircularGauge(
                  value: availability.toDouble(),
                  max: availability > 100
                      ? availability.toDouble()
                      : 100.0,
                  size: 140,
                  strokeWidth: 14,
                  color: statusColor,
                  showPercentage: true,
                ),
                const SizedBox(height: AppSpacing.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 18),
                    const SizedBox(width: AppSpacing.spaceS),
                    Text(
                      'Supply Status: $statusLabel',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceM),
          // Metrics - Fixed height
          Row(
            children: [
              Expanded(
                child: StandardMetricCard(
                  title: 'Current Stock',
                  value: product.stockLevels.toString(),
                  icon: Icons.inventory_2,
                  iconColor: context.colors.info,
                  unit: 'units',
                  height: AppSpacing.metricCardHeight,
                  valueFontSize: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: StandardMetricCard(
                  title: 'Production',
                  value: product.productionVolumes.toString(),
                  icon: Icons.factory,
                  iconColor: context.colors.primary,
                  unit: 'units',
                  height: AppSpacing.metricCardHeight,
                  valueFontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceM),
          // Manufacturing Info
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.build, color: context.colors.primary, size: 20),
                    const SizedBox(width: AppSpacing.spaceS),
                    Text(
                      'Manufacturing',
                      style: AppTypography.textTheme.titleSmall?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceM),
                _InfoRow(
                  label: 'Lead Time',
                  value: '${product.manufacturingLeadTime} days',
                  icon: Icons.access_time,
                ),
                const SizedBox(height: AppSpacing.spaceS),
                _InfoRow(
                  label: 'Cost per Unit',
                  value: 'RM ${product.manufacturingCosts.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: context.colors.textSecondary, size: 16),
          const SizedBox(width: AppSpacing.spaceS),
        ],
        Expanded(
          child: Text(
            label,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.spaceS),
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}

// Quality Tab - Consistent risk meters
class _QualityTabRefined extends StatelessWidget {
  const _QualityTabRefined({required this.product});

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final defectRate = product.defectRates;
    String riskLabel;
    Color riskColor;
    IconData riskIcon;

    if (defectRate < 1.0) {
      riskLabel = 'Low Risk';
      riskColor = context.colors.success;
      riskIcon = Icons.check_circle;
    } else if (defectRate < 5.0) {
      riskLabel = 'Medium Risk';
      riskColor = context.colors.warning;
      riskIcon = Icons.warning;
    } else {
      riskLabel = 'High Risk';
      riskColor = context.colors.danger;
      riskIcon = Icons.error;
    }

    final qualityScore = (100 - defectRate * 10).clamp(0, 100).toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quality Gauge - Fixed size
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceL),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Text(
                  'Quality Score',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceL),
                CircularGauge(
                  value: qualityScore,
                  max: 100,
                  size: 140,
                  strokeWidth: 14,
                  color: riskColor,
                  showPercentage: true,
                  label: 'Score',
                ),
                const SizedBox(height: AppSpacing.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(riskIcon, color: riskColor, size: 18),
                    const SizedBox(width: AppSpacing.spaceS),
                    Text(
                      riskLabel,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceM),
          // Quality Metrics - Fixed height
          Row(
            children: [
              Expanded(
                child: StandardMetricCard(
                  title: 'Defect Rate',
                  value: '${defectRate.toStringAsFixed(2)}%',
                  icon: Icons.bug_report,
                  iconColor: riskColor,
                  subtitle: 'Lower is better',
                  height: AppSpacing.metricCardHeight,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: StandardMetricCard(
                  title: 'Inspection',
                  value: product.inspectionResults,
                  icon: _getInspectionIcon(product.inspectionResults),
                  iconColor: _getInspectionColor(
                    context,
                    product.inspectionResults,
                  ),
                  height: AppSpacing.metricCardHeight,
                  valueFontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceM),
          // Quality Assessment
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.colors.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.spaceS),
                    Text(
                      'Quality Assessment',
                      style: AppTypography.textTheme.titleSmall?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceM),
                Text(
                  _getQualityExplanation(defectRate),
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getInspectionIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pass':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'fail':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getInspectionColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pass':
        return context.colors.success;
      case 'pending':
        return context.colors.warning;
      case 'fail':
        return context.colors.danger;
      default:
        return context.colors.textSecondary;
    }
  }

  String _getQualityExplanation(double defectRate) {
    if (defectRate < 1.0) {
      return 'Excellent quality standards maintained. Defect rate is well below industry average.';
    } else if (defectRate < 5.0) {
      return 'Good quality with minor defects. Within acceptable industry standards.';
    } else {
      return 'Quality concerns detected. Defect rate exceeds recommended thresholds. Review manufacturing processes.';
    }
  }
}

// Logistics Tab - Consistent info cards
class _LogisticsTabRefined extends StatelessWidget {
  const _LogisticsTabRefined({required this.product});

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shipping Overview
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: context.colors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.spaceS),
                    Text(
                      'Shipping Details',
                      style: AppTypography.textTheme.titleSmall?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceM),
                _LogisticsInfoCard(
                  icon: Icons.business,
                  label: 'Carrier',
                  value: product.shippingCarriers,
                  color: context.colors.primary,
                ),
                const SizedBox(height: AppSpacing.spaceS),
                _LogisticsInfoCard(
                  icon: Icons.directions_transit,
                  label: 'Transport Mode',
                  value: product.transportationModes,
                  color: context.colors.info,
                ),
                const SizedBox(height: AppSpacing.spaceS),
                _LogisticsInfoCard(
                  icon: Icons.route,
                  label: 'Route',
                  value: product.routes,
                  color: context.colors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceM),
          // Time and Cost - Fixed height
          Row(
            children: [
              Expanded(
                child: StandardMetricCard(
                  title: 'Shipping Time',
                  value: '${product.shippingTimes}',
                  icon: Icons.access_time,
                  iconColor: context.colors.warning,
                  unit: 'days',
                  height: AppSpacing.metricCardHeight,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: StandardMetricCard(
                  title: 'Shipping Cost',
                  value: 'RM ${product.shippingCosts.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  iconColor: context.colors.success,
                  height: AppSpacing.metricCardHeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceM),
          // Warning Note
          GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            margin: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.colors.warning,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.spaceS),
                Expanded(
                  child: Text(
                    'This is operational metadata, not live tracking. For real-time shipment tracking, contact the carrier directly.',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogisticsInfoCard extends StatelessWidget {
  const _LogisticsInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTypography.textTheme.labelSmall?.copyWith(
                      color: context.colors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Trace Tab - Consistent timeline
class _TraceTabRefined extends StatelessWidget {
  const _TraceTabRefined({
    required this.traceLogs,
    required this.verified,
    required this.isVerifying,
    required this.onVerify,
  });

  final List<TraceLog> traceLogs;
  final bool verified;
  final bool isVerifying;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TraceStatusHeader(
            verified: verified,
            isVerifying: isVerifying,
            onVerify: onVerify,
          ),
          const SizedBox(height: AppSpacing.spaceM),
          if (traceLogs.isEmpty)
            const _EmptyTraceState()
          else
            ...traceLogs.asMap().entries.map((entry) {
              final index = entry.key;
              final log = entry.value;
              final isLast = index == traceLogs.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : AppSpacing.spaceM,
                ),
                child: _TraceTimelineItem(log: log, isLast: isLast),
              );
            }),
        ],
      ),
    );
  }
}

class _TraceStatusHeader extends StatelessWidget {
  const _TraceStatusHeader({
    required this.verified,
    required this.isVerifying,
    required this.onVerify,
  });
  final bool verified;
  final bool isVerifying;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceL),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                verified ? Icons.verified : Icons.verified_outlined,
                color: verified
                    ? context.colors.success
                    : context.colors.textSecondary,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.spaceS),
              Text(
                verified ? 'Blockchain Verified' : 'Not Verified',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: verified
                      ? context.colors.success
                      : context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceM),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: isVerifying
                  ? 'Verifying...'
                  : verified
                  ? 'Re-verify All Transactions'
                  : 'Verify All Transactions',
              icon: verified
                  ? Icons.refresh_rounded
                  : Icons.verified_user_rounded,
              onPressed: isVerifying ? null : onVerify,
              isLoading: isVerifying,
              variant: AppButtonVariant.filled,
              size: AppButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTraceState extends StatelessWidget {
  const _EmptyTraceState();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceL * 1.5),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: context.colors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.spaceM),
          Text(
            'No trace logs yet',
            style: AppTypography.textTheme.titleSmall?.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceS),
          Text(
            'Verify on-chain to fetch blockchain history',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TraceTimelineItem extends StatelessWidget {
  const _TraceTimelineItem({required this.log, required this.isLast});

  final TraceLog log;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final date = log.timestamp.toLocal();
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    final isVerified = log.verified == true;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineDot(isVerified: isVerified, isLast: isLast),
        const SizedBox(width: AppSpacing.spaceM),
        Expanded(
          child: GlassContainer(
            borderRadius: AppSpacing.radiusM,
            padding: const EdgeInsets.all(AppSpacing.spaceM),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$dateStr at $timeStr',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isVerified) const _VerifiedMiniBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceS),
                Row(
                  children: [
                    Icon(Icons.cloud, size: 12, color: context.colors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      log.blockchainNetwork.toUpperCase(),
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(context, log.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        log.status,
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(context, log.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceS),
                InkWell(
                  onTap: () {
                    final url = 'https://sepolia.etherscan.io/tx/${log.txHash}';
                    context.push(
                      '/webview/etherscan',
                      extra: {'url': url, 'title': 'Transaction Details'},
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.open_in_new, size: 12, color: context.colors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          log.txHash,
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                            fontFamily: 'monospace',
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return context.colors.success;
      case 'pending':
        return context.colors.warning;
      case 'failed':
        return context.colors.danger;
      default:
        return context.colors.textSecondary;
    }
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.isVerified, required this.isLast});
  final bool isVerified;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isVerified ? context.colors.success : Colors.transparent,
              border: Border.all(
                color: isVerified
                    ? context.colors.success.withValues(alpha: 0.5)
                    : context.colors.textSecondary.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: isVerified
                  ? [
                      BoxShadow(
                        color: context.colors.success.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        if (!isLast)
          Container(
            width: 1.5,
            height: 80,
            color: context.colors.textSecondary.withValues(alpha: 0.15),
          ),
      ],
    );
  }
}

class _VerifiedMiniBadge extends StatelessWidget {
  const _VerifiedMiniBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 10, color: context.colors.success),
          const SizedBox(width: 4),
          Text(
            'Verified',
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: context.colors.success,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
