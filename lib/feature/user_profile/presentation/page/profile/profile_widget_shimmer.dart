import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class ProfileWidgetShimmer extends StatelessWidget {
  const ProfileWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Row(
            children: [
              ShimmerWidget.circular(width: 72.w, height: 72.h),
              const Spacer(),
            ],
          ),
          SizedBox(height: 16.h),
          ShimmerWidget.rectangular(width: 240.w, height: 24.h),
          SizedBox(height: 16.h),
          ShimmerWidget.rectangular(height: 16.h),
          SizedBox(height: 8.h),
          ShimmerWidget.rectangular(height: 16.w),
          SizedBox(height: 8.h),
          ShimmerWidget.rectangular(width: 240.w, height: 16.h),
          SizedBox(height: 24.h),
          Align(
            alignment: Alignment.topCenter,
            child: ShimmerWidget.circular(
              width: 144.w,
              height: 40.h,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48).r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
