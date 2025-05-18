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
}

class AuthRepository: AuthRepositoryProtocol {
    private let authClient: AuthClientProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(authClient: AuthClientProtocol = AuthClient()) {
        self.authClient = authClient
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
}
