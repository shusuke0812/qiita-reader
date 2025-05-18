//
//  SecureStorageError.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Foundation

enum SecureStorageError: Error {
    case noData
    case unhandledError(status: OSStatus)
    case unexpectedData
}
