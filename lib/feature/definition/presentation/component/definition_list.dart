import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../../core/common_widget/infinite_scroll_bottom_indicator.dart';
import '../../../../util/constant/initial_main_group.dart';
import '../../../../util/logger.dart';
import '../../application/definition_id_list_state.dart';
import '../../util/definition_feed_type.dart';
import 'definition_tile.dart';
import 'definition_tile_shimmer.dart';

class DefinitionList extends ConsumerWidget {
  DefinitionList({
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
  final int shimmerTileNumber;

  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionIdListState = ref.watch(
      definitionIdListStateNotifierProvider(
        definitionFeedType,
        wordId: wordId,
        targetUserId: targetUserId,
        initialSubGroup: initialSubGroup,
      ),
    );

    return asyncDefinitionIdListState.when(
      data: (data) {
        final definitionIdList = data.definitionIdList;

        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            // 画面の一番下までスクロールしたかどうかを判定
            if (notification.metrics.extentAfter == 0) {
              ref
                  .read(
                    definitionIdListStateNotifierProvider(
                      definitionFeedType,
                      wordId: wordId,
                      targetUserId: targetUserId,
                      initialSubGroup: initialSubGroup,
                    ).notifier,
                  )
                  .fetchMore();
              return true;
            }
            return false;
          },
          child: Scrollbar(
            key: globalKey,
            controller: scrollController,
            child: CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  builder: buildCustomRefreshIndicator,
                  onRefresh: () async {
                    ref.invalidate(
                      definitionIdListStateNotifierProvider(
                        definitionFeedType,
                        wordId: wordId,
                        targetUserId: targetUserId,
                        initialSubGroup: initialSubGroup,
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  // TODO(me): エラー時と全く同じListView.builderを使っているので共通化したい
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: definitionIdList.length,
                    itemBuilder: (context, index) {
                      return DefinitionTile(
                        definitionId: definitionIdList[index],
                      );
                    },
                  ),
                ),
                InfiniteScrollBottomIndicator(hasMore: data.hasMore),
              ],
            ),
          ),
        );
      },
      error: (error, _) {
        logger.e('$error');

        // 取得済みのデータがある場合、それを表示する
        if (asyncDefinitionIdListState.hasValue) {
          final definitionIdList =
              asyncDefinitionIdListState.value!.definitionIdList;

          return Scrollbar(
            key: globalKey,
            controller: scrollController,
            child: CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  builder: buildCustomRefreshIndicator,
                  onRefresh: () async {
                    ref.invalidate(
                      definitionIdListStateNotifierProvider(
                        definitionFeedType,
                        wordId: wordId,
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: definitionIdList.length,
                    itemBuilder: (context, index) {
                      return DefinitionTile(
                        definitionId: definitionIdList[index],
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 40),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(
                                definitionIdListStateNotifierProvider(
                                  definitionFeedType,
                                  wordId: wordId,
                                ).notifier,
                              )
                              .fetchMore();
                        },
                        // TODO(me): UIいい感じにする
                        child: const Column(
                          children: [
                            Icon(CupertinoIcons.exclamationmark_triangle_fill),
                            Text('再読み込み'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // 取得済みのデータがない（初回読み込みが失敗した）場合のエラー表示
        // TODO(me): エラー画面を表示させる
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      },
      loading: () {
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shimmerTileNumber,
          itemBuilder: (context, index) {
            return const DefinitionTileShimmer();
          },
        );
      },
    );
  }
}
