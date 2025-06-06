//
//  Item.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Foundation

struct Item: Decodable, Identifiable {
    let id: String
    let likesCount: Int
    let tags: [Self.Tag]
    let title: String
    let updatedAtString: String
    let urlString: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case likesCount = "likes_count"
        case tags
        case title
        case updatedAtString = "updated_at"
        case urlString = "url"
        case user
    }

    var formattedUpdatedAtString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "ja_JP")

        if let date = formatter.date(from: updatedAtString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy年MM月dd日"
            return outputFormatter.string(from: date)
        }
        return "-"
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

        var name: String {
            "@" + id
        }
    }

    struct Tag: Decodable, Identifiable {
        let id: UUID = UUID()
        let name: String

        enum CodingKeys: String, CodingKey {
            case name
        }
    }
}
