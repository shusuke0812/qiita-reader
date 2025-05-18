//
//  TagRequest.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Foundation

/// [API doc](https://qiita.com/api/v2/docs#get-apiv2tagstag_id)
struct TagRequest: APIRequestProtocol {
    typealias Response = Tag

    private let tagId: String

    init(tagId: String) {
        self.tagId = tagId
    }

    var baseUrl: String {
        EndPoint.qiita.urlString
    }
    var path: String {
        "/tags/\(tagId)"
    }

    var method: HTTPMethod {
        .get
    }

    var parameters: [URLQueryItem]? {
        nil
    }
    var header: [String : String]? {
        nil
    }
    var body: Data? {
        nil
    }
}
