//
//  AuthError.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/30.
//

import AuthenticationServices
import Foundation

enum AuthError: Error {
    case canceledLogin
    case other(ASWebAuthenticationSessionError)
}
