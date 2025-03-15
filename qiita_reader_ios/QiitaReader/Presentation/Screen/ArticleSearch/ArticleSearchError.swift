//
//  ArticleSearchError.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/15.
//

import Foundation

enum ArticleSearchError: Error {
    case notFoundArticls
    case apiError(APIError)

    var description: String {
        switch self {
        case .notFoundArticls:
            return "記事が見つかりませんでした"
        case .apiError(let error):
            return error.description
        }
    }
}
