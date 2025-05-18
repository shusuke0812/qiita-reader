//
//  SignInUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Combine
import Foundation

protocol SignInUseCaseProtocol {
    func signIn() -> AnyPublisher<Void, SignInError>
}

class SignInUseCase: SignInUseCaseProtocol {
    init() {}

    func signIn() -> AnyPublisher<Void, SignInError> {
        Just(())
            .setFailureType(to: SignInError.self)
            .eraseToAnyPublisher()
    }
}
