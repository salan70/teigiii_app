import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class ProfileWidgetShimmer extends StatelessWidget {
  const ProfileWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          const Row(
            children: [
              ShimmerWidget.circular(width: 72, height: 72),
              Spacer(),
              
            ],
          ),
          const Gap(16),
          const ShimmerWidget.rectangular(width: 240, height: 24),
          const Gap(16),
          const ShimmerWidget.rectangular(height: 16),
          const Gap(8),
          const ShimmerWidget.rectangular(height: 16),
          const Gap(8),
          const ShimmerWidget.rectangular(width: 240, height: 16),
          const Gap(24),
          Align(
            alignment: Alignment.topCenter,
            child: ShimmerWidget.circular(
              width: 144,
              height: 40,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
