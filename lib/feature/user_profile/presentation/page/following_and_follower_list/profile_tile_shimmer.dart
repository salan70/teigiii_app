import 'package:flutter/material.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';

class ProfileTileShimmer extends StatelessWidget {
  const ProfileTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerWidget.circular(width: 48, height: 48),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ShimmerWidget.rectangular(
                          width: 120,
                          height: 24,
                        ),
                        ShimmerWidget.circular(
                          width: 144,
                          height: 40,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const ShimmerWidget.rectangular(height: 16),
                    const SizedBox(height: 8),
                    const ShimmerWidget.rectangular(height: 16),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerWidget.rectangular(width: 240, height: 16),
                    ),
                    const SizedBox(height: 24),
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
