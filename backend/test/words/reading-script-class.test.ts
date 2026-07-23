import { describe, expect, test } from "bun:test";

import {
  readingScriptClass,
  readingScriptClassFromSubGroup,
} from "../../src/words/reading-script-class";

describe("readingScriptClassFromSubGroup", () => {
  test("かなサブグループは scriptClass 0", () => {
    expect(readingScriptClassFromSubGroup("あ")).toBe(0);
    expect(readingScriptClassFromSubGroup("ん")).toBe(0);
    expect(readingScriptClassFromSubGroup("わ")).toBe(0);
  });

  test("英字サブグループは scriptClass 1", () => {
    expect(readingScriptClassFromSubGroup("A")).toBe(1);
    expect(readingScriptClassFromSubGroup("Z")).toBe(1);
  });

  test("数字・記号・その他は scriptClass 2", () => {
    expect(readingScriptClassFromSubGroup("数字")).toBe(2);
    expect(readingScriptClassFromSubGroup("記号")).toBe(2);
    expect(readingScriptClassFromSubGroup("その他")).toBe(2);
  });
});

describe("readingScriptClass", () => {
  test("よみから五十音 → 英字 → その他の順になる", () => {
    expect(readingScriptClass("あさ")).toBe(0);
    expect(readingScriptClass("Apple")).toBe(1);
    expect(readingScriptClass("123")).toBe(2);
    expect(readingScriptClass("！")).toBe(2);
  });
});
