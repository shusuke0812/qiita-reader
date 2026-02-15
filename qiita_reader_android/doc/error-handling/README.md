# エラーハンドリング

## API リトライ

ネットワーク不安定時や一時的なサーバーエラー時に API リクエストの成功率を上げるため、**Infrastructure 層**（OkHttp）でリトライを行う。

- **実装場所**: `QiitaApiClient` に **RetryInterceptor**（`data/infrastructure/qiitaapi/RetryInterceptor.kt`）を組み込み、当該クライアントを経由する全 API 呼び出しにリトライがかかる。Repository や UseCase の変更は不要。
- **リトライ回数**: 最大 3 回リトライ（初回含め合計 4 回まで実行）。`RetryInterceptor` の `maxRetryCount` で変更可能。
- **リトライ対象**  
  - `IOException`（接続エラー・タイムアウト・読み取り失敗など）  
  - HTTP 408 Request Timeout、429 Too Many Requests  
  - HTTP 502 Bad Gateway、503 Service Unavailable、504 Gateway Timeout  
- **リトライしない**: 上記以外の 4xx（クライアントエラー）。2xx/3xx はそのまま返す。
- **待機**: 指数バックオフ（デフォルト: 500ms → 1s → 2s）。`initialDelayMs`・`multiplier` で調整可能。
