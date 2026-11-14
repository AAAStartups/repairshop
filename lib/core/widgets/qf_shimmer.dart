import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QFShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const QFShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1F2D27) : const Color(0xFFE2EBE7),
      highlightColor: isDark ? const Color(0xFF2E3D37) : const Color(0xFFEEF5F2),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class QFShimmerList extends StatelessWidget {
  final int count;
  final double itemHeight;

  const QFShimmerList({super.key, this.count = 4, this.itemHeight = 80});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => QFShimmer(
        width: double.infinity,
        height: itemHeight,
        borderRadius: 16,
      ),
    );
  }
}
