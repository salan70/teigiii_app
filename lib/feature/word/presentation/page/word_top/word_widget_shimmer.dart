import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class WordWidgetShimmer extends StatelessWidget {
  const WordWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          ShimmerWidget.rectangular(width: 80.w, height: 24.h),
          SizedBox(height: 8.h),
          ShimmerWidget.rectangular(width: 120.w, height: 16.h),
          SizedBox(height: 24.h),
          ShimmerWidget.rectangular(width: 32.w, height: 16.h),
        ],
      ),
    );
  }
}
