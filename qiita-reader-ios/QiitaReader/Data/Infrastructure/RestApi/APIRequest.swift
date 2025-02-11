//
//  APIRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Foundation

protocol APIRequestProtocol {
    associatedtype Response: Decodable

    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var body: Data? { get }
}

extension APIRequestProtocol {
    func buildUrlRequest() -> URLRequest {
        let url = URL(string: baseUrl.appending(path))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        switch method {
        case .get:
            components?.queryItems = parameters
        default:
            fatalError("Unimplemented HTTP mehotd: \(method)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
}
