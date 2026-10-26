# Apple / Google 認証追加（Issue #250）

## 目的

iOS の匿名アカウントへ Apple / Google 認証をリンクし、既存 UID のままデータを保護する。再インストール時は Welcome 画面から既存アカウントへサインインできるようにする。

## 採用方針（2026-10-26）

業務 API、D1、R2、フレーム計測は Cloudflare を継続し、認証、App Check、Analytics、Crashlytics は Firebase を継続する。
既存の Firebase プロジェクトと UID を維持し、認証基盤の新設やプロジェクトの再作成は行わない。
対象は iOS のみとする。
Android は配信停止中のため、今回の認証実装・設定取得・検証には含めない。
Google・Apple の設定取得と整合検査をコード化し、クラウドへの設定適用と実機での受け入れ確認は実施結果を分けて記録する。

## 実行手順

1. `google_sign_in` と iOS の Apple / Google ネイティブ設定を追加する。
2. AuthRepository、AuthService、AccountLinkService に認証・衝突・削除・再認証の処理を追加する。
3. ProviderScope を再生成できるルート機構を追加する。
4. 設定画面のアカウント連携画面と Welcome 画面の復元導線を追加する。
5. 情報設計とテストを更新し、生成・解析・テスト・デザインシステム検査を実行する。
6. 既存 Firebase iOS アプリの設定を完全一致の Bundle ID で取得し、環境、App ID、OAuth 設定を検査してから反映する。
7. 連携衝突時は切り替え先への認証成功後に元の匿名アカウントを削除する。
8. 連携済みアカウントの削除前に再認証し、Apple 連携時は認可を失効させる。
9. backend のアカウント削除に、匿名以外は直近 300 秒以内の再認証を要求する。

## 完了条件

- iOS 実機で匿名アカウントへ Apple / Google をリンクでき、UID と既存データが保持される。
- 再インストール後に Welcome の復元導線から既存データへ戻れる。
- 連携は `linkWithCredential`、復元は `signInWithCredential` 相当の別導線になっている。
- アカウント衝突時にデータ件数を提示し、キャンセル可能である。
- 切り替え先の認証失敗やキャンセルで、元のアカウントや所有データを削除しない。
- 切り替え前の認証を保持し、切り替え先の認証成功後に元の匿名アカウントを削除できる。
- 削除の後処理が失敗した場合に、成功と誤認させず再試行できる。
- 連携済みアカウントの削除が再認証込みで完了する。
- Apple の認可失効が完了する前にサーバーのデータを削除しない。
- backend が古い認証時刻での非匿名アカウント削除を拒否し、削除済みユーザーの旧トークンで本人向け API と更新操作を利用できない。
- 設定の取り違え、OAuth 設定の欠落、取得失敗を検出し、検査に失敗した設定で既存ファイルを上書きしない。

## 検証・外部設定の状態

- 修正前の認証単体テストは mobile 25 件、backend 32 件が成功した。
- Firebase CLI で既存 dev / prod アプリの最新 plist を取得・検査し、ローカルの plist と公開 xcconfig に反映した。
- dev / prod とも `CLIENT_ID` と `REVERSED_CLIENT_ID` が存在し、Apple / Google プロバイダーが有効であることを読み取り専用の API で確認した。
- 設定自動化 12 件、最終補強後の mobile 認証・連携画面 52 件、backend Workers 統合 145 件のテストが成功した。
- mobile 全体テスト 423 件と golden 31 件、DS 検査、DocBridge、backend の lint・型検査・format 検査が成功した。
- backend 単体テストの 13 件は、変更していないマイグレーションの SQLite エラーで失敗した。
  既知の [Issue #328](https://github.com/salan70/teigiii_app/issues/328) と一致し、今回の対象外とする。
- 本番の Dart 設定と flavor 検査が旧 Bundle ID の Firebase App ID を参照していたため、現在の Bundle ID に対応する App ID へ修正した。
- mobile 解析、format、iOS flavor 検査と dev の iOS Simulator ビルドが成功した。
  Simulator ビルド後に加えた REST ヘッダーと限定的な再試行の補強は、前述の認証テストで確認した。
- 再起動や切り替え元のトークン失効後は匿名アカウントの後処理を再開できない。
  通常削除でサーバーの成功応答を受け取れなかった場合の復旧も未対応であり、[情報設計](../specs/new-ui-information-architecture.md) に制約を記載した。
  Firebase 削除後に応答が失われた場合も、既削除と認証エラーを区別できず後処理が保留になる場合がある。
- Apple Developer 側の capability、鍵、プロビジョニングと、実機でのトークン発行・認証・削除は未確認。
- 設定の取得・監査と実機確認の手順は [Firebase 認証の設定](../firebase-auth-configuration.md) に記載する。
- 本計画は実機での受け入れ確認が完了するまで `done/` へ移動しない。
