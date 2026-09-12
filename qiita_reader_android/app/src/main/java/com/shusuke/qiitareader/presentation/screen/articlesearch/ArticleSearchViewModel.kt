package com.shusuke.qiitareader.presentation.screen.articlesearch

import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError
import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.domain.reporterror.ReportErrorUseCase
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCase
import com.shusuke.qiitareader.shared.viewmodel.BaseViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class ArticleSearchViewModel(
    private val searchArticlesUseCase: SearchArticlesUseCase,
    private val reportErrorUseCase: ReportErrorUseCase
) : BaseViewModel<ArticleSearchUiState, ArticleSearchAction>() {

    private val _uiState = MutableStateFlow<ArticleSearchUiState>(ArticleSearchUiState.Initial)
    override val uiState: StateFlow<ArticleSearchUiState> = _uiState.asStateFlow()

    private val _query = MutableStateFlow("")
    val query: StateFlow<String> = _query.asStateFlow()

    private var page = 1

    override fun onAction(action: ArticleSearchAction) {
        when (action) {
            is ArticleSearchAction.QueryChanged -> _query.value = action.value
            is ArticleSearchAction.Search -> searchItems()
        }
    }

    private fun searchItems() {
        val query = _query.value
        viewModelScope.launch {
            _uiState.update { ArticleSearchUiState.Loading }
            searchArticlesUseCase(page = page, query = query).collect { result ->
                result.fold(
                    onSuccess = { itemList -> updateStateOnSearchSuccess(itemList) },
                    onFailure = { e -> handleSearchFailure(e, query) }
                )
            }
        }
    }

    private fun updateStateOnSearchSuccess(itemList: ItemList) {
        _uiState.update {
            if (itemList.list.isEmpty()) {
                ArticleSearchUiState.SearchError(ArticleSearchError.NotFoundArticles)
            } else {
                ArticleSearchUiState.Searched.List(itemList)
            }
        }
    }

    private fun handleSearchFailure(e: Throwable, query: String) {
        val apiError = (e as? CustomApiError) ?: CustomApiError.Unknown
        _uiState.update {
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
