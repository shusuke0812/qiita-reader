# Qiita Reader Android

Qiita の記事検索・閲覧を行う Android アプリ。  
構成は [qiita_reader_ios](../qiita_reader_ios) を参考にし、Presentation / Domain / Data の3層で整理している。

---

## ドキュメント

| ドキュメント | 説明 |
| --- | --- |
| [設計思想・アーキテクチャ](doc/architecture/README.md) | 全体の設計思想、Data 層の責務・パッケージ構成・エラー・テスト方針 |
| [エラーハンドリング](doc/error-handling/README.md) | API エラーや UI 側のエラー扱い（詳細は別途記載予定） |
| [ロギング・クラッシュレポート（Sentry）](doc/logging/README.md) | Sentry 導入の設計（クラッシュ収集・ブレッドクラム・設定方針） |
