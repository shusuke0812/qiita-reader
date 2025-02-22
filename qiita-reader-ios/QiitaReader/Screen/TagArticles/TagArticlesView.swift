//
//  TagArticlesView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import SwiftUI

struct TagArticlesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
//                TagAttributeView(tag: )
//                ArticleSearchItemView(item: ) { tag in
//                }
//                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    TagArticlesView()
}
