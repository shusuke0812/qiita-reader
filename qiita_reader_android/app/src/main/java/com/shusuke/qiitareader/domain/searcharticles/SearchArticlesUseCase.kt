package com.shusuke.qiitareader.domain.searcharticles

import android.util.Log
import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.data.repository.items.ItemsRepository
import kotlinx.coroutines.flow.Flow

/**
 * 記事検索
 * クエリに応じた記事一覧を Flow で返す
 */
interface SearchArticlesUseCase {
    fun invoke(page: Int, query: String): Flow<Result<ItemList>>
}

class SearchArticlesUseCaseImpl (
    private val itemsRepository: ItemsRepository
) : SearchArticlesUseCase {

    override fun invoke(page: Int, query: String): Flow<Result<ItemList>> {
        Log.d("SearchArticlesUseCase", "invoke: page=$page, query=$query")
        return itemsRepository.getItemsFlow(page = page, query = query)
    }
}
