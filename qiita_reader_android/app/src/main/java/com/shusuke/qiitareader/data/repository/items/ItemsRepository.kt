package com.shusuke.qiitareader.data.repository.items

import com.shusuke.qiitareader.data.infrastructure.api.toApiError
import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiClient
import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

interface ItemsRepositoryProtocol {
    suspend fun getItems(page: Int, query: String): Result<ItemList>
}

class ItemsRepository(
    private val api: QiitaApiService = QiitaApiClient.qiitaApiService
) : ItemsRepositoryProtocol {

    override suspend fun getItems(page: Int, query: String): Result<ItemList> = withContext(Dispatchers.IO) {
        runCatching {
            val items = api.getItems(page = page, perPage = 20, query = query)
            ItemList(list = items)
        }.fold(
            onSuccess = { Result.success(it) },
            onFailure = { e -> Result.failure(e.toApiError()) }
        )
    }
}
