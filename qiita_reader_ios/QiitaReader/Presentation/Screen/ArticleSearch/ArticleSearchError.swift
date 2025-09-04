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

    var descriptionLocalizedKey: String {
        switch self {
        case .notFoundArticls:
            return "article_search_error_notfound"
        case .apiError(let error):
            return error.descriptionLocalizedKey
        }
    }
}
