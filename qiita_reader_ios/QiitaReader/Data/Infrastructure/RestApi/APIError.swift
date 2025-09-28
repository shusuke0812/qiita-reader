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

    var descriptionLocalizedKey: String {
        switch self {
        case .lackOfAccessToken:
            return "common_api_error_lack_of_accesstoken"
        case .networkError:
            return "common_api_error_network"
        case .invalidRequest:
            return "common_api_error_invalid_request"
        case .responseParseError:
            return "common_api_error_response_parse"
        case .serverError:
            return "common_api_error_server"
        case .unknown:
            return "common_api_error_unknown"
        }
    }
}
