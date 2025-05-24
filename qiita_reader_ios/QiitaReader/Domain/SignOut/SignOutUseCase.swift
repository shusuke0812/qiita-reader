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
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func signOut() -> AnyPublisher<Void, Error> {
        authRepository.deleteAccessToken()
    }
}
