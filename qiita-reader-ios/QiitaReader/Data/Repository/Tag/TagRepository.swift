//
//  TagRepository.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Combine
import Foundation

protocol TagRepositoryProtocol {
    func getTag(id: String) -> AnyPublisher<Tag, APIError>
}

class TagRepository: TagRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func getTag(id: String) -> AnyPublisher<Tag, APIError> {
        let request = TagRequest(tagId: id)
        return apiClient
            .start(request)
            .eraseToAnyPublisher()
    }
}
