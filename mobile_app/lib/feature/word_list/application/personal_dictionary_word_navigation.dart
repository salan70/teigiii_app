import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../definition_list/repository/definition_id_list_repository.dart';
import '../../word/domain/word.dart';

/// あなたの辞書の言葉タップ先を決める。
///
/// - 投稿数 0: 遷移しない（下書きのみ等）
/// - 投稿数 1: 定義詳細へ直接遷移（ID 取得が必要）
/// - 投稿数 2+: 自分の定義一覧へ遷移
enum PersonalDictionaryWordNavKind { none, detail, list }

PersonalDictionaryWordNavKind personalDictionaryWordNavKind(
  int postedDefinitionCount,
) {
  if (postedDefinitionCount <= 0) {
    return PersonalDictionaryWordNavKind.none;
  }
  if (postedDefinitionCount == 1) {
    return PersonalDictionaryWordNavKind.detail;
  }
  return PersonalDictionaryWordNavKind.list;
}

Future<void> openPersonalDictionaryWord({
  required BuildContext context,
  required WidgetRef ref,
  required Word word,
  required String userId,
}) async {
  switch (personalDictionaryWordNavKind(word.postedDefinitionCount)) {
    case PersonalDictionaryWordNavKind.none:
      return;
    case PersonalDictionaryWordNavKind.list:
      await context.pushRoute(
        UserWordDefinitionListRoute(
          targetUserId: userId,
          wordId: word.id,
          wordLabel: word.word,
        ),
      );
      return;
    case PersonalDictionaryWordNavKind.detail:
      final page = await ref
          .read(definitionIdListRepositoryProvider)
          .fetchForUserWord(userId, word.id, null);
      if (!context.mounted || page.list.isEmpty) {
        return;
      }
      await context.pushRoute(
        DefinitionDetailRoute(definitionId: page.list.first),
      );
  }
}
