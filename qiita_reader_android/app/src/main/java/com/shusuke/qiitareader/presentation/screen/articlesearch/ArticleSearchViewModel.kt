package com.shusuke.qiitareader.presentation.screen.articlesearch

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.infrastructure.api.ApiError
import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.data.repository.items.ItemsRepository
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCase
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCaseProtocol
import com.shusuke.qiitareader.presentation.UiState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class ArticleSearchViewModel(
    private val searchArticlesUseCase: SearchArticlesUseCaseProtocol = SearchArticlesUseCase(
        ItemsRepository()
    )
) : ViewModel() {

    private val _query = MutableStateFlow("")
    val query: StateFlow<String> = _query.asStateFlow()

    private val _viewState = MutableStateFlow<UiState<ItemList, ArticleSearchError>>(UiState.Standby)
    val viewState: StateFlow<UiState<ItemList, ArticleSearchError>> = _viewState.asStateFlow()

    private var page = 1

    fun updateQuery(value: String) {
        _query.update { value }
    }

    fun searchItems() {
        viewModelScope.launch {
            _viewState.value = UiState.Loading
            searchArticlesUseCase.invokeFlow(page = page, query = _query.value).collect { result ->
                result.fold(
                    onSuccess = { itemList ->
                        _viewState.value = if (itemList.list.isEmpty()) {
                            UiState.Failure(ArticleSearchError.NotFoundArticles)
                        } else {
                            UiState.Success(itemList)
                        }
                    },
                    onFailure = { e ->
                        _viewState.value = UiState.Failure(
                            (e as? ApiError)?.let { ArticleSearchError.FromApi(it) }
                                ?: ArticleSearchError.FromApi(ApiError.Unknown)
                        )
                    }
                )
            }
        }
    }
}
