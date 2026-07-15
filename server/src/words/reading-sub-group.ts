// 旧 Flutter 実装（lib/util/constant/initial_main_group.dart の InitialSubGroup.fromString）と
// 同じ分類規則。words.reading_sub_group に保存するラベルを算出する。

/** 濁音・半濁音・小書き・歴史的仮名遣いを清音ラベルへ寄せる対応。清音・を・ん は自分自身。 */
const kanaConversions: ReadonlyArray<readonly [source: string, label: string]> = [
  [
    "あいうえおかきくけこさしすせそたちつてとなにぬねの",
    "あいうえおかきくけこさしすせそたちつてとなにぬねの",
  ],
  ["はひふへほまみむめもやゆよらりるれろわをん", "はひふへほまみむめもやゆよらりるれろわをん"],
  ["がぎぐげご", "かきくけこ"],
  ["ざじずぜぞ", "さしすせそ"],
  ["だぢづでど", "たちつてと"],
  ["ばびぶべぼ", "はひふへほ"],
  ["ぱぴぷぺぽ", "はひふへほ"],
  ["ぁぃぅぇぉ", "あいうえお"],
  ["ゃゅょ", "やゆよ"],
  ["っ", "つ"],
  ["ゔ", "う"],
  ["ゐゑ", "いえ"],
  ["ゎ", "わ"],
];

const kanaToLabel = new Map<string, string>(
  kanaConversions.flatMap(([source, label]) =>
    Array.from(source, (kana, index) => [kana, label[index]!] as const),
  ),
);

/** ヷヸヹヺ は単純な符号シフトで変換できないため個別対応する。 */
const irregularKatakana = new Map<string, string>([
  ["ヷ", "わ"],
  ["ヸ", "ゐ"],
  ["ヹ", "ゑ"],
  ["ヺ", "を"],
]);

const basicSymbolPattern = /^[!#$%&()*+,\-./:;<=>?@[\\\]^_`{|}~（）「」『』ー]$/;

function katakanaToHiragana(character: string): string {
  const irregular = irregularKatakana.get(character);
  if (irregular !== undefined) return irregular;
  const code = character.codePointAt(0)!;
  // ァ（U+30A1）〜ヴ（U+30F4）はひらがなと 0x60 の固定オフセット
  if (code < 0x30a1 || code > 0x30f4) return character;
  return String.fromCodePoint(code - 0x60);
}

/**
 * よみの先頭文字からあかさたな行のサブグループラベルを返す。
 * かな → 清音 1 文字、英字 → 大文字 1 文字、それ以外 → 数字 / 記号 / その他。
 */
export function readingSubGroup(reading: string): string {
  const trimmed = reading.trim();
  if (trimmed === "") return "その他";

  const initial = katakanaToHiragana(String.fromCodePoint(trimmed.codePointAt(0)!));

  const kanaLabel = kanaToLabel.get(initial);
  if (kanaLabel !== undefined) return kanaLabel;
  if (/^[a-zA-Z]$/.test(initial)) return initial.toUpperCase();
  if (/^[0-9]$/.test(initial)) return "数字";
  if (basicSymbolPattern.test(initial)) return "記号";
  return "その他";
}
