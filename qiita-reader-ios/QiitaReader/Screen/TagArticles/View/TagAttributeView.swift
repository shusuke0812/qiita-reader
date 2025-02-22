//
//  TagAttributeView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import SwiftUI

struct TagAttributeView: View {
    var tag: Tag

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            HeaderView(iconImageUrl: tag.iconUrl, tagId: tag.id)
            FooterView(itemsCount: tag.itemsCount, followersCount: tag.followersCount)
        }
    }
}

private struct HeaderView: View {
    let iconImageUrl: URL?
    let tagId: String

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            AsyncImage(url: iconImageUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .tagIconImageModifier()
                case .failure:
                    Image(systemName: "questionmark.app.dashed")
                        .tagIconImageModifier()
                case .empty:
                    ProgressView()
                @unknown default:
                    Image(systemName: "questionmark.app.dashed")
                        .tagIconImageModifier()
                }
            }
            Text(tagId)
                .font(.system(size: 22, weight: .semibold))
        }
    }
}

private extension Image {
    func tagIconImageModifier(size: CGFloat = 60) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}

private struct FooterView: View {
    let itemsCount: Int
    let followersCount: Int

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .center, spacing: 8) {
                Text("\(itemsCount)")
                    .foregroundStyle(.secondary)
                Text("記事")
                    .foregroundStyle(.secondary)
            }
            .frame(width: 150)

            Divider()
            VStack(alignment: .center, spacing: 8) {
                Text("\(followersCount)")
                    .foregroundStyle(.secondary)
                Text("フォロワー")
                    .foregroundStyle(.secondary)
            }
            .frame(width: 150)
        }
        .frame(height: 70)
    }
}

#Preview {
    let tag = Tag(
        id: "Swift",
        iconUrlString: "https://s3-ap-northeast-1.amazonaws.com/qiita-tag-image/8924010780db484a83145542a3e49c6c2084ecb7/medium.jpg?1401738498",
        followersCount: 10958,
        itemsCount: 23098
    )
    TagAttributeView(tag: tag)
}
