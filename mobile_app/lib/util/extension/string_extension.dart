extension StringExtension on String {
  /// 末尾の空白文字を削除する。
  String trimEnd() {
    return replaceAll(RegExp(r'\s+$'), '');
  }
}
