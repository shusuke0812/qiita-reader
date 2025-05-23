//
//  SecureStorageClient.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

// Ref: https://developer.apple.com/documentation/security/adding-a-password-to-the-keychain

import Foundation

struct SecureStorageClient {
    static func setData(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else { return }
        try setKeyChain(key: key, data: data)
    }

    static func deleteData(key: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Bundle.main.bundleIdentifier ?? "",
            kSecAttrService: key
        ] as CFDictionary)
        guard status == errSecSuccess else {
            throw SecureStorageError.failedToDelete(status: status)
        }
    }

    static func getStringData(key: String) -> String? {
        do {
            guard let data = try getKeyChain(key: key) else {
                return nil
            }
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }

    private static func setKeyChain(key: String, data: Data) throws {
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

    private static func getKeyChain(key: String) throws -> Data? {
        var query = [
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
