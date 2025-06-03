//
//  AuthRepository.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/17.
//

import Combine
import Foundation

protocol AuthRepositoryProtocol {
    func authorize() -> AnyPublisher<Authorize, AuthError>
    func generateAccessToken(authorizedCode: String) -> AnyPublisher<AuthToken, APIError>
}

class AuthRepository: AuthRepositoryProtocol {
    private let authClient: AuthClientProtocol
    private let apiClient: APIClientProtocol


    init(
        authClient: AuthClientProtocol = AuthClient(),
        apiClient: APIClientProtocol = APIClient()
    ) {
        self.authClient = authClient
        self.apiClient = apiClient
    }

    func authorize() -> AnyPublisher<Authorize, AuthError> {
        let request = AuthorizeRequest()
        return authClient
            .start(request)
            .map { url in
                return Authorize(url: url)
            }
            .eraseToAnyPublisher()
    }

    func generateAccessToken(authorizedCode: String) -> AnyPublisher<AuthToken, APIError> {
        let request = AccessTokenRequest(authorizedCode: authorizedCode)
        return apiClient
            .start(request)
            .eraseToAnyPublisher()
    }
}
