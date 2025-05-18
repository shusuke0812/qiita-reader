//
//  AuthorizeRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/17.
//

import Foundation

struct AuthorizeRequest: AuthRequestProtocol {
    typealias Response = Authorize

    var baseUrl: String {
        EndPoint.qiita.urlString
    }
    
    var path: String {
        "/oauth/authorize"
    }
    
    var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "client_id", value: Env.Qiita.clientId),
            URLQueryItem(name: "scope", value: Env.Qiita.scope)
        ]
    }
    
    var callbackUrlScheme: String {
        if let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] {
            if let urlScheme = urlTypes.first?["CFBundleURLSchemes"] as? [String] {
                return urlScheme.first!
            }
        }
        return "not-found"
    }
}
