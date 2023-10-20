import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../../core/common_widget/infinite_scroll_bottom_indicator.dart';
import '../../application/definition_id_list_state.dart';
import '../../application/definition_service.dart';
import '../../util/definition_feed_type.dart';
import 'definition_tile.dart';
import 'definition_tile_shimmer.dart';

class DefinitionList extends ConsumerWidget {
  DefinitionList({
    super.key,
    required this.definitionFeedType,
  });

  final DefinitionFeedType definitionFeedType;
  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionIdListState =
        ref.watch(definitionIdListStateNotifierProvider(definitionFeedType));

    return asyncDefinitionIdListState.when(
      data: (data) {
        final definitionIdList = data.definitionIdList;

        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            // 画面の一番下までスクロールしたかどうかを判定
            if (notification.metrics.extentAfter == 0) {
              ref
                  .read(
                    definitionIdListStateNotifierProvider(definitionFeedType)
                        .notifier,
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
                    await ref
                        .read(definitionServiceProvider.notifier)
                        .refreshAll(definitionFeedType);
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
        debugPrint('エラー: $error');

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
                    await ref
                        .read(definitionServiceProvider.notifier)
                        .refreshAll(definitionFeedType);
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
                                ).notifier,
                              )
                              .fetchMore();
                        },
                        // TODO(me): UIいい感じにする
                        child: const Column(
                          children: [
                            Icon(Icons.warning),
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
        return ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < 4; i++) const DefinitionTileShimmer(),
          ],
        );
      },
    );
  }
}
