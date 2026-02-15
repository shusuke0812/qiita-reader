package com.shusuke.qiitareader.presentation.screen.articlesearch

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import com.shusuke.qiitareader.presentation.screen.articlesearch.compose.ArticleSearchScreen
import org.koin.androidx.viewmodel.ext.android.viewModel
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme

class ArticleSearchFragment : Fragment() {

    private val viewModel: ArticleSearchViewModel by viewModel()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return ComposeView(requireContext()).apply {
            setContent {
                QiitaReaderTheme {
                    val uiState by viewModel.uiState.collectAsState(initial = ArticleSearchUiState())
                    ArticleSearchScreen(
                        uiState = uiState,
                        onQueryChange = viewModel::updateQuery,
                        onSearch = viewModel::searchItems,
                        onTagClick = { _ -> /* TODO: タグ記事画面へ */ },
                        onItemClick = { _ -> /* TODO: 記事詳細へ */ },
                        onStockClick = { _ -> /* TODO: ストック */ }
                    )
                }
            }
        }
    }
}