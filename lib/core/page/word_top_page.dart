import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../../feature/word/application/word_state.dart';
import '../../feature/word/presentation/word_page_shimmer.dart';
import '../../feature/word/presentation/word_widget.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../../util/logger.dart';
import '../common_widget/button/post_definition_fab.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../common_widget/stickey_tab_bar_deligate.dart';

@RoutePage()
class WordTopPage extends ConsumerWidget {
  const WordTopPage({
    super.key,
    required this.wordId,
  });

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWord = ref.watch(wordProvider(wordId));

    return DefaultTabController(
      length: 2,
      child: asyncWord.when(
        data: (word) {
          if (word == null) {
            // * 該当するWordがない場合
            // [WordTopPage] から [DefinitionDetailPage] に遷移し、投稿削除/編集して
            // 戻ってきた場合にnullになる想定
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_circle_fill,
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    const Gap(16),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '対象の語句が見つかりませんでした。',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Gap(8),
                    const Text('投稿が0件になり、語句が削除された可能性があります。'),
                  ],
                ),
              ),
            );
          }

          // * 該当するWordがある場合
          return Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool _) {
                  return <Widget>[
                    SliverAppBar(
                      forceElevated: true,
                      floating: true,
                      title: Text(
                        word.word,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SliverList(
                      delegate:
                          SliverChildListDelegate([WordWidget(word: word)]),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: StickyTabBarDelegate(
                        tabBar: TabBar(
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                          indicatorWeight: 3,
                          tabs: const [
                            Tab(text: '投稿順'),
                            Tab(text: 'いいね数順'),
                          ],
                          onTap: (_) {
                            if (DefaultTabController.of(context)
                                .indexIsChanging) {
                              // * タブを切り替えた場合
                              return;
                            }

                            // * 同じタブをタップした場合
                            PrimaryScrollController.of(context).scrollToTop();
                          },
                        ),
                      ),
                    ),
                  ];
                },
                // WordTopは定義が投稿されていないと開けないので、emptyWidgetはnull
                body: TabBarView(
                  children: [
                    DefinitionList(
                      definitionFeedType:
                          DefinitionFeedType.wordTopOrderByCreatedAt,
                      wordId: wordId,
                      shimmerTileNumber: 2,
                      emptyWidget: null,
                      // TODO(me): スワイプリフレッシュ時、インジケータの表示がなめらかじゃないの直したい。
                      additionalOnRefresh: () =>
                          ref.invalidate(wordProvider(wordId)),
                    ),
                    DefinitionList(
                      definitionFeedType:
                          DefinitionFeedType.wordTopOrderByLikesCount,
                      wordId: wordId,
                      shimmerTileNumber: 2,
                      emptyWidget: null,
                      additionalOnRefresh: () =>
                          ref.invalidate(wordProvider(wordId)),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: const PostDefinitionFAB(),
          );
        },
        loading: () => Scaffold(
          appBar: AppBar(),
          body: const Column(
            children: [
              WordPageShimmer(),
            ],
          ),
        ),
        error: (error, stackTrace) {
          logger.e('語句[$wordId]の取得に失敗しました。'
              'error: $error, stackTrace: $stackTrace');

          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: asyncWord.isRefreshing
                    ? // エラー発生後の再読み込み中の場合
                    const CupertinoActivityIndicator()
                    : ErrorAndRetryWidget(
                        onRetry: () => ref.invalidate(wordProvider(wordId)),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
