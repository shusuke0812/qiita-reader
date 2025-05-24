//
//  Publisher+Extension.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/30.
//

import Combine
import Foundation
import AuthenticationServices


extension Publisher where Output == AuthSessionCallback.Output, Failure == AuthSessionCallback.Failure {
    func validateError() -> AnyPublisher<URL?, AuthError> {
        return self
            .mapError { error in
                if let error = error as? ASWebAuthenticationSessionError {
                    switch error.code {
                    case .canceledLogin:
                        return AuthError.canceledLogin
                    default:
                        return AuthError.other(error)
                    }
                }
                return AuthError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
}
