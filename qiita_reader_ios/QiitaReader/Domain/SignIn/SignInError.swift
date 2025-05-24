//
//  SignInError.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Foundation

enum SignInError: Error {
    case cancel
    case failedToAuthenticate(Error)
    case notFoundAuthorizedCode
    case failedToGetAccessToken(Error)
    case failedToSaveAccessToken(Error)
}
