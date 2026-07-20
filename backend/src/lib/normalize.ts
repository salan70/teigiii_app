/** 前後空白の除去 + NFC 正規化。言葉の表記・よみは保存前に必ずこれを通す。 */
export function normalizeText(value: string): string {
  return value.trim().normalize("NFC");
}
