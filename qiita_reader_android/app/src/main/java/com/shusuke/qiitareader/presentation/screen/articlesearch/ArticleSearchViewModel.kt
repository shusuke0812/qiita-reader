package com.shusuke.qiitareader.presentation.screen.articlesearch

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.infrastructure.api.ApiError
import com.shusuke.qiitareader.data.repository.items.ItemsRepositoryImpl
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCase
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCaseImpl
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class ArticleSearchViewModel(
    private val searchArticlesUseCase: SearchArticlesUseCase = SearchArticlesUseCaseImpl(
        ItemsRepositoryImpl()
    )
) : ViewModel() {

    private val _uiState = MutableStateFlow(ArticleSearchUiState())
    val uiState: StateFlow<ArticleSearchUiState> = _uiState.asStateFlow()

    private var page = 1

    fun updateQuery(value: String) {
        _uiState.update { it.copy(query = value) }
    }

    fun searchItems() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }
            searchArticlesUseCase.invoke(page = page, query = _uiState.value.query).collect { result ->
                result.fold(
                    onSuccess = { itemList ->
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
                    },
                    onFailure = { e ->
                        _uiState.update {
                            it.copy(
                                isLoading = false,
                                content = ArticleSearchUiState.ArticleSearchContent.Failure(
                                    (e as? ApiError)?.let { ArticleSearchError.FromApi(it) }
                                        ?: ArticleSearchError.FromApi(ApiError.Unknown)
                                )
                            )
                        }
                    }
                )
            }
        }
    }
}
