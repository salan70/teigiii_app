import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../../definition/presentation/component/definition_list.dart';
import '../../../../definition/util/definition_feed_type.dart';
import '../../../application/word_state.dart';
import 'word_widget.dart';

@RoutePage()
class WordTopPage extends ConsumerWidget {
  const WordTopPage({
    super.key,
    required this.wordId,
  });

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              return <Widget>[
                SliverAppBar(
                  forceElevated: true,
                  floating: true,
                  title: Consumer(
                    builder: (context, ref, _) {
                      return ref.watch(wordProvider(wordId)).maybeWhen(
                            data: (word) {
                              return Text(
                                word.word,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                            orElse: () => const Text(''),
                          );
                    },
                  ),
                  leading: const BackIconButton(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [WordWidget(wordId: wordId)],
                  ),
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
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                DefinitionList(
                  definitionFeedType:
                      DefinitionFeedType.wordTopOrderByCreatedAt,
                  wordId: wordId,
                  shimmerTileNumber: 2,
                ),
                DefinitionList(
                  definitionFeedType:
                      DefinitionFeedType.wordTopOrderByLikesCount,
                  wordId: wordId,
                  shimmerTileNumber: 2,
                ),
              ],
            ),
          ),
          floatingActionButton: const PostDefinitionFAB(definition: null),
        ),
      ),
    );
  }
}
