//
//  DataTaskPublisher+Extension.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Foundation

extension URLSession.DataTaskPublisher {
    // Ref: https://developer.apple.com/documentation/foundation/urlerror/networkunavailablereason
    func validateNetworkConnectivity() -> Self {
        tryCatch { error -> URLSession.DataTaskPublisher in
            switch error.networkUnavailableReason {
            case .cellular:
                break
            case .constrained:
                break
            case .expensive:
                break
            default:
                break
            }
            return self
        }.upstream
    }

    func validateError() -> Self {
        tryMap { data, response -> Data in
            switch (response as? HTTPURLResponse)?.statusCode {
            case .some(let code) where (200...300).contains(code):
                return data
            case .some(let code) where (300...400).contains(code):
                throw NSError(domain: "client error", code: code)
            case .some(let code) where (400...500).contains(code):
                throw NSError(domain: "server error", code: code)
            default:
                throw NSError(domain: String(data: data, encoding: .utf8) ?? "unexpected error", code: 0)
            }
        }.upstream
    }
}
