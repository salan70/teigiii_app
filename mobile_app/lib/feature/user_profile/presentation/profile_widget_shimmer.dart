import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/design_system/design_system.dart';

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
            children: [DsShimmer.circular(width: 72, height: 72), Spacer()],
          ),
          const Gap(16),
          const DsShimmer.rectangular(width: 240, height: 24),
          const Gap(16),
          const DsShimmer.rectangular(height: 16),
          const Gap(8),
          const DsShimmer.rectangular(height: 16),
          const Gap(8),
          const DsShimmer.rectangular(width: 240, height: 16),
          const Gap(24),
          Align(
            alignment: Alignment.topCenter,
            child: DsShimmer.pill(width: 144, height: 40),
          ),
        ],
      ),
    );
  }
}
