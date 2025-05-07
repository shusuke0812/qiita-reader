//
//  AuthClient.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/24.
//

import AuthenticationServices
import Combine
import Foundation

typealias AuthSessionCallback = AnyPublisher<URL?, Error>

protocol AuthClientProtocol {
    func start<T: AuthRequestProtocol>(_ request: T) -> AnyPublisher<URL?, AuthError>
}

class AuthClient: AuthClientProtocol {
    private let retriesLeft: Int

    init(retriesLeft: Int = 3) {
        self.retriesLeft = retriesLeft
    }

    func start<T: AuthRequestProtocol>(_ request: T) -> AnyPublisher<URL?, AuthError> {
        return session(request)
            .validateError()
            .retry(retriesLeft)
            .eraseToAnyPublisher()
    }

    private func session<T: AuthRequestProtocol>(_ request: T) -> AnyPublisher<URL?, Error> {
        return Future<URL?, Error> { promise in
            let session = ASWebAuthenticationSession(url: request.buildUrl()!, callbackURLScheme: request.callbackUrlScheme) { url, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                promise(.success(url))
            }
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
        .eraseToAnyPublisher()
    }
}
