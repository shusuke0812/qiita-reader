package com.shusuke.qiitareader.presentation.screen.articlesearch

import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.presentation.screen.setting.AppLanguage

data class ArticleSearchUiState(
    val query: String = "",
    val isLoading: Boolean = false,
    val content: ArticleSearchContent = ArticleSearchContent.Standby,
    val language: AppLanguage = AppLanguage.JAPANESE
) {
    sealed class ArticleSearchContent {
        data object Standby : ArticleSearchContent()
        data class Success(val itemList: ItemList) : ArticleSearchContent()
        data class Failure(val error: ArticleSearchError) : ArticleSearchContent()
    }
}
