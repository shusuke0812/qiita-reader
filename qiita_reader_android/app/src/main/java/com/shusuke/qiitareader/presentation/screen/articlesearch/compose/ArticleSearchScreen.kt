package com.shusuke.qiitareader.presentation.screen.articlesearch.compose

import androidx.compose.foundation.background
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.shusuke.qiitareader.data.repository.items.Item
import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.presentation.screen.articlesearch.ArticleSearchError
import com.shusuke.qiitareader.presentation.screen.articlesearch.ArticleSearchUiState
import com.shusuke.qiitareader.presentation.theme.DevGrey50
import com.shusuke.qiitareader.presentation.theme.DevGrey100
import com.shusuke.qiitareader.presentation.theme.DevGrey400
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme

/**
 * 記事検索画面（Compose）。
 *
 * State は持たず、Fragment から渡された [uiState], [onQueryChange], [onSearch] 等で描画する。
 */
@Composable
fun ArticleSearchScreen(
    uiState: ArticleSearchUiState,
    onQueryChange: (String) -> Unit,
    onSearch: () -> Unit,
    onTagClick: (String) -> Unit,
    onItemClick: (String) -> Unit,
    onStockClick: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    Scaffold(
        modifier = modifier.fillMaxSize(),
        containerColor = DevGrey50
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
        ) {
            Surface(
                modifier = Modifier.fillMaxWidth(),
                color = MaterialTheme.colorScheme.surface.copy(alpha = 0.8f),
                shadowElevation = 0.dp,
                border = BorderStroke(1.dp, DevGrey100)
            ) {
                val focusManager = LocalFocusManager.current
                TextField(
                    value = uiState.query,
                    onValueChange = onQueryChange,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    placeholder = { Text("Search articles...") },
                    singleLine = true,
                    leadingIcon = {
                        Icon(
                            Icons.Default.Search,
                            contentDescription = null,
                            tint = DevGrey400
                        )
                    },
                    shape = RoundedCornerShape(12.dp),
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = DevGrey100,
                        unfocusedContainerColor = DevGrey100,
                        disabledContainerColor = DevGrey100,
                        focusedIndicatorColor = Color.Transparent,
                        unfocusedIndicatorColor = Color.Transparent,
                        disabledIndicatorColor = Color.Transparent,
                        unfocusedPlaceholderColor = DevGrey400,
                        focusedPlaceholderColor = DevGrey400
                    ),
                    keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
                    keyboardActions = KeyboardActions(onSearch = {
                        focusManager.clearFocus()
                        onSearch()
                    })
                )
            }
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 16.dp)
                    .background(DevGrey50)
            ) {
                if (uiState.isLoading) {
                    LoadingView()
                } else {
                    when (val content = uiState.content) {
                        is ArticleSearchUiState.ArticleSearchContent.Standby -> StandbyView()
                        is ArticleSearchUiState.ArticleSearchContent.Success -> ArticleListView(
                            itemList = content.itemList,
                            onTagClick = onTagClick,
                            onItemClick = onItemClick,
                            onStockClick = onStockClick
                        )
                        is ArticleSearchUiState.ArticleSearchContent.Failure -> ErrorView(
                            message = content.error.messageForDisplay()
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun StandbyView(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(32.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.Search,
            contentDescription = null,
            modifier = Modifier.padding(bottom = 16.dp)
        )
        Text("キーワードを入力して検索")
    }
}

@Composable
private fun LoadingView(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        CircularProgressIndicator()
    }
}

@Composable
private fun ArticleListView(
    itemList: ItemList,
    onTagClick: (String) -> Unit,
    onItemClick: (String) -> Unit,
    onStockClick: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    LazyColumn(
        modifier = modifier.fillMaxSize(),
        verticalArrangement = Arrangement.spacedBy(24.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        items(
            items = itemList.list,
            key = { it.id }
        ) { item ->
            ArticleSearchItemView(
                item = item,
                onSelectedTag = onTagClick,
                onSelectedItem = { onItemClick(item.urlString) },
                onStockItem = onStockClick
            )
        }
    }
}

@Composable
private fun ErrorView(
    message: String,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(32.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.Warning,
            contentDescription = null,
            modifier = Modifier.padding(bottom = 16.dp)
        )
        Text(text = message)
    }
}

@Preview(widthDp = 360, heightDp = 640, showBackground = true)
@Composable
private fun ArticleSearchScreenStandbyPreview() {
    QiitaReaderTheme {
        ArticleSearchScreen(
            uiState = ArticleSearchUiState(),
            onQueryChange = {},
            onSearch = {},
            onTagClick = {},
            onItemClick = {},
            onStockClick = {}
        )
    }
}

@Preview(widthDp = 360, heightDp = 640, showBackground = true)
@Composable
private fun ArticleSearchScreenLoadingPreview() {
    QiitaReaderTheme {
        ArticleSearchScreen(
            uiState = ArticleSearchUiState(query = "Kotlin", isLoading = true),
            onQueryChange = {},
            onSearch = {},
            onTagClick = {},
            onItemClick = {},
            onStockClick = {}
        )
    }
}

@Preview(widthDp = 360, heightDp = 640, showBackground = true)
@Composable
private fun ArticleSearchScreenSuccessPreview() {
    QiitaReaderTheme {
        ArticleSearchScreen(
            uiState = ArticleSearchUiState(
                query = "Kotlin",
                content = ArticleSearchUiState.ArticleSearchContent.Success(
                    ItemList(
                        list = listOf(
                            sampleItemForPreview(id = "1", title = "Kotlin 入門", profileImageId = 1005),
                            sampleItemForPreview(id = "2", title = "Compose の使い方", profileImageId = 1006)
                        )
                    )
                )
            ),
            onQueryChange = {},
            onSearch = {},
            onTagClick = {},
            onItemClick = {},
            onStockClick = {}
        )
    }
}

@Preview(widthDp = 360, heightDp = 640, showBackground = true)
@Composable
private fun ArticleSearchScreenErrorPreview() {
    QiitaReaderTheme {
        ArticleSearchScreen(
            uiState = ArticleSearchUiState(
                query = "Kotlin",
                content = ArticleSearchUiState.ArticleSearchContent.Failure(ArticleSearchError.NotFoundArticles),
            ),
            onQueryChange = {},
            onSearch = {},
            onTagClick = {},
            onItemClick = {},
            onStockClick = {}
        )
    }
}

private fun sampleItemForPreview(
    id: String = "id",
    title: String = "title",
    profileImageId: Int = 1005
) = Item(
    id = id,
    likesCount = 10,
    tags = listOf(Item.Tag(name = "Kotlin"), Item.Tag(name = "Android")),
    title = title,
    updatedAtString = "2025-01-01T00:00:00+09:00",
    urlString = "https://example.com",
    user = Item.User(
        id = "user1",
        profileImageUrlString = "https://picsum.photos/id/$profileImageId/100/100"
    )
)
