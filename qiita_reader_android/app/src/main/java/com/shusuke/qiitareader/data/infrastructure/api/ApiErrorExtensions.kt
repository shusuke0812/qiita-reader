package com.shusuke.qiitareader.data.infrastructure.api

import retrofit2.HttpException
import java.io.IOException

fun Throwable.toCustomApiError(): CustomApiError = when (this) {
    is IOException -> CustomApiError.NetworkError(this)
    is HttpException -> when (code()) {
        in 400..499 -> CustomApiError.InvalidRequest(message(), code())
        in 500..599 -> CustomApiError.ServerError(message(), code())
        else -> CustomApiError.Unknown
    }
    else -> CustomApiError.Unknown
}
