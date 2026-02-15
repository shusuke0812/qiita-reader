package com.shusuke.qiitareader.presentation.screen.articlesearch

import com.shusuke.qiitareader.data.repository.items.ItemList

/**
 * 記事検索画面の ViewModel 用 UiState。
 * 検索クエリ・ローディング状態・表示内容（Standby / Success / Failure）を保持する。
 */
data class ArticleSearchUiState(
    val query: String = "",
    val isLoading: Boolean = false,
    val content: ArticleSearchContent = ArticleSearchContent.Standby
) {
    sealed class ArticleSearchContent {
        data object Standby : ArticleSearchContent()
        data class Success(val itemList: ItemList) : ArticleSearchContent()
        data class Failure(val error: ArticleSearchError) : ArticleSearchContent()
    }
}
