package com.shusuke.qiitareader.data.infrastructure.sentry

import io.sentry.Sentry
import io.sentry.protocol.User

class SentryClient {

    fun captureException(
        error: Throwable,
        screenName: String,
        operation: String,
        userId: String?,
        extra: Map<String, String>? = null
    ) {
        Sentry.withScope { scope ->
            scope.setTag("screen", screenName)
            scope.setTag("operation", operation)
            scope.user = userId?.let { User().apply { id = it } }
            extra?.forEach { (key, value) -> scope.setExtra(key, value) }
            Sentry.captureException(error)
        }
    }
}
