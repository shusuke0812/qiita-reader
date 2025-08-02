package com.shusuke.qiitareader.presentation.screen.articlesearch

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun ArticleSearchScreen() {
    ArticleSearchScreenImpl(
        searchQuery = "",
        onValueChange = {}
    )
}

@Composable
private fun ArticleSearchScreenImpl(
    searchQuery: String,
    onValueChange: (String) -> Unit
) {
    Scaffold { innerPadding ->
        Column(
            modifier = Modifier.padding(innerPadding)
        ) {
            OutlinedTextField(
                value = searchQuery,
                onValueChange = onValueChange,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(8.dp),
                placeholder = { Text("Search") },
                singleLine = true,
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) }
            )
        }
    }
}

@Preview(widthDp = 360, heightDp = 753)
@Composable
private fun ArticleSearchScreenPreview() {
    ArticleSearchScreenImpl(
        searchQuery = "",
        onValueChange = {}
    )
}