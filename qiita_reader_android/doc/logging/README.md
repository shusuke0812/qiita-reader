# Sentryを使ったログレポート設計

## 基本コンセプト

- Sentryのエラーログから原因がわかること
  - 入力、出力内容をロギングする。特に出力内容にはエラーの原因を記載する。
- Sentryのエラーログを使って不具合を再現できること
  - 改善策が有効か否かを確認するために不具合を再現する必要がある。
  - そのためにエラーログが発生するまでの処理をトレースできるようにしておく。
- オフラインで発生したエラーもローカルに保持し、オンライン復帰時にサーバーへアップロードする

---

## 実装

### 何を出力するか

- API通信エラー
  - ステータスコードが 4XX/5XX のもの
- クラッシュログ

### 出力しないログ

- 個人情報

### 出力する方法、出力する場所

- UIの操作、API通信のリクエスト・レスポンス内容はLog.dを使ってエラーのBreadcrumbsの一部としてSentryサーバーに出力する。
- エラーの捕捉およびSentryサーバーへの出力は ViewModel で行う。「どの画面・どの操作でエラーが出たか」はViewModelが知っている状態とする。
- Sentryサーバーへ出力するクラスはDomainのReportErrorUseCaseとして定義する。
- productFlavorsごとにSentryのプロジェクトを作成しDSNを設定する。

### 出力されたログを検索する方法

- どのユーザーで発生したログか検索できるようにするためにReportErrorUseCaseではUser IDをTagとして設定するようにする。
- User IDはRepositoryから取得できるようにしておく。

## 設定項目

- **DSN**: Sentry プロジェクトの DSN。**`env.properties`** にキー **`SENTRY_DNS`** で定義し、ビルド時に `BuildConfig` へ注入する。
- **tracesSampleRate**: パフォーマンス計測のサンプリング率（0.0 ～ 1.0）。本番では 1.0 または適切な割合を指定する。
- **sendDefaultPii**: 個人情報を含めない方針とする場合はfalse。
- **isEnableLogcatBreadcrumbs**: LogcatをBreadcrumbsに統合する場合はtrue。

---

## ドキュメント・参照

- [Sentry Android 公式ドキュメント](https://docs.sentry.io/platforms/android/manual-setup/)
- エラー型の詳細: [doc/error-handling/README.md](../error-handling/README.md)  
- アプリ全体の設計: [doc/architecture/README.md](../architecture/README.md)
