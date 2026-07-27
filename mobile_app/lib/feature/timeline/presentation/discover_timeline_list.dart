import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../feature/definition/presentation/definition_tile.dart';
import '../../../feature/definition/presentation/definition_tile_shimmer.dart';
import '../application/discover_timeline_state.dart';
import '../domain/discover_feed_entry.dart';
import 'word_registered_tile.dart';

class DiscoverTimelineList extends ConsumerWidget {
  const DiscoverTimelineList({super.key, required this.emptyWidget});

  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InfinityScrollWidget<DiscoverFeedEntry>(
      listStateNotifierProvider: discoverTimelineStateNotifierProvider,
      fetchMore: ref
          .read(discoverTimelineStateNotifierProvider.notifier)
          .fetchMore,
      tileBuilder: (entry) => switch (entry) {
        DiscoverFeedDefinitionEntry() => DefinitionTile(
          definitionId: entry.definition.id,
        ),
        DiscoverFeedWordRegisteredEntry() => WordRegisteredTile(
          activity: entry.activity,
        ),
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shimmerTile: const DefinitionTileShimmer(),
      shimmerTileNumber: 8,
      emptyWidget: emptyWidget,
      showBannerAd: true,
    );
  }
}
