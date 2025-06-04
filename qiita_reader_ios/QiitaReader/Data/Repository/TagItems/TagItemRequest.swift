//
//  TagItemRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Foundation

/// [API doc](https://qiita.com/api/v2/docs#get-apiv2tagstag_iditems)
struct TagItemRequest: APIRequestProtocol {
    typealias Response = [TagItem]

    private let tagId: String
    private let page: Int
    private let perPage: Int = 20

    init(tagId: String, page: Int) {
        self.tagId = tagId
        self.page = page
    }

    var baseUrl: String {
        EndPoint.qiita.urlString
    }
    var path: String {
        "/tags/\(tagId)/items"
    }
    var method: HTTPMethod {
        .get
    }

    var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage)),
        ]
    }
    var header: [String : String]? {
        nil
    }
    var body: HTTPBody? {
        nil
    }
    var interceptors: [RequestInterceptorProtocol] {
        []
    }
}
