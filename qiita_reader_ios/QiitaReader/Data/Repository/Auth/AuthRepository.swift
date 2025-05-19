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
    func setAccessToken(_ value: String)
    func getAccessToken() -> String?
    func deleteAccessToken()
}

class AuthRepository: AuthRepositoryProtocol {
    private let authClient: AuthClientProtocol
    private let apiClient: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []

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

    func setAccessToken(_ value: String) {
        let key = Env.Qiita.accessTokenStorageKey
        SecureStorageClient.setData(key: key, value: value)
    }

    func getAccessToken() -> String? {
        let key = Env.Qiita.accessTokenStorageKey
        return SecureStorageClient.getStringData(key: key)
    }

    func deleteAccessToken() {
        let key = Env.Qiita.accessTokenStorageKey
        SecureStorageClient.deleteData(key: key)
    }
}
