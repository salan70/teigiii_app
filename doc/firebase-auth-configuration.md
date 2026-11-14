# Firebase 認証の設定

Issue #250 の対象は iOS のみとする。
Android は配信停止中のため、今回の設定取得・検査・受け入れ確認には含めない。
既存の Firebase プロジェクトを使い、UID とデータを維持する。

## 環境と設定ファイル

| 環境 | Firebase プロジェクト | Bundle ID |
| --- | --- | --- |
| dev | `everyone-teigi-dev` | `com.toda.teigiii.dev` |
| prod | `everyone-teigi-prod` | `com.toda.teigiii` |

`scripts/firebase/config.py` は Bundle ID が完全一致する iOS アプリを選ぶ。
取得した plist のプロジェクト、Bundle ID、App ID、OAuth クライアント ID を検査してから、次のファイルを更新する。
取得内容と Dart の iOS 用 `FirebaseOptions` の App ID、プロジェクト、Bundle ID が一致しない場合も反映を中断する。

- `mobile_app/ios/{dev,prod}/GoogleService-Info.plist`
- `mobile_app/ios/Flutter/Firebase-{dev,prod}.xcconfig`

どちらも公開 SDK 設定として Git で管理する。
xcconfig の内容は Google のクライアント ID と URL スキームであり、Apple の秘密鍵や OAuth クライアントシークレットは含めない。
検証に失敗した取得内容は反映しない。
複数ファイルの置換中に失敗した場合は元のファイルへの復元を試み、復元できなかった場合もエラーを返す。

## 設定の取得とローカル検査

Python 3、Firebase CLI、Just を用意する。
Nix を使う場合も Firebase CLI は別途必要となる。
Firebase CLI で対象プロジェクトを読めるアカウントにログインしてから実行する。

```bash
firebase login
just firebase-configure dev
just firebase-check dev
just firebase-configure prod
just firebase-check prod
```

`configure` は既存アプリの設定を取得してローカルファイルに反映する。
クラウド上のアプリや認証プロバイダーは作成・変更しない。
`check` はローカルの plist と生成 xcconfig の整合を検査し、外部通信は行わない。
同じ設定の再取得ではファイルを書き換えない。
iOS の各ビルド設定は生成 xcconfig を必須で読み込むため、CI の checkout にも両環境の xcconfig を含める。

## プロバイダーの監査

監査は Google Cloud CLI の Application Default Credentials（ADC）を使用する。
Firebase CLI のログインとは別の認証となる。

```bash
gcloud auth application-default login
just firebase-audit dev
just firebase-audit prod
```

`audit` は Apple / Google プロバイダーの有効状態だけを表示する。
`complete` は読み取り完了を表し、両プロバイダーの有効化や実機動作を保証しない。
鍵やアクセストークンは出力しない。

macOS の Python に CA 証明書が設定されておらず TLS 検証に失敗する場合は、システムの CA を明示する。
証明書検証は無効にしない。

```bash
SSL_CERT_FILE=/etc/ssl/cert.pem just firebase-audit dev
```

## 確認済みの状態と残る作業

2026-10-26 に dev / prod の最新 plist を取得し、ローカル検査の成功を確認した。
同日、両環境とも Apple / Google プロバイダーが有効であることを監査 API で確認した。
これらの操作によるクラウド設定の変更はない。

本番の Dart 設定は旧 Bundle ID `com.toda.teigiApp` の Firebase App ID を参照していたため、現在の `com.toda.teigiii` の登録に揃えた。
Firebase プロジェクトは変わらず、Auth の UID も変更しない。
App Check と計測は Firebase アプリ登録に依存するため、リリース前に現在の登録での動作を確認する。
現在の dev / prod アプリに DeviceCheck 設定が存在することは、[App Check の取得 API](https://firebase.google.com/docs/reference/appcheck/rest/v1/projects.apps.deviceCheckConfig/get) で確認した。
設定の存在と、実機でのトークン発行の成功は区別する。

Apple Developer 側の App ID の Sign in with Apple、鍵、プロビジョニングは未確認である。
Firebase 側の Apple 設定と併せて確認し、実機で次の受け入れ確認を行う。

1. Apple / Google それぞれで匿名アカウントへ連携し、UID と既存データが変わらないことを確認する。
2. 再インストール後に Welcome から復元し、既存データへ戻れることを確認する。
3. 既存アカウントとの衝突時に件数を確認でき、キャンセルや認証失敗で元のデータが消えないことを確認する。
4. 切り替え成功後に元の匿名アカウントだけが削除され、後処理の失敗が表示されることを確認する。
5. 通常削除で再認証を要求し、Apple の認可失効に失敗した場合はサーバーのデータが残ることを確認する。

実機では [iOS 実機デバッグ](ios-physical-device-debug.md) に従い、profile モードを使う。
受け入れ確認が終わるまで [実装計画](plans/2026-08-12-apple-google-auth-linking.md) は完了扱いにしない。
