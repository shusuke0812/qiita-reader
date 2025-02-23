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
            List {
                Section {
                    TagAttributeView(tag: viewModel.output.tag)
                }
                Section {
                    ForEach(viewModel.output.itemList.list) { item in
                        ArticleSearchItemView(
                            item: item,
                            onSelectedTag: { tagId in
                            },
                            onSelectedItem: {}
                        )
                    }
                    .listRowInsets(EdgeInsets())
                }
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
