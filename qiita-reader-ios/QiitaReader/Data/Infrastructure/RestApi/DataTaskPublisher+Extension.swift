//
//  DataTaskPublisher+Extension.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Foundation
import Combine

extension URLSession.DataTaskPublisher {
    // Ref: https://developer.apple.com/documentation/foundation/urlerror/networkunavailablereason
    func validateNetworkConnectivity() -> Self {
        tryCatch { error -> URLSession.DataTaskPublisher in
            switch error.networkUnavailableReason {
            case .cellular, .constrained, .expensive:
                throw APIError.networkError(error)
            default:
                throw APIError.unknown
            }
        }.upstream
    }

    func validateError() -> Self {
        tryMap { data, response -> Data in
            let message = String(data: data, encoding: .utf8)

            switch (response as? HTTPURLResponse)?.statusCode {
            case .some(let code) where (200...300).contains(code):
                return data
            case .some(let code) where (300...400).contains(code):
                throw APIError.invalidRequest(message: message, statusCode: code)
            case .some(let code) where (400...500).contains(code):
                throw APIError.serverError(message: message, statusCode: code)
            default:
                throw APIError.unknown
            }
        }.upstream
    }

    func handleError() -> Self {
        tryCatch { error -> AnyPublisher<Output, Error> in
            let apiError = error as? APIError
            switch apiError {
            case .invalidRequest:
                return Fail(error: apiError!).eraseToAnyPublisher()
            default:
                throw error
            }
        }.upstream
    }
}
