//
//  AuthRepositoryTests.swift
//  QiitaReaderTests
//
//  Created by Shusuke Ota on 2025/5/23.
//

import Combine
import Foundation
import Testing
@testable import QiitaReader

class AuthRepositoryTests {
    private let authRepository: AuthRepositoryProtocol
    private var secureStorageClient: MockSecureStorageClient

    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.secureStorageClient = MockSecureStorageClient()
        self.authRepository = AuthRepository(secureStorageClient: secureStorageClient)
    }

    @Test func test_setAccessToken_true() async {
        let expectedAccessToken = "ea5d0a593b2655e9568f144fb1826342292f5c6b"

        await confirmation("success") { expectation in
            authRepository
                .setAccessToken(expectedAccessToken)
                .sink(receiveCompletion: { _ in
                    expectation()
                }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }

        #expect(secureStorageClient.savedStringValue == expectedAccessToken)
    }

    @Test func test_setAccessToken_false_whenDuplicateToken() async {
        let expectedAccessToken = "ea5d0a593b2655e9568f144fb1826342292f5c6b"
        secureStorageClient.error = SecureStorageError.failedToSet(status: errSecDuplicateItem)
        var completionError: SecureStorageError?

        await confirmation("fail") { expectation in
            authRepository
                .setAccessToken(expectedAccessToken)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionError = error as? SecureStorageError
                    }
                    expectation()
                }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }

        #expect(secureStorageClient.savedStringValue == nil)
        #expect(completionError == SecureStorageError.failedToSet(status: errSecDuplicateItem))
    }

    @Test func test_setAccessToken_false_whenEmptyToken() async {
        let expectedAccessToken = ""
        var completionError: SecureStorageError?

        await confirmation("fail") { expectation in
            authRepository
                .setAccessToken(expectedAccessToken)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionError = error as? SecureStorageError
                    }
                    expectation()
                }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }

        #expect(secureStorageClient.savedStringValue == nil)
        #expect(completionError == SecureStorageError.emptyToken)
    }
}
