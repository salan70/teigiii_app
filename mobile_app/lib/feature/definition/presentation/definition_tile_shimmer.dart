import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/design_system/design_system.dart';

class DefinitionTileShimmer extends StatelessWidget {
  const DefinitionTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsShimmer.circular(width: 48, height: 48),
              Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DsShimmer.rectangular(height: 16, width: 160),
                        DsShimmer.rectangular(height: 16, width: 40),
                      ],
                    ),
                    Gap(8),
                    DsShimmer.rectangular(height: 24, width: 200),
                    Gap(8),
                    DsShimmer.rectangular(height: 72),
                    Gap(8),
                  ],
                ),
              ),
              Gap(8),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
