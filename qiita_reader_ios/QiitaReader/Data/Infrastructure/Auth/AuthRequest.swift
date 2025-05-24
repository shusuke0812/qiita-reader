//
//  AuthRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/26.
//

import Foundation

protocol AuthRequestProtocol {
    associatedtype Response: Decodable

    var baseUrl: String { get }
    var path: String { get }
    var parameters: [URLQueryItem]? { get }
    var callbackUrlScheme: String { get }
}

extension AuthRequestProtocol {
    func buildUrl() -> URL? {
        let url = URL(string: baseUrl.appending(path))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        components?.queryItems = parameters
        return components?.url
    }
}
