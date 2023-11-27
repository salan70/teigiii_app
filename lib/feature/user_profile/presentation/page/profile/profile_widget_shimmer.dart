import 'package:flutter/material.dart';

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
          const SizedBox(height: 24),
          const Row(
            children: [
              ShimmerWidget.circular(width: 72, height: 72),
              Spacer(),
              
            ],
          ),
          const SizedBox(height: 16),
          const ShimmerWidget.rectangular(width: 240, height: 24),
          const SizedBox(height: 16),
          const ShimmerWidget.rectangular(height: 16),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 16),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(width: 240, height: 16),
          const SizedBox(height: 24),
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
