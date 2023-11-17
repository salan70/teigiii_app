import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        );

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceVariant,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Container(
          height: height,
          width: width,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            shape: shapeBorder,
          ),
        ),
      );
}
