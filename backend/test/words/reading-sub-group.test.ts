import { describe, expect, test } from "bun:test";

import { normalizeText } from "../../src/lib/normalize";
import { readingSubGroup } from "../../src/words/reading-sub-group";

// U+3099 は結合用濁点。「か」+ U+3099 は NFC で「が」に合成される。
const combiningVoicedMark = String.fromCharCode(0x3099);

describe("normalizeText", () => {
  test("前後の空白を除去する", () => {
    expect(normalizeText("  こんにちは \n")).toBe("こんにちは");
  });

  test("結合文字を NFC で合成する", () => {
    const decomposed = `か${combiningVoicedMark}らす`;
    expect(decomposed).toHaveLength(4);

    const normalized = normalizeText(decomposed);

    expect(normalized).toBe("がらす");
    expect(normalized).toHaveLength(3);
  });

  test("合成済みの文字列はそのまま返す", () => {
    expect(normalizeText("がらす")).toBe("がらす");
  });
});

describe("readingSubGroup", () => {
  test("ひらがな清音は先頭文字をそのまま返す", () => {
    expect(readingSubGroup("あんこ")).toBe("あ");
    expect(readingSubGroup("ん")).toBe("ん");
    expect(readingSubGroup("をとめ")).toBe("を");
  });

  test("濁音・半濁音は清音の行に寄せる", () => {
    expect(readingSubGroup("がっこう")).toBe("か");
    expect(readingSubGroup("ずかん")).toBe("す");
    expect(readingSubGroup("ぱんだ")).toBe("は");
    expect(readingSubGroup("ゔぁいおりん")).toBe("う");
  });

  test("小書き・歴史的仮名遣いは対応する清音に寄せる", () => {
    expect(readingSubGroup("ゃくざいし")).toBe("や");
    expect(readingSubGroup("っち")).toBe("つ");
    expect(readingSubGroup("ゐど")).toBe("い");
    expect(readingSubGroup("ゑびす")).toBe("え");
    expect(readingSubGroup("ゎっふる")).toBe("わ");
  });

  test("カタカナはひらがなに変換して判定する", () => {
    expect(readingSubGroup("アイス")).toBe("あ");
    expect(readingSubGroup("ガム")).toBe("か");
    expect(readingSubGroup("ヴィンテージ")).toBe("う");
    expect(readingSubGroup("ヷルツ")).toBe("わ");
    expect(readingSubGroup("ヺング")).toBe("を");
  });

  test("アルファベットは大文字 1 文字を返す", () => {
    expect(readingSubGroup("apple")).toBe("A");
    expect(readingSubGroup("Zebra")).toBe("Z");
  });

  test("数字・記号・その他を分類する", () => {
    expect(readingSubGroup("123ごう")).toBe("数字");
    expect(readingSubGroup("ーめん")).toBe("記号");
    expect(readingSubGroup("「かっこ」")).toBe("記号");
    expect(readingSubGroup("")).toBe("その他");
    expect(readingSubGroup("   ")).toBe("その他");
  });
});
