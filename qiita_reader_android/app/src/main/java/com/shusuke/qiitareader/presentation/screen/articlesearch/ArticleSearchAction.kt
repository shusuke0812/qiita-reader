package com.shusuke.qiitareader.presentation.screen.articlesearch

sealed class ArticleSearchAction {
    data class QueryChanged(val value: String) : ArticleSearchAction()
    data object Search : ArticleSearchAction()
}
