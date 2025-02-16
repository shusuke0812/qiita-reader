//
//  QiitaSearchItemView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct QiitaSearchItemView: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HeaderView(userName: item.user.id, updatedAt: item.formattedUpdatedAtString, profileImageURL: item.user.profileImageUrl)
            TitleView(title: item.title)
            FooterView(likesCount: item.likesCount)
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
            AsyncImage(url: profileImageURL) { image in
                image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("@" + userName)
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

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                TagCloudView {}
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
    let item = Item(likesCount: 120, tags: [], title: "Qiita Reader", updatedAtString: "2025-02-16T13:21:39+09:00", user: Item.User(id: "qiita-tester", profileImageUrlString: "https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/82835/profile-images/1722951712"))
    QiitaSearchItemView(item: item)
}
