//
//  AccessTokenRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Foundation

struct AccessTokenRequest: APIRequestProtocol {
    typealias Response = AuthToken

    var baseUrl: String {
        EndPoint.qiita.urlString
    }

    var path: String {
        "/access_tokens"
    }

    var method: HTTPMethod = .post

    var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "client_id", value: Env.Qiita.clientId),
            URLQueryItem(name: "client_secret", value: Env.Qiita.clientSecret),
            URLQueryItem(name: "scope", value: Env.Qiita.scope)
        ]
    }

    var header: [String : String]? {
        nil
    }

    var body: Data? {
        nil
    }
}
