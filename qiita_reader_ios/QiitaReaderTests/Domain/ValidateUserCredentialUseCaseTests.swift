//
//  ValidateUserCredentialUseCaseTests.swift
//  QiitaReaderTests
//
//  Created by Shusuke Ota on 2025/5/21.
//

import Testing
@testable import QiitaReader

struct ValidateUserCredentialUseCaseTests {
    private let mockTokenRepository: MockTokenRepository

    init() {
        self.mockTokenRepository = MockTokenRepository()
    }

    /// 有効な40桁のアクセストークン
    @Test func test_isValid_true_whenValidAccessToken() {
        mockTokenRepository.accessToken = "ea5d0a593b2655e9568f144fb1826342292f5c6b"

        let useCase = ValidateUserCredentialUseCase(tokenRepository: mockTokenRepository)
        #expect(useCase.isValid == true)
    }

    /// 無効なアクセストークン（長さ超過）
    @Test func test_isValid_false_whenLongLengthAccessToken() {
        mockTokenRepository.accessToken = "ea5d0a593b2655e9568f144fb1826342292f5c6b6b6b"

        let useCase = ValidateUserCredentialUseCase(tokenRepository: mockTokenRepository)
        #expect(useCase.isValid == false)
    }

    /// 無効なアクセストークン（長さ不足）
    @Test func test_isValid_false_whenShortLengthAccessToken() {
        mockTokenRepository.accessToken = "ea5d0a593b2655e9568f144fb1826342292f"

        let useCase = ValidateUserCredentialUseCase(tokenRepository: mockTokenRepository)
        #expect(useCase.isValid == false)
    }

    /// 無効なアクセストークン（nil）
    @Test func test_isValid_false_whenAccessTokenIsNil() {
        mockTokenRepository.accessToken = nil

        let useCase = ValidateUserCredentialUseCase(tokenRepository: mockTokenRepository)
        #expect(useCase.isValid == false)
    }

    /// 無効なアクセストークン（空文字）
    @Test func test_isValid_false_whenAccessTokenIsEmpty() {
        mockTokenRepository.accessToken = ""

        let useCase = ValidateUserCredentialUseCase(tokenRepository: mockTokenRepository)
        #expect(useCase.isValid == false)
    }

    /// 無効なアクセストークン（大文字のアルファベットを含む）
    @Test func test_isValid_false_whenAccessTokenContainsUpperCases() {
        mockTokenRepository.accessToken = "EA5D0A593B2655E9568F144FB1826342292F5C6B"

        let useCase = ValidateUserCredentialUseCase(tokenRepository: mockTokenRepository)
        #expect(useCase.isValid == false)
    }
}
