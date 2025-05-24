//
//  AuthToken.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Foundation

struct AuthToken: Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
    }
}
