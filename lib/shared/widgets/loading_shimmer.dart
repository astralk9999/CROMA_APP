import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BoxShape shape;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.white, shape: shape),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: const LoadingShimmer()),
        const SizedBox(height: 12),
        const LoadingShimmer(height: 16, width: 120),
        const SizedBox(height: 8),
        const LoadingShimmer(height: 14, width: 80),
      ],
    );
  }
}
