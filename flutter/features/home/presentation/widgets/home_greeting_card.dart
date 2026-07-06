// import 'package:flutter/material.dart';
// import '../../../../core/utils/context_extensions.dart';
// import '../../../../design_system/components/glass/glass_container.dart';
// import '../../../../design_system/foundations/spacing.dart';
// import '../../../../design_system/components/loading/skeleton_wrapper.dart';

// class HomeGreetingCard extends StatelessWidget {
//   final int todayScanCount;
//   final bool isLoading;

//   const HomeGreetingCard({
//     super.key,
//     this.todayScanCount = 0,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return SkeletonWrapper(
//         height: 160,
//         skeleton: const _SkeletonGreetingCard(),
//       );
//     }

//     final primaryColor = context.colors.primary;

//     return GlassContainer(
//       borderRadius: AppSpacing.radiusM,
//       padding: EdgeInsets.zero, // Padding handled inside for layout freedom
//       child: Stack(
//         clipBehavior: Clip.antiAlias,
//         children: [
//           // 1. ATMOSPHERIC LIGHT SOURCES (Designer's touch)
//           Positioned(
//             top: -40,
//             right: -20,
//             child: _lightSource(primaryColor.withValues(alpha: 0.15), 150),
//           ),
//           Positioned(
//             bottom: -60,
//             left: -30,
//             child: _lightSource(
//               context.colors.secondary.withValues(alpha: 0.1),
//               180,
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(AppSpacing.spaceXL),
//             child: Row(
//               children: [
//                 // 2. TEXT CONTENT
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         _getGreeting(),
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w800,
//                           color: context.colors.textPrimary,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Ready to track your supply chain?',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: context.colors.textSecondary.withValues(
//                             alpha: 0.7,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       // Styled Scan Badge
//                       _buildScanBadge(context),
//                     ],
//                   ),
//                 ),

//                 // 3. PROFILE ORB
//                 _buildProfileOrb(context),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _lightSource(Color color, double size) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
//       ),
//     );
//   }

//   Widget _buildScanBadge(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: context.colors.primary.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(100), // Full Pill
//         border: Border.all(
//           color: context.colors.primary.withValues(alpha: 0.1),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.bolt, size: 14, color: context.colors.primary),
//           const SizedBox(width: 6),
//           Text(
//             todayScanCount > 0
//                 ? '$todayScanCount SCANS TODAY'
//                 : 'NO SCANS TODAY',
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w900,
//               letterSpacing: 0.5,
//               color: context.colors.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileOrb(BuildContext context) {
//     return Container(
//       width: 68,
//       height: 68,
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: context.colors.primary.withValues(alpha: 0.2),
//         ),
//       ),
//       child: CircleAvatar(
//         radius: 30,
//         backgroundColor: context.colors.primary.withValues(alpha: 0.1),
//         child: Icon(
//           Icons.person_2_outlined,
//           color: context.colors.primary,
//           size: 32,
//         ),
//       ),
//     );
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Good Morning';
//     if (hour < 17) return 'Good Afternoon';
//     return 'Good Evening';
//   }
// }

// // Skeleton loader
// class _SkeletonGreetingCard extends StatelessWidget {
//   const _SkeletonGreetingCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(AppSpacing.radiusM),
//       ),
//       padding: const EdgeInsets.all(AppSpacing.spaceL),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(width: 150, height: 28, color: Colors.white10),
//                 const SizedBox(height: AppSpacing.spaceS),
//                 Container(width: 220, height: 16, color: Colors.white10),
//                 const SizedBox(height: AppSpacing.spaceM),
//                 Container(width: 120, height: 20, color: Colors.white10),
//               ],
//             ),
//           ),
//           Container(
//             width: 64,
//             height: 64,
//             decoration: const BoxDecoration(
//               color: Colors.white10,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/components/loading/skeleton_wrapper.dart';

class HomeGreetingCard extends StatelessWidget {
  // This value comes from SharedPreferences via your parent widget/controller
  final int todayScanCount;
  final bool isLoading;

  const HomeGreetingCard({
    super.key,
    this.todayScanCount = 0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SkeletonWrapper(
        height: 160,
        skeleton: const _SkeletonGreetingCard(),
      );
    }

    final primaryColor = context.colors.primary;

    return GlassContainer(
      borderRadius: AppSpacing.radiusM,
      padding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          // 1. ATMOSPHERIC LIGHT SOURCES
          Positioned(
            top: -40,
            right: -20,
            child: _lightSource(primaryColor.withValues(alpha: 0.15), 150),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: _lightSource(
              context.colors.secondary.withValues(alpha: 0.1),
              180,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.spaceXL),
            child: Row(
              children: [
                // 2. TEXT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: context.colors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to track your supply chain?',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.colors.textSecondary.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Updated Badge Logic
                      _buildScanBadge(context),
                    ],
                  ),
                ),

                // 3. PROFILE ORB
                _buildProfileOrb(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lightSource(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }

  Widget _buildScanBadge(BuildContext context) {
    // Logic to handle singular/plural and empty states
    final bool hasScans = todayScanCount > 0;
    String label;
    IconData icon;

    if (todayScanCount == 0) {
      label = 'NO SCANS TODAY';
      icon = Icons.qr_code_scanner; // Prompt to scan
    } else if (todayScanCount == 1) {
      label = '1 SCAN TODAY';
      icon = Icons.bolt;
    } else {
      label = '$todayScanCount SCANS TODAY';
      icon = Icons.bolt;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // Highlight background slightly if there are scans
        color: hasScans
            ? context.colors.primary.withValues(alpha: 0.15)
            : context.colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: hasScans ? 0.2 : 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.colors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOrb(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: context.colors.primary.withValues(alpha: 0.1),
        child: Icon(
          Icons.person_2_outlined,
          color: context.colors.primary,
          size: 32,
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

// Skeleton loader
class _SkeletonGreetingCard extends StatelessWidget {
  const _SkeletonGreetingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      padding: const EdgeInsets.all(AppSpacing.spaceL),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 150, height: 28, color: Colors.white10),
                const SizedBox(height: AppSpacing.spaceS),
                Container(width: 220, height: 16, color: Colors.white10),
                const SizedBox(height: AppSpacing.spaceM),
                Container(width: 120, height: 20, color: Colors.white10),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
