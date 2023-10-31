import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../../../core/common_widget/infinite_scroll_bottom_indicator.dart';
import '../../../../../util/logger.dart';
import '../../../application/word_list_state.dart';
import '../../../util/initial_main_group.dart';
import 'word_tile.dart';

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
      wordListStateNotifierProvider(selectedInitialSubGroup.label),
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
                      wordListStateNotifierProvider(
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
                        wordListStateNotifierProvider(
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
          return const Center(
            child: CupertinoActivityIndicator(),
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
