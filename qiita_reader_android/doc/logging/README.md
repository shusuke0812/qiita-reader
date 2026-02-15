# ロギング・クラッシュレポート設計（Sentry）

本ドキュメントは、qiita-reader-android へ **Sentry** を導入する際の設計方針を定める。  
クラッシュ・未処理例外の収集に加え、ブレッドクラムとパフォーマンス監視を導入し、本番環境の不具合を把握しやすくすることを目的とする。

---

## 実装状況（初期化まで完了）

- **SDK**: `sentry-android` と `sentry-compose` を `libs.versions.toml` および `app/build.gradle.kts` で追加。Sentry Gradle プラグイン（`io.sentry.android.gradle`）を適用。
- **DSN の設定**: `env.defaults.properties` に `SENTRY_DNS`（prod）・`STG_SENTRY_DNS`（staging）を定義。実際の値は `env.properties` に記述し、secrets プラグイン経由で `BuildConfig` に渡す。アプリからは `Env.Qiita.sentryDns` で参照。
- **手動初期化**: `AndroidManifest.xml` で `SentryInitProvider` を `tools:node="remove"` によりマージ結果から削除し、[Sentry の手動初期化](https://docs.sentry.io/platforms/android/configuration/manual-init/)に従う。`QiitaReaderApplication#onCreate` で `Env.Qiita.sentryDns` が空でない場合のみ `SentryAndroid.init()` を呼ぶ。DSN が未設定のときは Sentry は有効にせず、クラッシュしない。

---

## 目的とスコープ

- **クラッシュ・未処理例外の収集**  
  アプリのクラッシュや、キャッチされずに上位に伝播した例外を Sentry に送信し、発生状況・スタックトレース・デバイス情報を確認できるようにする。
- **ブレッドクラム**  
  重要な操作（画面表示、API 呼び出し開始/完了、エラー表示など）をブレッドクラムとして記録し、クラッシュ直前のユーザー操作の流れを追えるようにする。
- **パフォーマンス**  
  起動時間や画面表示時間などのトランザクション計測を行い、遅延やボトルネックを把握できるようにする。
- **オフライン時のエラー**  
  オフライン中に発生したクラッシュや例外はローカルに保存し、オンラインに復帰したタイミングで Sentry へアップロードする。送信漏れを防ぎ、ネットワーク不安定時や機内モードでの不具合も把握できるようにする。

---

## アーキテクチャとの関係

- **設計の正本**: [doc/architecture/README.md](../architecture/README.md) の 3 層（Presentation / Domain / Data）とエラー扱いに従う。
- **既存のエラー扱い**:  
  - Data 層では `Result.failure(CustomApiError)` を返し、例外は Repository 内でキャッチして `CustomApiError` に変換している。  
  - Sentry には **キャッチされなかった例外**、**意図的に報告するエラー**に加え、**ネットワークエラー（4xx/5xx）** も送信する。4xx/5xx を送ることで、API の障害やクライアント側のリクエスト不備の傾向を把握できる。
- **初期化**  
  Sentry の初期化は **Application**（`QiitaReaderApplication`）の `onCreate` で行う。DSN は `Env.Qiita.sentryDns`（BuildConfig 由来）を参照し、空のときは `SentryAndroid.init()` を呼ばない。自動初期化用の `SentryInitProvider` は AndroidManifest で `tools:node="remove"` により削除している。

---

## 送信するもの・送信しないもの

| 種別 | 送信する | 送信しない（方針） |
| --- | --- | --- |
| 未処理例外・クラッシュ | ✅ | — |
| 意図的に `captureException` した例外 | ✅ | — |
| ネットワークエラー（4xx/5xx） | ✅ | — |
| ブレッドクラム | ✅ | — |
| パフォーマンストランザクション | ✅ | — |
| オフライン時に発生したエラーの遅延送信 | ✅ | — |

---

## 実装方針（概要）

1. **Sentry Android SDK の追加**  
   - 公式 [Sentry Android](https://docs.sentry.io/platforms/android/manual-setup/) に従い、Gradle で `sentry-android` を追加する。  
   - Compose 利用のため `sentry-compose` を追加し、ブレッドクラム・パフォーマンス計測に活用する。
2. **初期化**  
   - `Application#onCreate` で、`Env.Qiita.sentryDns` が空でない場合のみ `SentryAndroid.init()` を呼ぶ。  
   - DSN は **`env.properties`** にキー **`SENTRY_DNS`**（prod）・**`STG_SENTRY_DNS`**（staging）で定義する。ビルド時に `BuildConfig` に渡し、アプリからは `Env.Qiita.sentryDns` で参照する。`env.properties` はリポジトリに含めない（secrets 管理に合わせる）。  
   - 手動初期化のため、`AndroidManifest.xml` で `SentryInitProvider` を `tools:node="remove"` によりマージ結果から削除している（DSN 未設定時に ContentProvider が DSN 必須でクラッシュするのを防ぐ）。
3. **オフライン時のエラー送信**  
   - Sentry SDK のエンベロープキャッシュ（ディスクキュー）を有効にし、オフラインで発生したイベントをローカルに保存する。  
   - オンライン復帰時（ネットワーク利用可能になったタイミング）に、キューに溜まったイベントを自動でアップロードする。SDK のデフォルト挙動または `beforeSend` で送信タイミングを確認する。
4. **環境の切り分け**  
   - debug ビルドではサンプルレートを下げる、または開発用 DSN を指定する等で、本番イベントを汚さないようにする。
5. **ブレッドクラム**  
   - 画面表示・API 呼び出し開始/完了・エラー表示など、重要な操作で `Sentry.addBreadcrumb()` を呼ぶ。  
   - Compose の画面や ViewModel の主要処理でブレッドクラムを追加し、クラッシュ時の文脈が分かるようにする。
6. **パフォーマンス（トランザクション）**  
   - アプリ起動・画面表示など、重要な操作をトランザクションとして計測する。  
   - `Sentry.startTransaction()` / `finish()` または SDK の自動計測機能を有効化し、`tracesSampleRate` でサンプリングする。
7. **ネットワークエラー（4xx/5xx）の送信**  
   - `CustomApiError` のうち HTTP 4xx/5xx に該当するものを検知したタイミングで、Sentry に送信する（`captureMessage` またはコンテキスト付きの `captureException`）。Repository で失敗を emit する箇所、または ViewModel で `Result.failure` を受け取った箇所のいずれかで、ステータスコードやエラー種別を付与して送る。  
   - 送信内容に PII（個人を特定しうる情報）やリクエストボディを含めない。
8. **手動報告**  
   - 想定外の状態（例: ある `CustomApiError` の分岐で未対応の型が来た場合）のみ、`Sentry.captureException()` で送信する。  
   - 送信前に PII（個人を特定しうる情報）が含まれないよう注意する。
9. **テスト**  
   - 単体テストでは Sentry をモックまたは無効化し、外部送信が行われないようにする。

---

## 設定項目（検討用）

- **DSN**: Sentry プロジェクトの DSN。**`env.properties`** にキー **`SENTRY_DNS`** で定義し、ビルド時に `BuildConfig` へ注入する。
- **environment**: `debug` / `release` など。Sentry ダッシュボードでフィルタするため。
- **tracesSampleRate**: パフォーマンス計測のサンプリング率（0.0 ～ 1.0）。本番では 1.0 または適切な割合を指定する。
- **attachStacktrace**: デフォルト true でよい。
- **sendDefaultPii**: 個人情報を含めない方針とする場合は false。

---

## ドキュメント・参照

- [Sentry Android 公式ドキュメント](https://docs.sentry.io/platforms/android/manual-setup/)
- エラー型の詳細: [doc/error-handling/README.md](../error-handling/README.md)  
- アプリ全体の設計: [doc/architecture/README.md](../architecture/README.md)
