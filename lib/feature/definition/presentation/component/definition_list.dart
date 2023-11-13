import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../../util/constant/initial_main_group.dart';
import '../../application/definition_id_list_state.dart';
import '../../util/definition_feed_type.dart';
import 'definition_tile.dart';
import 'definition_tile_shimmer.dart';

class DefinitionList extends ConsumerWidget {
  const DefinitionList({
    super.key,
    required this.definitionFeedType,
    this.wordId,
    this.targetUserId,
    this.initialSubGroup,
    this.shimmerTileNumber = 8,
  });

  final DefinitionFeedType definitionFeedType;
  final String? wordId;
  final String? targetUserId;
  final InitialSubGroup? initialSubGroup;

  /// ローディング時に何タイル分のshimmerを表示させるか
  ///
  /// デフォルト値は恐らく画面を埋め尽くされるであろう数として8を設定
  final int shimmerTileNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionIdListProvider = definitionIdListStateNotifierProvider(
      definitionFeedType,
      wordId: wordId,
      targetUserId: targetUserId,
      initialSubGroup: initialSubGroup,
    );

    return InfinityScrollWidget(
      listStateNotifierProvider: definitionIdListProvider,
      fetchMore: ref.read(definitionIdListProvider.notifier).fetchMore,
      tileBuilder: (item) {
        return DefinitionTile(definitionId: item as String);
      },
      shimmerTile: const DefinitionTileShimmer(),
      shimmerTileNumber: shimmerTileNumber,
    );
  }
}
