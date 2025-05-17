//
//  Env.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/25.
//

import Foundation

enum Env {
    /// Read theses data from xcconfig file
    enum Qiita {
        static let clientId = Bundle.main.object(forInfoDictionaryKey: "ENV_QIITA_CLIENT_ID") as? String ?? ""
        static let clientSecret = Bundle.main.object(forInfoDictionaryKey: "ENV_QIITA_CLIENT_SECRET") as? String ?? ""
        static let scope = "read_qiita write_qiita"
    }
}
