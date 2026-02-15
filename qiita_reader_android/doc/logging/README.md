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

## エラーログ送信のアーキテクチャ概要

記事検索（TextField でクエリ入力 → 検索）など、画面操作に伴って発生したエラーを Sentry に送る場合の「どこで受け取り、いつ送るか」と、送信処理をまとめる層の構成を述べる。

### エラーを受け取るクラス・メソッド

- **受け取り場所**: **ViewModel**。  
  例: 記事検索では `ArticleSearchViewModel.searchItems()` 内で `searchArticlesUseCase.invoke(...).collect { result -> ... }` しており、`result` が `Result.failure` のときが「エラーを認識した」タイミングである。
- エラー自体は **Data 層の Repository**（例: `ItemsRepository.getItemsFlow`）で API 失敗を `Result.failure(CustomApiError)` として emit し、UseCase はその Flow をそのまま返す。**補足（受け取り）は ViewModel の collect の onFailure 側**で行う。  
  Presentation は「表示用のエラー（例: `ArticleSearchError`）に変換して UI State に載せる」責務に加え、「Sentry へ報告するかどうかを決め、報告を依頼する」役割を持つ。

### アップロードのタイミング

- **ViewModel が `Result.failure` を受け取った直後**（collect の `onFailure` ブロック内）で、Sentry へのアップロードを依頼する。  
  UI State を Failure に更新するのと同時、またはその直後に「エラー報告用の UseCase」を呼ぶ形にすると、同じエラーについて「ユーザーへの表示」と「Sentry への送信」のタイミングが揃う。

### Sentry 送信をまとめる層（Data 層）

- **Infrastructure: SentryClient**  
  Sentry SDK（`Sentry.captureException` / `captureMessage` 等）をラップするクラス。記事検索エラーに限らず、他の操作で発生したエラーを Sentry に送る場合もここを共通で使う。
- **Repository: アップロードメソッドを定義**  
  「エラーを Sentry に送る」という振る舞いを Domain / Presentation から使うために、**Repository のインターフェースにアップロード用メソッド**を定義する。  
  実装クラスは Infrastructure の **SentryClient** を依存に持ち、そのメソッド内で SentryClient を呼んで実際の送信を行う。  
  Domain / Presentation からは「Repository のインターフェース」だけを参照し、Sentry や SentryClient の詳細は Data 層に閉じる（[doc/architecture/README.md](../architecture/README.md) の Data 層の考え方に合わせる）。  
  配置の目安: **Infrastructure** に `infrastructure/sentry/` 等を設けて SentryClient を置き、**Repository** に `repository/errorreport/` 等を設けて ErrorReportRepository（interface + 実装）を置く。

### 呼び出しの流れ（例: 記事検索でエラー時）

1. **ViewModel**（例: `ArticleSearchViewModel.searchItems()` の collect 内 `onFailure`）  
   → エラーを受け取り、UI State を Failure に更新。  
   → 同時に「エラー報告用の UseCase」を呼ぶ（例: `reportErrorUseCase.invoke(error)`）。
2. **UseCase**（例: ReportErrorUseCase）  
   → Repository のアップロードメソッドを呼ぶ（例: `errorReportRepository.reportApiError(customApiError)`）。
3. **Repository 実装**（例: ErrorReportRepositoryImpl）  
   → **SentryClient** を呼ぶ（例: `sentryClient.captureApiError(customApiError)`）。
4. **SentryClient**（Infrastructure）  
   → Sentry SDK を使ってイベントを送信する。

このようにすると、「どの画面・どの操作でエラーが出たか」は ViewModel が知っており、**「Sentry に送る」という処理は Data 層（SentryClient + Repository）にまとまり、他操作でも同じ Repository / SentryClient を再利用できる**。

### コンテキスト（画面・操作・ユーザーID）の付与

エラーログと一緒に **どの画面で・どのような操作で発生したか**、および **ユーザーID** を Sentry に送り、スタックトレースやイベント詳細から原因を追いやすくし、Sentry コンソールからエラーログを検索・フィルタしやすくする。

- **付与する情報**  
  - **画面**: 例として画面名や画面を一意に表す識別子（例: `ArticleSearch`、`記事検索`）。  
  - **操作**: 例としてユーザーが行った操作の種類（例: `記事検索`、`searchItems`、`ストック追加`）。  
  - **ユーザーID**: ログイン済みユーザーを一意に表す識別子。Sentry コンソールで「特定ユーザーに発生したエラー」で検索・フィルタするために付与する。未ログインの場合は空文字や null を渡し、送信時に含めない、または `anonymous` 等のタグで区別する。
- **送信の形**  
  Sentry の **タグ（tag）** または **コンテキスト（context）** として付与し、`captureException` / `captureMessage` する際にスコープに設定する。ユーザーID は Sentry の [User 設定](https://docs.sentry.io/platforms/android/enriching-events/identify-user/)（`Sentry.setUser()` やイベントごとの user フィールド）に設定すると、コンソールの検索・フィルタで利用しやすい。  
  これにより、Sentry のイベント詳細に「画面」「操作」「ユーザーID」が表示され、スタックトレースとあわせて確認できる。
- **誰が渡すか**  
  ViewModel が「どの画面・どの操作で失敗したか」を知っており、ログイン状態に応じて **ユーザーID** も取得できるため、エラー報告用の UseCase を呼ぶときに **画面名・操作名・ユーザーID（未ログイン時は null 等）を引数で渡す**。UseCase → Repository → SentryClient の順でその情報を伝え、SentryClient が送信前にタグ／コンテキスト／User を設定する。  
  Repository のアップロードメソッドのシグネチャは、例: `reportApiError(customApiError: CustomApiError, screen: String, operation: String, userId: String?)` のようにコンテキストを受け取る形にする。

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
   - **画面・操作・ユーザーID の付与**: どの画面・どの操作で発生したか、およびユーザーID（ログイン済みの場合）をエラーログと一緒に送る。ViewModel が報告用 UseCase を呼ぶ際に画面名・操作名・ユーザーID（未ログイン時は null 等）を渡し、SentryClient がタグ／コンテキスト／User に設定してから送信する。Sentry コンソールでユーザー単位にエラーを検索・フィルタしやすくなる（上記「コンテキスト（画面・操作・ユーザーID）の付与」を参照）。
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
