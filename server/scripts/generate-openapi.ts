/**
 * ルート定義から openapi.json を生成する。
 * 生成物はコミットし、フェーズ 4 の Dart クライアント生成が
 * server のビルド環境なしで動くようにする。
 */
import { buildOpenApiDocument } from "../src/app";

const document = buildOpenApiDocument();
const outPath = new URL("../openapi.json", import.meta.url).pathname;

await Bun.write(outPath, `${JSON.stringify(document, null, 2)}\n`);

const pathCount = Object.keys(document.paths ?? {}).length;
console.log(`openapi.json generated: ${pathCount} paths`);
