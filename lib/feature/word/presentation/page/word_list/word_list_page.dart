import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../../../core/common_widget/infinite_scroll_bottom_indicator.dart';
import '../../../../../util/constant/initial_main_group.dart';
import '../../../../../util/logger.dart';
import '../../../application/word_list_state_by_initial.dart';
import '../../component/word_tile.dart';
import '../../component/word_tile_shimmer.dart';

@RoutePage()
class WordListPage extends ConsumerWidget {
  WordListPage({
    super.key,
    required this.selectedInitialSubGroup,
  });

  final InitialSubGroup selectedInitialSubGroup;
  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWordListState = ref.watch(
      wordListStateByInitialNotifierProvider(selectedInitialSubGroup.label),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedInitialSubGroup.label),
        leading: const BackIconButton(),
      ),
      body: asyncWordListState.when(
        data: (wordListState) {
          final wordList = wordListState.wordList;

          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              // 画面の一番下までスクロールしたかどうかを判定
              if (notification.metrics.extentAfter == 0) {
                ref
                    .read(
                      wordListStateByInitialNotifierProvider(
                        selectedInitialSubGroup.label,
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
                        wordListStateByInitialNotifierProvider(
                          selectedInitialSubGroup.label,
                        ),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: wordList.length,
                        itemBuilder: (context, index) {
                          return WordTile(word: wordList[index]);
                        },
                      ),
                    ),
                  ),
                  InfiniteScrollBottomIndicator(
                    hasMore: wordListState.hasMore,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () {
          return Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return const WordTileShimmer();
              },
            ),
          );
        },
        error: (error, stackTrace) {
          logger.e('$error');

          // 取得済みのデータがない（初回読み込みが失敗した）場合のエラー表示
          // TODO(me): エラー画面を表示させる

          return Center(
            child: Text(error.toString()),
          );
        },
      ),
    );
  }
}
