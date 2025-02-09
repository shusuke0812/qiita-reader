//
//  LikeView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct LikeView: View {
    let likeCount: Int

    var body: some View {
        HStack {
            Image(systemName: "heart")
                .frame(width: 20, height: 20)
                .foregroundStyle(.gray)
            Text("\(likeCount)")
        }
    }
}

#Preview {
    LikeView(likeCount: 146)
}
