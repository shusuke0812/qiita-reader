package com.shusuke.qiitareader.domain.reporterror

/**
 * エラー報告時に Sentry のブレッドクラムとして付与するコンテキスト。
 * ReportErrorUseCase に渡すと、送信直前に addBreadcrumb され、次に送るエラーイベントに付く。
 *
 * @param message 操作の説明（例: "記事検索"）
 * @param category 分類（例: "operation"）。null 可
 * @param data 追加データ（例: "query" → 検索キーワード）。null 可
 */
data class BreadcrumbContext(
    val message: String,
    val category: String? = null,
    val data: Map<String, String>? = null
)
