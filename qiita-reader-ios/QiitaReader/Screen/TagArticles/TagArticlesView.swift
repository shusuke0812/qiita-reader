//
//  TagArticlesView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import SwiftUI

struct TagArticlesView<ViewModel: TagArticlesViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 8) {
                TagAttributeView(tag: viewModel.output.tag)
                List(viewModel.output.itemList.list) { item in
                    ArticleSearchItemView(item: item) { tag in
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle())
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.gray)
                    })
                }
            }
        }
    }
}

#Preview {
    TagArticlesView(viewModel: TagArticlsViewModel(tagId: "Swift"))
}
