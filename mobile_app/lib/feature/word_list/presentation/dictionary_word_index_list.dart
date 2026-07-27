import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../auth/application/auth_state.dart';
import '../../word/presentation/word_tile.dart';
import '../../word/presentation/word_tile_shimmer.dart';
import '../application/community_dictionary_index_list_state.dart';
import '../application/personal_dictionary_word_navigation.dart';
import '../application/user_dictionary_index_list_state.dart';
import '../domain/dictionary_index_entry.dart';

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

    Widget tileBuilder(DictionaryIndexEntry entry) =>
        _buildTile(context, ref, entry, isMyDictionary: isMyDictionary);

    if (userId == null) {
      return InfinityScrollWidget<DictionaryIndexEntry>(
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

    return InfinityScrollWidget<DictionaryIndexEntry>(
      listStateNotifierProvider: userDictionaryIndexListStateNotifierProvider(
        userId,
      ),
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
    DictionaryIndexEntry entry, {
    required bool isMyDictionary,
  }) {
    switch (entry) {
      case DictionaryIndexSectionHeader():
        return _SectionHeader(label: entry.label);
      case DictionaryIndexWordEntry():
        final word = entry.word;
        return Padding(
          padding: _horizontalPadding,
          child: WordTile(
            word: word,
            showPostedDefinitionCount: !isMyDictionary,
            onTap: isMyDictionary
                ? () {
                    openPersonalDictionaryWord(
                      context: context,
                      ref: ref,
                      word: word,
                      userId: targetUserId!,
                    );
                  }
                : null,
          ),
        );
    }
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
