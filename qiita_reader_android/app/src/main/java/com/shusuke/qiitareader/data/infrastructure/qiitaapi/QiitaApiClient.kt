package com.shusuke.qiitareader.data.infrastructure.qiitaapi

import com.shusuke.qiitareader.BuildConfig
import kotlinx.serialization.json.Json
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import okhttp3.MediaType.Companion.toMediaType
import java.util.concurrent.TimeUnit

private const val BASE_URL = "https://qiita.com/api/v2/"

object QiitaApiClient {

    private val json = Json {
        ignoreUnknownKeys = true
        coerceInputValues = true
    }

    private val okHttpClient = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS) // TCP 3-way ハンドシェイクに失敗
        .readTimeout(30, TimeUnit.SECONDS) // ハンドシェイク後、サーバーからのレスポンスデータ待ち
        .apply {
            if (BuildConfig.DEBUG) {
                addInterceptor(HttpLoggingInterceptor().apply { setLevel(HttpLoggingInterceptor.Level.BODY) })
            }
            addInterceptor(RetryInterceptor(maxRetryCount = 3, initialDelayMs = 500))
        }
        .build()

    private val retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(okHttpClient)
        .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
        .build()

    val qiitaApiService: QiitaApiService = retrofit.create(QiitaApiService::class.java)
}
