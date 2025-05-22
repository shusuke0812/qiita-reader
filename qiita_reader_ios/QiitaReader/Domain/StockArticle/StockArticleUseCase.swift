//
//  StockArticleUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/22.
//

import Combine
import Foundation

protocol StockArticleUseCaseProtocol {
    func invoke(itemId: Int) -> AnyPublisher<Void, Error>
}

class StockArticleUseCase: StockArticleUseCaseProtocol {
    func invoke(itemId: Int) -> AnyPublisher<Void, Error> {
        return Just<Void>(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
