import 'package:flutter/material.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class DefinitionDeitailShimmer extends StatelessWidget {
  const DefinitionDeitailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerWidget.circular(width: 48, height: 48),
              SizedBox(width: 16),
              ShimmerWidget.rectangular(height: 16, width: 120),
            ],
          ),
          SizedBox(height: 16),
          ShimmerWidget.rectangular(height: 32, width: 300),
          SizedBox(height: 16),
          ShimmerWidget.rectangular(height: 120),
          SizedBox(height: 16),
          ShimmerWidget.rectangular(height: 16, width: 120),
          SizedBox(height: 4),
          ShimmerWidget.rectangular(height: 16, width: 120),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 20, width: 48),
        ],
      ),
    );
  }
}
