//
//  ArticleSearchView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct ArticleSearchView<ViewModel: ArticleSearchViewModelProtocol>: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: ViewModel

    var body: some View {
        List(viewModel.output.itemList.list) { item in
            ArticleSearchItemView(
                item: item,
                onSelectedTag: { tagId in
                    viewModel.input.openTagArticles(tagId: tagId)
                },
                onSelectedItem: {
                    router.pushTo(.articleDetail(articleUrlString: item.urlString))
                }
            )
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        .searchable(text: $viewModel.input.query)
        .onSubmit(of: .search) {
            viewModel.input.searchItems()
        }
        .sheet(isPresented: $viewModel.output.isPresentedTagArticle) {
            TagArticlesView(viewModel: TagArticlsViewModel(tagId: viewModel.output.selectedTagId))
        }
    }
}

#Preview {
    ArticleSearchView(viewModel: ArticleSearchViewModel())
}
