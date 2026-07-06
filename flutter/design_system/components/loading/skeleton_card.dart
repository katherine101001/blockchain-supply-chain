import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire card in a ConstrainedBox to give max width
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600), // optional max width
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // shrink-wrap vertically
            children: [
              // Title
              Container(
                height: 20,
                width: 200, // fixed width or % of parent
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              // Subtitle
              Container(height: 14, width: 150, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              // Full-width line
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              // Chips / tags
              Wrap(
                spacing: 8, // gap between tags
                runSpacing: 4,
                children: List.generate(
                  3,
                  (index) => Container(
                    height: 14,
                    width: 50, // fixed width for chip
                    color: Colors.grey.shade400,
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
