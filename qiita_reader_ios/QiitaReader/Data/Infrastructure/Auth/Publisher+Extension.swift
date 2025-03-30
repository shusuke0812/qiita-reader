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
    func validateError() -> AuthSessionCallback {
        return self
            .tryMap { output in
                if let error = output as? ASWebAuthenticationSessionError {
                    switch error.code {
                    case .canceledLogin:
                        throw AuthError.canceledLogin
                    default:
                        throw AuthError.other(error)
                    }
                }
                return output
            }.eraseToAnyPublisher()
    }
}

enum AuthError: Error {
    case canceledLogin
    case other(ASWebAuthenticationSessionError)
}
