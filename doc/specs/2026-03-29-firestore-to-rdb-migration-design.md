# Firestore → RDB 移行設計書

- **作成日**: 2026-03-29
- **ステータス**: Draft
- **関連 Issue**: #174

## 1. 背景と目的

### 現状の課題

Firestore をコアデータのデータソースとして使用しているが、以下の課題がある:

1. **検索の制限**: `word` フィールドのプレフィックス検索のみ。定義本文・読みの検索不可、中間一致不可
2. **データ間の紐づけの複雑さ**: `WordDefinitionRelations` 結合テーブルの手動管理、`whereIn` の 10 件制限によるチャンク分割+メモリ内ソート
3. **整合性の担保**: `likesCount` 非正規化の不整合リスク、Word 孤立化、Likes 削除漏れ（TODO コメント）、二重いいね/フォロー防止なし

### 目的

コアデータを RDB (PostgreSQL) に移行し、上記 3 課題を解決する。

## 2. 技術選定

### 選定結果

| 要素 | 選定技術 | 理由 |
|---|---|---|
| **データベース** | Neon PostgreSQL (Singapore) | サーバーレス、無料枠あり、標準 PostgreSQL |
| **API レイヤー** | Cloudflare Workers (TypeScript) | エッジ分散、無料枠 10 万 req/日、WebSocket で Neon 接続可 |
| **フレームワーク** | Hono | Workers ネイティブ、軽量、型安全 |
| **DB ドライバ** | `@neondatabase/serverless` | Workers の WebSocket/HTTP 対応 |
| **JWT 検証** | `jose` ライブラリ | Firebase 公開鍵で JWT 検証 |
| **認証** | Firebase Auth (既存維持) | 既存の認証基盤を活用 |
| **検索 (Phase 1)** | LIKE 部分一致 | 50K 行で ~100-200ms、現状のプレフィックス検索より改善 |
| **検索 (Phase 2)** | Meilisearch (将来) | 日本語形態素解析、BM25 ランキング（+$5/月） |

### 比較検討した候補

| 候補 | 不採用理由 |
|---|---|
| Supabase | 本番運用に $25/月 必須（無料枠は 7 日非活動で停止） |
| Turso (libSQL) | 日本語全文検索が困難、Flutter SDK がコミュニティ製 |
| PlanetScale | 無料枠廃止 |
| Firebase Data Connect | 無料トライアル後 ~$9.37/月、まだ新しい |

### コスト試算

| DAU | Neon | CF Workers | 月額合計 |
|---|---|---|---|
| ~1,000 | Free | Free | **$0** |
| ~3,000 | Launch $19 | Paid $5 | **$24** |
| ~10,000 | Scale $69 | Paid $9 | **$78** |

## 3. 全体アーキテクチャ

```text
┌─────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  Flutter App │────>│  Cloudflare Workers   │────>│  Neon PostgreSQL │
│             │<────│  (TypeScript / Hono)  │<────│  (Singapore)     │
│  - Riverpod │     │  - REST API           │     │                 │
│  - Freezed  │     │  - Firebase JWT 検証  │     │  コアデータ:     │
│             │     │  - ビジネスロジック     │     │  - users         │
└──────┬──────┘     └──────────────────────┘     │  - words         │
       │                                          │  - definitions   │
       │            ┌──────────────────────┐     │  - likes         │
       └───────────>│  Firebase            │     │  - user_follows  │
                    │  - Auth（認証）       │     │  - user_mutes    │
                    │  - Storage（画像）    │     └─────────────────┘
                    │  - Crashlytics       │
                    │  - Analytics         │
                    │  - Firestore         │
                    │    └ AppConfig のみ   │
                    └──────────────────────┘
```

### データ分離方針

| 移行先 | データ | 理由 |
|---|---|---|
| **Neon (PostgreSQL)** | users, words, definitions, likes, user_follows, user_mutes | FK・トランザクション・検索・JOIN が必要 |
| **Firebase (残留)** | AppConfig | 強制更新・メンテ制御のみ。コールドスタート回避 |

UserProfiles / UserConfigs は当初 Firebase 残留を想定したが、レビューの結果 PostgreSQL に移行する方針とした。理由: 定義フィード表示時に JOIN で著者情報を一括取得でき、ミュートフィルタも SQL 化できるため。

### 認証フロー

