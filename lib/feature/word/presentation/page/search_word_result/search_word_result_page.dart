import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../../../util/extension/scroll_controller_extension.dart';
import '../../../application/word_list_state_by_search_word.dart';
import '../../../domain/word.dart';
import '../../component/search_word_text_field.dart';
import '../../component/word_tile.dart';
import '../../component/word_tile_shimmer.dart';

@RoutePage()
class SearchWordResultPage extends ConsumerWidget {
  const SearchWordResultPage({
    super.key,
    required this.searchWord,
  });

  final String searchWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordListProvider =
        wordListStateBySearchWordNotifierProvider(searchWord);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: const Text('検索結果'),
          onTap: () => PrimaryScrollController.of(context).scrollToTop(),
        ),
        leading: const BackIconButton(),
        flexibleSpace: InkWell(
          onTap: () => PrimaryScrollController.of(context).scrollToTop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: REdgeInsets.symmetric(
              vertical: 24,
              horizontal: 36,
            ),
            child: SearchWordTextField(defaultText: searchWord),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: InfinityScrollWidget(
              listStateNotifierProvider: wordListProvider,
              fetchMore: ref.read(wordListProvider.notifier).fetchMore,
              tileBuilder: (item) => WordTile(word: item as Word),
              shimmerTile: const WordTileShimmer(),
              shimmerTileNumber: 2,
            ),
          ),
        ],
      ),
      floatingActionButton: const PostDefinitionFAB(),
    );
  }
}
