package com.shusuke.qiitareader.presentation.screen.articlesearch.compose

import androidx.compose.foundation.background
import androidx.compose.foundation.BorderStroke
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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Bookmark
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.outlined.BookmarkBorder
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Surface
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import coil.compose.SubcomposeAsyncImage
import com.shusuke.qiitareader.data.repository.items.Item
import com.shusuke.qiitareader.presentation.theme.DevBlue50
import com.shusuke.qiitareader.presentation.theme.DevBlue600
import com.shusuke.qiitareader.presentation.theme.DevGreen50
import com.shusuke.qiitareader.presentation.theme.DevGreen600
import com.shusuke.qiitareader.presentation.theme.DevGrey50
import com.shusuke.qiitareader.presentation.theme.DevGrey100
import com.shusuke.qiitareader.presentation.theme.DevGrey400
import com.shusuke.qiitareader.presentation.theme.DevGrey600
import com.shusuke.qiitareader.presentation.theme.DevGrey900
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme

@Composable
fun ArticleSearchItemView(
    item: Item,
    isStocked: Boolean = false,
    onSelectedTag: (String) -> Unit,
    onSelectedItem: () -> Unit,
    onStockItem: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier
            .fillMaxWidth()
            .clickable(onClick = onSelectedItem),
        shape = RoundedCornerShape(16.dp),
        color = Color.White,
        shadowElevation = 2.dp,
        border = BorderStroke(1.dp, DevGrey100)
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(0.dp)
        ) {
            // Header: Avatar + Name + Date | Bookmark
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.weight(1f)
                ) {
                    SubcomposeAsyncImage(
                        model = item.user.profileImageUrlString,
                        contentDescription = null,
                        modifier = Modifier
                            .size(36.dp)
                            .clip(RoundedCornerShape(50)),
                        contentScale = ContentScale.Crop,
                        loading = {
                            Box(
                                modifier = Modifier
                                    .size(36.dp)
                                    .clip(RoundedCornerShape(50)),
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
                        modifier = Modifier.padding(start = 12.dp)
                    ) {
                        Text(
                            text = item.user.name,
                            style = MaterialTheme.typography.bodyMedium,
                            fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
                            color = DevGrey900,
                            maxLines = 1
                        )
                        Text(
                            text = item.formattedUpdatedAtString,
                            style = MaterialTheme.typography.bodySmall,
                            color = DevGrey400
                        )
                    }
                }
                Icon(
                    imageVector = if (isStocked) Icons.Filled.Bookmark else Icons.Outlined.BookmarkBorder,
                    contentDescription = if (isStocked) "ストック済み" else "ストック",
                    tint = DevGrey400,
                    modifier = Modifier
                        .size(20.dp)
                        .clickable { onStockItem(item.id) }
                )
            }
            // Body: Title
            Text(
                text = item.title,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = androidx.compose.ui.text.font.FontWeight.Bold,
                color = DevGrey900,
                maxLines = 2,
                modifier = Modifier.padding(horizontal = 16.dp).padding(bottom = 16.dp)
            )
            // Stitch: border-t border-devGrey-50
            HorizontalDivider(
                thickness = 1.dp,
                color = DevGrey50
            )
            // Footer: Tags (horizontal scroll) | Heart + Likes
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
                    .padding(top = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.weight(1f)
                ) {
                    items(
                        items = item.tags,
                        key = { it.name }
                    ) { tag ->
                        val tagIndex = item.tags.indexOf(tag)
                        val (bgColor, textColor) = if (tagIndex == 0) {
                            // Stitch: first tag uses blue or green accent (e.g. Development=blue, AI=green)
                            val useGreen = tag.name.uppercase().let { n ->
                                n == "AI" || n.startsWith("AI") || n.contains("ML")
                            }
                            if (useGreen) DevGreen50 to DevGreen600 else DevBlue50 to DevBlue600
                        } else {
                            DevGrey100 to DevGrey600
                        }
                        Text(
                            text = tag.name.uppercase(),
                            style = MaterialTheme.typography.labelSmall,
                            color = textColor,
                            fontWeight = androidx.compose.ui.text.font.FontWeight.Bold,
                            modifier = Modifier
                                .background(bgColor, RoundedCornerShape(6.dp))
                                .padding(horizontal = 8.dp, vertical = 4.dp)
                                .clickable { onSelectedTag(tag.name) }
                        )
                    }
                }
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                    modifier = Modifier.padding(start = 8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Outlined.FavoriteBorder,
                        contentDescription = null,
                        tint = DevGrey400,
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        text = formatLikesCount(item.likesCount),
                        style = MaterialTheme.typography.bodySmall,
                        color = DevGrey400
                    )
                }
            }
        }
    }
}

private fun formatLikesCount(count: Int): String {
    return when {
        count >= 1_000_000 -> String.format("%.1fM", count / 1_000_000.0)
        count >= 1_000 -> String.format("%.1fk", count / 1_000.0)
        else -> count.toString()
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
            isStocked = false,
            onSelectedTag = {},
            onSelectedItem = {},
            onStockItem = {}
        )
    }
}
