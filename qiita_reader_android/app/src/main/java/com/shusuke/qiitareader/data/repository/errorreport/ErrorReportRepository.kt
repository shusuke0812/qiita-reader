package com.shusuke.qiitareader.data.repository.errorreport

import com.shusuke.qiitareader.data.infrastructure.sentry.SentryClient

interface ErrorReportRepository {

    fun reportError(
        error: Throwable,
        screenName: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>? = null
    )
}

class ErrorReportRepositoryImpl(
    private val sentryClient: SentryClient
) : ErrorReportRepository {

    override fun reportError(
        error: Throwable,
        screenName: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>?
    ) {
        sentryClient.captureException(
            error = error,
            screenName = screenName,
            operation = operation,
            userId = userId,
            extra = extra
        )
    }
}
