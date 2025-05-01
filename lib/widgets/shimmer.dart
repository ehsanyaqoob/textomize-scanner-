import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;

  const ShimmerWidget({
    Key? key,
    required this.height,
    this.width = double.infinity,
    this.margin = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