```text
1. Flutter App → Firebase Auth でログイン → ID Token (JWT) 取得
2. リクエスト: Authorization: Bearer <firebase_id_token>
3. Workers auth middleware:
   a. JWT の署名を Firebase 公開鍵 (JWKS) で検証
   b. iss, aud, exp をチェック
   c. uid を抽出 → リクエストコンテキストに格納
4. 各ルートハンドラーで ctx.userId を使用
```

Firebase 公開鍵は Workers KV にキャッシュ（TTL: 1 時間）。キャッシュミス時は Google の JWKS エンドポイント (`https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com`) から取得。

### ユーザー削除方針

`definitions.author_id` は `ON DELETE RESTRICT` であり、定義が存在する限り `users` の物理削除はブロックされる。soft delete (`deleted_at` の設定) は FK 参照を解除しないため、ユーザーも**物理削除せず soft delete に統一**する。

- `users` テーブルに `deleted_at TIMESTAMPTZ DEFAULT NULL` を追加
- ユーザーアカウント削除時: `users.deleted_at` を設定（物理削除しない）
- 削除済みユーザーの定義は「退会済みユーザー」として表示（表示名の差し替えは API レイヤーで処理。SQL クエリは `u.name` をそのまま返し、`u.deleted_at IS NOT NULL` の場合に API 層でプレースホルダーに置換する）
- `likes`, `user_follows`, `user_mutes` は物理削除（`ON DELETE CASCADE` は users 物理削除時のセーフティネットとして残すが、通常フローでは API 層で明示的に削除）

**注意:** soft delete した定義に紐づく likes は DB 上に残る（un-delete 対応のため）。フィード等のクエリでは `definitions.deleted_at IS NULL` で常にフィルタすること。

## 4. データベーススキーマ

### テーブル一覧

| テーブル | 用途 | 元 Firestore |
|---|---|---|
| `users` | ユーザー基本情報 + 設定 | UserProfiles + UserConfigs |
| `user_mutes` | ミュート関係 | UserConfigs.mutedUserIdList |
| `words` | 語句マスタ | Words |
| `definitions` | 定義 | Definitions |
| `likes` | いいね | Likes |
| `user_follows` | フォロー関係 | UserFollows |

**廃止テーブル:**
- `WordDefinitionRelations` → `definitions.word_id` FK で代替
- `UserFollowCounts` → `COUNT()` で計算（2K ユーザー規模では十分高速）

### DDL

```sql
-- ============================================================
-- Users（UserProfiles + UserConfigs を統合）
-- ============================================================
CREATE TABLE users (
  id TEXT PRIMARY KEY,                  -- Firebase Auth UID
  public_id TEXT NOT NULL UNIQUE,       -- 9桁の公開ID
  name TEXT NOT NULL
    CHECK (char_length(name) BETWEEN 1 AND 15),
  bio TEXT NOT NULL DEFAULT ''
    CHECK (char_length(bio) <= 150),
  profile_image_url TEXT NOT NULL DEFAULT '',
  os_version TEXT NOT NULL DEFAULT '',
  app_version TEXT NOT NULL DEFAULT '',
  deleted_at TIMESTAMPTZ DEFAULT NULL,   -- soft delete
  firestore_id TEXT UNIQUE,             -- 移行用（完了後に DROP）
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- UserMutes（ミュート関係 - 配列から正規化）
-- ============================================================
CREATE TABLE user_mutes (
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  muted_user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, muted_user_id),
  CHECK (user_id != muted_user_id)
);

-- ============================================================
-- Words（語句マスタ）
-- ============================================================
CREATE TABLE words (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  word TEXT NOT NULL
    CHECK (char_length(word) > 0),
  reading TEXT NOT NULL
    CHECK (char_length(reading) > 0),
  initial_sub_group_label TEXT NOT NULL,
  firestore_id TEXT UNIQUE,             -- 移行用
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(word, reading)
);

-- ============================================================
-- Definitions（定義）
-- ============================================================
CREATE TABLE definitions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  word_id BIGINT NOT NULL REFERENCES words(id) ON DELETE RESTRICT,
  author_id TEXT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  definition TEXT NOT NULL
    CHECK (char_length(definition) BETWEEN 1 AND 500),
  is_public BOOLEAN NOT NULL DEFAULT true,
  is_edited BOOLEAN NOT NULL DEFAULT false,
  likes_count INTEGER NOT NULL DEFAULT 0
    CHECK (likes_count >= 0),
  deleted_at TIMESTAMPTZ DEFAULT NULL,  -- soft delete
  firestore_id TEXT UNIQUE,             -- 移行用
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- Likes（いいね）
-- ============================================================
CREATE TABLE likes (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  definition_id BIGINT NOT NULL
    REFERENCES definitions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, definition_id)
);

-- ============================================================
-- UserFollows（フォロー関係）
-- 命名規約: follower = フォローする側, following = フォローされる側
-- ※ Firestore では逆の命名だったため、移行時にデータをスワップ
-- ============================================================
CREATE TABLE user_follows (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  follower_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- フォローする人
  following_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- フォローされる人
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);
```

