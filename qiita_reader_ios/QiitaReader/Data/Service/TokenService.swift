//
//  TokenService.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/6/3.
//

import Combine
import Foundation

protocol TokenServiceProtocol {
    func setAccessToken(_ value: String) -> AnyPublisher<Void, Error>
    func getAccessToken() -> String?
    func deleteAccessToken() -> AnyPublisher<Void, Error>
}

class TokenService: TokenServiceProtocol {
    private let secureStorageClient: SecureStorageClientProtocol

    init(secureStorageClient: SecureStorageClientProtocol = SecureStorageClient()) {
        self.secureStorageClient = secureStorageClient
    }

    func setAccessToken(_ value: String) -> AnyPublisher<Void, Error> {
        let key = Env.Qiita.accessTokenStorageKey
        return Result {
            try secureStorageClient.setData(key: key, value: value)
        }
        .publisher
        .eraseToAnyPublisher()
    }

    func getAccessToken() -> String? {
        let key = Env.Qiita.accessTokenStorageKey
        do {
            return try secureStorageClient.getStringData(key: key)
        } catch {
            return nil
        }
    }

    func deleteAccessToken() -> AnyPublisher<Void, Error> {
        let key = Env.Qiita.accessTokenStorageKey
        return Result {
            try secureStorageClient.deleteData(key: key)
        }
        .publisher
        .eraseToAnyPublisher()
    }
}
