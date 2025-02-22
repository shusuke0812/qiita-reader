//
//  LoadTagArticlesUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Combine
import Foundation

protocol LoadTagArticlesUseCaseProtocol {
    func invoke(tagId: String) -> AnyPublisher<Void, APIError>
}

class LoadTagArticlesUseCase: LoadTagArticlesUseCaseProtocol {
    private let tagRepository: TagRepositoryProtocol

    init(
        tagRepository: TagRepositoryProtocol = TagRepository()
    ) {
        self.tagRepository = tagRepository
    }

    func invoke(tagId: String) -> AnyPublisher<Void, APIError> {
    }
}
