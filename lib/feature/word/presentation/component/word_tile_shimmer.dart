import 'package:flutter/material.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class WordTileShimmer extends StatelessWidget {
  const WordTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangular(width: 160, height: 24),
              Spacer(),
              ShimmerWidget.rectangular(width: 64, height: 24),
            ],
          ),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(width: 120, height: 20),
          Divider(),
        ],
      ),
    );
  }
}
