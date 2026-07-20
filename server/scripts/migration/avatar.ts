// profileImageUrl の分類（plan 決定事項 4 のアバター対応表）。
// export（ダウンロード対象パスの決定）と transform（avatarKey 割り当て）の両方から使う。
//
// デフォルトアイコン 3 種は旧 lib/util/constant/url.dart の
// defaultIconImageUrlListForProd / ForDev が指す Storage オブジェクトパス
// `common/default_icon_image/{slug}.png` で判定する（URL 全体のトークンは
// ローテーションし得るため、比較対象は「バケット内オブジェクトパス」に限定する）。
// カスタム画像は `users/{uid}/profile_image.png` を指す。
// どちらにも一致しない場合は fail-fast（呼び出し側で例外を投げる）。

export const defaultAvatarSlugs = [
  "ghost_writer",
  "animal_chara_radio_penguin",
  "animal_chara_mogura_hakase",
] as const;

export type DefaultAvatarSlug = (typeof defaultAvatarSlugs)[number];

export type AvatarClassification =
  | { type: "default"; slug: DefaultAvatarSlug; objectPath: string }
  | { type: "custom"; objectPath: string };

const firebaseStorageUrlPattern =
  /^https:\/\/firebasestorage\.googleapis\.com\/v0\/b\/[^/]+\/o\/([^?]+)/;

const defaultObjectPathPattern = new RegExp(
  `^common/default_icon_image/(${defaultAvatarSlugs.join("|")})\\.png$`,
);

/**
 * Firebase Storage のダウンロード URL からバケット内オブジェクトパスを取り出す。
 * 既知の形式でなければ null（呼び出し側で fail-fast する）。
 */
export function parseFirebaseStorageObjectPath(url: string): string | null {
  const match = firebaseStorageUrlPattern.exec(url);
  if (match === null) return null;
  const encodedPath = match[1];
  if (encodedPath === undefined) return null;
  try {
    return decodeURIComponent(encodedPath);
  } catch {
    return null;
  }
}

/**
 * profileImageUrl を「デフォルトアイコン」「カスタム画像」に分類する。
 * 未知のパターンは呼び出し側でエラーとして扱う（fail-fast ポリシー）。
 */
export function classifyAvatarUrl(profileImageUrl: string, uid: string): AvatarClassification {
  const objectPath = parseFirebaseStorageObjectPath(profileImageUrl);
  if (objectPath === null) {
    throw new AvatarClassificationError(uid, profileImageUrl, "unrecognized_url_format");
  }

  const defaultMatch = defaultObjectPathPattern.exec(objectPath);
  if (defaultMatch !== null) {
    const slug = defaultMatch[1] as DefaultAvatarSlug;
    return { type: "default", slug, objectPath };
  }

  if (objectPath === `users/${uid}/profile_image.png`) {
    return { type: "custom", objectPath };
  }

  throw new AvatarClassificationError(uid, profileImageUrl, "unknown_object_path");
}

export class AvatarClassificationError extends Error {
  constructor(
    readonly uid: string,
    readonly profileImageUrl: string,
    readonly kind: "unrecognized_url_format" | "unknown_object_path",
  ) {
    super(
      `profileImageUrl for uid=${uid} does not match a known pattern (${kind}): ${profileImageUrl}`,
    );
    this.name = "AvatarClassificationError";
  }
}
