//
//  SecureStorageClient.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

// Ref: https://developer.apple.com/documentation/security/adding-a-password-to-the-keychain

import Foundation

protocol SecureStorageClientProtocol {
    func setData(key: String, value: String) throws
    func deleteData(key: String) throws
    func getStringData(key: String) throws -> String
}

class SecureStorageClient: SecureStorageClientProtocol {
    func setData(key: String, value: String) throws {
        guard let data = value.data(using: .utf8), !data.isEmpty else {
            throw SecureStorageError.emptyToken
        }
        try setKeyChain(key: key, data: data)
    }

    func deleteData(key: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Bundle.main.bundleIdentifier ?? "",
            kSecAttrService: key
        ] as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecureStorageError.failedToDelete(status: status)
        }
    }

    func getStringData(key: String) throws -> String {
        guard let data = try getKeyChain(key: key) else {
            throw SecureStorageError.noData
        }
        guard let stringValue = String(data: data, encoding: .utf8) else {
            throw SecureStorageError.parseError
        }
        return stringValue
    }

    private func setKeyChain(key: String, data: Data) throws {
        try deleteData(key: key)
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data,
            kSecAttrAccount: Bundle.main.bundleIdentifier ?? "",
            kSecAttrService: key
        ] as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStorageError.failedToSet(status: status)
        }
    }

    private func getKeyChain(key: String) throws -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Bundle.main.bundleIdentifier ?? "",
            kSecAttrService: key,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        guard status != errSecItemNotFound else { throw SecureStorageError.noData }
        guard status == errSecSuccess else { throw SecureStorageError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
              let secureData = existingItem[kSecValueData as String] as? Data
        else {
            throw SecureStorageError.unexpectedData
        }
        return secureData
    }
}
