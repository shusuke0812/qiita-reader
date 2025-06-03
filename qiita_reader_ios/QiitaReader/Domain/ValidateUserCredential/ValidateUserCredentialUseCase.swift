//
//  ValidateUserCredentialUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/21.
//

import Foundation

protocol ValidateUserCredentialUseCaseProtocol {
    var isValid: Bool { get }
}

class ValidateUserCredentialUseCase: ValidateUserCredentialUseCaseProtocol {
    private let tokenRepository: TokenRepositoryProtocol

    init(tokenRepository: TokenRepositoryProtocol = TokenRepository()) {
        self.tokenRepository = tokenRepository
    }

    var isValid: Bool {
        if let at = tokenRepository.getAccessToken() {
            return isValid40DigitHexString(at)
        }
        return false
    }

    /// [Access Token Pattern](https://qiita.com/api/v2/docs#%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3-1)
    private func isValid40DigitHexString(_ value: String) -> Bool {
        let pattern = #"^[0-9a-f]{40}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}
