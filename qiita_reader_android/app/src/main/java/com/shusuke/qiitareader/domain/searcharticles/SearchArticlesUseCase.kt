package com.shusuke.qiitareader.domain.searcharticles

import com.shusuke.qiitareader.data.repository.items.ItemList
import com.shusuke.qiitareader.data.repository.items.ItemsRepositoryProtocol
import kotlinx.coroutines.flow.Flow

/**
 * 記事検索
 * クエリに応じた記事一覧を Flow で返す
 */
interface SearchArticlesUseCaseProtocol {
    fun invokeFlow(page: Int, query: String): Flow<Result<ItemList>>
}

class SearchArticlesUseCase(
    private val itemsRepository: ItemsRepositoryProtocol
) : SearchArticlesUseCaseProtocol {

    override fun invokeFlow(page: Int, query: String): Flow<Result<ItemList>> =
        itemsRepository.getItemsFlow(page = page, query = query)
}
