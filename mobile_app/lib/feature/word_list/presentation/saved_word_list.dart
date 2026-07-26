import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/infinity_scroll_widget.dart';
import '../../word/domain/word.dart';
import '../../word/presentation/word_tile.dart';
import '../../word/presentation/word_tile_shimmer.dart';
import '../application/saved_word_list_state.dart';

/// 保存した言葉の一覧。
class SavedWordList extends ConsumerWidget {
  const SavedWordList({super.key, this.emptyWidget = const SizedBox.shrink()});

  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InfinityScrollWidget(
      listStateNotifierProvider: savedWordListStateNotifierProvider,
      fetchMore: ref
          .read(savedWordListStateNotifierProvider.notifier)
          .fetchMore,
      tileBuilder: (item) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: WordTile(word: item as Word),
      ),
      contentPadding: EdgeInsets.zero,
      shimmerTile: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: WordTileShimmer(),
      ),
      shimmerTileNumber: 8,
      emptyWidget: emptyWidget,
    );
  }
}
