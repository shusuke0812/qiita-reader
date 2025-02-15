//
//  EndPoint.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Foundation

enum EndPoint {
    case qiita

    var urlString: String {
        switch self {
        case .qiita:
            return "https://qiita.com/api/v2"
        }
    }
}
