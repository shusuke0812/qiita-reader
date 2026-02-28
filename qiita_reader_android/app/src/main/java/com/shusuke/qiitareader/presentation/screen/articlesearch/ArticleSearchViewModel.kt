package com.shusuke.qiitareader.presentation.screen.articlesearch

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.infrastructure.api.CustomApiError
import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.domain.reporterror.ReportErrorUseCase
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class ArticleSearchViewModel(
    private val searchArticlesUseCase: SearchArticlesUseCase,
    private val reportErrorUseCase: ReportErrorUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(ArticleSearchUiState())
    val uiState: StateFlow<ArticleSearchUiState> = _uiState.asStateFlow()

    private var page = 1

    fun updateQuery(value: String) {
        _uiState.update { it.copy(query = value) }
    }

    fun searchItems() {
        val query = _uiState.value.query
        Log.d("ArticleSearch", "searchItems: query=$query")
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }
            searchArticlesUseCase.invoke(page = page, query = query).collect { result ->
                result.fold(
                    onSuccess = { itemList -> updateStateOnSearchSuccess(itemList) },
                    onFailure = { e -> handleSearchFailure(e, query) }
                )
            }
        }
    }

    private fun updateStateOnSearchSuccess(itemList: ItemList) {
        _uiState.update {
            it.copy(
                isLoading = false,
                content = if (itemList.list.isEmpty()) {
                    ArticleSearchUiState.ArticleSearchContent.Failure(ArticleSearchError.NotFoundArticles)
                } else {
                    ArticleSearchUiState.ArticleSearchContent.Success(itemList)
                }
            )
        }
    }

    private fun handleSearchFailure(e: Throwable, query: String) {
        val apiError = (e as? CustomApiError) ?: CustomApiError.Unknown
        _uiState.update {
            it.copy(
                isLoading = false,
                content = ArticleSearchUiState.ArticleSearchContent.Failure(
                    ArticleSearchError.FromApi(apiError)
                )
            )
        }
        reportErrorUseCase.invoke(
            error = e,
            screenName = this::class.simpleName!!.removeSuffix("ViewModel"),
            operation = ::searchItems.name,
            extra = mapOf("query" to query)
        )
    }
}
