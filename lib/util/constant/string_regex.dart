final hiraganaRegex = RegExp(r'^[ぁ-んゔ]+$');
final katakanaRegex = RegExp(r'^[ァ-ンヴヷヸヹヺ]+$');
final alphabetRegex = RegExp(r'^[a-zA-Z]+$');
final numberRegex = RegExp(r'^[0-9]+$');

/// アプリ内において、「基本的な記号」と定義する記号にマッチする正規表現
final basicSymbolRegex =
    RegExp(r'^[!#$%&()*+,\-./:;<=>?@\[\]^_`{|}~（）「」『』ー]+$');

// TODO(me): ベタ書きではなく、既存の定数を使用して定義したい

/// 定義されている全ての正規表現を結合した正規表現
final combinedRegex = RegExp(
  r'^[ ぁ-んゔァ-ンヴヷヸヹヺa-zA-Z0-9!#$%&()*+,\-./:;<=>?@\[\\\]^_`{|}~（）「」『』ー]+$',
);
