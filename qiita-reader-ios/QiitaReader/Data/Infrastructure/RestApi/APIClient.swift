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
    func start<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.Response, APIError>
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let retriesLeft: Int
    private let jsonDecoder: JSONDecoder

    init(
        session: URLSession = URLSession.shared,
        retriesLeft: Int = 3
    ) {
        self.session = session
        self.retriesLeft = retriesLeft
        self.jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func start<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.Response, APIError> {
        return session
            .dataTaskPublisher(for: request.buildUrlRequest())
            .validateNetworkConnectivity()
            .validateError()
            .handleError()
            .retry(retriesLeft)
            .map { $0.data }
            .decode(type: T.Response.self, decoder: jsonDecoder)
            .mapError { error -> APIError in
                return APIError.responseParseError(error)
            }
            .eraseToAnyPublisher()
    }
}
