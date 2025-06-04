//
//  RequestInterceptor.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/6/4.
//

import Foundation

protocol RequestInterceptorProtocol {
    func intercept(request: URLRequest) throws -> URLRequest
}
