import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../../../util/constant/initial_main_group.dart';
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
        title: Text(selectedInitialSubGroup.label),
        leading: const BackIconButton(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: InfinityScrollWidget(
              listStateNotifierProvider: wordListProvider,
              fetchMore: ref.read(wordListProvider.notifier).fetchMore,
              tileBuilder: (item) => WordTile(word: item as Word),
              shimmerTile: const WordTileShimmer(),
              shimmerTileNumber: 10,
            ),
          ),
        ],
      ),
    );
  }
}
