//
//  ViewState.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/15.
//

import Foundation

enum ViewState<Success, Failure: Error> {
    case stadby
    case loading
    case success(Success)
    case failure(Failure)

    var value: Success? {
        switch self {
        case .success(let success):
            return success
        default:
            return nil
        }
    }

    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }

    var hasError: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}
