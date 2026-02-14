# Qiita Reader Android

Qiita の記事検索・閲覧を行う Android アプリ。  
構成は [qiita_reader_ios](../qiita_reader_ios) を参考にし、Presentation / Domain / Data の3層で整理している。

---

## 設計思想（全体）

- **Presentation**:
  - 画面（Fragment）・UI（Compose）・ViewModel。ユーザー入力と表示のみを担当する。
- **Domain**:
  - UseCase。Repositoryや他のUseCaseを組み合わせたアプリ固有の機能を担当。
- **Data**: 
  - Infrastructure。API・DB・設定などへのアプリ外のデータにアクセスする機能を担当する。
  - Repository。Infrastructureを使い、アプリ内で使うデータの永続化を担当する。

画面遷移は Fragment / Activity の API で行い、Compose のナビゲーションは使わない。  
Compose は State を持たず、ViewModel が保持した State を Fragment 経由で Compose に渡す。

---

## Data 層の設計思想

Data 層は「データの取得・永続化」と「外部サービスとの通信」を担当する。  
Domain / Presentation からは **Repository のインターフェース（Protocol）** だけを参照し、実装の詳細（HTTP クライアントやエラー変換）は Data 層に閉じる。

### 責務

- **Repository**  
  UseCase から呼ばれる窓口。  
  - API の呼び出し、レスポンスのモデル（Entity）への変換  
  - 通信エラー・HTTP エラーの捕捉と、アプリ用の `ApiError` へのマッピング  
  - 必要ならキャッシュや DB とのやりとりもここで行う（現状は API のみ）
- **Infrastructure**  
  実際の通信手段（Retrofit、OkHttp、シリアライズなど）の設定と、API クライアントの提供。  
  Repository は「API のインターフェース（例: `QiitaApiService`）」にだけ依存し、その実装が Retrofit であることは Data 層の内側の話に留める。

### パッケージ構成（Data 層）

```
data/
├── repository/                    # ドメインに近い「データの入出力」の抽象
│   └── items/
│       ├── Item.kt                # API レスポンスと同一のモデル（Snake_case → プロパティは Kotlin 慣習）
│       ├── ItemList.kt            # 一覧用のラッパー
│       ├── ItemsRepository.kt     # 実装
│       └── (ItemsRepositoryProtocol は同一ファイルで interface として定義)
└── infrastructure/                # 通信・永続化の具体的な手段
    ├── api/
    │   └── ApiError.kt            # 通信・HTTP エラーを表す型（Presentation の ArticleSearchError でラップ可能）
    └── qiitaapi/
        ├── QiitaApiService.kt     # Retrofit の interface（GET /items など）
        └── QiitaApiClient.kt      # Retrofit の組み立て・BASE_URL・Json 設定
```

- **モデル（Item, ItemList）**  
  Qiita API のレスポンス形状に合わせた Data 層のモデル。  
  `@SerialName` で Snake_case とマッピングし、表示用の導出値（例: `formattedUpdatedAtString`）は Data 層のモデルに持たせている（Presentation で重複させない）。
- **ApiError**  
  ネットワーク障害、4xx/5xx、パース失敗などを sealed class で表現。  
  Repository は `Result<ItemList>` を返し、失敗時は `Result.failure(ApiError)` とする。  
  Presentation 側では必要に応じて `ArticleSearchError` などに変換する。

### スレッド・非同期

- Repository の `getItems` は **suspend 関数**。  
  呼び出し側（UseCase / ViewModel）は Coroutine で呼ぶ。
- **IO スレッド**で API を実行するため、Repository 内で `withContext(Dispatchers.IO)` を使用。  
  メインスレッドでブロックしない。

### エラーの扱い

- **Repository**  
  `runCatching` で API 呼び出しを囲み、  
  - 成功: `Result.success(ItemList)`  
  - 失敗: `IOException` → `ApiError.NetworkError`、`HttpException` の status に応じて `InvalidRequest` / `ServerError` などにマッピングし、`Result.failure(apiError)` で返す。
- **Domain / Presentation**  
  `Result` を受け取り、成功時はデータを流し、失敗時は `ApiError`（またはそれをラップした UI 用エラー）でメッセージ表示やリトライを決める。

### テスト・差し替え

- `ItemsRepositoryProtocol` を interface にしているので、UseCase や ViewModel のテストでは **モックの Repository** を注入できる。
- 同様に、`QiitaApiService` を別実装（モックやスタブ）に差し替えることで、Repository 単体のテストやオフライン動作の検証がしやすい。

---
