/**
 * Basic Auth をスキップするパス（ブラウザが Authorization なしで取りに来ることがある）。
 * @param {string} pathname
 */
export function shouldSkipBasicAuth(pathname) {
  if (pathname === "/manifest.json" || pathname === "/favicon.png") {
    return true;
  }
  if (pathname === "/version.json" || pathname === "/flutter_service_worker.js") {
    return true;
  }
  if (pathname.startsWith("/icons/")) {
    return true;
  }
  return false;
}
