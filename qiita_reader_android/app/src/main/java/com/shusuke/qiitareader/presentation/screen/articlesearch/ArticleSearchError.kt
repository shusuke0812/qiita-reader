package com.shusuke.qiitareader.presentation.screen.articlesearch

import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError

/**
 * 記事検索画面用のエラー型（iOS ArticleSearchError に相当）。
 * CustomApiError をラップし、画面固有のエラー（検索結果0件など）を追加する。
 */
sealed class ArticleSearchError : Throwable() {
    data object NotFoundArticles : ArticleSearchError()
    data class FromApi(val error: CustomApiError) : ArticleSearchError()

    fun messageForDisplay(): String = when (this) {
        is NotFoundArticles -> "記事が見つかりませんでした"
        is FromApi -> when (error) {
            is CustomApiError.NetworkError -> "ネットワークエラー"
            is CustomApiError.InvalidRequest -> "リクエストエラー"
            is CustomApiError.ServerError -> "サーバーエラー"
            else -> "エラーが発生しました"
        }
    }
}