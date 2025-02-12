//
//  APIClient.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Combine
import Foundation

// Ref: https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine

protocol APIClientProtocol {
    func start<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.Response, Error>
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let retryiesLeft: Int
    private let jsonDecoder: JSONDecoder

    init(
        session: URLSession = URLSession.shared,
        retryiesLeft: Int = 3
    ) {
        self.session = session
        self.retryiesLeft = retryiesLeft
        self.jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func start<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.Response, Error> {
        return session
            .dataTaskPublisher(for: request.buildUrlRequest())
            .validateNetworkConnectivity()
            .validateError()
            .handleError()
            .retry(retryiesLeft)
            .map { $0.data }
            .decode(type: T.Response.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
