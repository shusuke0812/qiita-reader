//
//  StockRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/6/4.
//

import Foundation

/// [API doc](https://qiita.com/api/v2/docs#put-apiv2itemsitem_idstock)
struct StockRequest: APIRequestProtocol {
    typealias Response = NoContent

    private let itemId: String

    init(itemId: String) {
        self.itemId = itemId
    }

    var baseUrl: String {
        EndPoint.qiita.urlString
    }

    var path: String {
        "/items/\(itemId)/stock"
    }

    var method: HTTPMethod {
        .put // TODO: buildUrlRequestにpusの条件分岐を追加
    }

    var parameters: [URLQueryItem]? {
        nil
    }

    var header: [String : String]? {
        nil
    }

    var body: HTTPBody? {
        nil
    }

    var interceptors: [RequestInterceptorProtocol] {
        [TokenInterceptor()]
    }
}
