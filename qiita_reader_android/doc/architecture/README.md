# クラス設計

- アプリは Presentation, Domain, Data の３つの責務を担うレイヤーで構成される。
- PresentationがDomainを参照し、DomainがDataを参照する依存関係になっている。
- 各レイヤーの役割は次の通りとする。

- **Presentation**:
  - ユーザー入力と表示のみを担当。
  - 画面はFragment、画面内のUIコンポーネントはComposeを使う。
  - Compose は State を持たず、ViewModel が保持した State を Fragment 経由で Compose に渡す
- **Domain**:
  - Repositoryや他のDomainクラスを組み合わせたアプリ固有の機能を担当
  - 非同期処理
    - 状態が変化する場合は Flow を使う。Repository が `Flow<Result<T>>` を返し、UseCase はその Flow をそのまま返す。ViewModel が collect して UI State に変換する。
    - 一発の操作は suspend を使う。Repository / UseCase が `suspend fun ...(): Result<T>` で返す。
- **Data**:
  - Infrastructure
    - リモートもしくはローカルからデータを取得するクライアントを担当。
  - Repository
    - 各クライアントを使いアプリで必要なデータをまとめる。

# 画面遷移

- Fragment / Activity の API で行い、Compose のナビゲーションは使わない。

