//
//  TagCloudView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct TagCloudView: View {
    let onTapTag: () -> Void

    var body: some View {
        TagButtonView(onTapTag: onTapTag) // TODO: タグの数を動的に変更して表示させる
    }
}

private struct TagButtonView: View {
    let onTapTag: () -> Void

    var body: some View {
        Button(action: {
            onTapTag()
        }, label: {
            Text("Supabase")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        })
    }
}

#Preview {
    TagCloudView() {}
}
