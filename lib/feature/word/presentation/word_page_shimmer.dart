import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';
import '../../definition/presentation/definition_tile_shimmer.dart';

class WordPageShimmer extends StatelessWidget {
  const WordPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(24),
              const ShimmerWidget.rectangular(width: 160, height: 24),
              const Gap(8),
              const ShimmerWidget.rectangular(width: 120, height: 16),
              const Gap(26),
              const ShimmerWidget.rectangular(width: 32, height: 16),
              const Gap(16),
              Center(
                child: ShimmerWidget.circular(
                  width: 232,
                  height: 40,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
              ),
              const Gap(32),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShimmerWidget.rectangular(width: 64, height: 24),
                  ShimmerWidget.rectangular(width: 64, height: 24),
                ],
              ),
            ],
          ),
        ),
        const Gap(16),
        const DefinitionTileShimmer(),
      ],
    );
  }
}
