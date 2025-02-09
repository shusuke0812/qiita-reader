//
//  QiitaSearchItemView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct QiitaSearchItemView: View {
    var body: some View {
        HeaderView()
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
                Text("2025年02月07日")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

#Preview {
    QiitaSearchItemView()
}
