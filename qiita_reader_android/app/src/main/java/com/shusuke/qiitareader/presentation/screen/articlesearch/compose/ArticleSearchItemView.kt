package com.shusuke.qiitareader.presentation.screen.articlesearch.compose

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Bookmark
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import coil.compose.SubcomposeAsyncImage
import com.shusuke.qiitareader.data.repository.items.Item
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme

@Composable
fun ArticleSearchItemView(
    item: Item,
    onSelectedTag: (String) -> Unit,
    onSelectedItem: () -> Unit,
    onStockItem: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .clickable(onClick = onSelectedItem)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        Row(
            verticalAlignment = Alignment.Top,
            modifier = Modifier.fillMaxWidth()
        ) {
            SubcomposeAsyncImage(
                model = item.user.profileImageUrlString,
                contentDescription = null,
                modifier = Modifier
                    .size(36.dp)
                    .clip(MaterialTheme.shapes.medium),
                contentScale = ContentScale.Crop,
                loading = {
                    Box(
                        modifier = Modifier
                            .size(36.dp)
                            .clip(MaterialTheme.shapes.medium),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator(modifier = Modifier.size(20.dp))
                    }
                },
                error = {
                    Icon(
                        imageVector = Icons.Default.Person,
                        contentDescription = null,
                        modifier = Modifier.size(36.dp)
                    )
                }
            )
            Column(
                modifier = Modifier
                    .padding(start = 12.dp)
                    .weight(1f)
            ) {
                Text(
                    text = item.user.name,
                    style = MaterialTheme.typography.bodyMedium,
                    maxLines = 1
                )
                Text(
                    text = item.formattedUpdatedAtString,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        Text(
            text = item.title,
            style = MaterialTheme.typography.titleMedium,
            maxLines = 2
        )
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.Bottom
        ) {
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.weight(1f)
            ) {
                items(
                    items = item.tags,
                    key = { it.name }
                ) { tag ->
                    Text(
                        text = tag.name,
                        style = MaterialTheme.typography.labelMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier
                            .background(
                                MaterialTheme.colorScheme.surfaceVariant,
                                MaterialTheme.shapes.small
                            )
                            .padding(horizontal = 8.dp, vertical = 4.dp)
                            .clickable { onSelectedTag(tag.name) }
                    )
                }
            }
            Text(
                text = "${item.likesCount} Likes",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(start = 8.dp)
            )
            Icon(
                imageVector = Icons.Default.Bookmark,
                contentDescription = "ストック",
                modifier = Modifier
                    .size(24.dp)
                    .clickable { onStockItem(item.id) }
            )
        }
    }
}

@Preview(widthDp = 360, showBackground = true)
@Composable
private fun ArticleSearchItemViewPreview() {
    QiitaReaderTheme {
        ArticleSearchItemView(
            item = Item(
                id = "preview-id",
                likesCount = 42,
                tags = listOf(
                    Item.Tag(name = "Kotlin"),
                    Item.Tag(name = "Compose"),
                    Item.Tag(name = "Android")
                ),
                title = "Qiita Reader の記事タイトル例",
                updatedAtString = "2025-02-01T12:00:00+09:00",
                urlString = "https://qiita.com/example",
                user = Item.User(
                    id = "qiita-user",
                    profileImageUrlString = ""
                )
            ),
            onSelectedTag = {},
            onSelectedItem = {},
            onStockItem = {}
        )
    }
}
