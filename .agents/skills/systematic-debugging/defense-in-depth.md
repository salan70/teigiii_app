# 多層防御バリデーション

## 概要

不正なデータが原因のバグを修正するとき、1箇所にバリデーションを追加すれば十分に感じる。しかし、その1つのチェックは異なるコードパス、リファクタリング、またはモックによって迂回される可能性がある。

**基本原則:** データが通過するすべてのレイヤーでバリデーションする。バグを構造的に不可能にする。

## なぜ複数レイヤーが必要か

単一のバリデーション: 「バグを修正した」
複数レイヤー: 「バグを不可能にした」

異なるレイヤーが異なるケースを捕捉する:
- エントリバリデーションがほとんどのバグを捕捉
- ビジネスロジックがエッジケースを捕捉
- 環境ガードがコンテキスト固有の危険を防止
- デバッグログが他のレイヤーが失敗したときに助ける

## 4つのレイヤー

### レイヤー 1: エントリポイント バリデーション
**目的:** API 境界で明らかに不正な入力を拒否する

```typescript
function createProject(name: string, workingDirectory: string) {
  if (!workingDirectory || workingDirectory.trim() === '') {
    throw new Error('workingDirectory cannot be empty');
  }
  if (!existsSync(workingDirectory)) {
    throw new Error(`workingDirectory does not exist: ${workingDirectory}`);
  }
  if (!statSync(workingDirectory).isDirectory()) {
    throw new Error(`workingDirectory is not a directory: ${workingDirectory}`);
  }
  // ... 処理を続行
}
```

### レイヤー 2: ビジネスロジック バリデーション
**目的:** この操作に対してデータが妥当であることを確認する

```typescript
function initializeWorkspace(projectDir: string, sessionId: string) {
  if (!projectDir) {
    throw new Error('projectDir required for workspace initialization');
  }
  // ... 処理を続行
}
```

### レイヤー 3: 環境ガード
**目的:** 特定のコンテキストで危険な操作を防止する

```typescript
async function gitInit(directory: string) {
  // テスト中、一時ディレクトリ外での git init を拒否
  if (process.env.NODE_ENV === 'test') {
    const normalized = normalize(resolve(directory));
    const tmpDir = normalize(resolve(tmpdir()));

    if (!normalized.startsWith(tmpDir)) {
      throw new Error(
        `Refusing git init outside temp dir during tests: ${directory}`
      );
    }
  }
  // ... 処理を続行
}
```

### レイヤー 4: デバッグ インストルメンテーション
**目的:** フォレンジックのためにコンテキストをキャプチャする

```typescript
async function gitInit(directory: string) {
  const stack = new Error().stack;
  logger.debug('About to git init', {
    directory,
    cwd: process.cwd(),
    stack,
  });
  // ... 処理を続行
}
```

## パターンの適用方法

バグを見つけたら:

1. **データフローをトレース** — 不正な値はどこで発生し、どこで使われるか？
2. **すべてのチェックポイントをマップ** — データが通過するすべてのポイントを列挙
3. **各レイヤーにバリデーションを追加** — エントリ、ビジネス、環境、デバッグ
4. **各レイヤーをテスト** — レイヤー 1 を迂回しても、レイヤー 2 が捕捉することを検証

## セッションからの例

バグ: 空の `projectDir` がソースコードで `git init` を実行

**データフロー:**
1. テストセットアップ → 空文字列
2. `Project.create(name, '')`
3. `WorkspaceManager.createWorkspace('')`
4. `git init` が `process.cwd()` で実行

**追加した4つのレイヤー:**
- レイヤー 1: `Project.create()` が空でない/存在する/書き込み可能を検証
- レイヤー 2: `WorkspaceManager` が projectDir が空でないことを検証
- レイヤー 3: `WorktreeManager` がテスト中の tmpdir 外での git init を拒否
- レイヤー 4: git init 前のスタックトレースログ

**結果:** 全1847テストパス、バグの再現が不可能に

## 重要な知見

4つのレイヤーすべてが必要だった。テスト中、各レイヤーが他のレイヤーが見逃したバグを捕捉した:
- 異なるコードパスがエントリバリデーションを迂回
- モックがビジネスロジックチェックを迂回
- 異なるプラットフォームのエッジケースに環境ガードが必要
- デバッグログが構造的な誤用を特定

**1つのバリデーションポイントで止めない。** すべてのレイヤーにチェックを追加すること。
