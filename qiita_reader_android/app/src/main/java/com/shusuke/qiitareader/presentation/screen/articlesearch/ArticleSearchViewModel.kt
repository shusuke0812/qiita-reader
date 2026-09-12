package com.shusuke.qiitareader.presentation.screen.articlesearch

import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError
import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.domain.reporterror.ReportErrorUseCase
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCase
import com.shusuke.qiitareader.shared.MVIContractDelegate
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class ArticleSearchViewModel(
    private val searchArticlesUseCase: SearchArticlesUseCase,
    private val reportErrorUseCase: ReportErrorUseCase
) : MVIContractDelegate<ArticleSearchUiState, ArticleSearchAction, ArticleSearchSideEffect>(ArticleSearchUiState.Initial) {

    override fun onAction(action: ArticleSearchAction) {
        when (action) {
            is ArticleSearchAction.QueryChanged -> _query.value = action.value
            is ArticleSearchAction.Search -> searchItems()
        }
    }

    private val _query = MutableStateFlow("")
    val query: StateFlow<String> = _query.asStateFlow()

    private var page = 1

    private fun searchItems() {
        val query = _query.value
        viewModelScope.launch {
            update { ArticleSearchUiState.Loading }
            searchArticlesUseCase(page = page, query = query).collect { result ->
                result.fold(
                    onSuccess = { itemList -> updateStateOnSearchSuccess(itemList) },
                    onFailure = { e -> handleSearchFailure(e, query) }
                )
            }
        }
    }

    private suspend fun updateStateOnSearchSuccess(itemList: ItemList) {
        update {
            if (itemList.list.isEmpty()) {
                ArticleSearchUiState.SearchError(ArticleSearchError.NotFoundArticles)
            } else {
                ArticleSearchUiState.Searched.List(itemList)
            }
        }
    }

    private suspend fun handleSearchFailure(e: Throwable, query: String) {
        val apiError = (e as? CustomApiError) ?: CustomApiError.Unknown
        update {
            ArticleSearchUiState.SearchError(ArticleSearchError.FromApi(apiError))
        }
        reportErrorUseCase(
            error = e,
            screenName = this::class.simpleName!!.removeSuffix("ViewModel"),
            operation = ::searchItems.name,
            extra = mapOf("query" to query)
        )
    }
}
