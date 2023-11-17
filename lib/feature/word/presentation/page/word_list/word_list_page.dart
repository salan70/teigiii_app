import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../../../util/constant/initial_main_group.dart';
import '../../../../../util/extension/scroll_controller_extension.dart';
import '../../../application/word_list_state_by_initial.dart';
import '../../../domain/word.dart';
import '../../component/word_tile.dart';
import '../../component/word_tile_shimmer.dart';

@RoutePage()
class WordListPage extends ConsumerWidget {
  const WordListPage({
    super.key,
    required this.selectedInitialSubGroup,
  });

  final InitialSubGroup selectedInitialSubGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordListProvider =
        wordListStateByInitialNotifierProvider(selectedInitialSubGroup.label);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text(selectedInitialSubGroup.label),
          onTap: () => PrimaryScrollController.of(context).scrollToTop(),
        ),
        leading: const BackIconButton(),
        leadingWidth: 48.w,
        flexibleSpace: InkWell(
          onTap: () => PrimaryScrollController.of(context).scrollToTop(),
        ),
      ),
      body: InfinityScrollWidget(
        listStateNotifierProvider: wordListProvider,
        fetchMore: ref.read(wordListProvider.notifier).fetchMore,
        tileBuilder: (item) => WordTile(word: item as Word),
        shimmerTile: const WordTileShimmer(),
        shimmerTileNumber: 10,
      ),
      floatingActionButton: const PostDefinitionFAB(),
    );
  }
}
