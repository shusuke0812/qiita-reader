//
//  Items.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Foundation

struct Items: Decodable {
    let list: [Item]
}

struct Item: Decodable {
    let user: User
    let updatedAtString: String
    let title: String
    let likesCount: Int

    var updatedAt: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.date(from: updatedAtString)
    }

    enum CodingKeys: String, CodingKey {
        case user
        case updatedAtString = "updated_at"
        case title
        case likesCount = "likes_count"
    }

    struct User: Decodable {
        let id: String
        let profileImageUrlString: String

        enum CodingKeys: String, CodingKey {
            case id
            case profileImageUrlString = "profile_image_url"
        }

        var profileImageUrl: URL? {
            URL(string: profileImageUrlString)
        }
    }
}

struct Tags: Decodable {
    let list: [Tag]
}

struct Tag: Decodable {
    let name: String
}
