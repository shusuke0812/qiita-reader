//
//  SignOutUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/23.
//

import Combine
import Foundation

protocol SignOutUseCaseProtocol {
    func signOut() -> AnyPublisher<Void, Error>
}

class SignOutUseCase: SignOutUseCaseProtocol {
    private let tokenRepository: TokenRepositoryProtocol

    init(tokenRepository: TokenRepositoryProtocol = TokenRepository()) {
        self.tokenRepository = tokenRepository
    }

    func signOut() -> AnyPublisher<Void, Error> {
        tokenRepository.deleteAccessToken()
    }
}
