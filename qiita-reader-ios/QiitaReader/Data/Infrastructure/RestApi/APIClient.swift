//
//  APIClient.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Combine
import Foundation

protocol APIClientProtocol {
    func start<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.Response, Error>
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let retryiesLeft: Int

    init(
        session: URLSession = URLSession.shared,
        retryiesLeft: Int = 3
    ) {
        self.session = session
        self.retryiesLeft = retryiesLeft
    }

    func start<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.Response, Error> {
        return session
            .dataTaskPublisher(for: request.buildRequest())
            .eraseToAnyPublisher()
    }
}
