package com.shusuke.qiitareader.data.infrastructure.qiitaapi

import android.util.Log
import okhttp3.Interceptor
import okhttp3.Response
import java.io.IOException

/**
 * 失敗時にリトライする OkHttp の Interceptor。
 * ネットワーク不安定時や一時的なサーバーエラー時に、指定回数だけ指数バックオフで再試行する。
 *
 * リトライ対象:
 * - [IOException]（接続エラー・タイムアウト・読み取り失敗など）
 * - HTTP 408 Request Timeout, 429 Too Many Requests
 * - HTTP 502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout
 *
 * リトライしないもの: 上記以外の 4xx（クライアントエラー）・2xx/3xx
 */
class RetryInterceptor(
    private val maxRetryCount: Int = 3,
    private val initialDelayMs: Long = 500,
    private val multiplier: Double = 2.0,
    private val sleeper: (Long) -> Unit = { Thread.sleep(it) }
) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        var lastException: IOException? = null
        val request = chain.request()

        repeat(maxRetryCount + 1) { attempt ->
            try {
                val response = chain.proceed(request)
                if (response.isSuccessful) return response
                if (shouldRetryStatusCode(response.code) && attempt < maxRetryCount) {
                    response.close()
                    sleepBackoff(attempt)
                } else {
                    return response
                }
            } catch (e: IOException) {
                lastException = e
                if (attempt == maxRetryCount) throw e
                Log.d("RetryInterceptor", "Retry attempt ${attempt + 1}/$maxRetryCount after IOException: ${e.message}")
                sleepBackoff(attempt)
            }
        }

        throw lastException ?: IOException("Unexpected retry loop exit")
    }

    private fun shouldRetryStatusCode(code: Int): Boolean = when (code) {
        408, 429 -> true  // Request Timeout, Too Many Requests
        502, 503, 504 -> true  // Bad Gateway, Service Unavailable, Gateway Timeout
        else -> false
    }

    private fun sleepBackoff(attempt: Int) {
        var delayMs = initialDelayMs.toDouble()
        repeat(attempt) { delayMs *= multiplier }
        sleeper
    }
}
