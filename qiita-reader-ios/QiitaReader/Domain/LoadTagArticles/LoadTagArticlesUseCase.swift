//
//  LoadTagArticlesUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Combine
import Foundation

protocol LoadTagArticlesUseCaseProtocol {
    func invoke(tagId: String, page: Int) -> AnyPublisher<TagArticle, APIError>
}

class LoadTagArticlesUseCase: LoadTagArticlesUseCaseProtocol {
    private let tagRepository: TagRepositoryProtocol
    private let tagItemsRepository: TagItemsRepositoryProtocol

    private var itemList: TagItemList = TagItemList(list: [])
    private var tag: Tag = Tag(id: "", iconUrlString: "", followersCount: 0, itemsCount: 0)

    init(
        tagRepository: TagRepositoryProtocol = TagRepository(),
        tagItemsRepository: TagItemsRepositoryProtocol = TagItemsRepository()
    ) {
        self.tagRepository = tagRepository
        self.tagItemsRepository = tagItemsRepository
    }

    func invoke(tagId: String, page: Int) -> AnyPublisher<TagArticle, APIError> {
        if validateIsInitialLoad(tagId: tagId) {
            return initialLoad(tagId: tagId, page: page)
        }
        return reload(page: page)
    }

    private func initialLoad(tagId: String, page: Int) -> AnyPublisher<TagArticle, APIError> {
        Publishers.CombineLatest(
            tagRepository.getTag(id: tagId),
            tagItemsRepository.getItems(page: page, tagId: tagId)
        )
        .map { tag, itemList in
            self.tag = tag
            self.itemList = itemList
            return TagArticle(tag: tag, itemList: itemList)
        }
        .eraseToAnyPublisher()
    }

    private func reload(page: Int) -> AnyPublisher<TagArticle, APIError> {
        tagItemsRepository.getItems(page: page, tagId: self.tag.id)
            .map { itemList in
                self.itemList = self.itemList.add(items: itemList.list)
                return TagArticle(tag: self.tag, itemList: self.itemList)
            }
            .eraseToAnyPublisher()
    }

    private func validateIsInitialLoad(tagId: String) -> Bool {
        if self.tag.id == tagId {
            return false
        }
        return true
    }
}
