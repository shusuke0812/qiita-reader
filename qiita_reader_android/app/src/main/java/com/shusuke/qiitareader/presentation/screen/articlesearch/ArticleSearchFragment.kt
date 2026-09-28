package com.shusuke.qiitareader.presentation.screen.articlesearch

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.fragment.app.Fragment
import com.shusuke.qiitareader.presentation.ResourceProvider
import com.shusuke.qiitareader.presentation.screen.articlesearch.compose.ArticleSearchScreen
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme
import org.koin.android.ext.android.inject
import org.koin.androidx.viewmodel.ext.android.viewModel

class ArticleSearchFragment : Fragment() {

    private val viewModel: ArticleSearchViewModel by viewModel()
    private val resourceProvider: ResourceProvider by inject()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                QiitaReaderTheme {
                    val uiState by viewModel.state.collectAsState()
                    val query by viewModel.query.collectAsState()
                    ArticleSearchScreen(
                        uiState = uiState,
                        query = query,
                        resourceProvider = resourceProvider,
                        onQueryChange = { value -> viewModel.onAction(ArticleSearchAction.QueryChanged(value)) },
                        onSearch = { viewModel.onAction(ArticleSearchAction.Search) },
                        onTagClick = { _ -> /* TODO: タグ記事画面へ */ },
                        onItemClick = { _ -> /* TODO: 記事詳細へ */ },
                        onStockClick = { _ -> /* TODO: ストック */ },
                    )
                }
            }
        }
    }
}
