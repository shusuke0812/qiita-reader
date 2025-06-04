//
//  APIRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Foundation

protocol APIRequestProtocol {
    associatedtype Response: Decodable

    typealias HTTPBody = [String: Any]

    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var body: HTTPBody? { get }
    var interceptors: [RequestInterceptorProtocol] { get }
}

extension APIRequestProtocol {
    func buildUrlRequest() throws -> URLRequest {
        let url = URL(string: baseUrl.appending(path))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        var httpBody: Data?

        switch method {
        case .get:
            components?.queryItems = parameters
        case .post:
            if let body = body {
                do {
                    httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                } catch {
                    fatalError("Failed to serialize JSON body: \(error)")
                }
            }
        default:
            fatalError("Unimplemented HTTP mehotd: \(method)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBody
        if let header = header {
            for (key, value) in header {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }

        urlRequest = try interceptors.reduce(urlRequest) { nextRequest, interceptor in
            try interceptor.intercept(request: nextRequest)
        }

        return urlRequest
    }
}
