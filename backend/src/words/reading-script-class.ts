import { readingSubGroup } from "./reading-sub-group";

/**
 * 辞書インデックス表示順: 五十音(0) → 英字(1) → 数字・記号(2)。
 *
 * ORDER BY は CASE 式のため `words_reading_order_idx (reading_sub_group, reading, id)`
 * を並び替えには使えない（旧 `order by reading, id` も同様）。個人スケールでは許容。
 * 将来 `words` が大きくなったら `reading_script_class` 永続列 + 複合インデックスを検討する。
 */
export type ReadingScriptClass = 0 | 1 | 2;

/** SQL CASE の IN 句と TS 判定の単一ソース。 */
export const kanaSubGroups = [
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
] as const;

const kanaSubGroupSet = new Set<string>(kanaSubGroups);

/**
 * `reading_sub_group` 列からのクラス判定。
 *
 * SQL 側も同じ列を見る。カーソルの scriptClass もこの列（または同等の
 * `readingSubGroup(reading)`）から算出し、投入時の不変条件
 * `reading_sub_group === readingSubGroup(reading)` に依存する。
 */
export function readingScriptClassFromSubGroup(subGroup: string): ReadingScriptClass {
  if (kanaSubGroupSet.has(subGroup)) return 0;
  if (/^[A-Z]$/.test(subGroup)) return 1;
  return 2;
}

export function readingScriptClass(reading: string): ReadingScriptClass {
  return readingScriptClassFromSubGroup(readingSubGroup(reading));
}

/**
 * `words.reading_sub_group` から script class を算出する SQL CASE 式。
 * ORDER BY / keyset cursor の WHERE で共有する（エイリアス `w` 前提）。
 * かな一覧は [kanaSubGroups] から生成する。
 */
export const readingScriptClassSql = `case
  when w.reading_sub_group in (${kanaSubGroups.map((kana) => `'${kana}'`).join(",")}) then 0
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
