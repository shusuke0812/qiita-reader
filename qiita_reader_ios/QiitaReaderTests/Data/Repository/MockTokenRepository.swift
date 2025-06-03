//
//  MockTokenRepository.swift
//  QiitaReaderTests
//
//  Created by Shusuke Ota on 2025/6/3.
//

import Combine
import Foundation
@testable import QiitaReader

class MockTokenRepository: TokenRepositoryProtocol {
    var accessToken: String?

    func setAccessToken(_ value: String) -> AnyPublisher<Void, Error> {
        fatalError("Need not to test this method.")
    }

    func getAccessToken() -> String? {
        return accessToken
    }

    func deleteAccessToken() -> AnyPublisher<Void, Error> {
        fatalError("Need not to test this method.")
    }
}
