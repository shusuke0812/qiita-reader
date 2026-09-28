package com.shusuke.qiitareader.presentation.screen.articlesearch

import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.shared.MVIAction
import com.shusuke.qiitareader.shared.MVISideEffect
import com.shusuke.qiitareader.shared.MVIState

sealed class ArticleSearchUiState: MVIState {
    data object Initial : ArticleSearchUiState()
    data object Loading : ArticleSearchUiState()
    sealed class Searched : ArticleSearchUiState() {
        abstract val itemList: ItemList

        data class List(
            override val itemList: ItemList,
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

sealed class ArticleSearchAction: MVIAction {
    data class QueryChanged(val value: String) : ArticleSearchAction()
    data object Search : ArticleSearchAction()
}

sealed class ArticleSearchSideEffect: MVISideEffect {
    data object ShowSearchPageErrorDialog : ArticleSearchSideEffect()
}