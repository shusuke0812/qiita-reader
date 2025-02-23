//
//  Tag.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Foundation

struct Tag: Decodable {
    let id: String
    let iconUrlString: String
    let followersCount: Int
    let itemsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case iconUrlString = "icon_url"
        case followersCount = "followers_count"
        case itemsCount = "items_count"
    }

    var iconUrl: URL? {
        URL(string: iconUrlString)
    }
}
