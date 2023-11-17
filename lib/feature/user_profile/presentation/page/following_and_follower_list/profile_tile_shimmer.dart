import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class ProfileTileShimmer extends StatelessWidget {
  const ProfileTileShimmer({super.key});

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
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.rectangular(
                          width: 120.w,
                          height: 24.h,
                        ),
                        ShimmerWidget.circular(
                          width: 144.w,
                          height: 40.h,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48).r,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ShimmerWidget.rectangular(height: 16.w),
                    SizedBox(height: 8.h),
                    ShimmerWidget.rectangular(height: 16.h),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          ShimmerWidget.rectangular(width: 240.w, height: 16.h),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
