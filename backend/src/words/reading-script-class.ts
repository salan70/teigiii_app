import { readingSubGroup } from "./reading-sub-group";

/** 辞書インデックス表示順: 五十音(0) → 英字(1) → 数字・記号(2) */
export type ReadingScriptClass = 0 | 1 | 2;

const kanaSubGroups = new Set([
  "あ",
  "い",
  "う",
  "え",
  "お",
  "か",
  "き",
  "く",
  "け",
  "こ",
  "さ",
  "し",
  "す",
  "せ",
  "そ",
  "た",
  "ち",
  "つ",
  "て",
  "と",
  "な",
  "に",
  "ぬ",
  "ね",
  "の",
  "は",
  "ひ",
  "ふ",
  "へ",
  "ほ",
  "ま",
  "み",
  "む",
  "め",
  "も",
  "や",
  "ゆ",
  "よ",
  "ら",
  "り",
  "る",
  "れ",
  "ろ",
  "わ",
  "を",
  "ん",
]);

export function readingScriptClassFromSubGroup(subGroup: string): ReadingScriptClass {
  if (kanaSubGroups.has(subGroup)) return 0;
  if (/^[A-Z]$/.test(subGroup)) return 1;
  return 2;
}

export function readingScriptClass(reading: string): ReadingScriptClass {
  return readingScriptClassFromSubGroup(readingSubGroup(reading));
}

/**
 * `words.reading_sub_group` から script class を算出する SQL CASE 式。
 * ORDER BY / keyset cursor の WHERE で共有する（エイリアス `w` 前提）。
 */
export const readingScriptClassSql = `case
  when w.reading_sub_group in ('あ','い','う','え','お','か','き','く','け','こ','さ','し','す','せ','そ','た','ち','つ','て','と','な','に','ぬ','ね','の','は','ひ','ふ','へ','ほ','ま','み','む','め','も','や','ゆ','よ','ら','り','る','れ','ろ','わ','を','ん') then 0
  when w.reading_sub_group glob '[A-Z]' then 1
  else 2
end`;

/** keyset pagination 用: scriptClass → reading → id */
export function readingScriptClassCursorClause(): string {
  return `(
    (${readingScriptClassSql}) > ?
    or ((${readingScriptClassSql}) = ? and w.reading > ?)
    or ((${readingScriptClassSql}) = ? and w.reading = ? and w.id > ?)
  )`;
}

export function readingScriptClassOrderBy(): string {
  return `${readingScriptClassSql} asc, w.reading asc, w.id asc`;
}
