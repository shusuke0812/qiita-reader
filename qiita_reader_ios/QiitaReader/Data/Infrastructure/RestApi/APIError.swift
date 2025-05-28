//
//  APIError.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/11.
//

import Foundation

enum APIError: Error {
    case lackOfAccessToken
    case networkError(Error)
    case invalidRequest(dataString: String?, statusCode: Int)
    case responseParseError(Error)
    case serverError(dataString: String?, statusCode: Int)
    case unknown

    var description: String {
        switch self {
        case .lackOfAccessToken:
            return "アクセストークンが見つかりませんでした"
        case .networkError:
            return "ネットワークに接続できませんでした"
        case .invalidRequest:
            return "不正なリクエスト"
        case .responseParseError:
            return "取得したデータの変換に失敗"
        case .serverError:
            return "サーバーエラー"
        case .unknown:
            return "不明なエラー"
        }
    }
}
