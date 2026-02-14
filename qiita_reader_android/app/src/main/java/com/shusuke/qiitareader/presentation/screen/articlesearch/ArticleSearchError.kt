package com.shusuke.qiitareader.presentation.screen.articlesearch

import com.shusuke.qiitareader.data.infrastructure.api.ApiError

/**
 * 記事検索画面用のエラー型（iOS ArticleSearchError に相当）。
 * ApiError をラップし、画面固有のエラー（検索結果0件など）を追加する。
 */
sealed class ArticleSearchError : Throwable() {
    data object NotFoundArticles : ArticleSearchError()
    data class FromApi(val error: ApiError) : ArticleSearchError()

    fun messageForDisplay(): String = when (this) {
        is NotFoundArticles -> "記事が見つかりませんでした"
        is FromApi -> when (error) {
            is ApiError.NetworkError -> "ネットワークエラー"
            is ApiError.InvalidRequest -> "リクエストエラー"
            is ApiError.ServerError -> "サーバーエラー"
            else -> "エラーが発生しました"
        }
    }
}