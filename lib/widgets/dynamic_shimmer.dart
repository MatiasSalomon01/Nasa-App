import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DynamicShimmer extends StatelessWidget {
  DynamicShimmer({super.key, this.height, this.width});

  final double? height;
  final double? width;

  final LinearGradient lightGradient = LinearGradient(
    colors: [
      Colors.grey.shade400,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
    ],
  );

  final LinearGradient darkGradient = LinearGradient(
    colors: [
      Colors.grey.shade800,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade600,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: Theme.of(context).brightness == Brightness.dark
          ? darkGradient
          : lightGradient,
      child: Container(color: Colors.white, height: height, width: width),
    );
  }
}
