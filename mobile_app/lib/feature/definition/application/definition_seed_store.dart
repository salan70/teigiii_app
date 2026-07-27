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
/// Notifier ではなく素のクラスにしているのは、`definitionProvider` の
/// build の同期区間から参照されるため。
/// provider の state をその区間で変更すると Riverpod が例外を投げる。
class DefinitionSeedStore {
  final _seeds = <String, Definition>{};

  /// 現在保持しているシードの ID 集合。
  Set<String> get ids => _seeds.keys.toSet();

  /// 一覧取得で得られた定義をまとめて投入する。
  void seedAll(Iterable<Definition> definitions) {
    for (final definition in definitions) {
      _seeds[definition.id] = definition;
    }
  }

  /// フィードの世代を丸ごと置き換える。
  ///
  /// 既存のシードをすべて破棄したうえで [definitions] を投入する。
  /// 戻り値は置き換え前に保持していた ID 集合。
  Set<String> replaceAll(Iterable<Definition> definitions) {
    final previousIds = ids;
    _seeds.clear();
    seedAll(definitions);
    return previousIds;
  }

  /// [definitionId] のシードを返す。未投入の場合は null。
  Definition? read(String definitionId) => _seeds[definitionId];

  /// [definitionId] のシードを破棄する。
  ///
  /// シードが残っていると `definitionProvider` を invalidate しても
  /// 古い値を返してしまうため、再取得させたい場合は必ず破棄する。
  void remove(String definitionId) => _seeds.remove(definitionId);
}
