package com.shusuke.qiitareader.data.infrastructure.api

/**
 * API 通信エラー（iOS APIError に相当）。
 *
 * Result.failure(apiError) や catch にそのまま使いたいため、Throwableを継承する。
 * ```
 * // ログで原因例外を出力
 * result.onFailure { error ->
 *     Log.e("Api", error.message, error)
 *     error.getCause()?.let { cause ->
 *         Log.e("Api", "Caused by: ${cause.message}", cause)
 *     }
 * }
 *
 * // 原因の有無で分岐
 * when (val cause = apiError.getCause()) {
 *     is IOException -> showNetworkError()
 *     is JsonException -> showParseError()
 *     null -> showGenericError()
 * }
 * ```
 */
sealed class CustomApiError : Throwable {
    constructor() : super()
    constructor(cause: Throwable?) : super(cause)

    data object LackOfAccessToken : CustomApiError()
    data class NetworkError(override val cause: Throwable) : CustomApiError(cause)
    data class InvalidRequest(val dataString: String?, val statusCode: Int, override val cause: Throwable? = null) : CustomApiError(cause)
    data class ResponseParseError(override val cause: Throwable) : CustomApiError(cause)
    data class ServerError(val dataString: String?, val statusCode: Int, override val cause: Throwable? = null) : CustomApiError(cause)
    data object Unknown : CustomApiError()
}
