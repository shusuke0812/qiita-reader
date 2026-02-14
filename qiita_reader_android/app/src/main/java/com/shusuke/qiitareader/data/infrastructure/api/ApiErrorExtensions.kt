package com.shusuke.qiitareader.data.infrastructure.api

import retrofit2.HttpException
import java.io.IOException

fun Throwable.toApiError(): ApiError = when (this) {
    is IOException -> ApiError.NetworkError(this)
    is HttpException -> when (code()) {
        in 400..499 -> ApiError.InvalidRequest(message(), code())
        in 500..599 -> ApiError.ServerError(message(), code())
        else -> ApiError.Unknown
    }
    else -> ApiError.Unknown
}
