/// 無限スクロールで表示する一覧の state.
///
/// [T] は一覧に並ぶ要素の型。異種混在リストは sealed class を [T] に据えて
/// 表現する（`dynamic` に戻すと呼び出し側で実行時キャストが必要になる）。
abstract class ListState<T> {
  List<T> get list;
  bool get hasMore;
  String? get nextCursor;
}
