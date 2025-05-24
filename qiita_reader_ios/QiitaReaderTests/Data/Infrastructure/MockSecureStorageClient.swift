//
//  MockSecureStorageClient.swift
//  QiitaReaderTests
//
//  Created by Shusuke Ota on 2025/5/23.
//

import Foundation
@testable import QiitaReader

class MockSecureStorageClient: SecureStorageClientProtocol {
    var savedStringValue: String?
    var error: SecureStorageError?

    func setData(key: String, value: String) throws {
        guard let savedStringValue = savedStringValue, !savedStringValue.isEmpty else {
            throw SecureStorageError.emptyToken
        }
        if let error = error {
            throw error
        }
        self.savedStringValue = value
    }

    func deleteData(key: String) throws {
        if let error = error {
            throw error
        }
    }

    func getStringData(key: String) -> String? {
        savedStringValue
    }
}
