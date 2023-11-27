extension StringListExtension on List<String> {
  /// Listが空の場合、空のString（''）が入ったListを返す
  ///
  /// Firestoreでのデータ取得時にwhereNotInフィルターを使う場合、
  /// 空のListを渡すとエラーになるため、この関数を用いてエラーを回避する
  List<String> get orSingleEmptyStringList => isEmpty ? [''] : this;
}
