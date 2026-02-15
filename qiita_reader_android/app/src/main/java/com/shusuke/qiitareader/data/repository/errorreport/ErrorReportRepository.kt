package com.shusuke.qiitareader.data.repository.errorreport

import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError
import com.shusuke.qiitareader.data.infrastructure.sentry.SentryClient

/**
 * エラーを Sentry に送信するための Repository。
 * Domain / Presentation からはこの interface のみを参照する。
 */
interface ErrorReportRepository {

    /**
     * 操作ログをブレッドクラムとして記録する。
     * 次に [reportApiError] で送信するエラーイベントに付与される。
     *
     * @param message 操作の説明（例: "記事検索"）
     * @param category 分類（例: "operation"）。null の場合は送らない。
     * @param data 追加データ（例: "query" → 検索キーワード）。null の場合は送らない。
     */
    fun addBreadcrumb(
        message: String,
        category: String? = null,
        data: Map<String, String>? = null
    )

    /**
     * API エラーを Sentry に送信する。
     *
     * @param customApiError 送信するエラー
     * @param screen 画面識別子（例: "ArticleSearch"）
     * @param operation 操作識別子（例: "searchItems"）
     * @param userId ログイン済みユーザーID。未ログインの場合は null
     * @param extra 追加コンテキスト（例: 検索クエリ）。null の場合は送らない。
     */
    fun reportApiError(
        customApiError: CustomApiError,
        screen: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>? = null
    )
}

class ErrorReportRepositoryImpl(
    private val sentryClient: SentryClient
) : ErrorReportRepository {

    override fun addBreadcrumb(
        message: String,
        category: String?,
        data: Map<String, String>?
    ) {
        sentryClient.addBreadcrumb(message = message, category = category, data = data)
    }

    override fun reportApiError(
        customApiError: CustomApiError,
        screen: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>?
    ) {
        sentryClient.captureApiError(
            customApiError = customApiError,
            screen = screen,
            operation = operation,
            userId = userId,
            extra = extra
        )
    }
}
