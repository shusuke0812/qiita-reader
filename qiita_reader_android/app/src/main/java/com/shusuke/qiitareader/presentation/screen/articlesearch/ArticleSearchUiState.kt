package com.shusuke.qiitareader.presentation.screen.articlesearch

import com.shusuke.qiitareader.data.repository.items.ItemList

sealed class ArticleSearchUiState {
    data object Initial : ArticleSearchUiState()
    data object Loading : ArticleSearchUiState()
    sealed class Searched : ArticleSearchUiState() {
        abstract val itemList: ItemList

        data class List(
            override val itemList: ItemList
        ) : Searched()

        data class PageLoading(
            override val itemList: ItemList
        ) : Searched()

        data class PageError(
            override val itemList: ItemList,
            val error: ArticleSearchError
        ) : Searched()
    }
    data class SearchError(val error: ArticleSearchError) : ArticleSearchUiState()
}
