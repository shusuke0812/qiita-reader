//
//  QiitaSearchItemView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct QiitaSearchItemView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HeaderView()
            TitleView()
            FooterView()
        }
    }
}

private struct HeaderView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.crop.circle.fill")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .foregroundStyle(.gray)
            VStack(alignment: .leading, spacing: 8) {
                Text("@qiita-tester")
                    .font(.system(size: 14))
                    .lineLimit(1)
                Text("2025年02月07日")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

private struct TitleView: View {
    var body: some View {
        Text("【Playwright】並列機能とシャーディングでテスト実行時間を大幅短縮！GitHub ActionsのCI設定実例付き")
            .font(.system(size: 20, weight: .semibold))
            .lineLimit(2)
    }
}

private struct FooterView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TagCloudView {}
            LikeView(likeCount: 146)
        }
    }
}

#Preview {
    QiitaSearchItemView()
}
