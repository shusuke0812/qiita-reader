//
//  ItemsRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Foundation

struct ItemsRequest: APIRequestProtocol {
    typealias Response = Items

    private let query: String
    private let page: Int
    private let perPage: String = "20"

    init(query: String, page: Int) {
        self.query = query
        self.page = page
    }

    var baseUrl: String {
        "https://qiita.com/api/v2"
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
            URLQueryItem(name: "per_page", value: perPage),
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
