import { describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import path from "node:path";

const script = path.join(import.meta.dirname, "sanitize-pages-branch.sh");

function sanitize(raw: string): string {
  const result = spawnSync(
    "bash",
    ["-c", `source "$1"; sanitize_pages_branch "$2"`, "bash", script, raw],
    { encoding: "utf8" },
  );
  if (result.status !== 0) {
    throw new Error(result.stderr || `exit ${result.status}`);
  }
  return result.stdout.trim();
}

describe("sanitize_pages_branch", () => {
  test("slash をハイフンにし 28 文字へ切る", () => {
    expect(sanitize("cursor/254-web-qa-preview-90e8")).toBe(
      "cursor-254-web-qa-preview-90",
    );
  });

  test("短い PR ブランチはそのまま", () => {
    expect(sanitize("pr-275")).toBe("pr-275");
  });

  test("空や記号だけは preview", () => {
    expect(sanitize("///")).toBe("preview");
  });
});
