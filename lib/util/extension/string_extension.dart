extension StringExtension on String {
  String katakanaToHiragana() {
    // 1文字のStringであることをチェック
    if (runes.length != 1) {
      throw const FormatException('2文字以上の文字列が渡されました。');
    }

    final code = runes.first;
    // カタカナかどうかをチェック
    if (code < 0x30A1 || code > 0x30FA) {
      throw ArgumentError('カタカナでない文字が渡されました。');
    }

    // 一般的でないカタカナは直接ひらがなを指定
    if (this == 'ヷ') {
      return 'わ';
    }

    if (this == 'ヸ') {
      return 'ゐ';
    }

    if (this == 'ヹ') {
      return 'ゑ';
    }

    if (this == 'ヺ') {
      return 'を';
    }

    // カタカナからひらがなに変換
    return String.fromCharCode(code - 0x0060);
  }
}
