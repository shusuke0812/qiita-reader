//
//  ItemsRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Foundation

struct ItemsRequest: APIRequestProtocol {
    typealias Response = [Item]

    private let page: Int
    private let query: String
    private let perPage: Int = 20

    init(page: Int, query: String) {
        self.page = page
        self.query = query
    }

    var baseUrl: String {
        EndPoint.qiita.urlString
    }
    var path: String {
        "/items"
    }
    var method: HTTPMethod {
        .get
    }
    var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "query", value: query)
        ]
    }
    var header: [String : String]? {
        nil
    }
    var body: Data? {
        nil
    }
}
