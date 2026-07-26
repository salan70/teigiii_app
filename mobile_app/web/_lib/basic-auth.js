/**
 * Pages プレビュー専用 Basic 認証の判定（_worker.js から利用）。
 * @param {string | null | undefined} authorizationHeader
 * @param {string | undefined} user
 * @param {string | undefined} password
 * @returns {"ok" | "unauthorized" | "missing_config"}
 */
export function evaluateBasicAuth(authorizationHeader, user, password) {
  if (!user || !password) {
    return "missing_config";
  }

  if (!authorizationHeader?.startsWith("Basic ")) {
    return "unauthorized";
  }

  let decoded;
  try {
    decoded = atob(authorizationHeader.slice("Basic ".length).trim());
  } catch {
    return "unauthorized";
  }

  const separator = decoded.indexOf(":");
  if (separator < 0) {
    return "unauthorized";
  }

  const givenUser = decoded.slice(0, separator);
  const givenPassword = decoded.slice(separator + 1);

  if (
    !timingSafeEqual(givenUser, user) ||
    !timingSafeEqual(givenPassword, password)
  ) {
    return "unauthorized";
  }

  return "ok";
}

/**
 * @param {string} a
 * @param {string} b
 */
function timingSafeEqual(a, b) {
  const encoder = new TextEncoder();
  const aBytes = encoder.encode(a);
  const bBytes = encoder.encode(b);
  if (aBytes.length !== bBytes.length) {
    let sink = 0;
    const longer = aBytes.length > bBytes.length ? aBytes : bBytes;
    for (let i = 0; i < longer.length; i++) {
      sink |= longer[i] ^ longer[i];
    }
    void sink;
    return false;
  }
  let diff = 0;
  for (let i = 0; i < aBytes.length; i++) {
    diff |= aBytes[i] ^ bBytes[i];
  }
  return diff === 0;
}
