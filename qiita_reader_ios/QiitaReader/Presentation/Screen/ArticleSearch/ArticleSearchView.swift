//
//  ArticleSearchView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct ArticleSearchView<ViewModel: ArticleSearchViewModelProtocol>: View {
    @StateObject var router: Router<QiitaRoute> = .init(isPresented: .constant(.none))
    @StateObject var viewModel: ViewModel

    var body: some View {
        List(viewModel.output.itemList.list) { item in
            ArticleSearchItemView(
                item: item,
                onSelectedTag: { tagId in
                    router.routeTo(.tagArticles(tagId: tagId), via: .modal)
                },
                onSelectedItem: {
                    router.routeTo(.articleDetail(articleUrlString: item.urlString), via: .push)
                }
            )
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        .searchable(text: $viewModel.input.query)
        .onSubmit(of: .search) {
            viewModel.input.searchItems()
        }
    }
}

#Preview {
    ArticleSearchView(viewModel: ArticleSearchViewModel())
}
