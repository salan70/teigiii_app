import '../extension/string_extension.dart';
import 'string_regex.dart';

enum InitialMainGroup {
  // かな
  japaneseAColumn,
  japaneseKaColumn,
  japaneseSaColumn,
  japaneseTaColumn,
  japaneseNaColumn,
  japaneseHaColumn,
  japaneseMaColumn,
  japaneseYaColumn,
  japaneseRaColumn,
  japaneseWaColumn,

  // アルファベット
  alphabet,

  // その他
  other;

  String get label {
    switch (this) {
      case InitialMainGroup.japaneseAColumn:
        return 'あいうえお';
      case InitialMainGroup.japaneseKaColumn:
        return 'かきくけこ';
      case InitialMainGroup.japaneseSaColumn:
        return 'さしすせそ';
      case InitialMainGroup.japaneseTaColumn:
        return 'たちつてと';
      case InitialMainGroup.japaneseNaColumn:
        return 'なにぬねの';
      case InitialMainGroup.japaneseHaColumn:
        return 'はひふへほ';
      case InitialMainGroup.japaneseMaColumn:
        return 'まみむめも';
      case InitialMainGroup.japaneseYaColumn:
        return 'やゆよ';
      case InitialMainGroup.japaneseRaColumn:
        return 'らりるれろ';
      case InitialMainGroup.japaneseWaColumn:
        return 'わをん';
      case InitialMainGroup.alphabet:
        return 'A-Z';
      case InitialMainGroup.other:
        return '数字・記号';
    }
  }
}

enum InitialSubGroup {
  // かな
  a,
  i,
  u,
  e,
  o,
  ka,
  ki,
  ku,
  ke,
  ko,
  sa,
  shi,
  su,
  se,
  so,
  ta,
  chi,
  tsu,
  te,
  to,
  na,
  ni,
  nu,
  ne,
  no,
  ha,
  hi,
  fu,
  he,
  ho,
  ma,
  mi,
  mu,
  me,
  mo,
  ya,
  yu,
  yo,
  ra,
  ri,
  ru,
  re,
  ro,
  wa,
  wo,
  n,

  // アルファベット
  aAlpha,
  bAlpha,
  cAlpha,
  dAlpha,
  eAlpha,
  fAlpha,
  gAlpha,
  hAlpha,
  iAlpha,
  jAlpha,
  kAlpha,
  lAlpha,
  mAlpha,
  nAlpha,
  oAlpha,
  pAlpha,
  qAlpha,
  rAlpha,
  sAlpha,
  tAlpha,
  uAlpha,
  vAlpha,
  wAlpha,
  xAlpha,
  yAlpha,
  zAlpha,

  // その他
  number,
  basicSymbol,
  other;

