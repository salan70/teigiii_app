import { ApiError } from "../errors";

/**
 * keyset pagination の不透明カーソル。base64url でエンコードした JSON オブジェクトを持つ。
 * payload の形状検証（kind・version の照合）は各サービス側で行う。
 */
export function encodeOpaqueCursor(payload: Record<string, unknown>): string {
  const bytes = new TextEncoder().encode(JSON.stringify(payload));
  return btoa(String.fromCharCode(...bytes))
    .replaceAll("+", "-")
    .replaceAll("/", "_")
    .replace(/=+$/, "");
}

export function decodeOpaqueCursor(value: string): Record<string, unknown> {
  try {
    const base64 = value.replaceAll("-", "+").replaceAll("_", "/");
    const padded = base64.padEnd(Math.ceil(base64.length / 4) * 4, "=");
    const binary = atob(padded);
    const bytes = Uint8Array.from(binary, (character) => character.charCodeAt(0));
    const parsed: unknown = JSON.parse(new TextDecoder().decode(bytes));
    if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) {
      throw new Error("cursor payload must be a JSON object");
    }
    return parsed as Record<string, unknown>;
  } catch {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
}
