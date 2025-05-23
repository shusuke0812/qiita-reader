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
    func setAccessToken(_ value: String) -> AnyPublisher<Void, Error>
    func getAccessToken() -> String?
    func deleteAccessToken() -> AnyPublisher<Void, Error>
}

class AuthRepository: AuthRepositoryProtocol {
    private let authClient: AuthClientProtocol
    private let apiClient: APIClientProtocol
    private let secureStorageClient: SecureStorageClientProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(
        authClient: AuthClientProtocol = AuthClient(),
        apiClient: APIClientProtocol = APIClient(),
        secureStorageClient: SecureStorageClientProtocol = SecureStorageClient()
    ) {
        self.authClient = authClient
        self.apiClient = apiClient
        self.secureStorageClient = secureStorageClient
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

    func setAccessToken(_ value: String) -> AnyPublisher<Void, Error> {
        let key = Env.Qiita.accessTokenStorageKey
        return Result {
            try secureStorageClient.setData(key: key, value: value)
        }
        .publisher
        .eraseToAnyPublisher()
    }

    func getAccessToken() -> String? {
        let key = Env.Qiita.accessTokenStorageKey
        return secureStorageClient.getStringData(key: key)
    }

    func deleteAccessToken() -> AnyPublisher<Void, Error> {
        let key = Env.Qiita.accessTokenStorageKey
        return Result {
            try secureStorageClient.deleteData(key: key)
        }
        .publisher
        .eraseToAnyPublisher()
    }
}