  String get label {
    switch (this) {
      // かな
      case InitialSubGroup.a:
        return 'あ';
      case InitialSubGroup.i:
        return 'い';
      case InitialSubGroup.u:
        return 'う';
      case InitialSubGroup.e:
        return 'え';
      case InitialSubGroup.o:
        return 'お';
      case InitialSubGroup.ka:
        return 'か';
      case InitialSubGroup.ki:
        return 'き';
      case InitialSubGroup.ku:
        return 'く';
      case InitialSubGroup.ke:
        return 'け';
      case InitialSubGroup.ko:
        return 'こ';
      case InitialSubGroup.sa:
        return 'さ';
      case InitialSubGroup.shi:
        return 'し';
      case InitialSubGroup.su:
        return 'す';
      case InitialSubGroup.se:
        return 'せ';
      case InitialSubGroup.so:
        return 'そ';
      case InitialSubGroup.ta:
        return 'た';
      case InitialSubGroup.chi:
        return 'ち';
      case InitialSubGroup.tsu:
        return 'つ';
      case InitialSubGroup.te:
        return 'て';
      case InitialSubGroup.to:
        return 'と';
      case InitialSubGroup.na:
        return 'な';
      case InitialSubGroup.ni:
        return 'に';
      case InitialSubGroup.nu:
        return 'ぬ';
      case InitialSubGroup.ne:
        return 'ね';
      case InitialSubGroup.no:
        return 'の';
      case InitialSubGroup.ha:
        return 'は';
      case InitialSubGroup.hi:
        return 'ひ';
      case InitialSubGroup.fu:
        return 'ふ';
      case InitialSubGroup.he:
        return 'へ';
      case InitialSubGroup.ho:
        return 'ほ';
      case InitialSubGroup.ma:
        return 'ま';
      case InitialSubGroup.mi:
        return 'み';
      case InitialSubGroup.mu:
        return 'む';
      case InitialSubGroup.me:
        return 'め';
      case InitialSubGroup.mo:
        return 'も';
      case InitialSubGroup.ya:
        return 'や';
      case InitialSubGroup.yu:
        return 'ゆ';
      case InitialSubGroup.yo:
        return 'よ';
      case InitialSubGroup.ra:
        return 'ら';
      case InitialSubGroup.ri:
        return 'り';
      case InitialSubGroup.ru:
        return 'る';
      case InitialSubGroup.re:
        return 'れ';
      case InitialSubGroup.ro:
        return 'ろ';
      case InitialSubGroup.wa:
        return 'わ';
      case InitialSubGroup.wo:
        return 'を';
      case InitialSubGroup.n:
        return 'ん';

      // アルファベット
      case InitialSubGroup.aAlpha:
        return 'A';
      case InitialSubGroup.bAlpha:
        return 'B';
      case InitialSubGroup.cAlpha:
        return 'C';
      case InitialSubGroup.dAlpha:
        return 'D';
      case InitialSubGroup.eAlpha:
        return 'E';
      case InitialSubGroup.fAlpha:
        return 'F';
      case InitialSubGroup.gAlpha:
        return 'G';
      case InitialSubGroup.hAlpha:
        return 'H';
      case InitialSubGroup.iAlpha:
        return 'I';
      case InitialSubGroup.jAlpha:
        return 'J';
      case InitialSubGroup.kAlpha:
        return 'K';
      case InitialSubGroup.lAlpha:
        return 'L';
      case InitialSubGroup.mAlpha:
        return 'M';
      case InitialSubGroup.nAlpha:
        return 'N';
      case InitialSubGroup.oAlpha:
        return 'O';
      case InitialSubGroup.pAlpha:
        return 'P';
      case InitialSubGroup.qAlpha:
        return 'Q';
      case InitialSubGroup.rAlpha:
        return 'R';
      case InitialSubGroup.sAlpha:
        return 'S';
      case InitialSubGroup.tAlpha:
        return 'T';
      case InitialSubGroup.uAlpha:
        return 'U';
      case InitialSubGroup.vAlpha:
        return 'V';
      case InitialSubGroup.wAlpha:
        return 'W';
      case InitialSubGroup.xAlpha:
        return 'X';
      case InitialSubGroup.yAlpha:
        return 'Y';
      case InitialSubGroup.zAlpha:
        return 'Z';
      case InitialSubGroup.number:
        return '数字';
      case InitialSubGroup.basicSymbol:
        return '記号';
      case InitialSubGroup.other:
        return 'その他';
    }
  }

  static InitialSubGroup fromString(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return InitialSubGroup.other;
    }

    final initial = trimmed.substring(0, 1);

    // ひらがな
    if (hiraganaRegex.hasMatch(initial)) {
      return kanaMapping[initial]!;
    }

    // カタカナ
    if (katakanaRegex.hasMatch(initial)) {
      final hiraganaInitial = initial.katakanaToHiragana();
      return kanaMapping[hiraganaInitial]!;
    }

    // アルファベット
    if (alphabetRegex.hasMatch(initial)) {
      return InitialSubGroup.values
          .firstWhere(
            (element) => element.label == initial.toUpperCase(),
          )
          ;
    }

