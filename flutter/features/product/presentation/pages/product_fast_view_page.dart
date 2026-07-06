import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/components/loading/skeleton_wrapper.dart';
import '../../../../design_system/components/loading/skeleton_card.dart';
import '../../../../design_system/components/buttons/app_button.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../application/bloc/product_summary_cubit.dart';
import '../../application/bloc/product_verification_cubit.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/trace_log.dart';

class ProductFastViewPage extends StatelessWidget {
  const ProductFastViewPage({super.key, required this.sku});

  final String sku;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProductRepository>(
      create: (_) => ProductRepositoryImpl(
        remoteDataSource: ProductRemoteDataSourceImpl(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductSummaryCubit>(
            create: (context) =>
                ProductSummaryCubit(context.read<ProductRepository>())
                  ..load(sku),
          ),
          BlocProvider<ProductVerificationCubit>(
            create: (context) =>
                ProductVerificationCubit(context.read<ProductRepository>()),
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: context.colors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('TRASE'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceM),
                child: BlocBuilder<ProductSummaryCubit, ProductSummaryState>(
                  builder: (context, state) {
                    if (state is ProductSummaryLoading ||
                        state is ProductSummaryInitial) {
                      return const SkeletonWrapper(
                        height: 220,
                        skeleton: SkeletonCard(),
                      );
                    }

                    if (state is ProductSummaryError) {
                      return _ProductSummaryErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<ProductSummaryCubit>().load(sku);
                        },
                      );
                    }

                    final product = (state as ProductSummaryLoaded).product;
                    final availabilityBadge = _buildAvailabilityBadge(
                      context,
                      product.availability,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlassContainer(
                          borderRadius: AppSpacing.radiusM,
                          padding: const EdgeInsets.all(AppSpacing.spaceL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productType.toUpperCase(),
                                style: AppTypography.textTheme.labelLarge
                                    ?.copyWith(
                                      color: context.colors.textSecondary,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.spaceS),
                              Text(
                                'SKU: ${product.sku}',
                                style: AppTypography.textTheme.headlineMedium
                                    ?.copyWith(
                                      color: context.colors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.spaceM),
                              Row(
                                children: [
                                  Text(
                                    'Price: RM ${product.price.toStringAsFixed(2)}',
                                    style: AppTypography.textTheme.titleMedium
                                        ?.copyWith(
                                          color: context.colors.textPrimary,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.spaceS),
                              Row(
                                children: [
                                  availabilityBadge,
                                  const SizedBox(width: AppSpacing.spaceS),
                                  Text(
                                    'In stock (${product.availability})',
                                    style: AppTypography.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context.colors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.spaceL),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: context.colors.textSecondary,
                                  ),
                                  const SizedBox(width: AppSpacing.spaceXS),
                                  Text(
                                    'Latest status: Available',
                                    style: AppTypography.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context.colors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceM),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: 'View Full Details',
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              context.push(
                                '/product/${product.sku}/details',
                                extra: {'verifyOnOpen': true},
                              );
                            },
                            variant: AppButtonVariant.filled,
                            size: AppButtonSize.medium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceS),
                        _VerificationSection(sku: sku),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(BuildContext context, int availability) {
    Color color;
    String label;

    if (availability > 50) {
      color = context.colors.success;
      label = 'Healthy';
    } else if (availability > 10) {
      color = context.colors.warning;
      label = 'Moderate';
    } else {
      color = context.colors.danger;
      label = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceS,
        vertical: AppSpacing.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: AppSpacing.spaceXS),
          Text(
            label,
            style: AppTypography.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSummaryErrorWidget extends StatelessWidget {
  const _ProductSummaryErrorWidget({
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.danger),
            const SizedBox(height: AppSpacing.spaceM),
            Text(
              'Connection Error',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceS),
            Text(
              message,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceL),
            AppButton(
              label: 'Retry',
              icon: Icons.refresh,
              onPressed: onRetry,
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationSection extends StatelessWidget {
  const _VerificationSection({required this.sku});
  final String sku;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductVerificationCubit, ProductVerificationState>(
      builder: (context, verificationState) {
        if (verificationState is ProductVerificationInitial) {
          return SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Verify on Blockchain',
              icon: Icons.verified_outlined,
              onPressed: () {
                context.read<ProductVerificationCubit>().verify(sku);
              },
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.medium,
            ),
          );
        }

        if (verificationState is ProductVerificationLoading) {
          return SizedBox(
            width: double.infinity,
            child: GlassContainer(
              borderRadius: AppSpacing.radiusM,
              padding: const EdgeInsets.all(AppSpacing.spaceL),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  CircularProgressIndicator(color: context.colors.primary),
                  const SizedBox(height: AppSpacing.spaceM),
                  Text(
                    'Verifying on blockchain...',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (verificationState is ProductVerificationError) {
          return SizedBox(
            width: double.infinity,
            child: GlassContainer(
              borderRadius: AppSpacing.radiusM,
              padding: const EdgeInsets.all(AppSpacing.spaceL),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: context.colors.danger, size: 32),
                  const SizedBox(height: AppSpacing.spaceS),
                  Text(
                    'Verification failed',
                    style: AppTypography.textTheme.titleSmall?.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceS),
                  Text(
                    verificationState.message,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.spaceM),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Retry',
                      icon: Icons.refresh,
                      onPressed: () {
                        context.read<ProductVerificationCubit>().verify(sku);
                      },
                      variant: AppButtonVariant.filled,
                      size: AppButtonSize.medium,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final loaded = verificationState as ProductVerificationLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: loaded.verified ? 'Re-verify on Blockchain' : 'Verify on Blockchain',
                icon: loaded.verified ? Icons.refresh : Icons.verified_outlined,
                onPressed: () {
                  context.read<ProductVerificationCubit>().verify(sku);
                },
                variant: AppButtonVariant.outlined,
                size: AppButtonSize.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceM),
            _VerificationDetails(
              traceLogs: loaded.traceLogs,
              verified: loaded.verified,
            ),
            const SizedBox(height: 150),
          ],
        );
      },
    );
  }
}

class _VerificationDetails extends StatelessWidget {
  const _VerificationDetails({required this.traceLogs, required this.verified});

  final List<TraceLog> traceLogs;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceL),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VerificationHeaderRow(verified: verified),
          const SizedBox(height: AppSpacing.spaceM),
          if (traceLogs.isEmpty)
            const _EmptyBlockchainState()
          else ...[
            ...traceLogs.take(3).map((log) {
              final isLogVerified = log.verified == true;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spaceS),
                child: _TraceLogMiniCard(log: log, isVerified: isLogVerified),
              );
            }),
            if (traceLogs.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.spaceS),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceM,
                    vertical: AppSpacing.spaceS,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.more_horiz, size: 16, color: context.colors.primary),
                      const SizedBox(width: AppSpacing.spaceS),
                      Text(
                        '+${traceLogs.length - 3} more transactions',
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _VerificationHeaderRow extends StatelessWidget {
  const _VerificationHeaderRow({required this.verified});
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: verified
              ? [
                  context.colors.success.withValues(alpha: 0.15),
                  context.colors.success.withValues(alpha: 0.05),
                ]
              : [
                  context.colors.primary.withValues(alpha: 0.15),
                  context.colors.primary.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: verified
                  ? context.colors.success.withValues(alpha: 0.2)
                  : context.colors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              verified ? Icons.verified : Icons.verified_outlined,
              color: verified ? context.colors.success : context.colors.primary,
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
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  verified
                      ? 'Product verified on-chain'
                      : 'Product verified on-chain',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (verified) const _VerifiedBadgePill(),
        ],
      ),
    );
  }
}

class _VerifiedBadgePill extends StatelessWidget {
  const _VerifiedBadgePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceS,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: context.colors.success,
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
        boxShadow: [
          BoxShadow(
            color: context.colors.success.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Colors.white, size: 10),
          const SizedBox(width: 2),
          Text(
            'VERIFIED',
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBlockchainState extends StatelessWidget {
  const _EmptyBlockchainState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      decoration: BoxDecoration(
        color: context.colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: context.colors.warning.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: context.colors.warning, size: 20),
          const SizedBox(width: AppSpacing.spaceS),
          Expanded(
            child: Text(
              'No blockchain records found. This product may not be registered on-chain.',
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TraceLogMiniCard extends StatelessWidget {
  const _TraceLogMiniCard({required this.log, required this.isVerified});
  final TraceLog log;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final date = log.timestamp.toLocal();
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      decoration: BoxDecoration(
        color: isVerified
            ? context.colors.success.withValues(alpha: 0.05)
            : context.colors.glassBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: isVerified
              ? context.colors.success.withValues(alpha: 0.2)
              : context.colors.glassBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _TraceLogIcon(isVerified: isVerified),
          const SizedBox(width: AppSpacing.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud, size: 12, color: context.colors.primary),
                    const SizedBox(width: 4),
                    Text(
                      log.blockchainNetwork.toUpperCase(),
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(context, log.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        log.status,
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(context, log.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 10, color: context.colors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '$dateStr at $timeStr',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isVerified)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.colors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.verified, size: 16, color: context.colors.success),
            ),
        ],
      ),
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

class _TraceLogIcon extends StatelessWidget {
  const _TraceLogIcon({required this.isVerified});
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isVerified
            ? context.colors.success.withValues(alpha: 0.15)
            : context.colors.textSecondary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isVerified ? Icons.check_circle : Icons.pending,
        color: isVerified ? context.colors.success : context.colors.textSecondary,
        size: 18,
      ),
    );
  }
}
