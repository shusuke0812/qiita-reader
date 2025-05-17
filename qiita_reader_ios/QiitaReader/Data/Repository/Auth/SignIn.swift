//
//  SignIn.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/17.
//

import Foundation

struct SignIn: Decodable {
    let url: URL?

    var code: String? {
        if let url = url {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let code = components?.queryItems?.first(where: { $0.name == "code" })?.value
            return code
        }
        return nil
    }
}
