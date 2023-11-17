import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common_widget/shimmer_widget.dart';

class DefinitionTileShimmer extends StatelessWidget {
  const DefinitionTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: REdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.circular(width: 48.w, height: 48.h),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.rectangular(
                          height: 16.h,
                          width: 160.w,
                        ),
                        ShimmerWidget.rectangular(
                          height: 16.h,
                          width: 40.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ShimmerWidget.rectangular(
                      height: 24.h,
                      width: 200.w,
                    ),
                    SizedBox(height: 8.h),
                    ShimmerWidget.rectangular(height: 72.h),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
