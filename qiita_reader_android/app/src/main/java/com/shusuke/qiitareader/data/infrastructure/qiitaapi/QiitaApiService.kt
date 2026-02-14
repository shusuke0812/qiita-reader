package com.shusuke.qiitareader.data.infrastructure.qiitaapi

import com.shusuke.qiitareader.data.repository.items.Item
import retrofit2.http.GET
import retrofit2.http.Query

/**
 * Qiita API v2 の REST Interface。
 *
 * Document: https://qiita.com/api/v2/docs#get-apiv2items
 */
interface QiitaApiService {
    @GET("items")
    suspend fun getItems(
        @Query("page") page: Int,
        @Query("per_page") perPage: Int = 20,
        @Query("query") query: String
    ): List<Item>
}
