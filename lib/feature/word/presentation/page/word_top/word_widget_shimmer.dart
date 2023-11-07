import 'package:flutter/material.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class WordWidgetShimmer extends StatelessWidget {
  const WordWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          ShimmerWidget.rectangular(width: 80, height: 24),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(width: 120, height: 16),
          SizedBox(height: 24),
          ShimmerWidget.rectangular(width: 32, height: 16),
        ],
      ),
    );
  }
}
