//
//  LoginRepository.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/17.
//

import Combine
import Foundation

protocol LoginRepositoryProtocol {
    func login() -> AnyPublisher<URL?, AuthError>
}

class LoginRepository: LoginRepositoryProtocol {
    private let authClient: AuthClientProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(authClient: AuthClientProtocol = AuthClient()) {
        self.authClient = authClient
    }

    func login() -> AnyPublisher<URL?, AuthError> {
        <#code#>
    }

    func signin() {
        let request = LoginRequest()
        authClient
                .start(request)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { url in
                    print("url=\(url)")
                })
                .store(in: &cancellables)
    }
}
