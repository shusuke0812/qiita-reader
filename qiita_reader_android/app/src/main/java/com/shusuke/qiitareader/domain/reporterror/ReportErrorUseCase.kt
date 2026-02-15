package com.shusuke.qiitareader.domain.reporterror

import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError
import com.shusuke.qiitareader.data.repository.errorreport.ErrorReportRepository

/**
 * エラーを Sentry に報告する UseCase。
 * ViewModel が Result.failure を受け取ったときに呼び出す。
 * [breadcrumbContext] を渡すと、送信直前にブレッドクラムを付けてからエラーを送る。
 */
interface ReportErrorUseCase {

    /**
     * API エラーを Sentry に送信する。
     * [breadcrumbContext] がある場合は先に addBreadcrumb してから reportApiError する。
     *
     * @param customApiError 送信するエラー
     * @param screen 画面識別子（例: "ArticleSearch"）
     * @param operation 操作識別子（例: "searchItems"）
     * @param userId ログイン済みユーザーID。未ログインの場合は null
     * @param extra 追加コンテキスト（extra に載せる）。null の場合は送らない。
     * @param breadcrumbContext 報告直前に付けるブレッドクラム（例: 操作名・検索クエリ）。null の場合は付けない。
     */
    fun invoke(
        customApiError: CustomApiError,
        screen: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>? = null,
        breadcrumbContext: BreadcrumbContext? = null
    )
}

class ReportErrorUseCaseImpl(
    private val errorReportRepository: ErrorReportRepository
) : ReportErrorUseCase {

    override fun invoke(
        customApiError: CustomApiError,
        screen: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>?,
        breadcrumbContext: BreadcrumbContext?
    ) {
        breadcrumbContext?.let { ctx ->
            errorReportRepository.addBreadcrumb(
                message = ctx.message,
                category = ctx.category,
                data = ctx.data
            )
        }
        errorReportRepository.reportApiError(
            customApiError = customApiError,
            screen = screen,
            operation = operation,
            userId = userId,
            extra = extra
        )
    }
}
