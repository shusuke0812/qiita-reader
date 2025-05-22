//
//  AccessTokenRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/18.
//

import Foundation

/// [API doc](https://qiita.com/api/v2/docs#post-apiv2access_tokens)
struct AccessTokenRequest: APIRequestProtocol {
    typealias Response = AuthToken

    private let authorizedCode: String

    init(authorizedCode: String) {
        self.authorizedCode = authorizedCode
    }

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
            URLQueryItem(name: "code", value: authorizedCode)
        ]
    }

    var header: [String : String]? {
        ["Content-Type": "application/json"]
    }

    var body: HTTPBody? {
        nil
    }
}
