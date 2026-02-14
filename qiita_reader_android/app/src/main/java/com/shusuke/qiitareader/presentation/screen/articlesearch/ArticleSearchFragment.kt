package com.shusuke.qiitareader.presentation.screen.articlesearch

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.shusuke.qiitareader.presentation.UiState

class ArticleSearchFragment : Fragment() {

    private val viewModel: ArticleSearchViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return ComposeView(requireContext()).apply {
            setContent {
                val query by viewModel.query.collectAsState(initial = "")
                val viewState by viewModel.viewState.collectAsState(initial = UiState.Standby)
                ArticleSearchScreen(
                    query = query,
                    onQueryChange = viewModel::updateQuery,
                    viewState = viewState,
                    onSearch = viewModel::searchItems,
                    onTagClick = { _ -> /* TODO: タグ記事画面へ */ },
                    onItemClick = { _ -> /* TODO: 記事詳細へ */ },
                    onStockClick = { _ -> /* TODO: ストック */ }
                )
            }
        }
    }
}