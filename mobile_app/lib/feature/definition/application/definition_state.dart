import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user_profile/application/user_profile_state.dart';
import '../domain/definition.dart';
import '../repository/fetch_definition_repository.dart';
import 'definition_seed_store.dart';

part 'definition_state.g.dart';

/// 定義 1 件を提供する provider。
///
/// [definitionSeedStoreProvider] にシードがある場合は、それをそのまま返す。
/// この経路では API 取得も [userProfileProvider] の watch も行わない。
/// そのため、表示中に著者がプロフィール（名前・アイコン）を変更しても、
/// リフレッシュされるまでは一覧取得時点の値を表示し続ける。
/// N+1 リクエストの解消を優先し、この挙動は許容している。
///
/// この provider をリフレッシュする場合は、`ref.invalidate` を直接呼ばず
/// 必ず `refreshDefinition` を使うこと。
/// シードが残ったままだと invalidate しても古い値が返るため。
@riverpod
Future<Definition> definition(DefinitionRef ref, String definitionId) async {
  final seeded = ref.read(definitionSeedStoreProvider).read(definitionId);
  if (seeded != null) {
    return seeded;
  }

  final definition = await ref
      .read(fetchDefinitionRepositoryProvider)
      .fetchDefinition(definitionId);

  /// プロフィール更新に合わせて更新されるよう監視
  final userProfile = await ref.watch(
    userProfileProvider(definition.authorId).future,
  );

  return definition.copyWith(
    authorName: userProfile.name,
    authorImageUrl: userProfile.avatarUrl,
  );
}

/// application 層から [definitionProvider] をリフレッシュする。
extension DefinitionRefreshOnRef on Ref {
  /// [definitionId] のシードを破棄したうえで [definitionProvider] を invalidate する。
  void refreshDefinition(String definitionId) {
    read(definitionSeedStoreProvider).remove(definitionId);
    invalidate(definitionProvider(definitionId));
  }
}

/// 一覧取得の結果を [definitionSeedStoreProvider] へ投入する。
extension DefinitionSeedingOnRef on Ref {
  /// [feedKey] のフィードとして [definitions] をシードし、
  /// 影響を受ける [definitionProvider] を invalidate する。
  ///
  /// [isFirstFetch] が true（初回・refresh）のときは世代を置き換え、
  /// フィードから消えた定義のシードを破棄して単体取得へ戻す。
  /// false（追加読み込み）のときは追記のみ行う。
  ///
  /// シードを更新しただけでは購読中の [definitionProvider] は再評価されないため、
  /// invalidate まで行って初めて tile に反映される。
  void seedDefinitions({
    required String feedKey,
    required Iterable<Definition> definitions,
    required bool isFirstFetch,
  }) {
    final store = read(definitionSeedStoreProvider);

    final idsToInvalidate = <String>{};
    if (isFirstFetch) {
      idsToInvalidate.addAll(store.replaceAll(feedKey, definitions));
    } else {
      idsToInvalidate.addAll(store.seedAll(feedKey, definitions));
    }
    idsToInvalidate.addAll(definitions.map((definition) => definition.id));

    for (final id in idsToInvalidate) {
      invalidate(definitionProvider(id));
    }
  }
}

/// presentation 層から [definitionProvider] をリフレッシュする。
extension DefinitionRefreshOnWidgetRef on WidgetRef {
  /// [definitionId] のシードを破棄したうえで [definitionProvider] を invalidate する。
  void refreshDefinition(String definitionId) {
    read(definitionSeedStoreProvider).remove(definitionId);
    invalidate(definitionProvider(definitionId));
  }
}
