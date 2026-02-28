package com.shusuke.qiitareader.data.repository.items

import android.util.Log
import com.shusuke.qiitareader.data.infrastructure.api.toCustomApiError
import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiClient
import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.withContext

interface ItemsRepository {
    fun getItemsFlow(page: Int, query: String): Flow<Result<ItemList>>
}

class ItemsRepositoryImpl(
    private val api: QiitaApiService = QiitaApiClient.qiitaApiService
) : ItemsRepository {

    override fun getItemsFlow(page: Int, query: String): Flow<Result<ItemList>> = flow {
        Log.d("ItemsRepository", "getItemsFlow: page=$page, query=$query")
        val result = withContext(Dispatchers.IO) {
            runCatching {
                val items = api.getItems(page = page, perPage = 20, query = query)
                Log.d("ItemsRepository", "getItemsFlow: success, count=${items.size}")
                ItemList(list = items)
            }.fold(
                onSuccess = { Result.success(it) },
                onFailure = { e ->
                    Log.d("ItemsRepository", "getItemsFlow: failure")
                    Result.failure(e.toCustomApiError())
                }
            )
        }
        emit(result)
    }
}
