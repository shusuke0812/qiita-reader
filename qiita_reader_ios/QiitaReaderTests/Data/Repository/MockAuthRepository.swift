//
//  MockAuthRepository.swift
//  QiitaReaderTests
//
//  Created by Shusuke Ota on 2025/5/21.
//

import Combine
import Foundation
@testable import QiitaReader

class MockAuthRepository: AuthRepositoryProtocol {
    func authorize() -> AnyPublisher<Authorize, AuthError> {
        let authorize = Authorize(url: URL(string: "appsheme://xxx-callback?code=fefef5f067171f247fb415e38cb0631797b82f41"))
        return Just(authorize)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
    
    func generateAccessToken(authorizedCode: String) -> AnyPublisher<AuthToken, APIError> {
        let authToken = AuthToken(accessToken: "ea5d0a593b2655e9568f144fb1826342292f5c6b")
        return Just(authToken)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
