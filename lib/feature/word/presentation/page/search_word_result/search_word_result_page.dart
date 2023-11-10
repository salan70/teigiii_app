import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../../../../core/common_widget/infinite_scroll_bottom_indicator.dart';
import '../../../../../../util/logger.dart';
import '../../../application/word_list_state_by_search_word.dart';
import '../../component/word_search_text_field.dart';
import '../../component/word_tile.dart';

@RoutePage()
class SearchWordResultPage extends ConsumerWidget {
  SearchWordResultPage({
    super.key,
    required this.searchWord,
  });

  final String searchWord;
  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWordListState = ref.watch(
      wordListStateBySearchWordNotifierProvider(searchWord),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('検索結果'),
        leading: const BackIconButton(),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 36,
            ),
            child: WordSearchTextField(
              defaultText: searchWord,
            ),
          ),
          const SizedBox(height: 8),
          asyncWordListState.when(
            data: (wordListState) {
              final wordList = wordListState.wordList;

              return NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  // 画面の一番下までスクロールしたかどうかを判定
                  if (notification.metrics.extentAfter == 0) {
                    ref
                        .read(
                          wordListStateBySearchWordNotifierProvider(
                            searchWord,
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
                    shrinkWrap: true,
                    slivers: [
                      CupertinoSliverRefreshControl(
                        builder: buildCustomRefreshIndicator,
                        onRefresh: () async {
                          ref.invalidate(
                            wordListStateBySearchWordNotifierProvider(
                              searchWord,
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
        ],
      ),
    );
  }
}
