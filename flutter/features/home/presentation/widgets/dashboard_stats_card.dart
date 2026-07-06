// import 'package:flutter/material.dart';
// import '../../../../core/utils/context_extensions.dart';
// import '../../../../design_system/components/glass/glass_container.dart';
// import '../../../../design_system/foundations/spacing.dart';
// import '../../../../design_system/foundations/typography.dart';
// import '../../../../design_system/components/loading/skeleton_wrapper.dart';
// import '../../../../design_system/components/loading/skeleton_card.dart';
// import '../../domain/entities/product_scan.dart';

// class DashboardStatsCard extends StatelessWidget {
//   final List<ProductScan>? recentScans;
//   final bool isLoading;

//   const DashboardStatsCard({
//     super.key,
//     this.recentScans,
//     this.isLoading = false,
//   });

//   int get todayScans =>
//       recentScans
//           ?.where(
//             (s) =>
//                 s.scannedAt.year == DateTime.now().year &&
//                 s.scannedAt.month == DateTime.now().month &&
//                 s.scannedAt.day == DateTime.now().day,
//           )
//           .length ??
//       0;

//   int get verifiedScans => recentScans?.where((s) => s.isVerified).length ?? 0;

//   int get pendingVerifications =>
//       recentScans?.where((s) => !s.isVerified).length ?? 0;

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return SkeletonWrapper(height: 120, skeleton: const SkeletonCard());
//     }

//     final total = recentScans?.length ?? 0;
//     final today = todayScans;
//     final verified = verifiedScans;
//     final pending = pendingVerifications;

//     return GlassContainer(
//       borderRadius: AppSpacing.radiusM,
//       padding: const EdgeInsets.all(AppSpacing.spaceM),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(AppSpacing.spaceS),
//                 decoration: BoxDecoration(
//                   color: context.colors.primary.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(AppSpacing.radiusM),
//                 ),
//                 child: Icon(
//                   Icons.dashboard_outlined,
//                   color: context.colors.primary,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: AppSpacing.spaceM),
//               Expanded(
//                 child: Text(
//                   'Today\'s Overview',
//                   style: AppTypography.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: context.colors.textPrimary,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: AppSpacing.spaceM),

//           // Stats row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: _ModernStat(
//                   icon: Icons.qr_code_scanner,
//                   value: total.toString(),
//                   label: 'Total Scans',
//                   color: context.colors.primary,
//                 ),
//               ),
//               Expanded(
//                 child: _ModernStat(
//                   icon: Icons.verified,
//                   value: verified.toString(),
//                   label: 'Verified',
//                   color: context.colors.success,
//                 ),
//               ),
//               Expanded(
//                 child: _ModernStat(
//                   icon: Icons.today,
//                   value: today.toString(),
//                   label: 'Today',
//                   color: context.colors.info,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: AppSpacing.spaceM),

//           // Pending / Verified Notice
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(
//               vertical: AppSpacing.spaceS,
//               horizontal: AppSpacing.spaceM,
//             ),
//             decoration: BoxDecoration(
//               color: pending > 0
//                   ? context.colors.warning.withValues(alpha: 0.1)
//                   : context.colors.success.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(AppSpacing.radiusM),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   pending > 0 ? Icons.pending_actions : Icons.check_circle,
//                   size: 16,
//                   color: pending > 0
//                       ? context.colors.warning
//                       : context.colors.success,
//                 ),
//                 const SizedBox(width: AppSpacing.spaceS),
//                 Flexible(
//                   child: Text(
//                     pending > 0
//                         ? '$pending scans pending verification'
//                         : 'All scans verified',
//                     style: AppTypography.textTheme.bodyMedium?.copyWith(
//                       fontWeight: FontWeight.w500,
//                       color: pending > 0
//                           ? context.colors.warning
//                           : context.colors.success,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Modern Stat: icon left, number, label below, centered
// class _ModernStat extends StatelessWidget {
//   final String value;
//   final String label;
//   final IconData icon;
//   final Color color;

//   const _ModernStat({
//     required this.value,
//     required this.label,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Number + Icon
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(icon, color: color, size: 20),
//             const SizedBox(width: 6),
//             Text(
//               value,
//               style: AppTypography.textTheme.headlineMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 28,
//                 color: color,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: AppTypography.textTheme.bodyMedium?.copyWith(
//             color: context.colors.textSecondary,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../../../design_system/components/loading/skeleton_wrapper.dart';
import '../../../../design_system/components/loading/skeleton_card.dart';
import '../../domain/entities/product_scan.dart';

class DashboardStatsCard extends StatelessWidget {
  final List<ProductScan>? recentScans;
  final bool isLoading;

  const DashboardStatsCard({
    super.key,
    this.recentScans,
    this.isLoading = false,
  });

  int get todayScans =>
      recentScans
          ?.where(
            (s) =>
                s.scannedAt.year == DateTime.now().year &&
                s.scannedAt.month == DateTime.now().month &&
                s.scannedAt.day == DateTime.now().day,
          )
          .length ??
      0;

  int get verifiedScans => recentScans?.where((s) => s.isVerified).length ?? 0;

  int get pendingVerifications =>
      recentScans?.where((s) => !s.isVerified).length ?? 0;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SkeletonWrapper(height: 120, skeleton: const SkeletonCard());
    }

    final total = recentScans?.length ?? 0;
    final today = todayScans;
    final verified = verifiedScans;
    final pending = pendingVerifications;

    // --- LOGIC FIX START ---
    // Determine the status appearance before the widget tree
    final Color statusColor;
    final IconData statusIcon;
    final String statusText;

    if (total == 0) {
      // Case 1: No scans at all (Empty State)
      statusColor = context.colors.textSecondary;
      statusIcon = Icons.info_outline;
      statusText = 'No scans recorded';
    } else if (pending > 0) {
      // Case 2: Pending items exist
      statusColor = context.colors.warning;
      statusIcon = Icons.pending_actions;
      statusText = '$pending scans pending verification';
    } else {
      // Case 3: Items exist and all are verified
      statusColor = context.colors.success;
      statusIcon = Icons.check_circle;
      statusText = 'All scans verified';
    }
    // --- LOGIC FIX END ---

    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.spaceS),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                child: Icon(
                  Icons.dashboard_outlined,
                  color: context.colors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceM),
              Expanded(
                child: Text(
                  'Today\'s Overview',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.spaceM),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _ModernStat(
                  icon: Icons.qr_code_scanner,
                  value: total.toString(),
                  label: 'Total Scans',
                  color: context.colors.primary,
                ),
              ),
              Expanded(
                child: _ModernStat(
                  icon: Icons.verified,
                  value: verified.toString(),
                  label: 'Verified',
                  color: context.colors.success,
                ),
              ),
              Expanded(
                child: _ModernStat(
                  icon: Icons.today,
                  value: today.toString(),
                  label: 'Today',
                  color: context.colors.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.spaceM),

          // Status Notice (Updated to use calculated variables)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.spaceS,
              horizontal: AppSpacing.spaceM,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 16, color: statusColor),
                const SizedBox(width: AppSpacing.spaceS),
                Flexible(
                  child: Text(
                    statusText,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: statusColor,
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
    );
  }
}

// ... existing _ModernStat class below ...
class _ModernStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _ModernStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              value,
              style: AppTypography.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
