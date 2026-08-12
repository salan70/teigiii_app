# Apple / Google 認証追加（Issue #250）

## 目的

iOS の匿名アカウントへ Apple / Google 認証をリンクし、既存 UID のままデータを保護する。再インストール時は Welcome 画面から既存アカウントへサインインできるようにする。

## 実行手順

1. `google_sign_in` と iOS の Apple / Google ネイティブ設定を追加する。
2. AuthRepository、AuthService、AccountLinkService に認証・衝突・削除・再認証の処理を追加する。
3. ProviderScope を再生成できるルート機構を追加する。
4. 設定画面のアカウント連携画面と Welcome 画面の復元導線を追加する。
5. 情報設計とテストを更新し、生成・解析・テスト・デザインシステム検査を実行する。

## 完了条件

- iOS 実機で匿名アカウントへ Apple / Google をリンクでき、UID と既存データが保持される。
- 再インストール後に Welcome の復元導線から既存データへ戻れる。
- 連携は `linkWithCredential`、復元は `signInWithCredential` 相当の別導線になっている。
- アカウント衝突時にデータ件数を提示し、キャンセル可能である。
- 旧アカウントのサーバーデータを Firebase Auth 切替前に削除できる。
- 連携済みアカウントの削除が再認証込みで完了する。
