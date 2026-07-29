import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/design_system/design_system.dart';

class ProfileTileShimmer extends StatelessWidget {
  const ProfileTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DsShimmer.circular(width: 48, height: 48),
              const Gap(8),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const DsShimmer.rectangular(width: 120, height: 24),
                        DsShimmer.pill(width: 144, height: 40),
                      ],
                    ),
                    const Gap(8),
                    const DsShimmer.rectangular(height: 16),
                    const Gap(8),
                    const DsShimmer.rectangular(height: 16),
                    const Gap(8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: DsShimmer.rectangular(width: 240, height: 16),
                    ),
                    const Gap(24),
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