    // 数字
    if (numberRegex.hasMatch(initial)) {
      return InitialSubGroup.number;
    }

    // 記号
    if (basicSymbolRegex.hasMatch(initial)) {
      return InitialSubGroup.basicSymbol;
    }

    // その他
    return InitialSubGroup.other;
  }
}

final Map<InitialMainGroup, List<InitialSubGroup>> initialMapping = {
  InitialMainGroup.japaneseAColumn: [
    InitialSubGroup.a,
    InitialSubGroup.i,
    InitialSubGroup.u,
    InitialSubGroup.e,
    InitialSubGroup.o,
  ],
  InitialMainGroup.japaneseKaColumn: [
    InitialSubGroup.ka,
    InitialSubGroup.ki,
    InitialSubGroup.ku,
    InitialSubGroup.ke,
    InitialSubGroup.ko,
  ],
  InitialMainGroup.japaneseSaColumn: [
    InitialSubGroup.sa,
    InitialSubGroup.shi,
    InitialSubGroup.su,
    InitialSubGroup.se,
    InitialSubGroup.so,
  ],
  InitialMainGroup.japaneseTaColumn: [
    InitialSubGroup.ta,
    InitialSubGroup.chi,
    InitialSubGroup.tsu,
    InitialSubGroup.te,
    InitialSubGroup.to,
  ],
  InitialMainGroup.japaneseNaColumn: [
    InitialSubGroup.na,
    InitialSubGroup.ni,
    InitialSubGroup.nu,
    InitialSubGroup.ne,
    InitialSubGroup.no,
  ],
  InitialMainGroup.japaneseHaColumn: [
    InitialSubGroup.ha,
    InitialSubGroup.hi,
    InitialSubGroup.fu,
    InitialSubGroup.he,
    InitialSubGroup.ho,
  ],
  InitialMainGroup.japaneseMaColumn: [
    InitialSubGroup.ma,
    InitialSubGroup.mi,
    InitialSubGroup.mu,
    InitialSubGroup.me,
    InitialSubGroup.mo,
  ],
  InitialMainGroup.japaneseYaColumn: [
    InitialSubGroup.ya,
    InitialSubGroup.yu,
    InitialSubGroup.yo,
  ],
  InitialMainGroup.japaneseRaColumn: [
    InitialSubGroup.ra,
    InitialSubGroup.ri,
    InitialSubGroup.ru,
    InitialSubGroup.re,
    InitialSubGroup.ro,
  ],
  InitialMainGroup.japaneseWaColumn: [
    InitialSubGroup.wa,
    InitialSubGroup.wo,
    InitialSubGroup.n,
  ],
  InitialMainGroup.alphabet: [
    InitialSubGroup.aAlpha,
    InitialSubGroup.bAlpha,
    InitialSubGroup.cAlpha,
    InitialSubGroup.dAlpha,
    InitialSubGroup.eAlpha,
    InitialSubGroup.fAlpha,
    InitialSubGroup.gAlpha,
    InitialSubGroup.hAlpha,
    InitialSubGroup.iAlpha,
    InitialSubGroup.jAlpha,
    InitialSubGroup.kAlpha,
    InitialSubGroup.lAlpha,
    InitialSubGroup.mAlpha,
    InitialSubGroup.nAlpha,
    InitialSubGroup.oAlpha,
    InitialSubGroup.pAlpha,
    InitialSubGroup.qAlpha,
    InitialSubGroup.rAlpha,
    InitialSubGroup.sAlpha,
    InitialSubGroup.tAlpha,
    InitialSubGroup.uAlpha,
    InitialSubGroup.vAlpha,
    InitialSubGroup.wAlpha,
    InitialSubGroup.xAlpha,
    InitialSubGroup.yAlpha,
    InitialSubGroup.zAlpha,
  ],
  InitialMainGroup.other: [
    InitialSubGroup.number,
    InitialSubGroup.basicSymbol,
    InitialSubGroup.other,
  ],
};

