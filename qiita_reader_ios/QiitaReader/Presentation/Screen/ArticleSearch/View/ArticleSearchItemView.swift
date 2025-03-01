//
//  ArticleSearchItemView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct ArticleSearchItemView: View {
    let item: Item
    let onSelectedTag: (String) -> Void
    let onSelectedItem: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HeaderView(userName: item.user.name, updatedAt: item.formattedUpdatedAtString, profileImageURL: item.user.profileImageUrl)
            TitleView(title: item.title)
            FooterView(likesCount: item.likesCount, tags: item.tags) { tagId in
                onSelectedTag(tagId)
            }
        }
        .onTapGesture {
            onSelectedItem()
        }
        .padding()
    }
}

private struct HeaderView: View {
    let userName: String
    let updatedAt: String
    let profileImageURL: URL?

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: profileImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .profileImageModifier()
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .profileImageModifier()
                case .empty:
                    ProgressView()
                @unknown default:
                    Image(systemName: "person.circle.fill")
                        .profileImageModifier()
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(userName)
                    .font(.system(size: 14))
                    .lineLimit(1)
                Text(updatedAt)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

private extension Image {
    func profileImageModifier(size: CGFloat = 36) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
}

private struct TitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .semibold))
            .lineLimit(2)
    }
}

private struct FooterView: View {
    let likesCount: Int
    let tags: [Item.Tag]
    let onSelectedTag: (String) -> Void

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                TagCloudView(tags: tags) { tagId in
                    onSelectedTag(tagId)
                }
                LikeView(likesCount: likesCount)
            }
            Spacer()
            Button(action: {
                // TODO: タップアクション
            }, label: {
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 18, height: 24)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    let item = Item(
        likesCount: 120,
        tags: [
            Item.Tag(name: "Supabase"),
            Item.Tag(name: "Firebase"),
            Item.Tag(name: "Apple Vision Pro"),
            Item.Tag(name: "TypeScript"),
            Item.Tag(name: "SwiftUI")
        ],
        title: "Qiita Reader",
        updatedAtString: "2025-02-16T13:21:39+09:00",
        urlString: "https://developer.apple.com/jp/",
        user: Item.User(id: "qiita-tester", profileImageUrlString: "https://example.com/icon.png")
    )
    ArticleSearchItemView(item: item, onSelectedTag: { _ in }, onSelectedItem: {})
}