### トリガー

```sql
-- likes_count 自動更新トリガー
CREATE OR REPLACE FUNCTION update_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE definitions
       SET likes_count = likes_count + 1, updated_at = now()
     WHERE id = NEW.definition_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE definitions
       SET likes_count = GREATEST(likes_count - 1, 0), updated_at = now()
     WHERE id = OLD.definition_id;
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_likes_count
  AFTER INSERT OR DELETE ON likes
  FOR EACH ROW EXECUTE FUNCTION update_likes_count();
```

### インデックス

```sql
-- === Words: 検索・一覧 ===
CREATE INDEX idx_words_word ON words (word text_pattern_ops);
CREATE INDEX idx_words_reading ON words (reading text_pattern_ops);
CREATE INDEX idx_words_group_reading
    ON words (initial_sub_group_label, reading);

-- === Definitions: フィード・一覧 ===
CREATE INDEX idx_definitions_author_public_created
    ON definitions (author_id, is_public, created_at DESC)
 WHERE deleted_at IS NULL;

CREATE INDEX idx_definitions_public_created
    ON definitions (is_public, created_at DESC)
 WHERE deleted_at IS NULL;

CREATE INDEX idx_definitions_word_created
    ON definitions (word_id, created_at DESC)
 WHERE deleted_at IS NULL;

CREATE INDEX idx_definitions_word_likes
    ON definitions (word_id, likes_count DESC)
 WHERE deleted_at IS NULL;

-- === Likes ===
CREATE INDEX idx_likes_definition_id ON likes (definition_id);
CREATE INDEX idx_likes_user_created
    ON likes (user_id, created_at DESC);

-- === UserFollows ===
CREATE INDEX idx_user_follows_following
    ON user_follows (following_id);
```

### Firestore 課題の解消マッピング

| 課題 | Firestore | PostgreSQL |
|---|---|---|
| プレフィックス検索のみ | `.startAt().endAt()` | LIKE 部分一致（将来 Meilisearch） |
| WordDefinitionRelations 手動管理 | 結合テーブル + 複数クエリ | `definitions.word_id` FK + JOIN |
| `whereIn` 10 件制限 | チャンク分割 + メモリソート | `WHERE ... IN (...)` 制限なし |
| ミュートのメモリ内フィルタ | fetch 後にアプリで除外 | `NOT EXISTS` サブクエリ（NULL 安全・高パフォーマンス） |
| likes_count 不整合 | バッチ部分失敗リスク | トリガーで原子的に更新 |
| フォロー数不整合 | 非正規化テーブル | `COUNT()` で毎回計算 |
| Likes 削除漏れ | TODO コメント未実装 | `ON DELETE CASCADE` で自動 |
| Word 孤立化 | ヒューリスティック判定 | `ON DELETE RESTRICT` + アプリ層で安全に削除 |
| 二重いいね/フォロー | チェックなし | `UNIQUE` 制約で DB レベル防止 |
| 自己フォロー | チェックなし | `CHECK` 制約で防止 |
| UserProfiles 別取得 | 定義表示ごとに別クエリ | JOIN で一括取得 |

## 5. API レイヤー設計

### エンドポイント

