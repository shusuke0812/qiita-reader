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
        nil
    }

    var header: [String : String]? {
        ["Content-Type": "application/json"]
    }

    var body: HTTPBody? {
        [
            "client_id": Env.Qiita.clientId,
            "client_secret": Env.Qiita.clientSecret,
            "code": authorizedCode
        ]
    }
}
