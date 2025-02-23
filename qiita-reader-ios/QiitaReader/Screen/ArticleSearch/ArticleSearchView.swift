//
//  ArticleSearchView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct ArticleSearchView<ViewModel: ArticleSearchViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.output.itemList.list) { item in
                ArticleSearchItemView(item: item) { tagId in
                    viewModel.input.openTagArticles(tagId: tagId)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
        }
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