```text
# Words
GET    /api/words                       -- 語句一覧（ページネーション、グループ別）
GET    /api/words/search?q=...          -- 語句検索（LIKE 部分一致）
GET    /api/words/:id                   -- 語句詳細

# Definitions
GET    /api/definitions                 -- フィード（recommend / following）
GET    /api/definitions/:id             -- 定義詳細
POST   /api/definitions                 -- 定義作成（Word 自動作成含む）
PUT    /api/definitions/:id             -- 定義更新（Word 変更含む）
DELETE /api/definitions/:id             -- 定義 soft delete

# Likes
PUT    /api/definitions/:id/like       -- いいね追加
DELETE /api/definitions/:id/like       -- いいね解除
GET    /api/users/me/liked-definitions  -- いいねした定義一覧

# Users
GET    /api/users/me                    -- 自分のプロフィール
PUT    /api/users/me                    -- プロフィール更新
GET    /api/users/:id                   -- 他ユーザーのプロフィール
GET    /api/users/search?public_id=...  -- publicId でユーザー検索

# Follows
PUT    /api/users/:id/follow           -- フォロー追加
DELETE /api/users/:id/follow           -- フォロー解除
GET    /api/users/:id/followers         -- フォロワー一覧
GET    /api/users/:id/following         -- フォロー中一覧

# Mutes
PUT    /api/users/:id/mute             -- ミュート追加
DELETE /api/users/:id/mute             -- ミュート解除
```

### 主要クエリ例

**ホームフィード（おすすめ）:**

```sql
SELECT d.*, w.word, w.reading, u.name AS author_name, u.profile_image_url
  FROM definitions d
  JOIN words w ON w.id = d.word_id
  JOIN users u ON u.id = d.author_id
 WHERE d.deleted_at IS NULL
   AND (d.is_public = true OR d.author_id = $1)
   AND NOT EXISTS (SELECT 1 FROM user_mutes um WHERE um.user_id = $1 AND um.muted_user_id = d.author_id)
 ORDER BY d.created_at DESC
 LIMIT 20;
-- ※ カーソルページネーション時は WHERE に d.created_at < $cursor を追加
```

**フォロー中フィード:**

```sql
SELECT d.*, w.word, w.reading, u.name AS author_name, u.profile_image_url
  FROM definitions d
  JOIN words w ON w.id = d.word_id
  JOIN users u ON u.id = d.author_id
 WHERE d.deleted_at IS NULL
   AND d.is_public = true
   AND d.author_id IN (SELECT following_id FROM user_follows WHERE follower_id = $1)
   AND NOT EXISTS (SELECT 1 FROM user_mutes um WHERE um.user_id = $1 AND um.muted_user_id = d.author_id)
 ORDER BY d.created_at DESC
 LIMIT 20;
-- ※ カーソルページネーション時は WHERE に d.created_at < $cursor を追加
```

**定義作成（Word 自動作成含む）:**

```sql
-- CTE で Word を upsert し、取得した id で定義を 1 ステートメントで作成
WITH new_word AS (
  INSERT INTO words (word, reading, initial_sub_group_label)
    VALUES ($1, $2, $3)
    ON CONFLICT (word, reading) DO NOTHING
    RETURNING id
),
picked_word AS (
  SELECT id FROM new_word
  UNION ALL
  SELECT id FROM words WHERE word = $1 AND reading = $2
  LIMIT 1
)
INSERT INTO definitions (word_id, author_id, definition, is_public)
SELECT id, $4, $5, $6
FROM picked_word;
```

### ページネーション

複合カーソルベース（`created_at` + `id`）。同一タイムスタンプの行スキップを防止:

```sql
WHERE (d.created_at, d.id) < ($cursor_ts, $cursor_id)
ORDER BY d.created_at DESC, d.id DESC
LIMIT 20;
```

### エラーハンドリング

| ステータス | 用途 |
|---|---|
| `200 OK` | 成功 |
| `201 Created` | 作成成功 |
| `400 Bad Request` | バリデーションエラー |
| `401 Unauthorized` | JWT 無効・期限切れ |
| `403 Forbidden` | 他ユーザーの非公開定義へのアクセス |
| `404 Not Found` | リソースなし |
| `409 Conflict` | UNIQUE 制約違反（二重いいね等） |
| `500 Internal Error` | サーバーエラー |

## 6. Flutter 側の変更方針（概要）

> 詳細は実装フェーズで別途設計する。

### 方針

- リポジトリ層を差し替え: Firestore 直接アクセス → HTTP クライアント経由の REST API 呼び出し
- ドメイン層・プレゼンテーション層は原則変更なし
- Riverpod プロバイダーのインターフェースを維持し、内部実装のみ変更

### 影響範囲

