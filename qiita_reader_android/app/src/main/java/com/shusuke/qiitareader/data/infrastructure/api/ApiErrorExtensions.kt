package com.shusuke.qiitareader.data.infrastructure.api

import retrofit2.HttpException
import java.io.IOException

fun Throwable.toCustomApiError(): CustomApiError = when (this) {
    is IOException -> CustomApiError.NetworkError(this)
    is HttpException -> when (code()) {
        in 400..499 -> CustomApiError.InvalidRequest(message(), code(), cause = this)
        in 500..599 -> CustomApiError.ServerError(message(), code(), cause = this)
        else -> CustomApiError.Unknown
    }
    else -> CustomApiError.Unknown
}
