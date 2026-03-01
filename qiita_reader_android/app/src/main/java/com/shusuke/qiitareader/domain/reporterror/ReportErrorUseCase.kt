package com.shusuke.qiitareader.domain.reporterror

import com.shusuke.qiitareader.data.repository.errorreport.ErrorReportRepository

interface ReportErrorUseCase {
    operator fun invoke(
        error: Throwable,
        screenName: String,
        operation: String,
        extra: Map<String, String>? = null
    )
}

class ReportErrorUseCaseImpl(
    private val errorReportRepository: ErrorReportRepository
) : ReportErrorUseCase {

    override operator fun invoke(
        error: Throwable,
        screenName: String,
        operation: String,
        extra: Map<String, String>?
    ) {
        errorReportRepository.reportError(
            error = error,
            screenName = screenName,
            operation = operation,
            userId = getUserId(),
            extra = extra
        )
    }

    private fun getUserId(): String? {
        // TODO: UserRepository から取得する
        return "dummy-user-id"
    }
}
