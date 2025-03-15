//
//  LikeView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct LikeView: View {
    let likesCount: Int

    var body: some View {
        HStack {
            Image(systemName: SFSymbol.heart)
                .frame(width: 20, height: 20)
                .foregroundStyle(.gray)
            Text("\(likesCount)")
        }
    }
}

#Preview {
    LikeView(likesCount: 146)
}
