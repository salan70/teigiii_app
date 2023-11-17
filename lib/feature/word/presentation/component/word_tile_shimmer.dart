import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class WordTileShimmer extends StatelessWidget {
  const WordTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(top: 8, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangular(width: 160.w, height: 24.h),
              const Spacer(),
              ShimmerWidget.rectangular(width: 64.w, height: 24.h),
            ],
          ),
          SizedBox(height: 8.h),
          ShimmerWidget.rectangular(width: 120.w, height: 20.h),
          const Divider(),
        ],
      ),
    );
  }
}
