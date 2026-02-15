package com.shusuke.qiitareader.data.infrastructure.sentry

import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError
import io.sentry.Breadcrumb
import io.sentry.Sentry
import io.sentry.SentryLevel
import io.sentry.protocol.User

/**
 * Sentry SDK をラップするクライアント。
 * エラー送信時に画面・操作・ユーザーID をコンテキストとして付与する。
 * 操作ログはブレッドクラムで記録し、次に送信するエラーイベントに付与される。
 */
class SentryClient {

    /**
     * ブレッドクラムを追加する。
     * 次に [captureApiError] 等で送信するエラーイベントに、操作の流れとして付与される。
     *
     * @param message 操作の説明（例: "記事検索"）
     * @param category 分類（例: "operation"）。null の場合は "default" 相当
     * @param data 追加データ（例: "query" → 検索キーワード）。PII に注意すること。
     */
    fun addBreadcrumb(
        message: String,
        category: String? = null,
        data: Map<String, String>? = null
    ) {
        val breadcrumb = Breadcrumb().apply {
            setMessage(message)
            category?.let { setCategory(it) }
            setLevel(SentryLevel.INFO)
            data?.forEach { (key, value) -> setData(key, value) }
        }
        Sentry.addBreadcrumb(breadcrumb)
    }

    /**
     * API エラーを Sentry に送信する。
     * 画面・操作・ユーザーID をタグ／User に設定してから [customApiError] を送る。
     *
     * @param customApiError 送信するエラー（CustomApiError は Throwable を継承）
     * @param screen 画面識別子（例: "ArticleSearch"）
     * @param operation 操作識別子（例: "searchItems"）
     * @param userId ログイン済みユーザーID。未ログインの場合は null
     * @param extra 追加コンテキスト（例: 検索クエリ）。Sentry の extra に載る。PII に注意すること。
     */
    fun captureApiError(
        customApiError: CustomApiError,
        screen: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>? = null
    ) {
        Sentry.withScope { scope ->
            scope.setTag("screen", screen)
            scope.setTag("operation", operation)
            scope.user = userId?.let { User().apply { id = it } }
            extra?.forEach { (key, value) -> scope.setExtra(key, value) }
            Sentry.captureException(customApiError)
        }
    }
}
