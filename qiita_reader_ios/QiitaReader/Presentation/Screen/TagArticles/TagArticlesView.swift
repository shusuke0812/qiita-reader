//
//  TagArticlesView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import SwiftUI

struct TagArticlesView<ViewModel: TagArticlesViewModelProtocol>: View {
    @StateObject var router: Router<QiitaRoute> = .init(isPresented: .constant(.none))
    @StateObject var viewModel: ViewModel

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
                        router.dismiss()
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
