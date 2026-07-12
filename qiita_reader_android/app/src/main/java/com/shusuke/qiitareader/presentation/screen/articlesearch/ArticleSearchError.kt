package com.shusuke.qiitareader.presentation.screen.articlesearch

import androidx.annotation.StringRes
import com.shusuke.qiitareader.R
import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError

sealed class ArticleSearchError : Throwable() {
    data object NotFoundArticles : ArticleSearchError()
    data class FromApi(val error: CustomApiError) : ArticleSearchError()

    @StringRes
    fun messageResId(): Int = when (this) {
        is NotFoundArticles -> R.string.error_not_found_articles
        is FromApi -> when (error) {
            is CustomApiError.NetworkError -> R.string.error_network
            is CustomApiError.InvalidRequest -> R.string.error_invalid_request
            is CustomApiError.ServerError -> R.string.error_server
            else -> R.string.error_unknown
        }
    }
}