| レイヤー | 変更 |
|---|---|
| **Repository (データ層)** | Firestore → REST API に全面書き換え |
| **Application (ユースケース)** | 一部修正（エラーハンドリング等） |
| **Domain (ドメイン)** | 原則変更なし |
| **Presentation (UI)** | 原則変更なし |

### HTTP クライアント

`dio` または `http` パッケージを使用。Firebase Auth の ID Token を自動付与するインターセプターを実装。

## 7. 移行計画（概要）

> 詳細は実装フェーズで別途設計する。

### フェーズ

1. **Phase 0: インフラ構築** — Neon DB 作成、スキーマ適用、Workers デプロイ
2. **Phase 1: データ移行** — Firestore → PostgreSQL へのデータ変換・投入スクリプト作成
3. **Phase 2: Flutter 側リポジトリ差し替え** — 機能ごとに段階的に切り替え
4. **Phase 3: 検証・切り替え** — 並行稼働期間を経て完全移行

### 移行時の注意事項

- `firestore_id` カラムで Firestore ドキュメント ID のマッピングを保持
- `user_follows` の `follower_id` / `following_id` を標準命名にスワップ
- Firestore の `Timestamp` → `TIMESTAMPTZ` (UTC) の変換
- `UserConfigs.mutedUserIdList` (配列) → `user_mutes` テーブル (正規化)

## 8. 検索の段階的改善計画

| フェーズ | 方式 | コスト | 品質 |
|---|---|---|---|
| **Phase 1（ローンチ時）** | `LIKE '%keyword%'` | 無料 | 部分一致（現状のプレフィックス検索より改善） |
| **Phase 2（必要時）** | Meilisearch 追加 | +$5/月 | 日本語形態素解析 + BM25 ランキング |

Phase 1 の LIKE 検索は 50,000 行 x 500 文字で ~100-200ms（シーケンシャルスキャン）。`word`, `reading`, `definition` の 3 フィールドを横断検索可能。`text_pattern_ops` インデックスはプレフィックス検索 (`LIKE 'keyword%'`) にのみ有効で、中間一致 (`LIKE '%keyword%'`) ではシーケンシャルスキャンとなる。`pg_trgm` の GIN インデックスは日本語 (CJK) では正しく動作しないため採用しない。

## 9. リスクと緩和策

| リスク | 影響 | 緩和策 |
|---|---|---|
| Neon コールドスタート (~0.5-3s) | DAU 少ない時期の UX 低下 | 許容する。成長後に Launch プラン ($19) で always-on |
| 東京リージョンなし (SG: 60-80ms) | レイテンシ増加 | Workers エッジキャッシュ、バッチクエリ最適化 |
| 日本語検索品質 | LIKE は形態素解析なし | Phase 2 で Meilisearch 追加 |
| Cloudflare Workers 10 万 req/日上限 | ~1,500-2,500 DAU で到達 | Paid ($5/月) で 1,000 万 req/月に拡張 |

## 10. 設計判断の記録

| 判断 | 選択 | 理由 |
|---|---|---|
| PK の型 | BIGINT (UUID ではなく) | 500MB 無料枠でストレージ効率重視 |
| likes_count | 非正規化 + トリガー | ソート用途で必要。トリガーで整合性保証 |
| follow_counts | テーブル廃止、COUNT() | 2K ユーザーで十分高速。整合性リスク排除 |
| UserProfiles | PostgreSQL に移行 | JOIN で定義と一括取得。Firestore 往復を排除 |
| AppConfig | Firebase に残留 | コールドスタート不要で即座に取得 |
| follower/following 命名 | 標準規約に修正 | 移行を機に混乱を解消 |
| soft delete | definitions + users | 定義の取り消し対応 + ユーザー退会後も定義を「退会済みユーザー」として表示 |
| WordDefinitionRelations | 廃止 | FK で代替。結合テーブル不要 |
| Word 削除 | `ON DELETE RESTRICT` + API 層で制御 | soft delete された定義は FK 参照が残るため、Word 削除は「active な定義が 0 件かつ soft delete 済み定義を物理削除した後」にのみ実行。定期バッチで処理 |
| Neon 接続方式 | `@neondatabase/serverless` (WebSocket) | Workers は TCP 非対応。Neon 組込みコネクションプーラー使用 |
| ミュートフィルタ | `NOT EXISTS` サブクエリ | `NOT IN` より NULL 安全でパフォーマンスが良い |
