//
//  ItemsRepository.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Combine
import Foundation

protocol ItemsRepositoryProtocol {
    func getItems(page: Int, query: String) -> AnyPublisher<ItemList, APIError>
}

class ItemsRepository: ItemsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func getItems(page: Int, query: String) -> AnyPublisher<ItemList, APIError> {
        let request = ItemsRequest(page: page, query: query)
        return apiClient
            .start(request)
            .map { items in
                return ItemList(list: items)
            }
            .eraseToAnyPublisher()
    }
}
