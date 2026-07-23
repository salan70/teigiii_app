import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../auth/application/auth_state.dart';
import '../../word/domain/word.dart';
import '../../word/presentation/word_tile.dart';
import '../../word/presentation/word_tile_shimmer.dart';
import '../application/community_dictionary_index_list_state.dart';
import '../application/personal_dictionary_word_navigation.dart';
import '../application/user_dictionary_index_list_state.dart';

/// タイムラインの contentPadding と同じ左右余白。
const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16);

/// あかさたな連絡先風辞書リスト。
///
/// [targetUserId] が null → みんなの辞書（community）。
/// 非 null → 指定ユーザーの辞書（自分の場合は定義済み言葉、他ユーザーは公開辞書）。
class DictionaryWordIndexList extends ConsumerWidget {
  const DictionaryWordIndexList({super.key, required this.targetUserId});

  final String? targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = targetUserId;
    final currentUserId = ref.watch(userIdProvider);
    final isMyDictionary = userId != null && userId == currentUserId;

    // あかさたなヘッダー全幅のため contentPadding は zero。
    // 言葉・shimmer はタイムラインと同じ左右 16。
    const shimmerTile = Padding(
      padding: _horizontalPadding,
      child: WordTileShimmer(),
    );

    Widget tileBuilder(dynamic item) =>
        _buildTile(context, ref, item, isMyDictionary: isMyDictionary);

    if (userId == null) {
      return InfinityScrollWidget(
        listStateNotifierProvider:
            communityDictionaryIndexListStateNotifierProvider,
        fetchMore: ref
            .read(communityDictionaryIndexListStateNotifierProvider.notifier)
            .fetchMore,
        tileBuilder: tileBuilder,
        contentPadding: EdgeInsets.zero,
        shimmerTile: shimmerTile,
        shimmerTileNumber: 12,
        emptyWidget: const SizedBox.shrink(),
      );
    }

    return InfinityScrollWidget(
      listStateNotifierProvider:
          userDictionaryIndexListStateNotifierProvider(userId),
      fetchMore: ref
          .read(userDictionaryIndexListStateNotifierProvider(userId).notifier)
          .fetchMore,
      tileBuilder: tileBuilder,
      contentPadding: EdgeInsets.zero,
      shimmerTile: shimmerTile,
      shimmerTileNumber: 12,
      emptyWidget: const SizedBox.shrink(),
    );
  }

  Widget _buildTile(
    BuildContext context,
    WidgetRef ref,
    dynamic item, {
    required bool isMyDictionary,
  }) {
    if (item is String) {
      return _SectionHeader(label: item);
    }
    if (item is Word) {
      return Padding(
        padding: _horizontalPadding,
        child: WordTile(
          word: item,
          showPostedDefinitionCount: !isMyDictionary,
          onTap: isMyDictionary
              ? () {
                  openPersonalDictionaryWord(
                    context: context,
                    ref: ref,
                    word: item,
                    userId: targetUserId!,
                  );
                }
              : null,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
