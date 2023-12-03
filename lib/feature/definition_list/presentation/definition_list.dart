import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../definition/presentation/definition_tile.dart';
import '../../definition/presentation/definition_tile_shimmer.dart';
import '../appication/definition_id_list_state.dart';
import '../util/definition_feed_type.dart';

class DefinitionList extends ConsumerWidget {
  const DefinitionList({
    super.key,
    required this.definitionFeedType,
    required this.emptyWidget,
    this.wordId,
    this.targetUserId,
    this.initialSubGroup,
    this.shimmerTileNumber = 8,
    this.additionalOnRefresh,
  });

  final DefinitionFeedType definitionFeedType;

  /// 扱う state の中身が空の場合に表示させる Widget 。
  final Widget? emptyWidget;

  final String? wordId;
  final String? targetUserId;
  final InitialSubGroup? initialSubGroup;

  /// ローディング時に何タイル分の shimmer を表示させるか。
  ///
  /// デフォルト値は恐らく画面を埋め尽くされるであろう数として8を設定。
  final int shimmerTileNumber;

  /// スワイプリフレッシュ時、[definitionIdListStateNotifierProvider] の invalidate
  /// 以外に行う処理。
  ///
  /// null の場合は、[definitionIdListStateNotifierProvider] の invalidate のみ行う。
  final VoidCallback? additionalOnRefresh;

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shimmerTile: const DefinitionTileShimmer(),
      shimmerTileNumber: shimmerTileNumber,
      emptyWidget: emptyWidget,
      showBannerAd: true,
      additionalOnRefresh: additionalOnRefresh,
    );
  }
}
