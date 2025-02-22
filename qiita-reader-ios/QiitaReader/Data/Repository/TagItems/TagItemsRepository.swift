//
//  TagItemsRepository.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Combine
import Foundation

protocol TagItemsRepositoryProtocol {
    func getItems(page: Int, tagId: String) -> AnyPublisher<TagItemList, APIError>
}

class TagItemsRepository: TagItemsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func getItems(page: Int, tagId: String) -> AnyPublisher<TagItemList, APIError> {
        let request = TagItemRequest(tagId: tagId, page: page)
        return apiClient
            .start(request)
            .map { items in
                return TagItemList(list: items)
            }
            .eraseToAnyPublisher()
    }
}
