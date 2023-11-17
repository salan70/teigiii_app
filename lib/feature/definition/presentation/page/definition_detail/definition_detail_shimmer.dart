import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class DefinitionDeitailShimmer extends StatelessWidget {
  const DefinitionDeitailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerWidget.circular(width: 48.w, height: 48.h),
              SizedBox(width: 16.w),
              ShimmerWidget.rectangular(height: 16.h, width: 120.w),
            ],
          ),
          SizedBox(height: 16.h),
          ShimmerWidget.rectangular(height: 32.h, width: 300.w),
          SizedBox(height: 16.h),
          ShimmerWidget.rectangular(height: 120.h),
          SizedBox(height: 16.h),
          ShimmerWidget.rectangular(height: 16.h, width: 120.w),
          SizedBox(height: 4.h),
          ShimmerWidget.rectangular(height: 16.h, width: 120.w),
          SizedBox(height: 8.h),
          ShimmerWidget.rectangular(height: 20.h, width: 48.w),
        ],
      ),
    );
  }
}
