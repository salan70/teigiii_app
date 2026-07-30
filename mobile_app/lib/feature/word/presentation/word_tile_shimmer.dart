import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/design_system/design_system.dart';

class WordTileShimmer extends StatelessWidget {
  const WordTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DsShimmer.rectangular(width: 160, height: 24),
              Spacer(),
              DsShimmer.rectangular(width: 64, height: 24),
            ],
          ),
          Gap(8),
          DsShimmer.rectangular(width: 120, height: 20),
          Divider(),
        ],
      ),
    );
  }
}
