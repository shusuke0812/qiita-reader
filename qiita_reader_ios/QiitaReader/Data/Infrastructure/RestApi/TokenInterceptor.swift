//
//  TokenInterceptor.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/24.
//

import Combine
import Foundation

protocol RequestInterceptorProtocol {
    func intercept(request: URLRequest) -> URLRequest
}

class TokenInterceptor: RequestInterceptorProtocol {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func intercept(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
}
