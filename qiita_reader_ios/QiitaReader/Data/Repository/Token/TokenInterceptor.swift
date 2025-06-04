//
//  TokenInterceptor.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/24.
//

import Combine
import Foundation

class TokenInterceptor: RequestInterceptorProtocol {
    private let tokenRepository: TokenRepositoryProtocol

    init(tokenRepository: TokenRepositoryProtocol = TokenRepository()) {
        self.tokenRepository = tokenRepository
    }

    func intercept(request: URLRequest) throws -> URLRequest {
        guard let token = tokenRepository.getAccessToken(), !token.isEmpty else {
            throw APIError.lackOfAccessToken
        }
        var newRequest = request
        newRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
}