final Map<String, InitialSubGroup> kanaMapping = {
  // 清音 + を + ん
  'あ': InitialSubGroup.a,
  'い': InitialSubGroup.i,
  'う': InitialSubGroup.u,
  'え': InitialSubGroup.e,
  'お': InitialSubGroup.o,
  'か': InitialSubGroup.ka,
  'き': InitialSubGroup.ki,
  'く': InitialSubGroup.ku,
  'け': InitialSubGroup.ke,
  'こ': InitialSubGroup.ko,
  'さ': InitialSubGroup.sa,
  'し': InitialSubGroup.shi,
  'す': InitialSubGroup.su,
  'せ': InitialSubGroup.se,
  'そ': InitialSubGroup.so,
  'た': InitialSubGroup.ta,
  'ち': InitialSubGroup.chi,
  'つ': InitialSubGroup.tsu,
  'て': InitialSubGroup.te,
  'と': InitialSubGroup.to,
  'な': InitialSubGroup.na,
  'に': InitialSubGroup.ni,
  'ぬ': InitialSubGroup.nu,
  'ね': InitialSubGroup.ne,
  'の': InitialSubGroup.no,
  'は': InitialSubGroup.ha,
  'ひ': InitialSubGroup.hi,
  'ふ': InitialSubGroup.fu,
  'へ': InitialSubGroup.he,
  'ほ': InitialSubGroup.ho,
  'ま': InitialSubGroup.ma,
  'み': InitialSubGroup.mi,
  'む': InitialSubGroup.mu,
  'め': InitialSubGroup.me,
  'も': InitialSubGroup.mo,
  'や': InitialSubGroup.ya,
  'ゆ': InitialSubGroup.yu,
  'よ': InitialSubGroup.yo,
  'ら': InitialSubGroup.ra,
  'り': InitialSubGroup.ri,
  'る': InitialSubGroup.ru,
  'れ': InitialSubGroup.re,
  'ろ': InitialSubGroup.ro,
  'わ': InitialSubGroup.wa,
  'を': InitialSubGroup.wo,
  'ん': InitialSubGroup.n,

  // 濁音
  'が': InitialSubGroup.ka,
  'ぎ': InitialSubGroup.ki,
  'ぐ': InitialSubGroup.ku,
  'げ': InitialSubGroup.ke,
  'ご': InitialSubGroup.ko,
  'ざ': InitialSubGroup.sa,
  'じ': InitialSubGroup.shi,
  'ず': InitialSubGroup.su,
  'ぜ': InitialSubGroup.se,
  'ぞ': InitialSubGroup.so,
  'だ': InitialSubGroup.ta,
  'ぢ': InitialSubGroup.chi,
  'づ': InitialSubGroup.tsu,
  'で': InitialSubGroup.te,
  'ど': InitialSubGroup.to,
  'ば': InitialSubGroup.ha,
  'び': InitialSubGroup.hi,
  'ぶ': InitialSubGroup.fu,
  'べ': InitialSubGroup.he,
  'ぼ': InitialSubGroup.ho,
  'ゔ': InitialSubGroup.u,

  // 半濁音
  'ぱ': InitialSubGroup.ha,
  'ぴ': InitialSubGroup.hi,
  'ぷ': InitialSubGroup.fu,
  'ぺ': InitialSubGroup.he,
  'ぽ': InitialSubGroup.ho,

  // 小書き
  'ぁ': InitialSubGroup.a,
  'ぃ': InitialSubGroup.i,
  'ぅ': InitialSubGroup.u,
  'ぇ': InitialSubGroup.e,
  'ぉ': InitialSubGroup.o,
  'ゃ': InitialSubGroup.ya,
  'ゅ': InitialSubGroup.yu,
  'ょ': InitialSubGroup.yo,
  'っ': InitialSubGroup.tsu,

  // 歴史的仮名遣い
  'ゐ': InitialSubGroup.i,
  'ゑ': InitialSubGroup.e,
};
