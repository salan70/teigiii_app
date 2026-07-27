import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/definition.dart';

part 'definition_seed_store.g.dart';

@Riverpod(keepAlive: true)
DefinitionSeedStore definitionSeedStore(DefinitionSeedStoreRef ref) =>
    DefinitionSeedStore();

/// 一覧取得のレスポンスに含まれていた [Definition] を保持するストア。
///
/// タイムラインなどの一覧 API は定義本体を返すため、
/// 各 tile が `definitionProvider` で個別に再取得すると N+1 になる。
/// 一覧取得時にここへ投入しておき、`definitionProvider` が取得の代わりに
/// 参照することで追加リクエストをなくす。
///
/// シードはフィード単位（[feedKey]）で世代管理する。ホーム画面の
/// おすすめタブとフォロー中タブのように複数フィードが同時に生存するため、
/// 単一世代にすると片方の refresh がもう片方のシードを消してしまう。
///
/// Notifier ではなく素のクラスにしているのは、`definitionProvider` の
/// build の同期区間から参照されるため。
/// provider の state をその区間で変更すると Riverpod が例外を投げる。
class DefinitionSeedStore {
  final _seeds = <String, Definition>{};

  /// フィードごとに、そのフィードが参照している ID 集合。
  final _idsByFeed = <String, Set<String>>{};

  /// 現在保持しているシードの ID 集合。
  Set<String> get ids => _seeds.keys.toSet();

  /// [feedKey] のフィードが参照している ID 集合。
  Set<String> idsOf(String feedKey) => {...?_idsByFeed[feedKey]};

  /// 一覧取得で得られた定義をまとめて投入する（追記）。
  void seedAll(String feedKey, Iterable<Definition> definitions) {
    final feedIds = _idsByFeed.putIfAbsent(feedKey, () => <String>{});
    for (final definition in definitions) {
      _seeds[definition.id] = definition;
      feedIds.add(definition.id);
    }
  }

  /// [feedKey] のフィードの世代を丸ごと置き換える。
  ///
  /// 戻り値は、この置き換えでシードが失われた ID 集合。
  /// 他のフィードがまだ参照している ID はシードを残すため、戻り値に含めない。
  /// 呼び出し側は戻り値の ID の `definitionProvider` を invalidate して、
  /// 単体取得へ戻す必要がある。
  Set<String> replaceAll(String feedKey, Iterable<Definition> definitions) {
    final previousIds = idsOf(feedKey);
    _idsByFeed[feedKey] = <String>{};
    seedAll(feedKey, definitions);

    final droppedIds = previousIds.difference(idsOf(feedKey));
    final removedIds = <String>{};
    for (final id in droppedIds) {
      if (_isReferenced(id)) {
        continue;
      }
      _seeds.remove(id);
      removedIds.add(id);
    }
    return removedIds;
  }

  /// [definitionId] のシードを返す。未投入の場合は null。
  Definition? read(String definitionId) => _seeds[definitionId];

  /// [definitionId] のシードを破棄する。
  ///
  /// シードが残っていると `definitionProvider` を invalidate しても
  /// 古い値を返してしまうため、再取得させたい場合は必ず破棄する。
  void remove(String definitionId) {
    _seeds.remove(definitionId);
    for (final feedIds in _idsByFeed.values) {
      feedIds.remove(definitionId);
    }
  }

  bool _isReferenced(String definitionId) =>
      _idsByFeed.values.any((feedIds) => feedIds.contains(definitionId));
}
