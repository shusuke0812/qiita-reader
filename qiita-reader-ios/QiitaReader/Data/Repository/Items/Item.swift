//
//  Item.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Foundation

struct Item: Decodable {
    let likesCount: Int
    let tags: [Tag]
    let title: String
    let updatedAtString: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case likesCount = "likes_count"
        case tags
        case title
        case updatedAtString = "updated_at"
        case user
    }

    var updatedAt: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.date(from: updatedAtString)
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

    struct Tag: Decodable {
        let name: String
    }
}
