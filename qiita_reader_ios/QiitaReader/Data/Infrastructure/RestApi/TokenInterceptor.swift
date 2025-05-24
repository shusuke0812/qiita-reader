//
//  TokenInterceptor.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/24.
//

import Combine
import Foundation

protocol InterceptorProtocol {
    func intercept(request: URLRequest) -> AnyPublisher<URLRequest, Error>
}

class TokenInterceptor: InterceptorProtocol {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func intercept(request: URLRequest) -> AnyPublisher<URLRequest, Error> {
        var newRequest = request
        newRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return Just(newRequest)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
