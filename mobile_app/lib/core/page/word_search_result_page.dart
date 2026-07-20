import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/definition/presentation/post_definition_fab.dart';
import '../../feature/word/domain/word.dart';
import '../../feature/word/presentation/word_tile.dart';
import '../../feature/word/presentation/word_tile_shimmer.dart';
import '../../feature/word_list/application/word_list_state_by_search_word.dart';
import '../../feature/word_list/presentation/search_word_text_field.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../common_widget/infinity_scroll_widget.dart';
import '../common_widget/simple_empty_widget.dart';

@RoutePage()
class WordSearchResultPage extends ConsumerWidget {
  const WordSearchResultPage({super.key, required this.searchWord});

  final String searchWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordListProvider = wordListStateBySearchWordNotifierProvider(
      searchWord,
    );

    String generateEmptyMessage(String label) {
      final messageList = [
        '検索した語句は見つかりませんでした。',
        '検索した語句は見つかりませんでした。。\nどうでしょう、あなたが投稿しませんか？😎',
      ];

      // ランダムでメッセージを返す
      return messageList[Random().nextInt(messageList.length)];
    }

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool _) {
            return <Widget>[
              SliverAppBar(
                forceElevated: true,
                pinned: true,
                title: InkWell(
                  child: const Text('検索結果'),
                  onTap: () =>
                      PrimaryScrollController.of(context).scrollToTop(),
                ),
                leading: const BackButton(),
                flexibleSpace: InkWell(
                  onTap: () =>
                      PrimaryScrollController.of(context).scrollToTop(),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              const Gap(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: SearchWordTextField(defaultText: searchWord),
              ),
              const Gap(32),
              Expanded(
                child: InfinityScrollWidget(
                  listStateNotifierProvider: wordListProvider,
                  fetchMore: ref.read(wordListProvider.notifier).fetchMore,
                  tileBuilder: (item) => WordTile(word: item as Word),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shimmerTile: const WordTileShimmer(),
                  shimmerTileNumber: 2,
                  emptyWidget: SimpleEmptyWidget(
                    message: generateEmptyMessage(searchWord),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const PostDefinitionFAB(),
    );
  }
}
