//
//  SecureStorageError.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Foundation

enum SecureStorageError: Error, Equatable {
    case emptyToken
    case failedToSet(status: OSStatus)
    case failedToDelete(status: OSStatus)
    case noData
    case parseError
    case unhandledError(status: OSStatus)
    case unexpectedData
}
