package com.shusuke.qiitareader.data.repository.items

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.text.SimpleDateFormat
import java.util.Locale

/**
 * Qiita API v2 の記事アイテム。
 *
 * 参考: https://qiita.com/api/v2/docs#get-apiv2items
 */
@Serializable
data class Item(
    val id: String,
    @SerialName("likes_count") val likesCount: Int,
    val tags: List<Tag>,
    val title: String,
    @SerialName("updated_at") val updatedAtString: String,
    @SerialName("url") val urlString: String,
    val user: User
) {
    val formattedUpdatedAtString: String
        get() = runCatching {
            val input = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX", Locale.JAPAN)
            val output = SimpleDateFormat("yyyy年MM月dd日", Locale.JAPAN)
            output.format(input.parse(updatedAtString)!!)
        }.getOrElse { "-" }

    @Serializable
    data class User(
        val id: String,
        @SerialName("profile_image_url") val profileImageUrlString: String
    ) {
        val name: String get() = "@$id"
    }

    @Serializable
    data class Tag(
        val name: String
    )
}
