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
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func signIn() -> AnyPublisher<Void, SignInError> {
        return authRepository.authorize()
            .mapError { error in
                switch error {
                case .canceledLogin:
                    return SignInError.cancel
                default:
                    return SignInError.failedToAuthenticate(error)
                }
            }
            .flatMap { authorize -> AnyPublisher<String, SignInError> in
                if let code = authorize.code {
                    return Just(code)
                        .setFailureType(to: SignInError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail<String, SignInError>(error: SignInError.notFoundAuthorizedCode)
                        .eraseToAnyPublisher()
                }
            }
            .flatMap { code in
                self.authRepository.generateAccessToken(authorizedCode: code)
                    .mapError { SignInError.failedToGetAccessToken($0) }
            }
            .flatMap { authToken in
                self.authRepository.setAccessToken(authToken.accessToken)
                    .mapError { SignInError.failedToSaveAccessToken($0) }
            }
            .eraseToAnyPublisher()
    }
}
